"""Memory-budget adaptive chunk sizing for chunked prefill.

The scheduler consults ``self.dynamic_chunk_sizer.predict(history_len)`` before
every prefill batch (sglang/srt/managers/scheduler.py) and uses the returned
size as that step's chunked_prefill_size. The stock sizer is only installed
when ``enable_dynamic_chunking`` is set AND pp_size > 1, so on this PP=1 stack
we install our own object unconditionally: keep the per-chunk indexer
transient (c * chunk * prefix, c ~= 14 B) under a measured budget by shrinking
the chunk as the prefix grows.

    chunk(L) = clamp(round_down(BUDGET / L, page), MIN, MAX)

Defaults: BUDGET=2.2e8 token^2, MIN=256, MAX=2048, page=256. Every value is
env-tunable (DSV41_CHUNK_BUDGET / DSV41_CHUNK_MIN / DSV41_CHUNK_MAX);
DSV41_ADAPTIVE_CHUNK=0 disables the install and keeps the static
CHUNKED_PREFILL_SIZE everywhere.

The sizer is consulted only for *continuation* chunks - a request's first
chunk always uses the static CHUNKED_PREFILL_SIZE. Keep that at 256 so a new
request landing on a long cached prefix cannot jump the budget, while
continuation chunks of short prompts get the large sizes back.

install_indexer_budget() applies docs/chunked-prefill-memory.md 2.2: lower
_TORCH_INDEXER_SCORE_BUDGET_BYTES (a per-step cap on two indexer score-chunk
copies) from 1 GiB to 256 MiB. Both users of the cap are pure chunking loops,
so results are identical; the transient coefficient drops from ~14 B to
~11 B per (row, key), i.e. the chunk budget rises ~30%.
"""
from __future__ import annotations

import os
import sys

_PREFIX = "[dsv41-adaptive-chunk]"


def _env_int(name: str, default: int) -> int:
    raw = os.environ.get(name, "")
    if raw == "":
        return int(default)
    try:
        return int(float(raw))
    except (TypeError, ValueError):
        return int(default)


class BudgetChunkSizer:
    """chunk(prefix) = clamp(round_down(BUDGET / prefix, page), MIN, MAX)."""

    def __init__(self, page: int, budget: int, chunk_min: int, chunk_max: int):
        self.page = max(int(page), 1)
        self.budget = max(int(budget), 1)
        self.chunk_min = max(int(chunk_min), self.page)
        self.chunk_max = max(int(chunk_max), self.chunk_min)
        self._last_size = None

    def predict(self, history_len: int):
        prefix = max(int(history_len), 1)
        size = (self.budget // prefix) // self.page * self.page
        if size < self.chunk_min:
            size = self.chunk_min
        elif size > self.chunk_max:
            size = self.chunk_max
        if size <= 0:
            return None
        if size != self._last_size:
            self._last_size = size
            print(
                f"{_PREFIX} chunk={size} at prefix={prefix} "
                f"(budget={self.budget} min={self.chunk_min} max={self.chunk_max})",
                flush=True,
            )
        return size


def install(module) -> None:
    """Install the budget sizer on the Scheduler class."""
    if _env_int("DSV41_ADAPTIVE_CHUNK", 1) != 1:
        print(f"{_PREFIX} disabled (DSV41_ADAPTIVE_CHUNK=0)", flush=True)
        return
    scheduler_cls = getattr(module, "Scheduler", None)
    if scheduler_cls is None:
        print(f"{_PREFIX} no Scheduler attribute in {module.__name__}", file=sys.stderr, flush=True)
        return
    original = scheduler_cls.maybe_init_dynamic_chunk_sizer

    def maybe_init(self):
        original(self)
        try:
            sizer = BudgetChunkSizer(
                page=int(getattr(self, "page_size", 256)),
                budget=_env_int("DSV41_CHUNK_BUDGET", 220_000_000),
                chunk_min=_env_int("DSV41_CHUNK_MIN", 256),
                chunk_max=_env_int("DSV41_CHUNK_MAX", 2048),
            )
            self.dynamic_chunk_sizer = sizer
            print(
                f"{_PREFIX} installed: budget={sizer.budget} min={sizer.chunk_min} "
                f"max={sizer.chunk_max} page={sizer.page}",
                flush=True,
            )
        except Exception as exc:
            print(f"{_PREFIX} install failed: {exc!r}", file=sys.stderr, flush=True)

    scheduler_cls.maybe_init_dynamic_chunk_sizer = maybe_init


def install_indexer_budget(module) -> None:
    """Shrink the indexer score-chunk cap (docs/chunked-prefill-memory.md 2.2)."""
    mib = _env_int("DSV41_INDEXER_SCORE_BUDGET_MIB", 256)
    if mib <= 0:
        print(f"{_PREFIX} indexer score budget kept stock (DSV41_INDEXER_SCORE_BUDGET_MIB=0)", flush=True)
        return
    old = getattr(module, "_TORCH_INDEXER_SCORE_BUDGET_BYTES", None)
    module._TORCH_INDEXER_SCORE_BUDGET_BYTES = mib << 20
    print(f"{_PREFIX} indexer score budget: {old} -> {mib << 20} ({mib} MiB)", flush=True)
