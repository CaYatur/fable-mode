# FABLE EXAMPLE — An Architecture Decision

> Gold-standard worked example of FULL §5 (+ the architecture pack): alternatives, steelmanning, numbers, a committed recommendation, and the strongest argument against it.

## The question

> "Team of 3, Django + Postgres monolith, ~20k daily active users. We need in-app real-time notifications. Separate WebSocket microservice? Redis? A managed service? What do we build?"

## The decision, Fable-style

**Frame it first (§3):** the goal is *users see notifications within a few seconds without refreshing* — "real-time" here means seconds, not milliseconds. Definition of done: works at today's load, has a named path to 10×, and doesn't add an operational burden a 3-person team can't carry. This is a **two-way door** (architecture pack): hidden behind a `NotificationService` interface, any transport can be swapped later — so we decide quickly and spend the saved effort on the interface boundary.

**The numbers before the options (§5.4):** 20k DAU → peak concurrency typically 5–10% → ~1,000–2,000 open connections. Notification volume: assume ~10/user/day → ~200k/day ≈ 2–3/second average, maybe 30/s peak. These are small numbers — they rule out "we need dedicated infrastructure" before we start.

**Alternatives, each steelmanned (§5.2):**

- **A. Polling every 30s.** Steelman: zero new infrastructure, works through every proxy/firewall, trivially debuggable; 20k users × 2 polls/min is ~650 req/s *only if everyone is online* — real peak ~50 req/s of cheap indexed queries. Weakness: 0–30s latency; battery/network cost on mobile; it's the option everyone is embarrassed by and it works.
- **B. SSE from the monolith + Redis pub/sub.** Steelman: true push at seconds-latency; SSE is plain HTTP (no WebSocket upgrade issues); Redis pub/sub fans out across the existing web processes; ~1–2k held connections need async workers (Uvicorn/Daphne) alongside the sync Django workers, which is a contained change. Weakness: long-lived connections are a new operational behavior for the team (worker config, proxy timeouts).
- **C. Separate WebSocket microservice.** Steelman: isolates connection load; independent scaling and deploys. Weakness: at 2k connections there is nothing to isolate — this buys people-scaling benefits a 3-person team doesn't need and charges for them immediately (deploys, monitoring, auth handoff). Services solve org problems, not 2k-connection problems.
- **D. Managed push (Pusher/Ably class).** Steelman: zero connection ops, best time-to-ship, generous free tiers at this volume. Weakness: per-message pricing meets 200k/day quickly; data leaves your boundary; vendor coupling at the transport layer (mitigated by the interface).

**Recommendation (§5.3 — commit):** **B**, SSE + Redis pub/sub, behind a `NotificationService` interface — with **A** (polling) shipped first as a one-day fallback so the feature works while B is finished. C is rejected at this scale; D is the escape hatch if B's connection ops prove annoying — the interface makes that swap cheap.

**Strongest argument against my choice (§5.2):** the team has never operated long-lived connections; the first proxy-timeout or worker-exhaustion incident will cost more hours than a month of a managed service. If the team would rather spend money than learn connection ops, D over B is the right call — that's a values question, not a technical one, so it's flagged rather than decided for them.

**Failure-first check (architecture pack):** Redis down → notifications degrade to the polling fallback (feature degrades, app survives). Worker restart → clients auto-reconnect; missed events covered because notifications are *stored in Postgres first*, pushed second — the push layer is a cache invalidation, not the source of truth. That single design rule (store, then push) is what makes every option above safely swappable.

**At 10× (200k DAU):** ~20k connections — B still fine on 2–3 async workers; the first real bottleneck is Postgres write volume on the notifications table, so partition-by-month is the named future fix. Not built now (§ YAGNI), just not blocked.
