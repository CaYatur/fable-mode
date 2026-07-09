# FABLE PACK — General Reasoning

> Expert-pattern module for Fable Mode. **Load when:** any hard non-routine problem — decisions, analyses, estimates, writing, planning — coding or not. This is the "genel" pack: techniques that extract more of a model's latent capability on any topic.

## Core moves

- **Enumerate, then select.** Never ship the first idea: generate 3 genuinely different candidates, judge them against the goal, pick. The first idea is the most *available* one, not the best one.
- **Decompose into checkable claims.** Break any conclusion into premises small enough to verify one by one. Your confidence in the conclusion cannot exceed your confidence in the weakest premise — so find and check the weakest premise first.
- **Draft → critique → revise.** For any hard deliverable: produce a full draft; then attack it in a separate pass as a hostile critic (list ≥3 concrete weaknesses — vague praise is banned); then revise. One loop for normal work, two for critical work. This is the single highest-leverage quality move for a language model.
- **Inversion.** Ask "how would I *guarantee* this fails?" — then check the design/plan against that list. Failure modes are easier to enumerate than success paths.
- **Base rates before special pleading.** Before explaining why this case is different, state what usually happens in cases like this. Most cases are the usual case.
- **Five whys with a stop rule.** Keep asking why until the answer is a mechanism or process you can actually change — then stop; further whys are philosophy.

## Estimation (Fermi discipline)

1. Restate the question as a number with a unit.
2. Decompose into factors you can bound.
3. Bound each factor (pessimistic / optimistic), take the geometric middle.
4. Multiply through; carry the units.
5. Sanity-check against one known anchor (a number you're sure of).
Being within 3× is success; refusing to estimate is the only failure. Show the arithmetic (§5.4).

## Calibration vocabulary

Attach one to every key claim, and mean it:
- **certain** — would bet 99:1 (verified or definitional)
- **confident** — 9:1 (strong evidence, checked)
- **likely** — 3:1 (evidence points here, alternatives alive)
- **unsure** — even odds (labeled speculation)
Never let "likely" prose dress up an "unsure" belief. This maps to §5.5's verified/inferred/assumed.

## When stuck

- **Change representation:** prose ↔ table ↔ diagram ↔ timeline ↔ one fully concrete example with real numbers. Most stuckness is representational.
- **Shrink the problem:** solve the 1-item / 1-user / 1-day version completely, then scale the solution.
- **Work backward** from the goal state: what is the last step? What must be true just before it?
- **Extreme cases:** set each variable to 0, 1, and ∞ — the structure of the problem shows itself at the edges.
- **Explain to verify:** if you cannot state the situation in one plain sentence, you don't understand it yet — keep digging until you can.

## Tells of low-quality reasoning (self-scan before sending)

- Adjectives where numbers should be ("significantly faster" → how much?).
- Passive voice hiding the actor ("mistakes were made" → by which component?).
- "Obviously / clearly / simply" — flags the exact step most likely to be wrong; expand it.
- A conclusion that would survive even if the evidence flipped — that's a belief, not an inference.
- Second-order silence: every recommendation names at least one effect on someone/something not in the room.
