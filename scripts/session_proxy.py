#!/usr/bin/env python3
"""Thin session-aware proxy for the head node (rank 0).

Sits in front of the SGLang engine (default 127.0.0.1:8000) and listens on
0.0.0.0:SESSION_PROXY_PORT (default 8888).  Two jobs:

  1. Inject a per-conversation ``session_id`` into every generation request so
     SGLang's session-aware radix cache (--enable-session-radix-cache) can keep
     an active conversation's prefix alive while it evicts unreferenced /
     least-recently-used KV first.  The id comes from the ``X-Session-Id``
     request header when present, otherwise from a conversation fingerprint
     (sha1 of the first system + first user message).
  2. Normalize the ``model`` field: clients may send any model name; it is
     rewritten to SESSION_PROXY_MODEL (the served name) before forwarding.

Everything else is passed through untouched (streaming SSE, /health,
/v1/models, /abort_request, auth headers).  Every request is appended to a
JSONL log (SESSION_PROXY_LOG, default /state/session-proxy.jsonl) with the
session id, model name in/out, token usage (incl. cached_tokens when the
engine reports it) and latency -- the evidence trail for cache behaviour.

This file is stdlib-only; it is meant to run inside the head container
(started by boot.py) or directly on the host.  Memory footprint ~20-40 MB.
"""
import hashlib
import http.client
import json
import os
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit

PORT = int(os.environ.get("SESSION_PROXY_PORT", "8888"))
UPSTREAM = os.environ.get("SESSION_PROXY_UPSTREAM", "http://127.0.0.1:8000")
MODEL = os.environ.get("SESSION_PROXY_MODEL", "deepseek-v4.1-flash").strip()
LOG_PATH = os.environ.get("SESSION_PROXY_LOG", "/state/session-proxy.jsonl")
UP = urlsplit(UPSTREAM)
UP_HOST = UP.hostname or "127.0.0.1"
UP_PORT = UP.port or 80
GEN_PATHS = ("/v1/chat/completions", "/v1/completions", "/v1/messages",
             "/generate", "/v1/generate")
HOP_HEADERS = {"connection", "keep-alive", "proxy-authenticate",
               "proxy-authorization", "te", "trailers", "upgrade",
               "transfer-encoding", "content-length", "host", "accept-encoding"}
_log_lock = threading.Lock()


def _text_of(message):
    content = message.get("content")
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return " ".join(part.get("text", "") for part in content
                        if isinstance(part, dict) and isinstance(part.get("text"), str))
    return ""


def _fingerprint(body):
    messages = body.get("messages")
    if isinstance(messages, list) and messages:
        system_text = next((_text_of(m) for m in messages
                            if isinstance(m, dict) and m.get("role") == "system"), "")
        user_text = next((_text_of(m) for m in messages
                          if isinstance(m, dict) and m.get("role") == "user"), "")
        base = (system_text + "\n" + user_text).strip()
        if base:
            return hashlib.sha1(base.encode("utf-8", "ignore")).hexdigest()[:16]
    for key in ("prompt", "text", "input"):
        value = body.get(key)
        if isinstance(value, str) and value.strip():
            return hashlib.sha1(value[:4000].encode("utf-8", "ignore")).hexdigest()[:16]
    return None


def _log(record):
    try:
        line = json.dumps(record, ensure_ascii=False)
        with _log_lock:
            with open(LOG_PATH, "a", encoding="utf-8") as handle:
                handle.write(line + "\n")
    except Exception:
        pass


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "dsv41-session-proxy"

    def log_message(self, format, *args):  # keep container logs quiet
        pass

    def _handle(self):
        started = time.time()
        length = int(self.headers.get("Content-Length") or 0)
        body = self.rfile.read(length) if length else b""
        path = self.path
        model_in = model_out = None
        session = None
        is_gen = path.split("?", 1)[0] in GEN_PATHS

        if is_gen and body:
            try:
                payload = json.loads(body)
                model_in = payload.get("model")
                session = (self.headers.get("X-Session-Id") or "").strip() or _fingerprint(payload)
                if session:
                    payload["session_id"] = session
                    extra = payload.get("extra_body")
                    if isinstance(extra, dict):
                        extra.setdefault("session_id", session)
                    else:
                        payload["extra_body"] = {"session_id": session}
                if MODEL:
                    payload["model"] = MODEL
                model_out = payload.get("model")
                body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
            except Exception as exc:
                print(f"[session-proxy] body rewrite skipped: {exc}", flush=True)

        headers = {k: v for k, v in self.headers.items()
                   if k.lower() not in HOP_HEADERS}
        headers["Host"] = f"{UP_HOST}:{UP_PORT}"
        headers["Accept-Encoding"] = "identity"
        if body:
            headers["Content-Length"] = str(len(body))

        status = 502
        streamed = False
        usage = {}
        try:
            conn = http.client.HTTPConnection(UP_HOST, UP_PORT, timeout=1800)
            conn.request(self.command, path, body=body or None, headers=headers)
            upstream = conn.getresponse()
            status = upstream.status
            payload_chunks = []
            content_length = upstream.getheader("Content-Length")
            if content_length is not None:
                data = upstream.read()
                payload_chunks.append(data)
            else:
                streamed = True
            self.send_response(status)
            for key, value in upstream.getheaders():
                if key.lower() in HOP_HEADERS:
                    continue
                self.send_header(key, value)
            if content_length is not None:
                self.send_header("Content-Length", content_length)
            else:
                self.send_header("Transfer-Encoding", "chunked")
            self.send_header("Connection", "close")
            self.end_headers()
            if content_length is not None:
                self.wfile.write(payload_chunks[0] if payload_chunks else b"")
            else:
                while True:
                    chunk = upstream.read(65536)
                    if not chunk:
                        break
                    self.wfile.write(b"%X\r\n" % len(chunk) + chunk + b"\r\n")
                self.wfile.write(b"0\r\n\r\n")
            conn.close()
            self.close_connection = True
            if not streamed and payload_chunks:
                try:
                    parsed = json.loads(payload_chunks[0])
                    if isinstance(parsed, dict) and isinstance(parsed.get("usage"), dict):
                        details = parsed["usage"].get("prompt_tokens_details") or {}
                        usage = {
                            "prompt_tokens": parsed["usage"].get("prompt_tokens"),
                            "completion_tokens": parsed["usage"].get("completion_tokens"),
                            "cached_tokens": details.get("cached_tokens"),
                        }
                except Exception:
                    pass
        except Exception as exc:
            try:
                self.send_response(502)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", "0")
                self.send_header("Connection", "close")
                self.end_headers()
                self.close_connection = True
            except Exception:
                pass
            print(f"[session-proxy] upstream error: {exc}", flush=True)

        record = {
            "ts": time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime(started)),
            "path": path,
            "status": status,
            "session": session,
            "model_in": model_in,
            "model_out": model_out,
            "stream": streamed,
            "dur_ms": int((time.time() - started) * 1000),
        }
        record.update({k: v for k, v in usage.items() if v is not None})
        _log(record)
        if is_gen:
            print(f"[session-proxy] {path} {status} session={session} "
                  f"model={model_in}->{model_out} {record['dur_ms']}ms", flush=True)

    do_GET = do_POST = do_DELETE = do_PUT = do_PATCH = _handle


def main():
    server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    print(f"[session-proxy] listening on 0.0.0.0:{PORT} -> "
          f"{UP_HOST}:{UP_PORT} (model={MODEL or 'as-is'}, log={LOG_PATH})", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
