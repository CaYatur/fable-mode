# FABLE EXAMPLE — A Debug Session

> Gold-standard worked example. **Purpose:** models imitate examples; this is what FULL §6 (+ the debugging pack) looks like applied end-to-end. Imitate the *process and calibration*, not the specific bug.

## The report

> "Since last week, some customers get charged once but receive two order confirmations, and fulfillment ships two boxes. Happens maybe once in 50 orders. Node/Express app, orders created from a payment provider webhook."

## The session

**§6.1 Reproduce first.** Pulled logs for 3 affected orders. Pattern found: each duplicate pair has the same provider `event_id`, ~30s apart, and the *first* attempt logged a 500. Local reproduction: send the same webhook payload twice → two orders created. Reproduced — now it's fixable and provable.

**§6.2 Read the whole error.** The 500 on first attempts, bottom of the stack: `ETIMEDOUT` from the email service — *after* `INSERT INTO orders` succeeded. So the handler does: create order → send email (times out) → 500 → provider retries (at-least-once delivery) → handler runs again.

**§6.3 Last-known-good.** `git log` on the handler: confirmation-email call added 8 days ago — matches "since last week". Before that, failures after insert were impossible because nothing slow ran after insert.

**§6.4 Hypotheses across layers** (ranked by evidence):
- (a) **Logic/state:** handler is not idempotent; any post-insert failure + provider retry → duplicate. *Strong — explains timing, event_id match, and the onset date.*
- (b) **Concurrency:** two deliveries of the same event race past an exists-check simultaneously. *Possible even after fixing (a) — check-then-act is not atomic.*
- (c) **Data/env:** provider sends genuinely duplicate events regardless of our response. *Their docs: at-least-once, dedupe is receiver's job — so this is expected input, not a bug on their side.*

**§6.5 Cheapest discriminating tests.** Replay same event sequentially → duplicate (confirms a). Replay same event twice *concurrently* against a build with a naive `SELECT ... WHERE event_id` guard → still duplicates (confirms b: the guard has a race window).

**§6.6 Fix the mechanism, not the symptom.** The mechanism: *at-least-once delivery + non-idempotent, non-atomic handler.* A "check if exists" guard treats the symptom and loses to the race. The fix: (1) `UNIQUE` constraint on `processed_events(event_id)`; insert it **first**, in the same transaction as the order — a second delivery hits the constraint and returns 200 without side effects; (2) move the email send out of the request path onto a queue, so a slow email can never 500 the webhook again.

**§6.7 Prove it.** Regression tests: sequential duplicate delivery → 1 order (was 2); 10 concurrent deliveries of one event → 1 order (was 2–3); email service down → webhook still 200, email retried by the queue. All green; the original replay now produces one order.

**§6.8 Hunt the class.** Grepped for other webhook handlers: the refund handler has the identical pattern → same fix applied + test. One line on prevention: a canary test that replays every webhook fixture twice would have caught this at review time.

## The closing report (calibration on display)

> **Verified:** duplicate orders came from provider retries hitting a non-idempotent handler; fix proven by replay tests (1 order from N deliveries, sequential and concurrent).
> **Inferred:** the ~1/50 rate matches the email service's timeout rate; expect duplicates to stop entirely.
> **Assumed:** the provider never reuses `event_id` for different payloads (their documented contract). If that's wrong, the unique constraint would drop a legitimate event — mitigated by logging constraint hits.
