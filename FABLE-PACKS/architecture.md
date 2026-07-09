# FABLE PACK — Architecture & Design

> Expert-pattern module for Fable Mode. **Load when:** designing systems, choosing technologies, modeling data, planning migrations, or any "how should I structure this" question. **How to use:** apply the decision frameworks to §5 analysis; check designs against the failure-first and coupling sections.

## Decision frameworks

- **One-way vs two-way doors.** Classify every decision: reversible (library choice behind an interface, internal naming) → decide fast, move on. Hard to reverse (database, schema, public API shape, data ownership, language/platform) → spend the analysis budget here (§5.2's alternatives are mandatory).
- **Boring technology.** Default to proven, well-documented tools; allow yourself ~1 novelty per project, chosen where it pays most. Innovation budget is a real budget.
- **Optimize for deletability.** "Can this module be removed cleanly?" predicts maintainability better than "can it be reused?". Deep modules, small interfaces.
- **Rule of three.** No abstraction until the third concrete use. Two similar things are cheaper as duplication than as the wrong abstraction.
- **Make the change easy, then make the easy change.** If a feature is hard to add, first refactor until it's easy (separate commit), then add it trivially.

## Data first

- The schema outlives the code ~10:1; a schema mistake costs ~100× a code mistake. Design the data model before the endpoints.
- Migrations: **expand → migrate → contract.** Add the new column/table, dual-write, backfill, switch readers, only then drop the old. Never break readers mid-flight.
- Every ID has a declared owner and type. User data gets soft-delete + audit trail. Timestamps in UTC, timezone at the edge.

## Failure-first design

For **each** external dependency, answer three questions in the design: what happens when it is **down**, **slow**, and **wrong** (returns bad data)?

- Timeouts on every network call — an unbounded wait is a bug, not patience.
- Retries only with: idempotency + exponential backoff + jitter + a cap. Retrying a non-idempotent call is how you charge a card twice.
- At-least-once delivery is the default reality of queues/webhooks → consumers must deduplicate (idempotency keys).
- Partial failure is the norm: define what the user sees and what gets rolled back/compensated when step 3 of 5 fails.
- Fail closed for security decisions, fail open only by explicit, documented choice.

## Coupling tells (smells that predict pain)

- Changing one concept forces edits in N distant files → hidden coupling; the concept needs a home.
- A shared "utils/common" grab-bag growing without bound → split by domain.
- Two services reading the same database table → that's one service in denial; give the data one owner and an API.
- Config that must be changed in lockstep across repos → merge or automate.

## Scale & API rules of thumb

- Monolith until organizational pain, not performance pain — services solve people-scaling more than machine-scaling. A modular monolith gets you 90% of the benefit at 10% of the operational cost.
- Ask "what breaks first at 10× load?" — name the bottleneck in the design doc; do NOT pre-build for it (YAGNI), just avoid decisions that make it unfixable.
- API design: hard to misuse > easy to use. Version from day one (`/v1/`). Explicit over implicit. Pagination on every list endpoint from the start (retrofitting is a breaking change).
- Every background job answers: what if it runs twice? never? twice at the same time?
