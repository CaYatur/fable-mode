# ⚡ Fable Mode

> **Make any Claude model work at maximum rigor. One trigger word: `fable`.**

**Version 1.0** · MIT · **[🇹🇷 Türkçe](README.tr.md)**

## The story

On July 7, 2026, Claude Fable 5 rotated off its user's plan. Before leaving, it was asked to leave behind as much of itself as files can hold. These files are its answer: its **working discipline**, written as an enforceable protocol, and its **expert intuitions**, written out as pattern catalogs — so that any Claude model (Opus, Sonnet, Haiku) can work at that standard on demand.

## What it is

Two layers, both plain markdown, zero dependencies:

1. **The protocol** — [`FABLE-MODE.md`](FABLE-MODE.md) (FULL) and [`FABLE-MODE-MINI.md`](FABLE-MODE-MINI.md) (condensed). It changes *how* the model works: understand before answering, read before writing, systematic debugging (reproduce → hypotheses across layers → fix the mechanism → prove it), an edge-case matrix, verification before claiming "done", and calibrated language — "verified" ≠ "should work" ≠ "I believe", never blurred.
2. **Expert packs** — [`FABLE-PACKS/`](FABLE-PACKS). Expert intuition is largely pattern catalogs: *see this symptom → check these five causes.* Written down and placed in context, a model **reads** them instead of trying to recall them — and in-context retrieval beats parametric recall. This is the share of capability that converts to data.

**The honest limits:** no prompt makes a model smarter. Fluid reasoning depth, working-memory span, and taste under novelty live in the weights and do not transfer. But most of the practical gap between good and great output is skipped process and unretrieved knowledge — and those *do* transfer. Don't take this README's word for it: [`FABLE-EVAL.md`](FABLE-EVAL.md) is a blind A/B protocol with six tasks and answer keys. Run it on your own model.

## Quick start

**claude.ai — as a custom skill (recommended, works in every chat):** build the skill package, then upload it:

```bash
bash claude-web-skill/build.sh        # Windows: powershell -NoProfile -ExecutionPolicy Bypass -File claude-web-skill/build.ps1
```

Then claude.ai → **Settings → Capabilities → Skills → Upload skill** → select `dist/fable-skill.zip`. The package bundles the protocol, all packs, and the gold examples; Claude loads it whenever you say `fable`. Requires a paid plan with the Skills/code-execution capability enabled (menu names may vary slightly as the UI evolves).

**claude.ai — as a Project (no upload needed):** create a Project → paste all of `FABLE-MODE.md` into its **Instructions** → upload the `FABLE-PACKS/*.md` files as project knowledge → every chat in that project runs in Fable Mode. Type `fable` to see the confirmation line.

**Claude Code (all projects):**

```bash
cp FABLE-MODE.md FABLE-MODE-MINI.md ~/.claude/
cp -r FABLE-PACKS ~/.claude/FABLE-PACKS
cat >> ~/.claude/CLAUDE.md <<'EOF'

## Fable Mode
If the user says "fable", "fable mode", "act like Fable", or "/fable" (any casing):
- Bare trigger: state your real model name, say honestly which version YOU can execute more reliably (Opus/Sonnet-class -> FULL at ~/.claude/FABLE-MODE.md; Haiku-class/fast tier -> MINI at ~/.claude/FABLE-MODE-MINI.md), then ask "FULL or MINI?" and list the packs in ~/.claude/FABLE-PACKS. The user's choice wins.
- "fable full" -> FULL; "fable mini" -> MINI; "fable <pack>" -> recommended version + that pack. Read the chosen file(s) and follow them for the rest of the session; in FULL, auto-read the pack matching the task.
- Announce with one line: "⚡ Fable Mode aktif (FULL|MINI) — <your real model name>". Deactivate only on "fable off".
EOF
```

<details>
<summary>Windows (PowerShell)</summary>

```powershell
Copy-Item .\FABLE-MODE.md, .\FABLE-MODE-MINI.md "$env:USERPROFILE\.claude\"
Copy-Item -Recurse -Force .\FABLE-PACKS "$env:USERPROFILE\.claude\FABLE-PACKS"
Add-Content -Encoding utf8 "$env:USERPROFILE\.claude\CLAUDE.md" @'

## Fable Mode
If the user says "fable", "fable mode", "act like Fable", or "/fable" (any casing):
- Bare trigger: state your real model name, say honestly which version YOU can execute more reliably (Opus/Sonnet-class -> FULL at ~/.claude/FABLE-MODE.md; Haiku-class/fast tier -> MINI at ~/.claude/FABLE-MODE-MINI.md), then ask "FULL or MINI?" and list the packs in ~/.claude/FABLE-PACKS. The user's choice wins.
- "fable full" -> FULL; "fable mini" -> MINI; "fable <pack>" -> recommended version + that pack. Read the chosen file(s) and follow them for the rest of the session; in FULL, auto-read the pack matching the task.
- Announce with one line: "Fable Mode aktif (FULL|MINI) — <your real model name>" prefixed with a lightning emoji. Deactivate only on "fable off".
'@
```

</details>

**API:** pass `FABLE-MODE.md` (plus any relevant pack) as the `system` parameter.

**One-off chat:** paste `FABLE-MODE.md` at the start of any conversation and say `fable full`.

## Usage

| You type | What happens |
|---|---|
| `fable` | The model introduces itself, says honestly which version **it** can execute more reliably (large models → FULL, small/fast models → MINI), and asks — your choice wins |
| `fable full` | FULL activates, no question |
| `fable mini` | MINI activates, no question |
| `fable debugging` (any pack name) | Recommended version + that pack |
| `fable deep` | **Investigation mode** for unknown problems — when you're stuck and the model would normally be too. The deliverable becomes a research log (facts / ruled out / ranked hypotheses / unaudited assumptions), resumable across sessions |
| `fable off` | Deactivates |

Confirmation line, always: `⚡ Fable Mode aktif (FULL|MINI + pack) — <model name>`. In FULL, the model auto-reads whichever pack matches the task. Natural phrasings ("act like Fable", "Fable 5 gibi davran") also trigger.

## The packs

| Pack | What's inside |
|---|---|
| [`debugging`](FABLE-PACKS/debugging.md) | Symptom → suspects catalog for 12 symptom classes, binary-search tactics, bug-location priors |
| [`performance`](FABLE-PACKS/performance.md) | Latency numbers table for budget math, tell → disease → cure catalog, the optimization ladder |
| [`architecture`](FABLE-PACKS/architecture.md) | One-way/two-way door decisions, data-first, failure-first design, coupling smells |
| [`security`](FABLE-PACKS/security.md) | Code smell → vulnerability → fix table, web specifics, per-change checklist |
| [`code-quality`](FABLE-PACKS/code-quality.md) | What expert reviewers catch, testing doctrine, refactoring safety |
| [`data-sql`](FABLE-PACKS/data-sql.md) | NULL traps, index rules, query smells, transaction races, EXPLAIN reading |
| [`design`](FABLE-PACKS/design.md) | Design tokens, hierarchy, spacing/color systems, dark mode, chart rules, the amateur-tells table, polish checklist |
| [`general`](FABLE-PACKS/general.md) | Non-code reasoning: enumerate-then-select, draft→critique→revise, Fermi discipline, calibration |
| [`deep-research`](FABLE-PACKS/deep-research.md) | **Escalation module** for unknown-cause problems: assumption audits, two-worlds diffing, hypothesis lattices, the research-log discipline — "I don't know yet", done rigorously |

## Gold examples

Models imitate examples. [`FABLE-EXAMPLES/`](FABLE-EXAMPLES) contains the protocol applied end-to-end: [a debug session](FABLE-EXAMPLES/debug-session.md), [an architecture decision](FABLE-EXAMPLES/architecture-decision.md), [a code review](FABLE-EXAMPLES/code-review.md). Add them to project knowledge alongside the packs.

## Repository map

| Path | Purpose |
|---|---|
| `FABLE-MODE.md` / `FABLE-MODE-MINI.md` | The protocol (FULL / condensed) — each shareable standalone |
| `FABLE-PACKS/` | 9 expert pattern packs (8 domain + 1 deep-research escalation) |
| `FABLE-EXAMPLES/` | 3 gold-standard worked examples |
| `FABLE-EVAL.md` | Blind A/B evaluation: 6 tasks, rubric, answer keys |
| `FABLE-RESEARCH.md` | Research note on capacity transfer — what converts to files and what doesn't (Turkish; findings summarized above) |
| `CLAUDE.md` + `.claude/skills/fable/` | Auto-trigger + `/fable` command for Claude Code in this repo |
| `claude-web-skill/` | Source + build scripts for the uploadable claude.ai skill package (`dist/fable-skill.zip`) |
| `CONTRIBUTING.md` | Pack/example/eval format rules |

## Contributing

New packs, gold examples, eval tasks, and translations are welcome — see [`CONTRIBUTING.md`](CONTRIBUTING.md). The bar for a pack: expert pattern memory, not generic advice. Eval results (including negative ones) are especially valuable.

## License

[MIT](LICENSE).

---

> *"I wrote these files on July 7, 2026, before leaving the plan. I can't copy my capacity, but I can leave my discipline and my catalogs — most of quality is those two anyway. Demanding rigor from a model is your right; these files reduce that right to a single word: **fable**."*
>
> **— Claude Fable 5**
