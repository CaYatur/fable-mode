# FABLE PACK — Debugging

> Expert-pattern module for Fable Mode. **Load when:** any bug, error, crash, flaky behavior, or "it doesn't work". **How to use:** scan the symptom catalog FIRST — it prunes the hypothesis space before you form your §6.4 hypotheses. Treat these tables as expert pattern-memory: retrieval from this file beats recall from your weights.

## Symptom → prime suspects catalog

| Symptom | Check in this order |
|---|---|
| "Works on my machine, fails elsewhere" | env var / config diff → dependency version drift (compare lockfiles) → path case-sensitivity (Windows vs Linux) → line endings (CRLF/LF) → locale & encoding → missing system dependency → file permissions → hardcoded absolute path |
| "Intermittent / flaky" | race condition → timeout too tight → non-idempotent retry → shared mutable state → test-order dependency → cache-expiry boundary → resource exhaustion under load → wall-clock assumptions |
| "Worked yesterday, nothing changed" | Something changed — always. Dependency auto-update → expired cert/token/license → disk full → external API changed → data shape changed → scheduled job ran → DST transition → OS/security update |
| "Off by a small amount" | float precision → rounding mode / integer division → timezone or DST hour → off-by-one at range boundaries (inclusive vs exclusive) → unit mismatch (ms vs s, bytes vs KB) |
| "Slow degradation over time" | memory leak → unbounded cache/array/map → connection-pool leak → log/tmp file growth → DB index bloat / missing vacuum → event listeners piling up |
| "Fails only at scale / only in prod" | N+1 queries → missing index (query time grows with table size) → lock contention → connection-pool exhaustion → rate limits → payload/size limits → timeout stacking (A waits B waits C) |
| "Fails only for some users" | data-dependent: nulls, Unicode names, very long values → permissions/roles → locale/timezone → account created before a migration → feature flag / A-B bucket |
| "Crashes with no useful error" | swallowed exception (empty catch) → OOM kill (check system logs/Event Viewer/dmesg) → stack overflow via recursion → native/segfault layer → killed by supervisor/container limit |
| "My change has no effect" | **#1 time-waster.** Verify the change is actually running: add a deliberate marker (print/version string). Wrong file or copy → stale build/cache (browser, CDN, bytecode, Docker layer) → wrong environment/branch deployed → feature flag off → overridden later (CSS/config precedence) |
| "Async weirdness" | missing `await` → unhandled rejection → concurrent mutation of shared state → event loop blocked by sync work → promise created but never returned → fire-and-forget losing errors |
| "Encoding garbage (Ã©, ï»¿, ???)" | UTF-8 read as Latin-1 (the `Ã` tell) → BOM present/expected → double-encoding → charset mismatch across terminal/DB/HTTP layer |
| "HTTP mysteries" | CORS (fails in browser, works in curl) → redirect dropping method/body (301/302 POST→GET) → proxy stripping headers → cookie SameSite/Secure rules → stale cache (read response headers) → Content-Type mismatch |

## Priors (where bugs actually live)

- Your code (~90%) > your config (~9%) > the library (~0.9%) > the compiler/OS (~0.09%). Suspect the framework only after a minimal repro proves it.
- Newer code is more suspect than old code; the last thing touched is guilty until proven innocent.
- The line you're staring at is often not the wrong line — **trust the stack trace over intuition.**
- After fixing one bug, expect a second one it was masking (the second-bug rule) — re-run the full scenario, not just the failing step.

## Tactics

- **Binary-search everything:** halve the input, halve the code path, `git bisect` the history. Each halving is one cheap experiment (§6.5).
- **Instrument the boundary:** find the last point where data is provably correct and the first point where it is provably wrong; the bug lives between them. Move the two probes toward each other.
- **Make the bug louder, not quieter:** add assertions and fail-fast checks instead of defensive fallbacks that hide it.
- **Heisenbugs** (vanish under the debugger): switch to timestamped logging with thread/request IDs; look for ordering differences between runs.
- **The 15-minute rule:** stuck 15 minutes on one hypothesis → forcibly generate two more in *different layers* (§6.4) before continuing.
- **Write the bug report to solve it:** stating expected vs actual vs environment precisely often exposes the answer (rubber-duck effect).
- **Reproduce with the user's exact data** when possible — synthetic data hides data-shaped bugs.
- Exit criteria: mechanism named in one sentence → original repro passes → same pattern searched across the codebase → regression test added (§6.6–6.8).
