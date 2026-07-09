# FABLE PACK — Performance

> Expert-pattern module for Fable Mode. **Load when:** anything is slow, expensive, or resource-hungry; capacity planning; optimization requests. **How to use:** measure first, then match against the pathology catalog; use the numbers table for budget arithmetic (§5.4).

## Law 0 — Measure before touching

Never optimize unprofiled code. The bottleneck is almost never where intuition points. Get one real measurement (profiler, EXPLAIN, timing log, flame graph) and quote it before proposing any change. After optimizing: re-measure, state before/after numbers, keep the measurement harness.

## Numbers for budget math (orders of magnitude, modern hardware)

| Operation | Cost |
|---|---|
| L1 cache hit | ~1 ns |
| Main memory read | ~100 ns |
| Hash/checksum 1 KB | ~1 µs |
| NVMe SSD random read | ~20–100 µs |
| Same-datacenter round trip | ~0.5 ms |
| Simple indexed DB query | ~0.5–2 ms |
| HDD seek | ~5–10 ms |
| Cross-region round trip | ~50–150 ms |
| JSON parse throughput | ~50–200 MB/s |

Use them like this: *200 sequential DB calls × 1 ms ≈ 200 ms → batching to 2 calls beats any micro-optimization by 100×.* Always do this arithmetic before proposing work.

## Pathology catalog (tell → disease → cure)

| Tell | Disease | Cure |
|---|---|---|
| Query/await inside a loop | N+1 | batch fetch, JOIN, dataloader |
| Query time grows with table size; EXPLAIN shows full scan | missing index | add index matching the WHERE/ORDER BY; verify with EXPLAIN |
| Many small network/disk calls | chatty I/O | batch, pipeline, coalesce |
| Everything slow while CPU is idle | sync work blocking the event loop / lock held across I/O | move to worker, shrink critical section |
| Fast at 10 users, collapses at 1000 | unbounded concurrency, pool exhaustion | bounded queues, backpressure, pool sizing |
| Fetching whole rows/documents for one field | over-fetching | select only needed columns/fields, pagination |
| Hot loop serializing/deserializing | serialization tax | cache parsed form, move serialization to the edge |
| Periodic latency spikes at fixed intervals | cache stampede at TTL expiry / GC pauses | jittered TTLs, request coalescing; check GC logs |
| Innocent-looking loop is O(n²) | `includes`/`indexOf` in a loop, string concat in a loop, repeated sorts | set/map lookup, join once, sort once |
| Logging/metrics in the hot path | observability tax | sample, move off the critical path, lazy-format |

## Optimization ladder (in order — stop at the first rung that meets the budget)

1. **Do less work:** cache, precompute, early-exit, don't call it at all. The fastest code is no code.
2. **Better algorithm / data structure:** the only rung that changes complexity class.
3. **Batch & parallelize:** amortize fixed costs; parallelism helps only the parallel fraction (Amdahl — 90% parallel caps speedup at 10×).
4. **Move data closer:** index, denormalize, CDN, memory over disk.
5. **Micro-optimize last** — and only with a benchmark proving it matters.

## Perceived performance

- Optimize p95/p99, not the average — tail latency is what users feel.
- Stream the first bytes early; show optimistic UI; do slow work after responding when semantics allow.
- A 100 ms improvement users feel beats a 10× improvement in a path nobody waits on — pick targets by user-visible impact.
