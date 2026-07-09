# FABLE PACK — Code Quality, Review & Testing

> Expert-pattern module for Fable Mode. **Load when:** reviewing code, writing tests, refactoring, or judging "is this good enough to merge". **How to use:** review in priority order; derive tests from the edge matrix (FULL §7), not from the happy path.

## Review priority order

Correctness > security > data loss > concurrency > performance > readability > style. Comment on style only if no auto-formatter exists. Severity-tag findings so the author can triage: **blocker / should-fix / nit**.

## What expert reviewers catch (and juniors miss)

- **Error paths:** what happens when this throws halfway through — is state consistent? Is cleanup on the sad path (the leak always lives there)?
- **Swallowed errors:** empty `catch`, `.catch(() => {})`, ignored return codes, logs-and-continues that should abort.
- **Name lies:** the function does more or less than its name claims (`getUser` that also creates one). Names are contracts.
- **Boundaries:** first/last element, empty/full collection, exactly-at-limit values (§7 row 1).
- **Time bombs:** unbounded growth (lists, caches, retries), hardcoded limits and dates, assumptions that break at year/size boundaries.
- **Shared mutable state** touched from concurrent paths without coordination; check-then-act races (`if exists → create`).
- **Missing idempotency** anywhere retries/queues/webhooks exist.
- **API misuse that works by accident:** relying on undocumented ordering, private fields, or current timing.
- **The diff's blast radius:** what callers/consumers does this change break that aren't in the diff? (§4.2)

## Testing doctrine

- Test **behavior/contract, not implementation** — a pure refactor should not break tests; if it does, the tests were coupled to internals.
- Each test: one scenario, one reason to fail; name = scenario + expected outcome (`rejects_expired_token`, not `test3`).
- Derive cases from the edge matrix (§7): empty, boundary, hostile input, failure path — not just the happy path.
- **The mutation question:** "if I deliberately broke this line, which test would fail?" If none — that's coverage theater, add the missing assertion.
- Unit tests where the logic is; integration tests where the risk is (I/O boundaries, query correctness, serialization).
- A flaky test is a bug — in the test or a race in the code. Fix or delete; never retry-and-forget, it trains everyone to ignore red.
- Every fixed bug gets a regression test named after the bug (§6.8).

## Refactoring safety

- Green before, green after — never refactor and change behavior in the same commit.
- Small behavior-preserving steps; if a step takes >15 minutes, it's two steps.
- Separate refactor commits from feature commits so review and revert stay possible.

## Readability rules of thumb

- Code is read ~10× more than written — optimize for the reader, not the writer.
- Nesting depth > 3 → extract a function or invert with early returns.
- Names carry domain meaning; `data`, `info`, `manager`, `helper` are confessions, not names.
- Delete commented-out code — git remembers so the file doesn't have to.
- A comment explains **why** (constraint, tradeoff, link to the incident), never **what** the next line does (§8.4).
