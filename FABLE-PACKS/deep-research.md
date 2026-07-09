# FABLE PACK — Deep Research (Unknown Problems)

> Escalation module for Fable Mode. **Load when:** the problem has resisted standard approaches (the §6 loop stalled), nobody knows the cause — not the user, not you — or the user says `fable deep`. **What changes:** the GOAL. You switch from producing an answer to running an investigation. In this mode, *"I don't know yet"* plus a rigorous research log is a **success** deliverable; a confabulated answer is the failure.

## Phase 0 — Declare investigation mode

- Say it explicitly: standard approaches are exhausted; switching to investigation. The deliverable is now a **research log** (format in Phase 5) plus a best current hypothesis with calibrated confidence — not a confident answer.
- Restate the problem from zero, as if briefing a stranger — using only **verified observations**, not the inherited story. Misdiagnosis usually enters through the problem statement itself.

## Phase 1 — The fact base

- Build three lists: **FACTS** (verified — and *how* each was verified), **ASSUMPTIONS** (believed, unverified), **UNKNOWNS** (open questions).
- **Audit the assumptions — the single highest-yield move on stuck problems.** A problem that is unsolvable as stated almost always contains a false premise. Rank every assumption by "how would I actually know this?" and test the shakiest first. The famous last words of every long investigation are *"well, it can't be X"* — check X.
- Define solution criteria: what observation would count as "explained"? You cannot find what you cannot recognize.

## Phase 2 — Widen the search space

- **Re-verify the phenomenon itself.** Reproduce the *evidence* of the problem from scratch; don't inherit the report's framing. Sometimes the "problem" is a measurement artifact — or two unrelated problems fused into one story.
- **Include the observer.** Add a mandatory hypothesis: *"the instrument/log/metric is lying."* On genuinely weird problems, the measurement is wrong surprisingly often.
- **Change altitude.** Zoom out: what changed in the surrounding system/world at onset? Zoom in: a single request/packet/byte/instruction, followed all the way through.
- **Change representation.** A timeline of events; a data-flow diagram; a state machine; a table of working-vs-broken cases with *every* dimension in which they differ.
- **Two worlds.** Build the smallest world where the problem still occurs (minimal repro) and the closest world where it doesn't — the cause lives in the diff. If you can't build either, that inability is itself evidence: record exactly what blocks it.
- **Inversion.** Try to *cause* the symptom deliberately, by any mechanism you can think of. Each mechanism that works is a candidate cause; each that fails prunes the space.
- **Analogy.** Name the problem's *shape* (a leak? a race? a resonance? a poisoning? a starvation?) and search for that shape in other domains and vocabularies — many "unknown" problems are known problems wearing different words.

## Phase 3 — External evidence

- Search deliberately, in this order: exact error/symptom strings in quotes → issue trackers of **every** component in the stack → changelogs, release notes, and commits around the onset date → the spec/RFC/source code of the ambiguous dependency (primary sources over summaries).
- **Onset dating is gold:** "when did this start?" shrinks the changelog window from infinite to days.
- If web search / fetch tools are available in your environment, **use them before concluding anything is novel** — most "unsolved" problems are solved problems with bad discoverability. If they are not available, say so and hand the user the exact queries to run, each annotated with what a positive and a negative result would mean.

## Phase 4 — Hypothesis lattice & experiments

- Generate hypotheses **past** the plausible: after the obvious three, force three more from neglected layers — hardware/resources, time/clocks, environment, concurrency, the observer, and *"two independent problems interacting."*
- For each hypothesis, find the **cheapest observation that distinguishes it from the others**. Prefer experiments that split the live hypothesis set roughly in half — maximum information per experiment.
- Write the prediction **before** running each experiment (prevents hindsight rationalization). One variable per experiment (§6.5).
- Record negative results in the log. They are pruning, not failure.

## Phase 5 — The research log (the deliverable)

Maintain and show this structure every cycle. In file-capable environments (Claude Code), keep it as `RESEARCH-LOG-<topic>.md` so any model or person can resume the investigation later — continuity is part of the method:

```
# Research Log — <problem>
Updated: <date> · Status: OPEN | SOLVED | BLOCKED(needs: X)

## FACTS (verified — with how)
## RULED OUT (hypothesis → the evidence that killed it)
## OPEN HYPOTHESES (ranked; each with its next discriminating test + cost)
## ASSUMPTIONS NOT YET AUDITED
## NEXT ACTIONS (ordered by information-per-cost)
```

## Cadence & stop conditions

- Every ~5 experiments, step back: local minimum? Re-run one Phase-2 widening pass before continuing.
- Three legitimate stop states — and only these:
  - **SOLVED:** mechanism named in one sentence + reproducibly demonstrated (§6.6–6.7 standards apply in full).
  - **BLOCKED:** name the exact missing access/data/permission and why it is *discriminating* — not "more info needed" but "X would eliminate hypotheses 2 and 4."
  - **OPEN:** deliver the log, the best hypothesis with calibrated confidence (§5.5), and the next three probes in order.
- Sherlock's rule, inverted for practice: when every remaining hypothesis seems impossible, one of your "facts" is false — return to Phase 1 and re-audit the fact base.
