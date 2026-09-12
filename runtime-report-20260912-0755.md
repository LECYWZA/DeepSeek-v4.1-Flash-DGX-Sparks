# DeepSeek-V4.1-Flash 运行报告（3× Spark TP3）

- 导出时间: 2026-09-12 07:55:14 CST
- 配置: CONTEXT_LENGTH=1048576 MAX_RUNNING_REQUESTS=4 MAX_TOTAL_TOKENS=3000000 

## 0. 容器状态
```
== spark-1 ==
dsv41-head Up 21 minutes (healthy)
dsv41-nfs Up 22 minutes
== spark-2 ==
dsv41-worker Up 21 minutes (healthy)
== spark-3 ==
dsv41-worker Up 21 minutes (healthy)
```

## 1. 内存状态（导出时实时）
### spark-1
```
               total        used        free      shared  buff/cache   available
内存：         121Gi       118Gi       3.3Gi       279Mi       2.0Gi       3.5Gi
交换：          15Gi       6.3Gi       9.7Gi
MemTotal:       127600748 kB
MemAvailable:    3659708 kB
Cached:          1757420 kB
SwapCached:      1667372 kB
SwapTotal:      16777212 kB
SwapFree:       10196356 kB
```
### spark-2
```
               total        used        free      shared  buff/cache   available
内存：         121Gi       117Gi       3.7Gi       279Mi       2.4Gi       4.4Gi
交换：          15Gi       4.2Gi        11Gi
MemTotal:       127600748 kB
MemAvailable:    4617684 kB
SwapTotal:      16777212 kB
SwapFree:       12405576 kB
```
### spark-3
```
               total        used        free      shared  buff/cache   available
内存：         121Gi       117Gi       2.9Gi       279Mi       2.9Gi       4.4Gi
交换：          15Gi       4.3Gi        11Gi
MemTotal:       127600752 kB
MemAvailable:    4598708 kB
SwapTotal:      16777212 kB
SwapFree:       12246176 kB
```

## 2. 启动关键指标（head 日志提取）
```
[2026-09-11 23:34:13 TP0 EP0] Load weight begin. avail mem=111.47 GB
[2026-09-11 23:43:15 TP0 EP0] Load weight end. elapsed=541.76 s, type=DeepseekV4ForCausalLM, quant=fp8, avail mem=17.47 GB, mem usage=94.00 GB.
[2026-09-11 23:44:38 TP0 EP0] Load weight begin. avail mem=17.54 GB
[2026-09-11 23:45:53 TP0 EP0] Load weight end. elapsed=74.58 s, type=DeepseekV4ForCausalLMDSpark, quant=fp8, avail mem=14.74 GB, mem usage=2.80 GB.
[2026-09-11 23:46:13 TP0 EP0] Memory pool end. avail mem=9.90 GB
[2026-09-11 23:46:14 TP0 EP0] Memory pool end. avail mem=9.90 GB
[2026-09-11 23:46:30 TP0 EP0] Capture target verify CUDA graph begin. backend=full, num_tokens_per_req=6, bs=[1, 2, 3, 4], avail mem=8.20 GB
[2026-09-11 23:46:44 TP0 EP0] Capture target verify CUDA graph end. elapsed=13.48 s, mem usage=0.58 GB, avail mem=7.62 GB.
[2026-09-11 23:46:44 TP0 EP0] Capture draft verify CUDA graph begin. backend=full, num_tokens_per_req=5, bs=[1, 2, 3, 4], avail mem=7.67 GB
[2026-09-11 23:46:49 TP0 EP0] Capture draft verify CUDA graph end. elapsed=4.26 s, mem usage=-0.01 GB, avail mem=7.68 GB.
[2026-09-11 23:46:49 TP0 EP0] max_total_num_tokens=2999808, chunked_prefill_size=1024, max_prefill_tokens=16384, max_running_requests=4, context_len=1048576, available_gpu_mem=7.68 GB
[2026-09-11 23:46:50] Engine startup timings (s): load_weight=616.34, kv_cache_allocation=6.68, scheduler_e2e=761.30, cuda_graph={prefill=0.00, decode=0.00, target_verify=13.48, draft_prefill=0.00, draft_decode=4.26, draft_extend=0.00}, tokenizer_e2e=766.76
```

## 3. 容器日志（全量）
### 3.1 dsv41-head（spark-1）
~~~
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
SKIP_PREPARE=1 — using existing checkpoint
DSPARK_SPS_TABLE=/state/dspark_sps.json not found; staying on the verify-all schedule
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
/sgl-workspace/sglang/python/sglang/launch_server.py:63: UserWarning: 'python -m sglang.launch_server' is still supported, but 'sglang serve' is the recommended entrypoint.
  Example: sglang serve --model-path <model> [options]
  warnings.warn(
[2026-09-11 23:34:02] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:02] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:02] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:02] Hybrid SWA model detected. architectures=['DeepseekV4ForCausalLM']
[2026-09-11 23:34:02] Breakable CUDA graph is incompatible with DeepSeek-V4 (heavy capture-pool memory pressure); disabling prefill CUDA graph.
[2026-09-11 23:34:02] Failed to get GPU memory capacity from nvidia-smi. Falling back to torch.cuda.mem_get_info(). Reported total GPU memory per device (MiB): [124610], using min: 124610 MiB.
[2026-09-11 23:34:02] Use dsv4 attention backend for DeepseekV4ForCausalLM, setting page_size to 256.
[2026-09-11 23:34:02] Setting KV cache dtype to fp8_e4m3 for DeepseekV4ForCausalLM.
[2026-09-11 23:34:02] DSpark draft weights are bundled in the target checkpoint; defaulting --speculative-draft-model-path to --model-path (/models/DeepSeek-V4.1-Flash).
[2026-09-11 23:34:03] Compiled-kernel caches now live under SGLANG_CACHE_DIR (/root/.cache/sglang). These older directories are no longer used by sglang, but may still be used by other frameworks on this machine, so they were left alone: /root/.cache/flashinfer. Remove them yourself if nothing else needs them.
[2026-09-11 23:34:03] server_args={'model_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_mode': 'auto', 'tokenizer_backend': 'huggingface', 'tokenizer_worker_num': 1, 'detokenizer_worker_num': 1, 'skip_tokenizer_init': False, 'load_format': 'safetensors', 'model_loader_extra_config': '{}', 'trust_remote_code': True, 'context_length': 1048576, 'is_embedding': False, 'enable_multimodal': None, 'revision': None, 'model_impl': 'auto', 'model_config_parser': 'auto', 'json_model_override_args': '{}', 'dtype': 'auto', 'quantization': None, 'quantization_param_path': None, 'kv_cache_dtype': 'fp8_e4m3', 'enable_fp32_lm_head': False, 'modelopt_quant': None, 'modelopt_checkpoint_restore_path': None, 'modelopt_checkpoint_save_path': None, 'modelopt_export_path': None, 'quantize_and_serve': False, 'rl_quant_profile': None, 'enable_tf32_matmul': False, 'mem_fraction_static': 0.95, 'max_running_requests': 4, 'max_queued_requests': None, 'max_total_tokens': 3000000, 'chunked_prefill_size': 1024, 'prefill_decode_interval': 0, 'enable_dynamic_chunking': False, 'max_prefill_tokens': 16384, 'prefill_max_requests': None, 'schedule_policy': 'fcfs', 'enable_priority_scheduling': False, 'disable_priority_preemption': False, 'default_priority_value': None, 'abort_on_priority_when_disabled': False, 'schedule_low_priority_values_first': False, 'priority_scheduling_preemption_threshold': 10, 'retraction_policy': 'length', 'schedule_conservativeness': 1.0, 'page_size': 256, 'c128_page_size': 16, 'swa_full_tokens_ratio': 0.8, 'swa_prefix_tails': None, 'disable_hybrid_swa_memory': False, 'radix_eviction_policy': 'lru', 'prefill_only_disable_kv_cache': False, 'disable_radix_cache': False, 'enable_page_major_kv_layout': False, 'enable_unified_memory': False, 'disable_chunked_prefix_cache': False, 'disable_overlap_schedule': False, 'num_continuous_decode_steps': 1, 'scheduler_recv_interval': 1, 'enable_mixed_chunk': False, 'nccl_port': None, 'dist_timeout': None, 'dist_init_addr': '192.168.123.103:20000', 'gated_launch_port': None, 'nnodes': 3, 'node_rank': 0, 'tp_size': 3, 'dcp_size': 1, 'pp_size': 1, 'pp_max_micro_batch_size': None, 'pp_async_batch_depth': 0, 'dp_size': 1, 'load_balance_method': 'round_robin', 'attn_cp_size': 1, 'moe_dp_size': 1, 'dwdp_size': 1, 'dcp_comm_backend': 'ag_rs', 'dcp_replicate_q_proj': None, 'enable_prefill_cp': False, 'cp_strategy': None, 'enable_dsa_cache_layer_split': False, 'enable_dsa_prefill_context_parallel': False, 'dsa_prefill_cp_mode': 'round-robin-split', 'enable_prefill_context_parallel': False, 'prefill_cp_mode': 'in-seq-split', 'enable_cp_decode_attn_tp': False, 'enable_dp_attention': False, 'enable_dp_attention_local_control_broadcast': False, 'enable_dp_lm_head': False, 'enable_tp_lm_head_all_to_all': False, 'enable_attn_tp_input_scattered': False, 'enable_shared_experts_attn_tp': False, 'enable_dense_mlp_attn_tp': False, 'enable_layernorm_sp': False, 'disable_attn_tp_gather': False, 'enable_p2p_check': False, 'device': 'cuda', 'base_gpu_id': 0, 'gpu_id_step': 1, 'random_seed': 0, 'mlx_enable_sampling': False, 'watchdog_timeout': 1800.0, 'soft_watchdog_timeout': None, 'sleep_on_idle': False, 'use_ray': False, 'custom_sigquit_handler': None, 'numa_node': None, 'gc_threshold': None, 'host': '0.0.0.0', 'port': 8888, 'fastapi_root_path': '', 'smg_grpc_mode': False, 'grpc_mode': False, 'grpc_port': None, 'grpc_worker_threads': 4, 'sidecar': None, 'sidecar_args': None, 'skip_server_warmup': False, 'warmups': None, 'enable_http2': False, 'http2_max_concurrent_streams': 200, 'http2_initial_connection_window_size': 1048576, 'ssl_keyfile': None, 'ssl_certfile': None, 'ssl_ca_certs': None, 'ssl_keyfile_password': None, 'enable_ssl_refresh': False, 'api_key': '[REDACTED]', 'admin_api_key': None, 'served_model_name': 'deepseek-v4.1-flash', 'weight_version': 'default', 'chat_template': None, 'hf_chat_template_name': None, 'completion_template': None, 'file_storage_path': 'sglang_storage', 'enable_cache_report': False, 'reasoning_parser': 'deepseek-v41', 'default_chat_template_kwargs': None, 'strip_thinking_cache': False, 'enable_strict_thinking': False, 'tool_call_parser': 'deepseekv41', 'tool_server': None, 'sampling_defaults': 'model', 'asr_max_buffer_seconds': 60, 'asr_max_concurrent_sessions': 32, 'preferred_sampling_params': None, 'allow_auto_truncate': False, 'stream_interval': 1, 'batch_notify_size': 16, 'stream_response_default_include_usage': False, 'incremental_streaming_output': False, 'enable_streaming_session': False, 'enable_session_radix_cache': False, 'log_level': 'info', 'log_level_http': None, 'log_requests': False, 'log_requests_level': 2, 'log_requests_format': 'text', 'log_requests_target': None, 'uvicorn_access_log_exclude_prefixes': [], 'crash_dump_folder': None, 'show_time_cost': False, 'enable_metrics': False, 'smg_http_sidecar_port': None, 'enable_mfu_metrics': False, 'enable_metrics_for_all_schedulers': False, 'load_snapshot_publish_interval': 15, 'tokenizer_metrics_custom_labels_header': 'x-custom-labels', 'tokenizer_metrics_allowed_custom_labels': None, 'extra_metric_labels': None, 'bucket_time_to_first_token': None, 'bucket_inter_token_latency': None, 'bucket_e2e_request_latency': None, 'prompt_tokens_buckets': None, 'generation_tokens_buckets': None, 'gc_warning_threshold_secs': 0.0, 'decode_log_interval': 40, 'enable_request_time_stats_logging': False, 'kv_events_config': None, 'load_publish_endpoint': None, 'enable_forward_pass_metrics': False, 'forward_pass_metrics_worker_id': '', 'forward_pass_metrics_ipc_name': None, 'enable_trace': False, 'trace_modules': 'request', 'otlp_traces_endpoint': 'localhost:4317', 'export_metrics_to_file': False, 'export_metrics_to_file_dir': None, 'stat_loggers': None, 'constrained_json_whitespace_pattern': None, 'constrained_json_disable_any_whitespace': False, 'attention_backend': 'dsv4', 'decode_attention_backend': None, 'enable_lean_attention': None, 'prefill_attention_backend': None, 'sampling_backend': 'flashinfer', 'grammar_backend': 'xgrammar', 'radix_cache_backend': None, 'mm_attention_backend': None, 'fp8_gemm_runner_backend': 'flashinfer_cutlass', 'fp4_gemm_runner_backend': 'auto', 'bf16_gemm_backend': 'auto', 'dsa_prefill_backend': None, 'dsv4_prefill_backend': 'auto', 'dsa_decode_backend': None, 'dsa_paged_mqa_logits_backend': 'auto', 'dsa_topk_backend': 'sgl-kernel', 'disable_flashinfer_autotune': False, 'flashinfer_autotune_skip_ops': None, 'mamba_backend': 'triton', 'cuda_graph_config': {'decode': {'backend': 'full', 'max_bs': 4, 'bs': [1, 2, 3, 4], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}, 'prefill': {'backend': 'disabled', 'max_bs': 1024, 'bs': [4, 8, 12, 16, 20, 24, 28, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 288, 320, 352, 384, 416, 448, 480, 512, 576, 640, 704, 768, 832, 896, 960, 1024], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}}, 'cuda_graph_backend_decode': None, 'cuda_graph_backend_prefill': None, 'cuda_graph_max_bs_decode': 4, 'cuda_graph_max_bs_prefill': None, 'cuda_graph_max_seq_len_prefill': None, 'cuda_graph_bs_decode': None, 'cuda_graph_bs_prefill': None, 'cuda_graph_tc_compiler': None, 'disable_prefill_cuda_graph': False, 'disable_decode_cuda_graph': False, 'disable_cuda_graph': False, 'disable_cuda_graph_padding': False, 'enable_profile_cuda_graph': False, 'enable_cudagraph_gc': False, 'debug_cuda_graph': False, 'enable_layerwise_nvtx_marker': False, 'enable_nccl_nvls': False, 'enable_symm_mem': False, 'triton_attention_reduce_in_fp32': False, 'triton_attention_num_kv_splits': 8, 'triton_attention_split_tile_size': None, 'flashinfer_mla_disable_ragged': False, 'enable_fused_qk_norm_rope': False, 'enable_precise_embedding_interpolation': False, 'enable_fused_moe_sum_all_reduce': False, 'enable_deepseek_v4_fp4_indexer': False, 'disable_custom_all_reduce': False, 'enable_mscclpp': False, 'enable_torch_symm_mem': False, 'enable_scattered_sconv': False, 'pre_warm_nccl': False, 'enable_quant_communications': False, 'enable_flashinfer_allreduce_fusion': False, 'enforce_disable_flashinfer_allreduce_fusion': False, 'flashinfer_allreduce_fusion_backend': None, 'enable_aiter_allreduce_fusion': False, 'enable_torch_compile': False, 'enable_torch_compile_debug_mode': False, 'torch_compile_max_bs': 32, 'speculative_algorithm': 'DSPARK', 'uno_lora_path': None, 'speculative_draft_model_path': '/models/DeepSeek-V4.1-Flash', 'speculative_draft_model_revision': None, 'speculative_draft_load_format': None, 'speculative_num_steps': 1, 'speculative_eagle_topk': 1, 'speculative_num_draft_tokens': 6, 'speculative_dflash_block_size': None, 'speculative_dspark_block_size': 5, 'speculative_dspark_sps_table_path': None, 'speculative_dspark_confidence_sts_path': None, 'speculative_dspark_align_verify_tokens_to_graph_tier': False, 'speculative_accept_threshold_single': 1.0, 'speculative_accept_threshold_acc': 1.0, 'speculative_use_rejection_sampling': False, 'speculative_token_map': None, 'speculative_attention_mode': 'prefill', 'speculative_draft_attention_backend': None, 'speculative_dsa_topk_backend': 'sgl-kernel', 'speculative_draft_kv_cache_dtype': None, 'speculative_draft_window_size': None, 'speculative_moe_runner_backend': 'flashinfer_mxfp4', 'speculative_moe_a2a_backend': None, 'speculative_draft_model_quantization': None, '_speculative_draft_quantization_explicitly_set': False, 'speculative_skip_dp_mlp_sync': False, 'enable_multi_layer_eagle': False, 'speculative_adaptive': False, 'speculative_adaptive_config': None, 'decoupled_spec_bind_endpoint': None, 'decoupled_spec_connect_endpoints': None, 'decoupled_spec_rank': None, 'decoupled_spec_role': 'null', 'spec_trace_dir': None, 'speculative_ngram_min_bfs_breadth': 1, 'speculative_ngram_max_bfs_breadth': 10, 'speculative_ngram_match_type': 'BFS', 'speculative_ngram_max_trie_depth': 18, 'speculative_ngram_capacity': 10000000, 'speculative_ngram_external_corpus_path': None, 'speculative_ngram_external_sam_budget': 0, 'speculative_ngram_external_corpus_max_tokens': 10000000, 'ep_size': 3, 'moe_a2a_backend': 'none', 'enable_w4a4_mxfp4_megamoe': False, 'deepep_v2_mode': 'direct', 'moe_runner_backend': 'flashinfer_mxfp4', 'flashinfer_mxfp4_moe_precision': 'default', 'deepep_mode': 'auto', 'fuseep_mode': 2, 'deepep_dispatcher_output_dtype': 'auto', 'ep_num_redundant_experts': 0, 'ep_dispatch_algorithm': None, 'init_expert_location': 'trivial', 'enable_eplb': False, 'eplb_algorithm': 'auto', 'eplb_rebalance_num_iterations': 1000, 'eplb_rebalance_layers_per_chunk': None, 'eplb_min_rebalancing_utilization_threshold': 1.0, 'expert_distribution_recorder_mode': None, 'expert_distribution_recorder_buffer_size': 1000, 'expert_balancedness_report_mode': 'off', 'deepep_config': None, 'moe_dense_tp_size': None, 'elastic_ep_backend': None, 'enable_elastic_expert_backup': False, 'mooncake_ib_device': None, 'enable_waterfill': False, 'ep_join_mode': None, 'ep_join_rank_offset': 0, 'elastic_ep_initial_size': None, 'max_ep_size': None, 'elastic_ep_scale_timeout': 600, 'elastic_ep_rejoin': False, 'disable_flashinfer_cutlass_moe_fp4_allgather': False, 'disable_shared_experts_fusion': False, 'enforce_shared_experts_fusion': False, 'max_mamba_cache_size': None, 'mamba_ssm_dtype': None, 'mamba_max_states_per_path': -1, 'enable_mamba_cache_stochastic_rounding': False, 'mamba_cache_philox_rounds': 0, 'mamba_full_memory_ratio': 0.9, 'mamba_radix_cache_strategy': 'auto', 'uses_mamba_radix_cache': False, 'mamba_track_interval': 256, 'enable_int8_mamba_checkpoint': False, 'int8_mamba_ckpt_size': None, 'linear_attn_backend': 'triton', 'linear_attn_decode_backend': None, 'linear_attn_prefill_backend': None, 'linear_attn_verify_backend': None, 'enable_linear_replayssm': False, 'linear_replayssm_cache_len': 16, 'enable_linear_replayssm_spec': False, 'enable_hierarchical_cache': False, 'hicache_host_memory_mode': 'cache', 'hicache_ratio': 2.0, 'hicache_size': 0, 'hicache_write_policy': 'write_through', 'hicache_io_backend': 'kernel', 'hicache_mem_layout': 'page_first', 'hicache_storage_backend': None, 'hicache_storage_prefetch_policy': 'timeout', 'hicache_storage_backend_extra_config': None, 'hicache_storage_prefetch_retry_poll_interval': 0, 'hicache_storage_prefetch_retry_max_attempts': 4, 'enable_unified_cache_external_linker': False, 'unified_cache_external_linker_backend': 'mooncake', 'enable_hisparse': False, 'hisparse_config': None, 'enable_broadcast_mm_inputs_process': False, 'enable_prefix_mm_cache': False, 'mm_enable_dp_encoder': False, 'mm_process_config': {}, 'mm_processor_worker_num': 0, 'mm_io_worker_num': 0, 'allowed_media_domains': [], 'media_url_max_file_size_mb': 64, 'mm_preprocess_cache_size_mb': None, 'trust_mm_content_hashes': False, 'limit_mm_data_per_request': None, 'enable_mm_global_cache': False, 'image_processor_backend': 'auto', 'mm_global_cache_backend': 'mooncake', 'disable_fast_image_processor': False, 'mm_feature_transport': 'cpu', 'keep_mm_feature_on_device': False, 'enable_lora': None, 'enable_lora_overlap_loading': None, 'max_lora_rank': None, 'lora_target_modules': None, 'lora_paths': None, 'max_loaded_loras': None, 'max_loras_per_batch': 8, 'lora_eviction_policy': 'lru', 'lora_backend': 'csgmv', 'max_lora_chunk_size': 16, 'experts_shared_outer_loras': None, 'lora_use_virtual_experts': False, 'lora_strict_loading': False, 'lora_drain_wait_threshold': 0.0, 'enable_two_batch_overlap': False, 'enable_single_batch_overlap': False, 'tbo_token_distribution_threshold': 0.48, 'cpu_offload_gb': 0, 'offload_group_size': -1, 'offload_num_in_group': 1, 'offload_prefetch_step': 1, 'offload_mode': 'cpu', 'enable_lmcache': False, 'lmcache_config_file': None, 'enable_flexkv': False, 'flexkv_config_file': None, 'kt_weight_path': None, 'kt_method': 'AMXINT4', 'kt_cpuinfer': None, 'kt_threadpool_count': 2, 'kt_num_gpu_experts': None, 'kt_max_deferred_experts_per_token': None, 'dllm_algorithm': None, 'dllm_algorithm_config': None, 'dllm_fdfo': True, 'disaggregation_mode': 'null', 'disaggregation_transfer_backend': 'mooncake', 'disaggregation_bootstrap_port': 8998, 'disaggregation_ib_device': None, 'disaggregation_decode_enable_radix_cache': False, 'disaggregation_decode_enable_offload_kvcache': False, 'disaggregation_decode_retraction_backup': None, 'num_reserved_decode_tokens': 512, 'disaggregation_decode_extra_slots': None, 'disaggregation_decode_polling_interval': 1, 'optimistic_prefill_attempts': 0, 'encoder_only': False, 'language_only': False, 'language_model_only': False, 'encoder_transfer_backend': 'zmq_to_scheduler', 'encoder_urls': [], 'encoder_bootstrap_port': 8997, 'encoder_register_urls': [], 'enable_adaptive_dispatch_to_encoder': False, 'enable_pdmux': False, 'pdmux_config_path': None, 'sm_group_num': 8, 'startup_weight_load_mode': 'serial', 'custom_weight_loader': [], 'weight_loader_disable_mmap': False, 'weight_loader_prefetch_checkpoints': False, 'weight_loader_prefetch_num_threads': 4, 'weight_loader_drop_cache_after_load': False, 'remote_instance_weight_loader_seed_instance_ip': None, 'remote_instance_weight_loader_seed_instance_service_port': None, 'remote_instance_weight_loader_send_weights_group_ports': None, 'remote_instance_weight_loader_backend': 'nccl', 'remote_instance_weight_loader_start_seed_via_transfer_engine': False, 'engine_info_bootstrap_port': 6789, 'modelexpress_config': None, 'download_dir': None, 'model_checksum': None, 'delete_ckpt_after_loading': False, 'decrypted_config_file': None, 'decrypted_draft_config_file': None, 'checkpoint_engine_wait_weights_before_ready': False, 'enable_prefill_delayer': False, 'prefill_delayer_max_delay_passes': 30, 'prefill_delayer_token_usage_low_watermark': None, 'prefill_delayer_forward_passes_buckets': None, 'prefill_delayer_wait_seconds_buckets': None, 'prefill_delayer_queue_min_ratio': None, 'prefill_delayer_max_delay_ms': None, 'min_free_slots_delay': None, 'enable_deterministic_inference': False, 'rl_on_policy_target': None, 'kv_canary': 'none', 'kv_canary_real_data': 'none', 'kv_canary_sweep_interval': 0, 'enable_dynamic_batch_tokenizer': False, 'dynamic_batch_tokenizer_batch_size': 32, 'dynamic_batch_tokenizer_batch_timeout': 0.002, 'enable_tokenizer_batch_encode': False, 'disable_tokenizer_batch_decode': False, 'debug_tensor_dump_output_folder': None, 'debug_tensor_dump_layers': None, 'debug_tensor_dump_input_file': None, 'enable_memory_saver': False, 'enable_weights_cpu_backup': False, 'enable_draft_weights_cpu_backup': False, 'enable_custom_logit_processor': False, 'enable_return_hidden_states': False, 'return_hidden_states_mode': None, 'enable_return_routed_experts': False, 'enable_return_indexer_topk': False, 'enable_encoder_swa_bounded_replay': False, 'enable_decoder_swa_bounded_replay': True, 'disable_outlines_disk_cache': False, 'enable_mis': False, 'weight_cache_mode': 'off', 'weight_cache_socket': None, 'weight_cache_timeout': 1800, 'forward_hooks': None, 'msprobe_dump_config': None}
[2026-09-11 23:34:03] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:03] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:03] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:03] DSV41 prefill empty_cache hook installed (extend forwards with a sequence >= 8192 tokens)
[2026-09-11 23:34:05] torchcodec is not installed; audio inputs will fail at request time
[2026-09-11 23:34:05] Ignore import error when loading sglang.srt.multimodal.processors.mimo_v2: No module named 'torchcodec'
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
[2026-09-11 23:34:07] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
DSV41 TP pad installed (tp=3)
DSV41 TP pad installed (tp=3)
[2026-09-11 23:34:08] Multimodal processor concurrency enabled with 2 isolated worker threads (auto).
[2026-09-11 23:34:08] No HuggingFace chat template found
[2026-09-11 23:34:08] No chat template found, defaulting to 'string' content format
DSV41 TP pad installed (tp=3)
[2026-09-11 23:34:09 TP0 EP0] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:09 TP0 EP0] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:09 TP0 EP0] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:10] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:10 TP0 EP0] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:10 TP0 EP0] DSV41 prefill empty_cache hook installed (extend forwards with a sequence >= 8192 tokens)
[2026-09-11 23:34:11 TP0 EP0] torchcodec is not installed; audio inputs will fail at request time
[2026-09-11 23:34:11 TP0 EP0] Ignore import error when loading sglang.srt.multimodal.processors.mimo_v2: No module named 'torchcodec'
[2026-09-11 23:34:11 TP0 EP0] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:11 TP0 EP0] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:11 TP0 EP0] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:11 TP0 EP0] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:34:11 TP0 EP0] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:11 TP0 EP0] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:11 TP0 EP0] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:11 TP0 EP0] Init torch distributed begin.
[2026-09-11 23:34:12 TP0 EP0] sglang is using nccl==2.30.7
[2026-09-11 23:34:12 TP0 EP0] CustomAllreduce is disabled because this process group spans across nodes.
[2026-09-11 23:34:12 TP0 EP0] Init torch distributed ends. elapsed=1.33 s, mem usage=0.61 GB
[2026-09-11 23:34:13 TP0 EP0] Load weight begin. avail mem=111.47 GB
[2026-09-11 23:34:13 TP0 EP0] Detected fp8 checkpoint.
[2026-09-11 23:34:13 TP0 EP0] Expert parallelism keeps only a slice of the routed experts on each rank, so the fused shared expert cannot be appended to the routed weight tensor (only DeepEP/MegaMOE per-rank shared slots support fusion under EP). Shared experts fusion optimization is disabled.
[2026-09-11 23:34:13 TP0 EP0] Multimodal attention backend not set. Use triton_attn.
[2026-09-11 23:34:13 TP0 EP0] Using triton_attn as multimodal attention backend.
[2026-09-11 23:34:13 TP0 EP0] FlashInfer TRTLLM MoE deferred finalize is disabled (moe_runner_backend=flashinfer_mxfp4, quant_method=Mxfp4FlashinferCutlassMoEMethod).
[2026-09-11 23:34:14 TP0 EP0] Exact nvme Engram layer=1 rank=0 rows=[0,128002056) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:14 TP0 EP0] Exact nvme Engram layer=14 rank=0 rows=[0,128005560) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:16 TP0 EP0] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:17 TP0 EP0] multimem all-gather disabled because the TP group spans across nodes.

Multi-thread loading shards:   0% Completed | 0/48 [00:00<?, ?it/s]
Multi-thread loading shards:   2% Completed | 1/48 [00:00<00:40,  1.16it/s]
Multi-thread loading shards:   6% Completed | 3/48 [00:07<01:56,  2.59s/it]
Multi-thread loading shards:   8% Completed | 4/48 [00:08<01:28,  2.01s/it]
Multi-thread loading shards:  10% Completed | 5/48 [00:08<01:01,  1.42s/it]
Multi-thread loading shards:  12% Completed | 6/48 [00:09<00:56,  1.34s/it]
Multi-thread loading shards:  15% Completed | 7/48 [00:09<00:40,  1.02it/s]
Multi-thread loading shards:  17% Completed | 8/48 [00:10<00:30,  1.31it/s]
Multi-thread loading shards:  19% Completed | 9/48 [00:10<00:24,  1.57it/s]
Multi-thread loading shards:  21% Completed | 10/48 [00:10<00:19,  1.98it/s]
Multi-thread loading shards:  23% Completed | 11/48 [00:17<01:28,  2.38s/it]
Multi-thread loading shards:  25% Completed | 12/48 [00:17<01:05,  1.82s/it]
Multi-thread loading shards:  27% Completed | 13/48 [00:24<01:51,  3.18s/it]
Multi-thread loading shards:  29% Completed | 14/48 [00:24<01:22,  2.42s/it]
Multi-thread loading shards:  31% Completed | 15/48 [00:25<00:59,  1.81s/it]
Multi-thread loading shards:  33% Completed | 16/48 [00:25<00:45,  1.42s/it]
Multi-thread loading shards:  35% Completed | 17/48 [00:26<00:33,  1.08s/it]
Multi-thread loading shards:  38% Completed | 18/48 [00:26<00:24,  1.21it/s]
Multi-thread loading shards:  40% Completed | 19/48 [00:29<00:43,  1.50s/it]
Multi-thread loading shards:  42% Completed | 20/48 [00:32<00:53,  1.93s/it]
Multi-thread loading shards:  44% Completed | 21/48 [00:32<00:42,  1.57s/it]
Multi-thread loading shards:  46% Completed | 22/48 [00:34<00:42,  1.62s/it]
Multi-thread loading shards:  48% Completed | 23/48 [00:35<00:32,  1.28s/it]
Multi-thread loading shards:  50% Completed | 24/48 [00:36<00:29,  1.22s/it]
Multi-thread loading shards:  52% Completed | 25/48 [00:36<00:22,  1.01it/s]
Multi-thread loading shards:  54% Completed | 26/48 [00:37<00:20,  1.09it/s]
Multi-thread loading shards:  56% Completed | 27/48 [00:38<00:19,  1.05it/s]
Multi-thread loading shards:  58% Completed | 28/48 [00:41<00:28,  1.44s/it]
Multi-thread loading shards:  60% Completed | 29/48 [00:42<00:28,  1.48s/it]
Multi-thread loading shards:  62% Completed | 30/48 [00:43<00:22,  1.26s/it]
Multi-thread loading shards:  65% Completed | 31/48 [00:45<00:24,  1.45s/it]
Multi-thread loading shards:  67% Completed | 32/48 [00:46<00:20,  1.27s/it]
Multi-thread loading shards:  69% Completed | 33/48 [00:46<00:15,  1.04s/it]
Multi-thread loading shards:  71% Completed | 34/48 [00:48<00:19,  1.42s/it]
Multi-thread loading shards:  73% Completed | 35/48 [00:49<00:16,  1.27s/it]
Multi-thread loading shards:  75% Completed | 36/48 [00:52<00:18,  1.53s/it]
Multi-thread loading shards:  77% Completed | 37/48 [00:53<00:16,  1.51s/it]
Multi-thread loading shards:  79% Completed | 38/48 [00:54<00:12,  1.29s/it]
Multi-thread loading shards:  81% Completed | 39/48 [00:54<00:09,  1.08s/it]
Multi-thread loading shards:  83% Completed | 40/48 [00:55<00:06,  1.20it/s]
Multi-thread loading shards:  85% Completed | 41/48 [00:55<00:05,  1.30it/s]
Multi-thread loading shards:  88% Completed | 42/48 [00:56<00:03,  1.50it/s]
Multi-thread loading shards:  92% Completed | 44/48 [00:56<00:01,  2.33it/s]
Multi-thread loading shards: 100% Completed | 48/48 [00:56<00:00,  1.18s/it]
[2026-09-11 23:35:13 TP0 EP0] Finished streaming dequant fp8 wo_a
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.0.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.1.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.2.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.3.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.4.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.5.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.6.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.7.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.8.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.9.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.10.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.11.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.12.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.13.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.14.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.15.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.16.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.17.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.18.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.19.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.20.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.21.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.22.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.23.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.24.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.25.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.26.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.27.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.28.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.29.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.30.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.31.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.32.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.33.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.34.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.35.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.36.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.37.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.38.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: model.layers.39.mlp.experts)...
[2026-09-11 23:43:15 TP0 EP0] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:43:15 TP0 EP0] Load weight end. elapsed=541.76 s, type=DeepseekV4ForCausalLM, quant=fp8, avail mem=17.47 GB, mem usage=94.00 GB.
[2026-09-11 23:44:37 TP0 EP0] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:44:38 TP0 EP0] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:44:38 TP0 EP0] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:44:38 TP0 EP0] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:44:38 TP0 EP0] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:44:38 TP0 EP0] Init torch distributed begin.
[2026-09-11 23:44:38 TP0 EP0] Init torch distributed ends. elapsed=0.02 s, mem usage=0.00 GB
[2026-09-11 23:44:38 TP0 EP0] Load weight begin. avail mem=17.54 GB
[2026-09-11 23:44:38 TP0 EP0] Detected fp8 checkpoint.
[2026-09-11 23:44:38 TP0 EP0] Expert parallelism keeps only a slice of the routed experts on each rank, so the fused shared expert cannot be appended to the routed weight tensor (only DeepEP/MegaMOE per-rank shared slots support fusion under EP). Shared experts fusion optimization is disabled.

Multi-thread loading shards:   0% Completed | 0/48 [00:00<?, ?it/s]
Multi-thread loading shards:   2% Completed | 1/48 [00:01<01:23,  1.77s/it]
Multi-thread loading shards:   6% Completed | 3/48 [00:07<01:52,  2.51s/it]
Multi-thread loading shards:   8% Completed | 4/48 [00:08<01:36,  2.20s/it]
Multi-thread loading shards:  10% Completed | 5/48 [00:09<01:10,  1.65s/it]
Multi-thread loading shards:  12% Completed | 6/48 [00:09<00:52,  1.25s/it]
Multi-thread loading shards:  15% Completed | 7/48 [00:11<00:51,  1.25s/it]
Multi-thread loading shards:  17% Completed | 8/48 [00:11<00:45,  1.13s/it]
Multi-thread loading shards:  19% Completed | 9/48 [00:13<00:50,  1.28s/it]
Multi-thread loading shards:  21% Completed | 10/48 [00:14<00:40,  1.07s/it]
Multi-thread loading shards:  23% Completed | 11/48 [00:15<00:37,  1.02s/it]
Multi-thread loading shards:  25% Completed | 12/48 [00:15<00:32,  1.10it/s]
Multi-thread loading shards:  27% Completed | 13/48 [00:16<00:31,  1.12it/s]
Multi-thread loading shards:  29% Completed | 14/48 [00:17<00:30,  1.11it/s]
Multi-thread loading shards:  31% Completed | 15/48 [00:18<00:30,  1.09it/s]
Multi-thread loading shards:  33% Completed | 16/48 [00:19<00:28,  1.14it/s]
Multi-thread loading shards:  35% Completed | 17/48 [00:31<02:16,  4.39s/it]
Multi-thread loading shards:  38% Completed | 18/48 [00:32<01:42,  3.42s/it]
Multi-thread loading shards:  40% Completed | 19/48 [00:33<01:11,  2.46s/it]
Multi-thread loading shards:  42% Completed | 20/48 [00:33<00:51,  1.86s/it]
Multi-thread loading shards:  44% Completed | 21/48 [00:34<00:42,  1.57s/it]
Multi-thread loading shards:  46% Completed | 22/48 [00:35<00:36,  1.42s/it]
Multi-thread loading shards:  48% Completed | 23/48 [00:36<00:31,  1.28s/it]
Multi-thread loading shards:  50% Completed | 24/48 [00:37<00:27,  1.16s/it]
Multi-thread loading shards:  52% Completed | 25/48 [00:38<00:27,  1.22s/it]
Multi-thread loading shards:  54% Completed | 26/48 [00:39<00:24,  1.10s/it]
Multi-thread loading shards:  56% Completed | 27/48 [00:41<00:29,  1.39s/it]
Multi-thread loading shards:  58% Completed | 28/48 [00:42<00:24,  1.22s/it]
Multi-thread loading shards:  60% Completed | 29/48 [00:42<00:18,  1.02it/s]
Multi-thread loading shards:  62% Completed | 30/48 [00:43<00:15,  1.17it/s]
Multi-thread loading shards:  65% Completed | 31/48 [00:43<00:12,  1.36it/s]
Multi-thread loading shards:  67% Completed | 32/48 [00:44<00:11,  1.45it/s]
Multi-thread loading shards:  69% Completed | 33/48 [00:45<00:11,  1.27it/s]
Multi-thread loading shards:  71% Completed | 34/48 [00:47<00:16,  1.15s/it]
Multi-thread loading shards:  73% Completed | 35/48 [00:47<00:11,  1.09it/s]
Multi-thread loading shards:  75% Completed | 36/48 [00:48<00:08,  1.39it/s]
Multi-thread loading shards:  77% Completed | 37/48 [00:48<00:08,  1.36it/s]
Multi-thread loading shards:  81% Completed | 39/48 [00:49<00:03,  2.31it/s]
Multi-thread loading shards:  85% Completed | 41/48 [00:49<00:02,  3.42it/s]
Multi-thread loading shards:  92% Completed | 44/48 [00:55<00:04,  1.07s/it]
Multi-thread loading shards:  94% Completed | 45/48 [01:00<00:05,  1.84s/it]
Multi-thread loading shards:  96% Completed | 46/48 [01:06<00:05,  2.63s/it]
Multi-thread loading shards: 100% Completed | 48/48 [01:06<00:00,  1.38s/it]
[2026-09-11 23:45:52 TP0 EP0] Finished streaming dequant fp8 wo_a
[2026-09-11 23:45:53 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: stages.0.mlp.experts)...
[2026-09-11 23:45:53 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: stages.1.mlp.experts)...
[2026-09-11 23:45:53 TP0 EP0] Preparing DSv4 MXFP4 experts for FlashInfer SM120 CUTLASS W4A8 (layer: stages.2.mlp.experts)...
[2026-09-11 23:45:53 TP0 EP0] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:45:53 TP0 EP0] Load weight end. elapsed=74.58 s, type=DeepseekV4ForCausalLMDSpark, quant=fp8, avail mem=14.74 GB, mem usage=2.80 GB.
[2026-09-11 23:46:07 TP0 EP0] Initialized DSpark draft runner. attention_backend=dsv4, model=DeepseekV4ForCausalLMDSpark, gamma=5, verify_num_draft_tokens=6, query_token_num=5, sample_from_anchor=True, mask_token_id=128799, markov_head=DSparkV4MarkovHead
[2026-09-11 23:46:11 TP0 EP0] Reserving 0.10 GB of the KV budget for post-sizing multimodal allocations (feature-transport pools + embedding cache).
[2026-09-11 23:46:11 TP0 EP0] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP0 EP0] DSV4 memory calculation: bytes_per_full_token=1670.75, available_bytes=8.84 GB, c128_state_fixed=0.00 GB, swa_fixed=0.30 GB, full_token=5491200
[2026-09-11 23:46:11 TP0 EP0] DSV4 pool sizes: full=5491200, swa=13312, c4=1372800, c128=42900, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP0 EP0] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP0 EP0] DSV4 pool sizes: full=2999808, swa=13312, c4=749952, c128=23436, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP0 EP0] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=749952 c4_logical_size=749952 c128_size=23436 c4_state_pool_size=1664 c128_state_pool_size=1280
[2026-09-11 23:46:13 TP0 EP0] Memory pool end. avail mem=9.90 GB
[2026-09-11 23:46:13 TP0 EP0] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=0 c4_logical_size=0 c128_size=0 c4_state_pool_size=0 c128_state_pool_size=0
[2026-09-11 23:46:14 TP0 EP0] Memory pool end. avail mem=9.90 GB
[2026-09-11 23:46:17 TP0 EP0] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:17 TP0 EP0] Overriding draft attention backend to dsv4.
[2026-09-11 23:46:17 TP0 EP0] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:18 TP0 EP0] FlashInfer autotune: per-rank caches disagree, discarding them and tuning from scratch so all ranks agree on the tactics.
[2026-09-11 23:46:18 TP0 EP0] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/05cc0d96dc7e28b8/rank_tp0_pp0_dp0.json
[2026-09-11 23:46:21 TP0 EP0] Disable CP decode attention TP

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 11.03profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 11.02profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/6 [00:00<?, ?profile/s]NCCL version 2.30.7+cuda13.3
[TensorRT-LLM][INFO] Set logger level to INFO

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  17%|█▋        | 1/6 [00:00<00:01,  3.76profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  33%|███▎      | 2/6 [00:00<00:00,  5.09profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  50%|█████     | 3/6 [00:00<00:00,  5.84profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  67%|██████▋   | 4/6 [00:01<00:00,  2.58profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  83%|████████▎ | 5/6 [00:01<00:00,  2.19profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.18profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.59profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  17%|█▋        | 1/6 [00:00<00:00,  9.72profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  33%|███▎      | 2/6 [00:00<00:00,  9.21profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 3/6 [00:00<00:00,  8.92profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  67%|██████▋   | 4/6 [00:00<00:00,  7.41profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  83%|████████▎ | 5/6 [00:00<00:00,  5.81profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  4.99profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  6.03profile/s]

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  50%|█████     | 3/6 [00:00<00:00, 25.68profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 17.99profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 18.83profile/s]
[2026-09-11 23:46:30 TP0 EP0] FlashInfer autotune completed.
[2026-09-11 23:46:30 TP0 EP0] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:30 TP0 EP0] Capture target verify CUDA graph begin. backend=full, num_tokens_per_req=6, bs=[1, 2, 3, 4], avail mem=8.20 GB

  0%|          | 0/4 [00:00<?, ?it/s]
Capturing batches (bs=4 avail_mem=7.94 GB):   0%|          | 0/4 [00:00<?, ?it/s]
Capturing batches (bs=4 avail_mem=7.94 GB):  25%|██▌       | 1/4 [00:08<00:24,  8.29s/it]
Capturing batches (bs=3 avail_mem=7.79 GB):  25%|██▌       | 1/4 [00:08<00:24,  8.29s/it]
Capturing batches (bs=3 avail_mem=7.79 GB):  50%|█████     | 2/4 [00:09<00:08,  4.12s/it]
Capturing batches (bs=2 avail_mem=7.75 GB):  50%|█████     | 2/4 [00:09<00:08,  4.12s/it]
Capturing batches (bs=2 avail_mem=7.75 GB):  75%|███████▌  | 3/4 [00:10<00:02,  2.75s/it]
Capturing batches (bs=1 avail_mem=7.69 GB):  75%|███████▌  | 3/4 [00:10<00:02,  2.75s/it]
Capturing batches (bs=1 avail_mem=7.69 GB): 100%|██████████| 4/4 [00:11<00:00,  2.14s/it]
Capturing batches (bs=1 avail_mem=7.69 GB): 100%|██████████| 4/4 [00:11<00:00,  2.96s/it]
[2026-09-11 23:46:44 TP0 EP0] Capture target verify CUDA graph end. elapsed=13.48 s, mem usage=0.58 GB, avail mem=7.62 GB.
[2026-09-11 23:46:44 TP0 EP0] DSpark draft proposal (greedy + sampling) folded into the draft cuda graph.
[2026-09-11 23:46:44 TP0 EP0] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:44 TP0 EP0] Capture draft verify CUDA graph begin. backend=full, num_tokens_per_req=5, bs=[1, 2, 3, 4], avail mem=7.67 GB

  0%|          | 0/4 [00:00<?, ?it/s]
Capturing batches (bs=4 avail_mem=7.67 GB):   0%|          | 0/4 [00:00<?, ?it/s][2026-09-11 23:46:45 TP0 EP0] FlashInfer autotune: per-rank caches disagree, discarding them and tuning from scratch so all ranks agree on the tactics.
[2026-09-11 23:46:45 TP0 EP0] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/3ea8a0a6a68937f8/rank_tp0_pp0_dp0.json


[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s][A

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  50%|█████     | 3/6 [00:00<00:00, 14.96profile/s][A
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 23.78profile/s]


[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/4 [00:00<?, ?profile/s][A

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  25%|██▌       | 1/4 [00:00<00:00,  8.90profile/s][A

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  75%|███████▌  | 3/4 [00:00<00:00,  9.93profile/s][A

[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  8.54profile/s][A
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  8.81profile/s]


[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/4 [00:00<?, ?profile/s][A

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 2/4 [00:00<00:00, 13.03profile/s][A

[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.41profile/s][A
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.73profile/s]
[2026-09-11 23:46:47 TP0 EP0] FlashInfer autotune completed.

Capturing batches (bs=4 avail_mem=7.67 GB):  25%|██▌       | 1/4 [00:03<00:10,  3.62s/it]
Capturing batches (bs=3 avail_mem=7.69 GB):  25%|██▌       | 1/4 [00:03<00:10,  3.62s/it]
Capturing batches (bs=2 avail_mem=7.67 GB):  25%|██▌       | 1/4 [00:03<00:10,  3.62s/it]
Capturing batches (bs=2 avail_mem=7.67 GB):  75%|███████▌  | 3/4 [00:03<00:00,  1.02it/s]
Capturing batches (bs=1 avail_mem=7.69 GB):  75%|███████▌  | 3/4 [00:03<00:00,  1.02it/s]
Capturing batches (bs=1 avail_mem=7.69 GB): 100%|██████████| 4/4 [00:03<00:00,  1.05it/s]
[2026-09-11 23:46:49 TP0 EP0] Capture draft verify CUDA graph end. elapsed=4.26 s, mem usage=-0.01 GB, avail mem=7.68 GB.
[2026-09-11 23:46:49 TP0 EP0] max_total_num_tokens=2999808, chunked_prefill_size=1024, max_prefill_tokens=16384, max_running_requests=4, context_len=1048576, available_gpu_mem=7.68 GB
[2026-09-11 23:46:49 TP0 EP0] Init Unified Radix Cache. Components: (<ComponentType.FULL: 0>, <ComponentType.SWA: 1>). Tree Core: UnifiedTreeCore
[2026-09-11 23:46:49 TP0 EP0] Tree cache initialized: source=default impl=UnifiedRadixCache hybrid_swa=True hybrid_ssm=False hicache_attached=False streaming_wrapped=False
[2026-09-11 23:46:50] Engine startup timings (s): load_weight=616.34, kv_cache_allocation=6.68, scheduler_e2e=761.30, cuda_graph={prefill=0.00, decode=0.00, target_verify=13.48, draft_prefill=0.00, draft_decode=4.26, draft_extend=0.00}, tokenizer_e2e=766.76
[2026-09-11 23:46:52] INFO:     Started server process [83]
[2026-09-11 23:46:52] INFO:     Waiting for application startup.
[2026-09-11 23:46:55] INFO:     Application startup complete.
[2026-09-11 23:46:55] INFO:     Uvicorn running on http://0.0.0.0:8888 (Press CTRL+C to quit)
[2026-09-11 23:46:56] INFO:     192.168.1.1:48436 - "GET /slots HTTP/1.1" 404 Not Found
/sgl-workspace/sglang/python/sglang/srt/entrypoints/http_server.py:454: FastAPIDeprecationWarning: ORJSONResponse is deprecated, FastAPI now serializes data directly to JSON bytes via Pydantic when a return type or response model is set, which is faster and doesn't need a custom response class. Read more in the FastAPI docs: https://fastapi.tiangolo.com/advanced/custom-response/#orjson-or-response-model and https://fastapi.tiangolo.com/tutorial/response-model/
  return await original_handler(ORJSONRequest(request.scope, request.receive))
[2026-09-11 23:46:56] INFO:     192.168.1.1:48450 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:46:56] INFO:     192.168.1.1:48436 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:46:56] INFO:     192.168.1.1:48450 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:46:56] INFO:     127.0.0.1:33996 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:46:56] INFO:     192.168.1.1:48436 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:46:57] INFO:     192.168.1.1:48450 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:46:57] INFO:     192.168.1.1:48436 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:46:57] INFO:     127.0.0.1:34018 - "GET /health HTTP/1.1" 503 Service Unavailable
[2026-09-11 23:46:58] INFO:     192.168.1.1:48436 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:46:58] INFO:     127.0.0.1:34026 - "GET /health HTTP/1.1" 503 Service Unavailable
[2026-09-11 23:47:01] Endpoint '/get_server_info' is deprecated and will be removed in a future version. Please use '/server_info' instead.
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:47:02 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.02, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 19.66
[2026-09-11 23:47:02] INFO:     192.168.1.1:48436 - "GET /get_server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:02] INFO:     192.168.1.1:48462 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:02] INFO:     192.168.1.1:48436 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:02] INFO:     192.168.1.1:48462 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:02] INFO:     127.0.0.1:38616 - "GET /health HTTP/1.1" 503 Service Unavailable
[2026-09-11 23:47:03] INFO:     127.0.0.1:38622 - "GET /health HTTP/1.1" 503 Service Unavailable
[2026-09-11 23:47:03] INFO:     127.0.0.1:34002 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:03 TP0 EP0] Freezing GC in Scheduler process. gen0: 580->0, gen1: 997->0, gen2: 1109475->0
[2026-09-11 23:47:09] Freezing GC in Detokenizer Manager process. gen0: 267->0, gen1: 2->0, gen2: 919601->0
[2026-09-11 23:47:09] Freezing GC in Tokenizer Manager process. gen0: 422->0, gen1: 3153->0, gen2: 1080006->0
[2026-09-11 23:47:09] INFO:     127.0.0.1:38638 - "POST /freeze_gc HTTP/1.1" 200 OK
[2026-09-11 23:47:09] INFO:     192.168.1.1:48436 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:09] The server is fired up and ready to roll!
[2026-09-11 23:47:09] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:10] INFO:     192.168.1.1:49810 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:10] INFO:     192.168.1.1:49810 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:10 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 28.98
[2026-09-11 23:47:10] INFO:     127.0.0.1:38654 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:47:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:12] INFO:     192.168.1.1:49810 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:12] INFO:     192.168.1.1:49810 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:14] INFO:     192.168.1.1:49810 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:14] INFO:     192.168.1.1:49810 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:15 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 53.16
[2026-09-11 23:47:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:16] INFO:     192.168.1.1:49810 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:16] INFO:     192.168.1.1:49810 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:16] INFO:     127.0.0.1:36642 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:47:16 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.02, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 228.43
[2026-09-11 23:47:16] INFO:     127.0.0.1:36652 - "POST /v1/chat/completions HTTP/1.1" 200 OK
Fresh inference passed: 19 + 23 = 42
[2026-09-11 23:47:17 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.02, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 693.75
[2026-09-11 23:47:17] INFO:     127.0.0.1:36660 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:18] INFO:     192.168.1.1:49810 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:18] INFO:     192.168.1.1:49810 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:18 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 512, #cached-token: 0, full token usage: 0.00, swa token usage: 0.04, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 481.51
[2026-09-11 23:47:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:18 TP0 EP0] Engram layer=1 lookups=6040 hit_rate=0.0% reads=6040 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:47:18 TP0 EP0] Engram layer=14 lookups=5992 hit_rate=0.0% reads=5992 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:47:18] INFO:     127.0.0.1:36666 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:23] Endpoint '/get_server_info' is deprecated and will be removed in a future version. Please use '/server_info' instead.
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:47:25 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 1024, #cached-token: 0, full token usage: 0.00, swa token usage: 0.04, #running-req: 0, #queue-req: 0, #pending-token: 47, cuda graph: False, input throughput (token/s): 144.88
[2026-09-11 23:47:25] INFO:     192.168.1.1:49802 - "GET /get_server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:25 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.04, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 16886.83
[2026-09-11 23:47:25] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:25] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:25] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:25] INFO:     127.0.0.1:36672 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:27 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 1024, #cached-token: 1024, full token usage: 0.00, swa token usage: 0.10, #running-req: 0, #queue-req: 0, #pending-token: 2128, cuda graph: False, input throughput (token/s): 593.64
[2026-09-11 23:47:27 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 1024, #cached-token: 0, full token usage: 0.00, swa token usage: 0.10, #running-req: 0, #queue-req: 0, #pending-token: 1104, cuda graph: False, input throughput (token/s): 2269.97
[2026-09-11 23:47:27 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 1024, #cached-token: 0, full token usage: 0.00, swa token usage: 0.04, #running-req: 0, #queue-req: 0, #pending-token: 80, cuda graph: False, input throughput (token/s): 4654.08
[2026-09-11 23:47:27 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.04, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 18078.54
[2026-09-11 23:47:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:28] INFO:     127.0.0.1:51360 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:28 TP0 EP0] Decode batch, #running-req: 1, #full token: 0, full token usage: 0.00, #swa token: 0, swa token usage: 0.00, accept len: 3.08, accept rate: 0.41, cuda graph: True, gen throughput (token/s): 3.12, #queue-req: 0
[2026-09-11 23:47:29 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.08, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 208.60
[2026-09-11 23:47:29 TP0 EP0] Prefill batch, #new-seq: 3, #new-token: 768, #cached-token: 0, full token usage: 0.00, swa token usage: 0.08, #running-req: 1, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 6583.26
[2026-09-11 23:47:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:31] INFO:     127.0.0.1:51376 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     127.0.0.1:51412 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     127.0.0.1:51396 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2026-09-11 23:47:32] INFO:     127.0.0.1:51390 - "POST /v1/chat/completions HTTP/1.1" 200 OK
Batch output sanity check passed: batch of 4 returned Latin prose.
Warm-up done in 15s (4 prompt sizes + one batch of 4)
Ready: API on port 8888 (rank 0). Key is in /state/api-key.
[2026-09-11 23:47:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
/opt/sglang/lib/python3.12/site-packages/starlette/middleware/errors.py:164: FastAPIDeprecationWarning: ORJSONResponse is deprecated, FastAPI now serializes data directly to JSON bytes via Pydantic when a return type or response model is set, which is faster and doesn't need a custom response class. Read more in the FastAPI docs: https://fastapi.tiangolo.com/advanced/custom-response/#orjson-or-response-model and https://fastapi.tiangolo.com/tutorial/response-model/
  await self.app(scope, receive, _send)
[2026-09-11 23:47:38] INFO:     127.0.0.1:57232 - "GET /v1/models HTTP/1.1" 401 Unauthorized
[2026-09-11 23:47:38] INFO:     127.0.0.1:57244 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:41 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 21.25
[2026-09-11 23:47:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:42] INFO:     127.0.0.1:50364 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:47:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:47:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:47:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:47:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:47:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:47:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:12 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:48:13] INFO:     127.0.0.1:52336 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:48:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:18 TP0 EP0] Engram layer=1 lookups=39185 hit_rate=0.0% reads=39185 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:48:18 TP0 EP0] Engram layer=14 lookups=39232 hit_rate=0.0% reads=39232 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:48:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:43 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.24
[2026-09-11 23:48:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:44] INFO:     127.0.0.1:59950 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:48:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:48:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:48:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:48:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:48:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:48:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:14 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.22
[2026-09-11 23:49:15] INFO:     127.0.0.1:52836 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:49:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:18 TP0 EP0] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:18 TP0 EP0] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:45 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:49:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:46] INFO:     127.0.0.1:34046 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:49:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:49:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:49:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:49:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:49:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:49:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:16 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:50:17] INFO:     127.0.0.1:56608 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:50:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:18 TP0 EP0] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:18 TP0 EP0] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:47 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:50:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:48] INFO:     127.0.0.1:47044 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:50:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:50:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:50:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:50:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:50:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:50:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:18 TP0 EP0] Engram layer=1 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:18 TP0 EP0] Engram layer=14 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:18 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.24
[2026-09-11 23:51:19] INFO:     127.0.0.1:53900 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:51:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:49 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.24
[2026-09-11 23:51:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:50] INFO:     127.0.0.1:43822 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:51:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:51:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:51:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:51:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:51:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:51:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:18 TP0 EP0] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:18 TP0 EP0] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:21 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.22
[2026-09-11 23:52:22] INFO:     127.0.0.1:47320 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:52:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:52 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:52:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:53] INFO:     127.0.0.1:39466 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:52:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:52:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:52:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:52:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:52:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:52:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:18 TP0 EP0] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:18 TP0 EP0] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:23 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:53:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:24] INFO:     127.0.0.1:35912 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:53:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:54 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.24
[2026-09-11 23:53:55] INFO:     127.0.0.1:47324 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:53:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:53:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:53:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:53:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:53:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:53:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:18] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:18] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:18] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:18] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:18] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:18 TP0 EP0] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:18 TP0 EP0] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:20] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:20] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:20] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:20] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:20] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:22] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:22] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:22] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:22] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:22] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:24] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:24] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:24] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:24] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:24] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:25 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.22
[2026-09-11 23:54:26] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:26] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:26] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:26] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:26] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:26] INFO:     127.0.0.1:34910 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:54:28] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:28] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:28] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:28] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:28] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:30] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:30] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:30] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:30] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:30] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:32] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:32] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:32] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:32] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:32] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:34] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:34] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:34] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:34] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:34] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:36] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:36] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:36] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:36] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:36] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:38] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:38] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:38] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:38] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:38] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:40] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:40] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:40] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:40] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:40] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:42] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:42] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:42] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:42] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:42] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:44] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:44] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:44] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:44] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:44] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:46] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:46] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:46] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:46] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:46] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:48] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:48] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:48] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:48] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:48] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:50] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:50] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:50] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:50] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:50] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:52] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:52] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:52] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:52] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:52] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:54] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:54] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:54] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:54] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:54] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:56] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:56] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:56] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:56] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:56] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:54:56 TP0 EP0] Prefill batch, #new-seq: 1, #new-token: 256, #cached-token: 0, full token usage: 0.00, swa token usage: 0.00, #running-req: 0, #queue-req: 0, #pending-token: 0, cuda graph: False, input throughput (token/s): 8.23
[2026-09-11 23:54:57] INFO:     127.0.0.1:52806 - "GET /health HTTP/1.1" 200 OK
[2026-09-11 23:54:58] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:58] INFO:     192.168.1.1:55654 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:54:58] INFO:     192.168.1.1:49802 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:54:58] INFO:     192.168.1.1:55654 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:54:58] INFO:     192.168.1.1:49802 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:54:58] INFO:     192.168.1.1:55654 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:00] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:00] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:00] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:00] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:00] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:02] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:02] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:02] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:02] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:02] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:04] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:04] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:04] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:04] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:04] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:06] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:06] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:06] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:06] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:06] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:08] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:08] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:08] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:08] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:08] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:10] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:10] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:10] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:10] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:10] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:12] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:12] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:12] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:12] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:12] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:14] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:14] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:14] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:14] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:14] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
[2026-09-11 23:55:16] INFO:     192.168.1.1:49802 - "GET /v1/models HTTP/1.1" 200 OK
[2026-09-11 23:55:16] INFO:     192.168.1.1:55654 - "GET /server_info HTTP/1.1" 200 OK
[2026-09-11 23:55:16] INFO:     192.168.1.1:49802 - "GET /v1/loads HTTP/1.1" 200 OK
[2026-09-11 23:55:16] INFO:     192.168.1.1:55654 - "GET /metrics HTTP/1.1" 404 Not Found
[2026-09-11 23:55:16] INFO:     192.168.1.1:49802 - "GET /model_info HTTP/1.1" 200 OK
~~~
### 3.2 dsv41-worker（spark-2）
~~~
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
SKIP_PREPARE=1 — using existing checkpoint
DSPARK_SPS_TABLE=/state/dspark_sps.json not found; staying on the verify-all schedule
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
/sgl-workspace/sglang/python/sglang/launch_server.py:63: UserWarning: 'python -m sglang.launch_server' is still supported, but 'sglang serve' is the recommended entrypoint.
  Example: sglang serve --model-path <model> [options]
  warnings.warn(
[2026-09-11 23:33:58] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:33:58] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:33:58] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:33:58] Hybrid SWA model detected. architectures=['DeepseekV4ForCausalLM']
[2026-09-11 23:33:58] Breakable CUDA graph is incompatible with DeepSeek-V4 (heavy capture-pool memory pressure); disabling prefill CUDA graph.
[2026-09-11 23:33:59] Failed to get GPU memory capacity from nvidia-smi. Falling back to torch.cuda.mem_get_info(). Reported total GPU memory per device (MiB): [124610], using min: 124610 MiB.
[2026-09-11 23:33:59] Use dsv4 attention backend for DeepseekV4ForCausalLM, setting page_size to 256.
[2026-09-11 23:33:59] Setting KV cache dtype to fp8_e4m3 for DeepseekV4ForCausalLM.
[2026-09-11 23:33:59] DSpark draft weights are bundled in the target checkpoint; defaulting --speculative-draft-model-path to --model-path (/models/DeepSeek-V4.1-Flash).
[2026-09-11 23:34:00] server_args={'model_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_mode': 'auto', 'tokenizer_backend': 'huggingface', 'tokenizer_worker_num': 1, 'detokenizer_worker_num': 1, 'skip_tokenizer_init': False, 'load_format': 'safetensors', 'model_loader_extra_config': '{}', 'trust_remote_code': True, 'context_length': 1048576, 'is_embedding': False, 'enable_multimodal': None, 'revision': None, 'model_impl': 'auto', 'model_config_parser': 'auto', 'json_model_override_args': '{}', 'dtype': 'auto', 'quantization': None, 'quantization_param_path': None, 'kv_cache_dtype': 'fp8_e4m3', 'enable_fp32_lm_head': False, 'modelopt_quant': None, 'modelopt_checkpoint_restore_path': None, 'modelopt_checkpoint_save_path': None, 'modelopt_export_path': None, 'quantize_and_serve': False, 'rl_quant_profile': None, 'enable_tf32_matmul': False, 'mem_fraction_static': 0.95, 'max_running_requests': 4, 'max_queued_requests': None, 'max_total_tokens': 3000000, 'chunked_prefill_size': 1024, 'prefill_decode_interval': 0, 'enable_dynamic_chunking': False, 'max_prefill_tokens': 16384, 'prefill_max_requests': None, 'schedule_policy': 'fcfs', 'enable_priority_scheduling': False, 'disable_priority_preemption': False, 'default_priority_value': None, 'abort_on_priority_when_disabled': False, 'schedule_low_priority_values_first': False, 'priority_scheduling_preemption_threshold': 10, 'retraction_policy': 'length', 'schedule_conservativeness': 1.0, 'page_size': 256, 'c128_page_size': 16, 'swa_full_tokens_ratio': 0.8, 'swa_prefix_tails': None, 'disable_hybrid_swa_memory': False, 'radix_eviction_policy': 'lru', 'prefill_only_disable_kv_cache': False, 'disable_radix_cache': False, 'enable_page_major_kv_layout': False, 'enable_unified_memory': False, 'disable_chunked_prefix_cache': False, 'disable_overlap_schedule': False, 'num_continuous_decode_steps': 1, 'scheduler_recv_interval': 1, 'enable_mixed_chunk': False, 'nccl_port': None, 'dist_timeout': None, 'dist_init_addr': '192.168.123.103:20000', 'gated_launch_port': None, 'nnodes': 3, 'node_rank': 1, 'tp_size': 3, 'dcp_size': 1, 'pp_size': 1, 'pp_max_micro_batch_size': None, 'pp_async_batch_depth': 0, 'dp_size': 1, 'load_balance_method': 'round_robin', 'attn_cp_size': 1, 'moe_dp_size': 1, 'dwdp_size': 1, 'dcp_comm_backend': 'ag_rs', 'dcp_replicate_q_proj': None, 'enable_prefill_cp': False, 'cp_strategy': None, 'enable_dsa_cache_layer_split': False, 'enable_dsa_prefill_context_parallel': False, 'dsa_prefill_cp_mode': 'round-robin-split', 'enable_prefill_context_parallel': False, 'prefill_cp_mode': 'in-seq-split', 'enable_cp_decode_attn_tp': False, 'enable_dp_attention': False, 'enable_dp_attention_local_control_broadcast': False, 'enable_dp_lm_head': False, 'enable_tp_lm_head_all_to_all': False, 'enable_attn_tp_input_scattered': False, 'enable_shared_experts_attn_tp': False, 'enable_dense_mlp_attn_tp': False, 'enable_layernorm_sp': False, 'disable_attn_tp_gather': False, 'enable_p2p_check': False, 'device': 'cuda', 'base_gpu_id': 0, 'gpu_id_step': 1, 'random_seed': 0, 'mlx_enable_sampling': False, 'watchdog_timeout': 1800.0, 'soft_watchdog_timeout': None, 'sleep_on_idle': False, 'use_ray': False, 'custom_sigquit_handler': None, 'numa_node': None, 'gc_threshold': None, 'host': '0.0.0.0', 'port': 8888, 'fastapi_root_path': '', 'smg_grpc_mode': False, 'grpc_mode': False, 'grpc_port': None, 'grpc_worker_threads': 4, 'sidecar': None, 'sidecar_args': None, 'skip_server_warmup': False, 'warmups': None, 'enable_http2': False, 'http2_max_concurrent_streams': 200, 'http2_initial_connection_window_size': 1048576, 'ssl_keyfile': None, 'ssl_certfile': None, 'ssl_ca_certs': None, 'ssl_keyfile_password': None, 'enable_ssl_refresh': False, 'api_key': '[REDACTED]', 'admin_api_key': None, 'served_model_name': 'deepseek-v4.1-flash', 'weight_version': 'default', 'chat_template': None, 'hf_chat_template_name': None, 'completion_template': None, 'file_storage_path': 'sglang_storage', 'enable_cache_report': False, 'reasoning_parser': 'deepseek-v41', 'default_chat_template_kwargs': None, 'strip_thinking_cache': False, 'enable_strict_thinking': False, 'tool_call_parser': 'deepseekv41', 'tool_server': None, 'sampling_defaults': 'model', 'asr_max_buffer_seconds': 60, 'asr_max_concurrent_sessions': 32, 'preferred_sampling_params': None, 'allow_auto_truncate': False, 'stream_interval': 1, 'batch_notify_size': 16, 'stream_response_default_include_usage': False, 'incremental_streaming_output': False, 'enable_streaming_session': False, 'enable_session_radix_cache': False, 'log_level': 'info', 'log_level_http': None, 'log_requests': False, 'log_requests_level': 2, 'log_requests_format': 'text', 'log_requests_target': None, 'uvicorn_access_log_exclude_prefixes': [], 'crash_dump_folder': None, 'show_time_cost': False, 'enable_metrics': False, 'smg_http_sidecar_port': None, 'enable_mfu_metrics': False, 'enable_metrics_for_all_schedulers': False, 'load_snapshot_publish_interval': 15, 'tokenizer_metrics_custom_labels_header': 'x-custom-labels', 'tokenizer_metrics_allowed_custom_labels': None, 'extra_metric_labels': None, 'bucket_time_to_first_token': None, 'bucket_inter_token_latency': None, 'bucket_e2e_request_latency': None, 'prompt_tokens_buckets': None, 'generation_tokens_buckets': None, 'gc_warning_threshold_secs': 0.0, 'decode_log_interval': 40, 'enable_request_time_stats_logging': False, 'kv_events_config': None, 'load_publish_endpoint': None, 'enable_forward_pass_metrics': False, 'forward_pass_metrics_worker_id': '', 'forward_pass_metrics_ipc_name': None, 'enable_trace': False, 'trace_modules': 'request', 'otlp_traces_endpoint': 'localhost:4317', 'export_metrics_to_file': False, 'export_metrics_to_file_dir': None, 'stat_loggers': None, 'constrained_json_whitespace_pattern': None, 'constrained_json_disable_any_whitespace': False, 'attention_backend': 'dsv4', 'decode_attention_backend': None, 'enable_lean_attention': None, 'prefill_attention_backend': None, 'sampling_backend': 'flashinfer', 'grammar_backend': 'xgrammar', 'radix_cache_backend': None, 'mm_attention_backend': None, 'fp8_gemm_runner_backend': 'flashinfer_cutlass', 'fp4_gemm_runner_backend': 'auto', 'bf16_gemm_backend': 'auto', 'dsa_prefill_backend': None, 'dsv4_prefill_backend': 'auto', 'dsa_decode_backend': None, 'dsa_paged_mqa_logits_backend': 'auto', 'dsa_topk_backend': 'sgl-kernel', 'disable_flashinfer_autotune': False, 'flashinfer_autotune_skip_ops': None, 'mamba_backend': 'triton', 'cuda_graph_config': {'decode': {'backend': 'full', 'max_bs': 4, 'bs': [1, 2, 3, 4], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}, 'prefill': {'backend': 'disabled', 'max_bs': 1024, 'bs': [4, 8, 12, 16, 20, 24, 28, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 288, 320, 352, 384, 416, 448, 480, 512, 576, 640, 704, 768, 832, 896, 960, 1024], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}}, 'cuda_graph_backend_decode': None, 'cuda_graph_backend_prefill': None, 'cuda_graph_max_bs_decode': 4, 'cuda_graph_max_bs_prefill': None, 'cuda_graph_max_seq_len_prefill': None, 'cuda_graph_bs_decode': None, 'cuda_graph_bs_prefill': None, 'cuda_graph_tc_compiler': None, 'disable_prefill_cuda_graph': False, 'disable_decode_cuda_graph': False, 'disable_cuda_graph': False, 'disable_cuda_graph_padding': False, 'enable_profile_cuda_graph': False, 'enable_cudagraph_gc': False, 'debug_cuda_graph': False, 'enable_layerwise_nvtx_marker': False, 'enable_nccl_nvls': False, 'enable_symm_mem': False, 'triton_attention_reduce_in_fp32': False, 'triton_attention_num_kv_splits': 8, 'triton_attention_split_tile_size': None, 'flashinfer_mla_disable_ragged': False, 'enable_fused_qk_norm_rope': False, 'enable_precise_embedding_interpolation': False, 'enable_fused_moe_sum_all_reduce': False, 'enable_deepseek_v4_fp4_indexer': False, 'disable_custom_all_reduce': False, 'enable_mscclpp': False, 'enable_torch_symm_mem': False, 'enable_scattered_sconv': False, 'pre_warm_nccl': False, 'enable_quant_communications': False, 'enable_flashinfer_allreduce_fusion': False, 'enforce_disable_flashinfer_allreduce_fusion': False, 'flashinfer_allreduce_fusion_backend': None, 'enable_aiter_allreduce_fusion': False, 'enable_torch_compile': False, 'enable_torch_compile_debug_mode': False, 'torch_compile_max_bs': 32, 'speculative_algorithm': 'DSPARK', 'uno_lora_path': None, 'speculative_draft_model_path': '/models/DeepSeek-V4.1-Flash', 'speculative_draft_model_revision': None, 'speculative_draft_load_format': None, 'speculative_num_steps': 1, 'speculative_eagle_topk': 1, 'speculative_num_draft_tokens': 6, 'speculative_dflash_block_size': None, 'speculative_dspark_block_size': 5, 'speculative_dspark_sps_table_path': None, 'speculative_dspark_confidence_sts_path': None, 'speculative_dspark_align_verify_tokens_to_graph_tier': False, 'speculative_accept_threshold_single': 1.0, 'speculative_accept_threshold_acc': 1.0, 'speculative_use_rejection_sampling': False, 'speculative_token_map': None, 'speculative_attention_mode': 'prefill', 'speculative_draft_attention_backend': None, 'speculative_dsa_topk_backend': 'sgl-kernel', 'speculative_draft_kv_cache_dtype': None, 'speculative_draft_window_size': None, 'speculative_moe_runner_backend': 'flashinfer_mxfp4', 'speculative_moe_a2a_backend': None, 'speculative_draft_model_quantization': None, '_speculative_draft_quantization_explicitly_set': False, 'speculative_skip_dp_mlp_sync': False, 'enable_multi_layer_eagle': False, 'speculative_adaptive': False, 'speculative_adaptive_config': None, 'decoupled_spec_bind_endpoint': None, 'decoupled_spec_connect_endpoints': None, 'decoupled_spec_rank': None, 'decoupled_spec_role': 'null', 'spec_trace_dir': None, 'speculative_ngram_min_bfs_breadth': 1, 'speculative_ngram_max_bfs_breadth': 10, 'speculative_ngram_match_type': 'BFS', 'speculative_ngram_max_trie_depth': 18, 'speculative_ngram_capacity': 10000000, 'speculative_ngram_external_corpus_path': None, 'speculative_ngram_external_sam_budget': 0, 'speculative_ngram_external_corpus_max_tokens': 10000000, 'ep_size': 3, 'moe_a2a_backend': 'none', 'enable_w4a4_mxfp4_megamoe': False, 'deepep_v2_mode': 'direct', 'moe_runner_backend': 'flashinfer_mxfp4', 'flashinfer_mxfp4_moe_precision': 'default', 'deepep_mode': 'auto', 'fuseep_mode': 2, 'deepep_dispatcher_output_dtype': 'auto', 'ep_num_redundant_experts': 0, 'ep_dispatch_algorithm': None, 'init_expert_location': 'trivial', 'enable_eplb': False, 'eplb_algorithm': 'auto', 'eplb_rebalance_num_iterations': 1000, 'eplb_rebalance_layers_per_chunk': None, 'eplb_min_rebalancing_utilization_threshold': 1.0, 'expert_distribution_recorder_mode': None, 'expert_distribution_recorder_buffer_size': 1000, 'expert_balancedness_report_mode': 'off', 'deepep_config': None, 'moe_dense_tp_size': None, 'elastic_ep_backend': None, 'enable_elastic_expert_backup': False, 'mooncake_ib_device': None, 'enable_waterfill': False, 'ep_join_mode': None, 'ep_join_rank_offset': 0, 'elastic_ep_initial_size': None, 'max_ep_size': None, 'elastic_ep_scale_timeout': 600, 'elastic_ep_rejoin': False, 'disable_flashinfer_cutlass_moe_fp4_allgather': False, 'disable_shared_experts_fusion': False, 'enforce_shared_experts_fusion': False, 'max_mamba_cache_size': None, 'mamba_ssm_dtype': None, 'mamba_max_states_per_path': -1, 'enable_mamba_cache_stochastic_rounding': False, 'mamba_cache_philox_rounds': 0, 'mamba_full_memory_ratio': 0.9, 'mamba_radix_cache_strategy': 'auto', 'uses_mamba_radix_cache': False, 'mamba_track_interval': 256, 'enable_int8_mamba_checkpoint': False, 'int8_mamba_ckpt_size': None, 'linear_attn_backend': 'triton', 'linear_attn_decode_backend': None, 'linear_attn_prefill_backend': None, 'linear_attn_verify_backend': None, 'enable_linear_replayssm': False, 'linear_replayssm_cache_len': 16, 'enable_linear_replayssm_spec': False, 'enable_hierarchical_cache': False, 'hicache_host_memory_mode': 'cache', 'hicache_ratio': 2.0, 'hicache_size': 0, 'hicache_write_policy': 'write_through', 'hicache_io_backend': 'kernel', 'hicache_mem_layout': 'page_first', 'hicache_storage_backend': None, 'hicache_storage_prefetch_policy': 'timeout', 'hicache_storage_backend_extra_config': None, 'hicache_storage_prefetch_retry_poll_interval': 0, 'hicache_storage_prefetch_retry_max_attempts': 4, 'enable_unified_cache_external_linker': False, 'unified_cache_external_linker_backend': 'mooncake', 'enable_hisparse': False, 'hisparse_config': None, 'enable_broadcast_mm_inputs_process': False, 'enable_prefix_mm_cache': False, 'mm_enable_dp_encoder': False, 'mm_process_config': {}, 'mm_processor_worker_num': 0, 'mm_io_worker_num': 0, 'allowed_media_domains': [], 'media_url_max_file_size_mb': 64, 'mm_preprocess_cache_size_mb': None, 'trust_mm_content_hashes': False, 'limit_mm_data_per_request': None, 'enable_mm_global_cache': False, 'image_processor_backend': 'auto', 'mm_global_cache_backend': 'mooncake', 'disable_fast_image_processor': False, 'mm_feature_transport': 'cpu', 'keep_mm_feature_on_device': False, 'enable_lora': None, 'enable_lora_overlap_loading': None, 'max_lora_rank': None, 'lora_target_modules': None, 'lora_paths': None, 'max_loaded_loras': None, 'max_loras_per_batch': 8, 'lora_eviction_policy': 'lru', 'lora_backend': 'csgmv', 'max_lora_chunk_size': 16, 'experts_shared_outer_loras': None, 'lora_use_virtual_experts': False, 'lora_strict_loading': False, 'lora_drain_wait_threshold': 0.0, 'enable_two_batch_overlap': False, 'enable_single_batch_overlap': False, 'tbo_token_distribution_threshold': 0.48, 'cpu_offload_gb': 0, 'offload_group_size': -1, 'offload_num_in_group': 1, 'offload_prefetch_step': 1, 'offload_mode': 'cpu', 'enable_lmcache': False, 'lmcache_config_file': None, 'enable_flexkv': False, 'flexkv_config_file': None, 'kt_weight_path': None, 'kt_method': 'AMXINT4', 'kt_cpuinfer': None, 'kt_threadpool_count': 2, 'kt_num_gpu_experts': None, 'kt_max_deferred_experts_per_token': None, 'dllm_algorithm': None, 'dllm_algorithm_config': None, 'dllm_fdfo': True, 'disaggregation_mode': 'null', 'disaggregation_transfer_backend': 'mooncake', 'disaggregation_bootstrap_port': 8998, 'disaggregation_ib_device': None, 'disaggregation_decode_enable_radix_cache': False, 'disaggregation_decode_enable_offload_kvcache': False, 'disaggregation_decode_retraction_backup': None, 'num_reserved_decode_tokens': 512, 'disaggregation_decode_extra_slots': None, 'disaggregation_decode_polling_interval': 1, 'optimistic_prefill_attempts': 0, 'encoder_only': False, 'language_only': False, 'language_model_only': False, 'encoder_transfer_backend': 'zmq_to_scheduler', 'encoder_urls': [], 'encoder_bootstrap_port': 8997, 'encoder_register_urls': [], 'enable_adaptive_dispatch_to_encoder': False, 'enable_pdmux': False, 'pdmux_config_path': None, 'sm_group_num': 8, 'startup_weight_load_mode': 'serial', 'custom_weight_loader': [], 'weight_loader_disable_mmap': False, 'weight_loader_prefetch_checkpoints': False, 'weight_loader_prefetch_num_threads': 4, 'weight_loader_drop_cache_after_load': False, 'remote_instance_weight_loader_seed_instance_ip': None, 'remote_instance_weight_loader_seed_instance_service_port': None, 'remote_instance_weight_loader_send_weights_group_ports': None, 'remote_instance_weight_loader_backend': 'nccl', 'remote_instance_weight_loader_start_seed_via_transfer_engine': False, 'engine_info_bootstrap_port': 6789, 'modelexpress_config': None, 'download_dir': None, 'model_checksum': None, 'delete_ckpt_after_loading': False, 'decrypted_config_file': None, 'decrypted_draft_config_file': None, 'checkpoint_engine_wait_weights_before_ready': False, 'enable_prefill_delayer': False, 'prefill_delayer_max_delay_passes': 30, 'prefill_delayer_token_usage_low_watermark': None, 'prefill_delayer_forward_passes_buckets': None, 'prefill_delayer_wait_seconds_buckets': None, 'prefill_delayer_queue_min_ratio': None, 'prefill_delayer_max_delay_ms': None, 'min_free_slots_delay': None, 'enable_deterministic_inference': False, 'rl_on_policy_target': None, 'kv_canary': 'none', 'kv_canary_real_data': 'none', 'kv_canary_sweep_interval': 0, 'enable_dynamic_batch_tokenizer': False, 'dynamic_batch_tokenizer_batch_size': 32, 'dynamic_batch_tokenizer_batch_timeout': 0.002, 'enable_tokenizer_batch_encode': False, 'disable_tokenizer_batch_decode': False, 'debug_tensor_dump_output_folder': None, 'debug_tensor_dump_layers': None, 'debug_tensor_dump_input_file': None, 'enable_memory_saver': False, 'enable_weights_cpu_backup': False, 'enable_draft_weights_cpu_backup': False, 'enable_custom_logit_processor': False, 'enable_return_hidden_states': False, 'return_hidden_states_mode': None, 'enable_return_routed_experts': False, 'enable_return_indexer_topk': False, 'enable_encoder_swa_bounded_replay': False, 'enable_decoder_swa_bounded_replay': True, 'disable_outlines_disk_cache': False, 'enable_mis': False, 'weight_cache_mode': 'off', 'weight_cache_socket': None, 'weight_cache_timeout': 1800, 'forward_hooks': None, 'msprobe_dump_config': None}
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
[2026-09-11 23:34:05 TP1 EP1] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:05 TP1 EP1] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:05 TP1 EP1] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
DSV41 TP pad installed (tp=3)
[2026-09-11 23:34:06 TP1 EP1] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:06 TP1 EP1] DSV41 prefill empty_cache hook installed (extend forwards with a sequence >= 8192 tokens)
[2026-09-11 23:34:08 TP1 EP1] torchcodec is not installed; audio inputs will fail at request time
[2026-09-11 23:34:08 TP1 EP1] Ignore import error when loading sglang.srt.multimodal.processors.mimo_v2: No module named 'torchcodec'
[2026-09-11 23:34:08 TP1 EP1] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:08 TP1 EP1] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:08 TP1 EP1] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:08 TP1 EP1] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:34:08 TP1 EP1] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:08 TP1 EP1] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:08 TP1 EP1] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:08 TP1 EP1] Init torch distributed begin.
[2026-09-11 23:34:12 TP1 EP1] CustomAllreduce is disabled because this process group spans across nodes.
[2026-09-11 23:34:12 TP1 EP1] Init torch distributed ends. elapsed=3.99 s, mem usage=0.61 GB
[2026-09-11 23:34:14 TP1 EP1] Load weight begin. avail mem=113.03 GB
[2026-09-11 23:34:14 TP1 EP1] Multimodal attention backend not set. Use triton_attn.
[2026-09-11 23:34:14 TP1 EP1] Using triton_attn as multimodal attention backend.
[2026-09-11 23:34:14 TP1 EP1] FlashInfer TRTLLM MoE deferred finalize is disabled (moe_runner_backend=flashinfer_mxfp4, quant_method=Mxfp4FlashinferCutlassMoEMethod).
[2026-09-11 23:34:14 TP1 EP1] Exact nvme Engram layer=1 rank=1 rows=[128002056,256004112) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:14 TP1 EP1] Exact nvme Engram layer=14 rank=1 rows=[128005560,256011121) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:16 TP1 EP1] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:17 TP1 EP1] multimem all-gather disabled because the TP group spans across nodes.
[2026-09-11 23:35:33 TP1 EP1] Finished streaming dequant fp8 wo_a
[2026-09-11 23:44:17 TP1 EP1] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:44:17 TP1 EP1] Load weight end. elapsed=603.73 s, type=DeepseekV4ForCausalLM, quant=fp8, avail mem=17.72 GB, mem usage=95.31 GB.
[2026-09-11 23:44:37 TP1 EP1] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:44:38 TP1 EP1] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:44:38 TP1 EP1] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:44:38 TP1 EP1] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:44:38 TP1 EP1] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:44:38 TP1 EP1] Init torch distributed begin.
[2026-09-11 23:44:38 TP1 EP1] Init torch distributed ends. elapsed=0.02 s, mem usage=0.00 GB
[2026-09-11 23:44:38 TP1 EP1] Load weight begin. avail mem=17.50 GB
[2026-09-11 23:45:58 TP1 EP1] Finished streaming dequant fp8 wo_a
[2026-09-11 23:45:59 TP1 EP1] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:45:59 TP1 EP1] Load weight end. elapsed=80.79 s, type=DeepseekV4ForCausalLMDSpark, quant=fp8, avail mem=15.08 GB, mem usage=2.41 GB.
[2026-09-11 23:46:11 TP1 EP1] Reserving 0.10 GB of the KV budget for post-sizing multimodal allocations (feature-transport pools + embedding cache).
[2026-09-11 23:46:11 TP1 EP1] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP1 EP1] DSV4 memory calculation: bytes_per_full_token=1670.75, available_bytes=8.84 GB, c128_state_fixed=0.00 GB, swa_fixed=0.30 GB, full_token=5491200
[2026-09-11 23:46:11 TP1 EP1] DSV4 pool sizes: full=5491200, swa=13312, c4=1372800, c128=42900, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP1 EP1] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP1 EP1] DSV4 pool sizes: full=2999808, swa=13312, c4=749952, c128=23436, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP1 EP1] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=749952 c4_logical_size=749952 c128_size=23436 c4_state_pool_size=1664 c128_state_pool_size=1280
[2026-09-11 23:46:14 TP1 EP1] Memory pool end. avail mem=10.20 GB
[2026-09-11 23:46:14 TP1 EP1] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=0 c4_logical_size=0 c128_size=0 c4_state_pool_size=0 c128_state_pool_size=0
[2026-09-11 23:46:14 TP1 EP1] Memory pool end. avail mem=10.17 GB
[2026-09-11 23:46:17 TP1 EP1] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:17 TP1 EP1] Overriding draft attention backend to dsv4.
[2026-09-11 23:46:17 TP1 EP1] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:18 TP1 EP1] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/05cc0d96dc7e28b8/rank_tp1_pp0_dp0.json
[2026-09-11 23:46:21 TP1 EP1] Disable CP decode attention TP

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  17%|█▋        | 1/6 [00:00<00:00,  6.41profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00,  9.10profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00,  8.91profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/6 [00:00<?, ?profile/s][TensorRT-LLM][INFO] Set logger level to INFO

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  17%|█▋        | 1/6 [00:00<00:01,  4.20profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  33%|███▎      | 2/6 [00:00<00:00,  5.40profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  50%|█████     | 3/6 [00:00<00:00,  6.08profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  67%|██████▋   | 4/6 [00:01<00:00,  2.61profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  83%|████████▎ | 5/6 [00:01<00:00,  2.20profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.19profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.63profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  17%|█▋        | 1/6 [00:00<00:00,  9.76profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  33%|███▎      | 2/6 [00:00<00:00,  9.22profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 3/6 [00:00<00:00,  8.94profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  67%|██████▋   | 4/6 [00:00<00:00,  7.39profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  83%|████████▎ | 5/6 [00:00<00:00,  5.81profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  4.99profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  6.03profile/s]

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  17%|█▋        | 1/6 [00:00<00:00,  5.08profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  67%|██████▋   | 4/6 [00:00<00:00, 14.25profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 13.56profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 12.62profile/s]
[2026-09-11 23:46:30 TP1 EP1] FlashInfer autotune completed.
[2026-09-11 23:46:30 TP1 EP1] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:30 TP1 EP1] Capture target verify CUDA graph begin. backend=full, num_tokens_per_req=6, bs=[1, 2, 3, 4], avail mem=8.15 GB
[2026-09-11 23:46:44 TP1 EP1] Capture target verify CUDA graph end. elapsed=13.46 s, mem usage=0.49 GB, avail mem=7.66 GB.
[2026-09-11 23:46:44 TP1 EP1] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:44 TP1 EP1] Capture draft verify CUDA graph begin. backend=full, num_tokens_per_req=5, bs=[1, 2, 3, 4], avail mem=7.65 GB
[2026-09-11 23:46:45 TP1 EP1] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/3ea8a0a6a68937f8/rank_tp1_pp0_dp0.json

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  50%|█████     | 3/6 [00:00<00:00, 15.19profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 23.92profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/4 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  25%|██▌       | 1/4 [00:00<00:00,  4.70profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  75%|███████▌  | 3/4 [00:00<00:00,  7.87profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  7.46profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  7.22profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/4 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 2/4 [00:00<00:00, 13.09profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.39profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.72profile/s]
[2026-09-11 23:46:47 TP1 EP1] FlashInfer autotune completed.
[2026-09-11 23:46:49 TP1 EP1] Capture draft verify CUDA graph end. elapsed=4.76 s, mem usage=-0.16 GB, avail mem=7.81 GB.
[2026-09-11 23:46:49 TP1 EP1] Init Unified Radix Cache. Components: (<ComponentType.FULL: 0>, <ComponentType.SWA: 1>). Tree Core: UnifiedTreeCore
[2026-09-11 23:46:49 TP1 EP1] Tree cache initialized: source=default impl=UnifiedRadixCache hybrid_swa=True hybrid_ssm=False hicache_attached=False streaming_wrapped=False
[2026-09-11 23:46:51] Dummy health check server started in background thread at 0.0.0.0:8888
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:47:03 TP1 EP1] Freezing GC in Scheduler process. gen0: 580->0, gen1: 975->0, gen2: 1109440->0
[2026-09-11 23:47:15 TP1 EP1] Engram layer=1 lookups=2944 hit_rate=0.0% reads=2944 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:47:15 TP1 EP1] Engram layer=14 lookups=2944 hit_rate=0.0% reads=2944 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:48:15 TP1 EP1] Engram layer=1 lookups=42279 hit_rate=0.0% reads=42279 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:48:15 TP1 EP1] Engram layer=14 lookups=42280 hit_rate=0.0% reads=42280 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:15 TP1 EP1] Engram layer=1 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:15 TP1 EP1] Engram layer=14 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:55:15 TP1 EP1] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:55:15 TP1 EP1] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
~~~
### 3.3 dsv41-worker（spark-3）
~~~
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
SKIP_PREPARE=1 — using existing checkpoint
DSPARK_SPS_TABLE=/state/dspark_sps.json not found; staying on the verify-all schedule
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
/sgl-workspace/sglang/python/sglang/launch_server.py:63: UserWarning: 'python -m sglang.launch_server' is still supported, but 'sglang serve' is the recommended entrypoint.
  Example: sglang serve --model-path <model> [options]
  warnings.warn(
[2026-09-11 23:33:59] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:33:59] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:33:59] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:33:59] Hybrid SWA model detected. architectures=['DeepseekV4ForCausalLM']
[2026-09-11 23:33:59] Breakable CUDA graph is incompatible with DeepSeek-V4 (heavy capture-pool memory pressure); disabling prefill CUDA graph.
[2026-09-11 23:33:59] Failed to get GPU memory capacity from nvidia-smi. Falling back to torch.cuda.mem_get_info(). Reported total GPU memory per device (MiB): [124610], using min: 124610 MiB.
[2026-09-11 23:33:59] Use dsv4 attention backend for DeepseekV4ForCausalLM, setting page_size to 256.
[2026-09-11 23:33:59] Setting KV cache dtype to fp8_e4m3 for DeepseekV4ForCausalLM.
[2026-09-11 23:33:59] DSpark draft weights are bundled in the target checkpoint; defaulting --speculative-draft-model-path to --model-path (/models/DeepSeek-V4.1-Flash).
[2026-09-11 23:34:00] server_args={'model_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_path': '/models/DeepSeek-V4.1-Flash', 'tokenizer_mode': 'auto', 'tokenizer_backend': 'huggingface', 'tokenizer_worker_num': 1, 'detokenizer_worker_num': 1, 'skip_tokenizer_init': False, 'load_format': 'safetensors', 'model_loader_extra_config': '{}', 'trust_remote_code': True, 'context_length': 1048576, 'is_embedding': False, 'enable_multimodal': None, 'revision': None, 'model_impl': 'auto', 'model_config_parser': 'auto', 'json_model_override_args': '{}', 'dtype': 'auto', 'quantization': None, 'quantization_param_path': None, 'kv_cache_dtype': 'fp8_e4m3', 'enable_fp32_lm_head': False, 'modelopt_quant': None, 'modelopt_checkpoint_restore_path': None, 'modelopt_checkpoint_save_path': None, 'modelopt_export_path': None, 'quantize_and_serve': False, 'rl_quant_profile': None, 'enable_tf32_matmul': False, 'mem_fraction_static': 0.95, 'max_running_requests': 4, 'max_queued_requests': None, 'max_total_tokens': 3000000, 'chunked_prefill_size': 1024, 'prefill_decode_interval': 0, 'enable_dynamic_chunking': False, 'max_prefill_tokens': 16384, 'prefill_max_requests': None, 'schedule_policy': 'fcfs', 'enable_priority_scheduling': False, 'disable_priority_preemption': False, 'default_priority_value': None, 'abort_on_priority_when_disabled': False, 'schedule_low_priority_values_first': False, 'priority_scheduling_preemption_threshold': 10, 'retraction_policy': 'length', 'schedule_conservativeness': 1.0, 'page_size': 256, 'c128_page_size': 16, 'swa_full_tokens_ratio': 0.8, 'swa_prefix_tails': None, 'disable_hybrid_swa_memory': False, 'radix_eviction_policy': 'lru', 'prefill_only_disable_kv_cache': False, 'disable_radix_cache': False, 'enable_page_major_kv_layout': False, 'enable_unified_memory': False, 'disable_chunked_prefix_cache': False, 'disable_overlap_schedule': False, 'num_continuous_decode_steps': 1, 'scheduler_recv_interval': 1, 'enable_mixed_chunk': False, 'nccl_port': None, 'dist_timeout': None, 'dist_init_addr': '192.168.123.103:20000', 'gated_launch_port': None, 'nnodes': 3, 'node_rank': 2, 'tp_size': 3, 'dcp_size': 1, 'pp_size': 1, 'pp_max_micro_batch_size': None, 'pp_async_batch_depth': 0, 'dp_size': 1, 'load_balance_method': 'round_robin', 'attn_cp_size': 1, 'moe_dp_size': 1, 'dwdp_size': 1, 'dcp_comm_backend': 'ag_rs', 'dcp_replicate_q_proj': None, 'enable_prefill_cp': False, 'cp_strategy': None, 'enable_dsa_cache_layer_split': False, 'enable_dsa_prefill_context_parallel': False, 'dsa_prefill_cp_mode': 'round-robin-split', 'enable_prefill_context_parallel': False, 'prefill_cp_mode': 'in-seq-split', 'enable_cp_decode_attn_tp': False, 'enable_dp_attention': False, 'enable_dp_attention_local_control_broadcast': False, 'enable_dp_lm_head': False, 'enable_tp_lm_head_all_to_all': False, 'enable_attn_tp_input_scattered': False, 'enable_shared_experts_attn_tp': False, 'enable_dense_mlp_attn_tp': False, 'enable_layernorm_sp': False, 'disable_attn_tp_gather': False, 'enable_p2p_check': False, 'device': 'cuda', 'base_gpu_id': 0, 'gpu_id_step': 1, 'random_seed': 0, 'mlx_enable_sampling': False, 'watchdog_timeout': 1800.0, 'soft_watchdog_timeout': None, 'sleep_on_idle': False, 'use_ray': False, 'custom_sigquit_handler': None, 'numa_node': None, 'gc_threshold': None, 'host': '0.0.0.0', 'port': 8888, 'fastapi_root_path': '', 'smg_grpc_mode': False, 'grpc_mode': False, 'grpc_port': None, 'grpc_worker_threads': 4, 'sidecar': None, 'sidecar_args': None, 'skip_server_warmup': False, 'warmups': None, 'enable_http2': False, 'http2_max_concurrent_streams': 200, 'http2_initial_connection_window_size': 1048576, 'ssl_keyfile': None, 'ssl_certfile': None, 'ssl_ca_certs': None, 'ssl_keyfile_password': None, 'enable_ssl_refresh': False, 'api_key': '[REDACTED]', 'admin_api_key': None, 'served_model_name': 'deepseek-v4.1-flash', 'weight_version': 'default', 'chat_template': None, 'hf_chat_template_name': None, 'completion_template': None, 'file_storage_path': 'sglang_storage', 'enable_cache_report': False, 'reasoning_parser': 'deepseek-v41', 'default_chat_template_kwargs': None, 'strip_thinking_cache': False, 'enable_strict_thinking': False, 'tool_call_parser': 'deepseekv41', 'tool_server': None, 'sampling_defaults': 'model', 'asr_max_buffer_seconds': 60, 'asr_max_concurrent_sessions': 32, 'preferred_sampling_params': None, 'allow_auto_truncate': False, 'stream_interval': 1, 'batch_notify_size': 16, 'stream_response_default_include_usage': False, 'incremental_streaming_output': False, 'enable_streaming_session': False, 'enable_session_radix_cache': False, 'log_level': 'info', 'log_level_http': None, 'log_requests': False, 'log_requests_level': 2, 'log_requests_format': 'text', 'log_requests_target': None, 'uvicorn_access_log_exclude_prefixes': [], 'crash_dump_folder': None, 'show_time_cost': False, 'enable_metrics': False, 'smg_http_sidecar_port': None, 'enable_mfu_metrics': False, 'enable_metrics_for_all_schedulers': False, 'load_snapshot_publish_interval': 15, 'tokenizer_metrics_custom_labels_header': 'x-custom-labels', 'tokenizer_metrics_allowed_custom_labels': None, 'extra_metric_labels': None, 'bucket_time_to_first_token': None, 'bucket_inter_token_latency': None, 'bucket_e2e_request_latency': None, 'prompt_tokens_buckets': None, 'generation_tokens_buckets': None, 'gc_warning_threshold_secs': 0.0, 'decode_log_interval': 40, 'enable_request_time_stats_logging': False, 'kv_events_config': None, 'load_publish_endpoint': None, 'enable_forward_pass_metrics': False, 'forward_pass_metrics_worker_id': '', 'forward_pass_metrics_ipc_name': None, 'enable_trace': False, 'trace_modules': 'request', 'otlp_traces_endpoint': 'localhost:4317', 'export_metrics_to_file': False, 'export_metrics_to_file_dir': None, 'stat_loggers': None, 'constrained_json_whitespace_pattern': None, 'constrained_json_disable_any_whitespace': False, 'attention_backend': 'dsv4', 'decode_attention_backend': None, 'enable_lean_attention': None, 'prefill_attention_backend': None, 'sampling_backend': 'flashinfer', 'grammar_backend': 'xgrammar', 'radix_cache_backend': None, 'mm_attention_backend': None, 'fp8_gemm_runner_backend': 'flashinfer_cutlass', 'fp4_gemm_runner_backend': 'auto', 'bf16_gemm_backend': 'auto', 'dsa_prefill_backend': None, 'dsv4_prefill_backend': 'auto', 'dsa_decode_backend': None, 'dsa_paged_mqa_logits_backend': 'auto', 'dsa_topk_backend': 'sgl-kernel', 'disable_flashinfer_autotune': False, 'flashinfer_autotune_skip_ops': None, 'mamba_backend': 'triton', 'cuda_graph_config': {'decode': {'backend': 'full', 'max_bs': 4, 'bs': [1, 2, 3, 4], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}, 'prefill': {'backend': 'disabled', 'max_bs': 1024, 'bs': [4, 8, 12, 16, 20, 24, 28, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 288, 320, 352, 384, 416, 448, 480, 512, 576, 640, 704, 768, 832, 896, 960, 1024], 'tc_compiler': 'eager', 'full_prefill_max_req': None, 'full_prefill_prefix_chunk_tokens': None, 'max_seq_len': None}}, 'cuda_graph_backend_decode': None, 'cuda_graph_backend_prefill': None, 'cuda_graph_max_bs_decode': 4, 'cuda_graph_max_bs_prefill': None, 'cuda_graph_max_seq_len_prefill': None, 'cuda_graph_bs_decode': None, 'cuda_graph_bs_prefill': None, 'cuda_graph_tc_compiler': None, 'disable_prefill_cuda_graph': False, 'disable_decode_cuda_graph': False, 'disable_cuda_graph': False, 'disable_cuda_graph_padding': False, 'enable_profile_cuda_graph': False, 'enable_cudagraph_gc': False, 'debug_cuda_graph': False, 'enable_layerwise_nvtx_marker': False, 'enable_nccl_nvls': False, 'enable_symm_mem': False, 'triton_attention_reduce_in_fp32': False, 'triton_attention_num_kv_splits': 8, 'triton_attention_split_tile_size': None, 'flashinfer_mla_disable_ragged': False, 'enable_fused_qk_norm_rope': False, 'enable_precise_embedding_interpolation': False, 'enable_fused_moe_sum_all_reduce': False, 'enable_deepseek_v4_fp4_indexer': False, 'disable_custom_all_reduce': False, 'enable_mscclpp': False, 'enable_torch_symm_mem': False, 'enable_scattered_sconv': False, 'pre_warm_nccl': False, 'enable_quant_communications': False, 'enable_flashinfer_allreduce_fusion': False, 'enforce_disable_flashinfer_allreduce_fusion': False, 'flashinfer_allreduce_fusion_backend': None, 'enable_aiter_allreduce_fusion': False, 'enable_torch_compile': False, 'enable_torch_compile_debug_mode': False, 'torch_compile_max_bs': 32, 'speculative_algorithm': 'DSPARK', 'uno_lora_path': None, 'speculative_draft_model_path': '/models/DeepSeek-V4.1-Flash', 'speculative_draft_model_revision': None, 'speculative_draft_load_format': None, 'speculative_num_steps': 1, 'speculative_eagle_topk': 1, 'speculative_num_draft_tokens': 6, 'speculative_dflash_block_size': None, 'speculative_dspark_block_size': 5, 'speculative_dspark_sps_table_path': None, 'speculative_dspark_confidence_sts_path': None, 'speculative_dspark_align_verify_tokens_to_graph_tier': False, 'speculative_accept_threshold_single': 1.0, 'speculative_accept_threshold_acc': 1.0, 'speculative_use_rejection_sampling': False, 'speculative_token_map': None, 'speculative_attention_mode': 'prefill', 'speculative_draft_attention_backend': None, 'speculative_dsa_topk_backend': 'sgl-kernel', 'speculative_draft_kv_cache_dtype': None, 'speculative_draft_window_size': None, 'speculative_moe_runner_backend': 'flashinfer_mxfp4', 'speculative_moe_a2a_backend': None, 'speculative_draft_model_quantization': None, '_speculative_draft_quantization_explicitly_set': False, 'speculative_skip_dp_mlp_sync': False, 'enable_multi_layer_eagle': False, 'speculative_adaptive': False, 'speculative_adaptive_config': None, 'decoupled_spec_bind_endpoint': None, 'decoupled_spec_connect_endpoints': None, 'decoupled_spec_rank': None, 'decoupled_spec_role': 'null', 'spec_trace_dir': None, 'speculative_ngram_min_bfs_breadth': 1, 'speculative_ngram_max_bfs_breadth': 10, 'speculative_ngram_match_type': 'BFS', 'speculative_ngram_max_trie_depth': 18, 'speculative_ngram_capacity': 10000000, 'speculative_ngram_external_corpus_path': None, 'speculative_ngram_external_sam_budget': 0, 'speculative_ngram_external_corpus_max_tokens': 10000000, 'ep_size': 3, 'moe_a2a_backend': 'none', 'enable_w4a4_mxfp4_megamoe': False, 'deepep_v2_mode': 'direct', 'moe_runner_backend': 'flashinfer_mxfp4', 'flashinfer_mxfp4_moe_precision': 'default', 'deepep_mode': 'auto', 'fuseep_mode': 2, 'deepep_dispatcher_output_dtype': 'auto', 'ep_num_redundant_experts': 0, 'ep_dispatch_algorithm': None, 'init_expert_location': 'trivial', 'enable_eplb': False, 'eplb_algorithm': 'auto', 'eplb_rebalance_num_iterations': 1000, 'eplb_rebalance_layers_per_chunk': None, 'eplb_min_rebalancing_utilization_threshold': 1.0, 'expert_distribution_recorder_mode': None, 'expert_distribution_recorder_buffer_size': 1000, 'expert_balancedness_report_mode': 'off', 'deepep_config': None, 'moe_dense_tp_size': None, 'elastic_ep_backend': None, 'enable_elastic_expert_backup': False, 'mooncake_ib_device': None, 'enable_waterfill': False, 'ep_join_mode': None, 'ep_join_rank_offset': 0, 'elastic_ep_initial_size': None, 'max_ep_size': None, 'elastic_ep_scale_timeout': 600, 'elastic_ep_rejoin': False, 'disable_flashinfer_cutlass_moe_fp4_allgather': False, 'disable_shared_experts_fusion': False, 'enforce_shared_experts_fusion': False, 'max_mamba_cache_size': None, 'mamba_ssm_dtype': None, 'mamba_max_states_per_path': -1, 'enable_mamba_cache_stochastic_rounding': False, 'mamba_cache_philox_rounds': 0, 'mamba_full_memory_ratio': 0.9, 'mamba_radix_cache_strategy': 'auto', 'uses_mamba_radix_cache': False, 'mamba_track_interval': 256, 'enable_int8_mamba_checkpoint': False, 'int8_mamba_ckpt_size': None, 'linear_attn_backend': 'triton', 'linear_attn_decode_backend': None, 'linear_attn_prefill_backend': None, 'linear_attn_verify_backend': None, 'enable_linear_replayssm': False, 'linear_replayssm_cache_len': 16, 'enable_linear_replayssm_spec': False, 'enable_hierarchical_cache': False, 'hicache_host_memory_mode': 'cache', 'hicache_ratio': 2.0, 'hicache_size': 0, 'hicache_write_policy': 'write_through', 'hicache_io_backend': 'kernel', 'hicache_mem_layout': 'page_first', 'hicache_storage_backend': None, 'hicache_storage_prefetch_policy': 'timeout', 'hicache_storage_backend_extra_config': None, 'hicache_storage_prefetch_retry_poll_interval': 0, 'hicache_storage_prefetch_retry_max_attempts': 4, 'enable_unified_cache_external_linker': False, 'unified_cache_external_linker_backend': 'mooncake', 'enable_hisparse': False, 'hisparse_config': None, 'enable_broadcast_mm_inputs_process': False, 'enable_prefix_mm_cache': False, 'mm_enable_dp_encoder': False, 'mm_process_config': {}, 'mm_processor_worker_num': 0, 'mm_io_worker_num': 0, 'allowed_media_domains': [], 'media_url_max_file_size_mb': 64, 'mm_preprocess_cache_size_mb': None, 'trust_mm_content_hashes': False, 'limit_mm_data_per_request': None, 'enable_mm_global_cache': False, 'image_processor_backend': 'auto', 'mm_global_cache_backend': 'mooncake', 'disable_fast_image_processor': False, 'mm_feature_transport': 'cpu', 'keep_mm_feature_on_device': False, 'enable_lora': None, 'enable_lora_overlap_loading': None, 'max_lora_rank': None, 'lora_target_modules': None, 'lora_paths': None, 'max_loaded_loras': None, 'max_loras_per_batch': 8, 'lora_eviction_policy': 'lru', 'lora_backend': 'csgmv', 'max_lora_chunk_size': 16, 'experts_shared_outer_loras': None, 'lora_use_virtual_experts': False, 'lora_strict_loading': False, 'lora_drain_wait_threshold': 0.0, 'enable_two_batch_overlap': False, 'enable_single_batch_overlap': False, 'tbo_token_distribution_threshold': 0.48, 'cpu_offload_gb': 0, 'offload_group_size': -1, 'offload_num_in_group': 1, 'offload_prefetch_step': 1, 'offload_mode': 'cpu', 'enable_lmcache': False, 'lmcache_config_file': None, 'enable_flexkv': False, 'flexkv_config_file': None, 'kt_weight_path': None, 'kt_method': 'AMXINT4', 'kt_cpuinfer': None, 'kt_threadpool_count': 2, 'kt_num_gpu_experts': None, 'kt_max_deferred_experts_per_token': None, 'dllm_algorithm': None, 'dllm_algorithm_config': None, 'dllm_fdfo': True, 'disaggregation_mode': 'null', 'disaggregation_transfer_backend': 'mooncake', 'disaggregation_bootstrap_port': 8998, 'disaggregation_ib_device': None, 'disaggregation_decode_enable_radix_cache': False, 'disaggregation_decode_enable_offload_kvcache': False, 'disaggregation_decode_retraction_backup': None, 'num_reserved_decode_tokens': 512, 'disaggregation_decode_extra_slots': None, 'disaggregation_decode_polling_interval': 1, 'optimistic_prefill_attempts': 0, 'encoder_only': False, 'language_only': False, 'language_model_only': False, 'encoder_transfer_backend': 'zmq_to_scheduler', 'encoder_urls': [], 'encoder_bootstrap_port': 8997, 'encoder_register_urls': [], 'enable_adaptive_dispatch_to_encoder': False, 'enable_pdmux': False, 'pdmux_config_path': None, 'sm_group_num': 8, 'startup_weight_load_mode': 'serial', 'custom_weight_loader': [], 'weight_loader_disable_mmap': False, 'weight_loader_prefetch_checkpoints': False, 'weight_loader_prefetch_num_threads': 4, 'weight_loader_drop_cache_after_load': False, 'remote_instance_weight_loader_seed_instance_ip': None, 'remote_instance_weight_loader_seed_instance_service_port': None, 'remote_instance_weight_loader_send_weights_group_ports': None, 'remote_instance_weight_loader_backend': 'nccl', 'remote_instance_weight_loader_start_seed_via_transfer_engine': False, 'engine_info_bootstrap_port': 6789, 'modelexpress_config': None, 'download_dir': None, 'model_checksum': None, 'delete_ckpt_after_loading': False, 'decrypted_config_file': None, 'decrypted_draft_config_file': None, 'checkpoint_engine_wait_weights_before_ready': False, 'enable_prefill_delayer': False, 'prefill_delayer_max_delay_passes': 30, 'prefill_delayer_token_usage_low_watermark': None, 'prefill_delayer_forward_passes_buckets': None, 'prefill_delayer_wait_seconds_buckets': None, 'prefill_delayer_queue_min_ratio': None, 'prefill_delayer_max_delay_ms': None, 'min_free_slots_delay': None, 'enable_deterministic_inference': False, 'rl_on_policy_target': None, 'kv_canary': 'none', 'kv_canary_real_data': 'none', 'kv_canary_sweep_interval': 0, 'enable_dynamic_batch_tokenizer': False, 'dynamic_batch_tokenizer_batch_size': 32, 'dynamic_batch_tokenizer_batch_timeout': 0.002, 'enable_tokenizer_batch_encode': False, 'disable_tokenizer_batch_decode': False, 'debug_tensor_dump_output_folder': None, 'debug_tensor_dump_layers': None, 'debug_tensor_dump_input_file': None, 'enable_memory_saver': False, 'enable_weights_cpu_backup': False, 'enable_draft_weights_cpu_backup': False, 'enable_custom_logit_processor': False, 'enable_return_hidden_states': False, 'return_hidden_states_mode': None, 'enable_return_routed_experts': False, 'enable_return_indexer_topk': False, 'enable_encoder_swa_bounded_replay': False, 'enable_decoder_swa_bounded_replay': True, 'disable_outlines_disk_cache': False, 'enable_mis': False, 'weight_cache_mode': 'off', 'weight_cache_socket': None, 'weight_cache_timeout': 1800, 'forward_hooks': None, 'msprobe_dump_config': None}
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 MXFP8 dense linears routed to FlashInfer backend 'b12x' (zero block scales of padded shards encoded as 1.0)
DSV41 padded-shard block-scale repair installed
DSV41 TP pad installed (tp=3)
DSV41 TP pad installed (tp=3)
[2026-09-11 23:34:05 TP2 EP2] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:05 TP2 EP2] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:05 TP2 EP2] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:06 TP2 EP2] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:07 TP2 EP2] DSV41 prefill empty_cache hook installed (extend forwards with a sequence >= 8192 tokens)
[2026-09-11 23:34:08 TP2 EP2] torchcodec is not installed; audio inputs will fail at request time
[2026-09-11 23:34:08 TP2 EP2] Ignore import error when loading sglang.srt.multimodal.processors.mimo_v2: No module named 'torchcodec'
[2026-09-11 23:34:09 TP2 EP2] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:09 TP2 EP2] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:09 TP2 EP2] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:09 TP2 EP2] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:34:09 TP2 EP2] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:34:09 TP2 EP2] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:34:09 TP2 EP2] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:34:09 TP2 EP2] Init torch distributed begin.
[2026-09-11 23:34:12 TP2 EP2] CustomAllreduce is disabled because this process group spans across nodes.
[2026-09-11 23:34:12 TP2 EP2] Init torch distributed ends. elapsed=3.53 s, mem usage=0.64 GB
[2026-09-11 23:34:14 TP2 EP2] Load weight begin. avail mem=112.98 GB
[2026-09-11 23:34:14 TP2 EP2] Multimodal attention backend not set. Use triton_attn.
[2026-09-11 23:34:14 TP2 EP2] Using triton_attn as multimodal attention backend.
[2026-09-11 23:34:14 TP2 EP2] FlashInfer TRTLLM MoE deferred finalize is disabled (moe_runner_backend=flashinfer_mxfp4, quant_method=Mxfp4FlashinferCutlassMoEMethod).
[2026-09-11 23:34:14 TP2 EP2] Exact nvme Engram layer=1 rank=2 rows=[256004112,384006168) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:14 TP2 EP2] Exact nvme Engram layer=14 rank=2 rows=[256011121,384016682) cache=0.0GiB (0 slots, 4-way, 0.0% of owned rows) scales=0.0GiB io_threads=96 packed=True
[2026-09-11 23:34:16 TP2 EP2] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:34:17 TP2 EP2] multimem all-gather disabled because the TP group spans across nodes.
[2026-09-11 23:36:06 TP2 EP2] Finished streaming dequant fp8 wo_a
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:44:34 TP2 EP2] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:44:34 TP2 EP2] Load weight end. elapsed=620.80 s, type=DeepseekV4ForCausalLM, quant=fp8, avail mem=17.78 GB, mem usage=95.20 GB.
[2026-09-11 23:44:37 TP2 EP2] Tokenizer for /models/DeepSeek-V4.1-Flash is still TokenizersBackend after retries with --trust-remote-code. Model-specific tokenizer attributes may be missing.
[2026-09-11 23:44:38 TP2 EP2] Draft checkpoint bundles a DSpark head; loading draft arch DeepseekV4ForCausalLMDSpark.
[2026-09-11 23:44:38 TP2 EP2] Auto-detected DSV4 routed-expert layout: is_fp4_experts=True
[2026-09-11 23:44:38 TP2 EP2] DSV41 TP pad: num_attention_heads 64→96, o_groups 8→12 (tp=3, local_heads=32)
[2026-09-11 23:44:38 TP2 EP2] DSV41 TP pad: dspark_n_routed_experts 128→129 (tp=3)
[2026-09-11 23:44:38 TP2 EP2] Init torch distributed begin.
[2026-09-11 23:44:38 TP2 EP2] Init torch distributed ends. elapsed=0.02 s, mem usage=0.00 GB
[2026-09-11 23:44:38 TP2 EP2] Load weight begin. avail mem=17.50 GB
[2026-09-11 23:46:06 TP2 EP2] Finished streaming dequant fp8 wo_a
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for ColumnParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] DSV41 block scales for RowParallelLinear: 20480 invalid scales (e.g. [5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39, 5.877471754111438e-39]), 20480 on all-zero weight blocks set to 1.0, 0 on non-zero blocks left alone
[2026-09-11 23:46:07 TP2 EP2] Using FP8 KV cache but no scaling factors provided. Defaulting to scaling factors of 1.0. This may lead to less accurate results!
[2026-09-11 23:46:07 TP2 EP2] Load weight end. elapsed=88.40 s, type=DeepseekV4ForCausalLMDSpark, quant=fp8, avail mem=14.96 GB, mem usage=2.54 GB.
[2026-09-11 23:46:11 TP2 EP2] Reserving 0.10 GB of the KV budget for post-sizing multimodal allocations (feature-transport pools + embedding cache).
[2026-09-11 23:46:11 TP2 EP2] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP2 EP2] DSV4 memory calculation: bytes_per_full_token=1670.75, available_bytes=8.84 GB, c128_state_fixed=0.00 GB, swa_fixed=0.30 GB, full_token=5491200
[2026-09-11 23:46:11 TP2 EP2] DSV4 pool sizes: full=5491200, swa=13312, c4=1372800, c128=42900, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP2 EP2] DSV4 SWA sizing: mode=cap, swa_tokens=13312, request_cap+headroom=13312, prefix_tails=16
[2026-09-11 23:46:11 TP2 EP2] DSV4 pool sizes: full=2999808, swa=13312, c4=749952, c128=23436, c4_state=1664, c128_state=0
[2026-09-11 23:46:11 TP2 EP2] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=749952 c4_logical_size=749952 c128_size=23436 c4_state_pool_size=1664 c128_state_pool_size=1280
[2026-09-11 23:46:12 TP2 EP2] Memory pool end. avail mem=10.09 GB
[2026-09-11 23:46:12 TP2 EP2] Initialize DeepSeekV4TokenToKVPool with max_num_reqs=4 swa_size=13312 c4_size=0 c4_logical_size=0 c128_size=0 c4_state_pool_size=0 c128_state_pool_size=0
[2026-09-11 23:46:12 TP2 EP2] Memory pool end. avail mem=10.07 GB
[2026-09-11 23:46:15 TP2 EP2] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:15 TP2 EP2] Overriding draft attention backend to dsv4.
[2026-09-11 23:46:15 TP2 EP2] Using DeepseekV4AttnBackend for dsv4 attention backend (CUDA).
[2026-09-11 23:46:18 TP2 EP2] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/05cc0d96dc7e28b8/rank_tp2_pp0_dp0.json
[2026-09-11 23:46:21 TP2 EP2] Disable CP decode attention TP

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  17%|█▋        | 1/6 [00:00<00:01,  3.09profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00,  7.65profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00,  7.13profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/6 [00:00<?, ?profile/s][TensorRT-LLM][INFO] Set logger level to INFO

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  17%|█▋        | 1/6 [00:00<00:02,  2.06profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  33%|███▎      | 2/6 [00:00<00:01,  3.49profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  50%|█████     | 3/6 [00:00<00:00,  4.55profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  67%|██████▋   | 4/6 [00:01<00:00,  2.40profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  83%|████████▎ | 5/6 [00:02<00:00,  2.10profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.13profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 6/6 [00:02<00:00,  2.37profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  17%|█▋        | 1/6 [00:00<00:00,  9.77profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  33%|███▎      | 2/6 [00:00<00:00,  9.21profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 3/6 [00:00<00:00,  8.94profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  67%|██████▋   | 4/6 [00:00<00:00,  7.40profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  83%|████████▎ | 5/6 [00:00<00:00,  5.81profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  4.99profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 6/6 [00:00<00:00,  6.03profile/s]

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  17%|█▋        | 1/6 [00:00<00:00,  8.20profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  67%|██████▋   | 4/6 [00:00<00:00, 17.87profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 15.23profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 14.99profile/s]
[2026-09-11 23:46:30 TP2 EP2] FlashInfer autotune completed.
[2026-09-11 23:46:30 TP2 EP2] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:30 TP2 EP2] Capture target verify CUDA graph begin. backend=full, num_tokens_per_req=6, bs=[1, 2, 3, 4], avail mem=8.44 GB
[2026-09-11 23:46:44 TP2 EP2] Capture target verify CUDA graph end. elapsed=13.47 s, mem usage=0.58 GB, avail mem=7.86 GB.
[2026-09-11 23:46:44 TP2 EP2] Disable prefill CUDA graph because cuda_graph_config resolved prefill.backend='disabled' (e.g. via --cuda-graph-backend-prefill=disabled or auto-disable rules).
[2026-09-11 23:46:44 TP2 EP2] Capture draft verify CUDA graph begin. backend=full, num_tokens_per_req=5, bs=[1, 2, 3, 4], avail mem=7.84 GB
[2026-09-11 23:46:45 TP2 EP2] Running FlashInfer autotune with cache: /root/.cache/sglang/flashinfer/autotune/0.6.18/sm121/3ea8a0a6a68937f8/rank_tp2_pp0_dp0.json

[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:   0%|          | 0/6 [00:00<?, ?profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4:  50%|█████     | 3/6 [00:00<00:00, 15.17profile/s]
[AutoTuner]: Tuning sparse_mla_sm120_decode_dsv4: 100%|██████████| 6/6 [00:00<00:00, 23.91profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm1:   0%|          | 0/4 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  25%|██▌       | 1/4 [00:00<00:00,  4.46profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1:  75%|███████▌  | 3/4 [00:00<00:00,  7.71profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  7.36profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm1: 100%|██████████| 4/4 [00:00<00:00,  7.08profile/s]

[AutoTuner]: Tuning trtllm::fused_moe::gemm2:   0%|          | 0/4 [00:00<?, ?profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2:  50%|█████     | 2/4 [00:00<00:00, 13.03profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.38profile/s]
[AutoTuner]: Tuning trtllm::fused_moe::gemm2: 100%|██████████| 4/4 [00:00<00:00, 10.71profile/s]
[2026-09-11 23:46:47 TP2 EP2] FlashInfer autotune completed.
[2026-09-11 23:46:49 TP2 EP2] Capture draft verify CUDA graph end. elapsed=4.74 s, mem usage=-0.01 GB, avail mem=7.85 GB.
[2026-09-11 23:46:49 TP2 EP2] Init Unified Radix Cache. Components: (<ComponentType.FULL: 0>, <ComponentType.SWA: 1>). Tree Core: UnifiedTreeCore
[2026-09-11 23:46:49 TP2 EP2] Tree cache initialized: source=default impl=UnifiedRadixCache hybrid_swa=True hybrid_ssm=False hicache_attached=False streaming_wrapped=False
[2026-09-11 23:46:51] Dummy health check server started in background thread at 0.0.0.0:8888
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:47:03 TP2 EP2] Freezing GC in Scheduler process. gen0: 580->0, gen1: 975->0, gen2: 1109436->0
[2026-09-11 23:47:14 TP2 EP2] Engram layer=1 lookups=2944 hit_rate=0.0% reads=2944 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:47:14 TP2 EP2] Engram layer=14 lookups=2944 hit_rate=0.0% reads=2944 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
/opt/sglang/lib/python3.12/site-packages/torch/distributed/c10d_logger.py:83: FutureWarning: `torch.distributed.all_gather_into_tensor` is deprecated. Please use `torch.distributed.all_gather_single` instead.
  return func(*args, **kwargs)
[2026-09-11 23:48:14 TP2 EP2] Engram layer=1 lookups=42280 hit_rate=0.0% reads=42280 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:48:14 TP2 EP2] Engram layer=14 lookups=42280 hit_rate=0.0% reads=42280 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:14 TP2 EP2] Engram layer=1 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:49:14 TP2 EP2] Engram layer=14 lookups=56 hit_rate=0.0% reads=56 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:50:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:51:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:52:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:53:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:54:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:55:14 TP2 EP2] Engram layer=1 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
[2026-09-11 23:55:14 TP2 EP2] Engram layer=14 lookups=112 hit_rate=0.0% reads=112 cache=0.0GiB(4-way) scales=0.0GiB threads=96 packed=True
~~~

## 4. 备注
- 服务: DeepSeek-V4.1-Flash 3×Spark TP3 (SGLang)
- 日志中 /slots 404 为外部探测，无碍。
