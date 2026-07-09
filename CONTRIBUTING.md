# Contributing to Fable Mode

Contributions welcome: new packs, gold examples, eval tasks, translations, and fixes. Everything here is plain markdown — no build, no dependencies.

## Adding a pack (`FABLE-PACKS/`)

Packs are **expert pattern memory, not generic advice**. A pack earns its place when a model reading it performs above its baseline. Format rules:

1. Header: `# FABLE PACK — <Domain>` + a one-line **Load when** and **How to use**.
2. Content is catalogs, not essays: symptom → cause tables, reference numbers (latencies, sizes, ratios), smell → vulnerability/fix tables, expert checklists.
3. The test for every line: *would a strong practitioner say "yes, that's the actual pattern"* — if it reads like a blog intro, cut it.
4. Keep it under ~90 lines; density beats coverage. English (most reliably followed across models); output language is handled by the protocol.
5. Cross-reference protocol sections (e.g. "§6.4") and other packs instead of repeating them.

## Adding a gold example (`FABLE-EXAMPLES/`)

Examples exist because models imitate. Show the full protocol applied to one realistic scenario: the numbered steps visibly followed, calibrated language (`verified / inferred / assumed`) in the close. One scenario per file; ~100 lines max.

## Adding eval tasks (`FABLE-EVAL.md`)

Each task needs: the exact prompt, what dimension it discriminates (see the rubric), and an answer key specific enough that two scorers agree. Tasks where mode-on and mode-off score identically on strong models are fine **if** they separate on smaller models — say which.

## Sync rule

The protocol lives in three places that must not drift: `FABLE-MODE.md` (source of truth), `FABLE-MODE-MINI.md`, and the fallback inside `.claude/skills/fable/SKILL.md`. If your PR changes protocol behavior, update all three. Packs are independent — add freely.

## PR checklist (yes, it's the protocol applied to itself)

- [ ] Every changed file listed in the PR description, with one line on why
- [ ] Claims about model behavior labeled: tested (which model, what task) or hypothesized
- [ ] New pack/example/task follows the format rules above
- [ ] Sync rule respected if protocol text changed
