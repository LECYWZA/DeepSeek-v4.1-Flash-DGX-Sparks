"""Cap the DeepSeek-V4 layer-20 candidate-block copy budget.

docs/chunked-prefill-memory.md section 2.2: `_TORCH_INDEXER_SCORE_BUDGET_BYTES`
bounds the padded [T, L] copy that `select_candidate_blocks` (layer 20) makes
for block selection.  Lowering 1 GiB -> 256 MiB makes the loop process fewer
rows per step with identical results; measured effect is ~14 B -> ~11 B per
(query, key) of live transient memory, i.e. the long-prompt budget rises from
~2.0e8 to ~2.6e8 token^2.

Installed by sitecustomize.py after `sglang.srt.layers.attention.deepseek_v4_backend`
is imported.  Override with DSV41_INDEXER_SCORE_BUDGET_MIB (MiB; <=0 disables).
"""
import os

DEFAULT_MIB = 256


def install(module):
    raw = os.environ.get("DSV41_INDEXER_SCORE_BUDGET_MIB", str(DEFAULT_MIB)).strip()
    try:
        mib = int(raw)
    except ValueError:
        mib = DEFAULT_MIB
    if mib <= 0:
        print("DSV41 indexer score budget: disabled (<=0)", flush=True)
        return
    if not hasattr(module, "_TORCH_INDEXER_SCORE_BUDGET_BYTES"):
        print("DSV41 indexer score budget: constant not found; hook skipped", flush=True)
        return
    old = module._TORCH_INDEXER_SCORE_BUDGET_BYTES
    module._TORCH_INDEXER_SCORE_BUDGET_BYTES = mib << 20
    print(f"DSV41 indexer score budget: {old} -> {mib << 20} bytes ({mib} MiB)", flush=True)
