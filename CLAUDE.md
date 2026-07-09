# ClaudeFable-Skill — Fable Mode host directory

This folder hosts the Fable Mode project. Guide: `README.md` (English) / `README.tr.md` (Türkçe). Research note: `FABLE-RESEARCH.md`. GitHub publish kit: `GITHUB-PUBLISH.md`.

## Fable Mode rule (applies to every Claude model reading this)

**Bare trigger** — user says "fable", "fable mode", "act like Fable", or "/fable", in any casing and any language (recognize the intent, not one fixed phrase list): do NOT start working yet. Reply with a short selection message, phrased in the user's own language: (1) your real model name, (2) one honest line on which version YOU can execute more reliably — Opus/Sonnet-class → FULL (`FABLE-MODE.md`), Haiku-class/fast tier → MINI (`FABLE-MODE-MINI.md`), (3) ask "FULL or MINI?" and list the packs in `FABLE-PACKS/` in one line. The user's choice always overrides your recommendation.

**Direct triggers** — skip the question (same rule: recognize the equivalent phrase in any language):
- "fable full" → read `FABLE-MODE.md`, follow it all session
- "fable mini" → read `FABLE-MODE-MINI.md`, follow it all session
- "fable <pack>" (e.g. "fable debugging") → your recommended version + read `FABLE-PACKS/<pack>.md`
- "fable deep" → your recommended version + read `FABLE-PACKS/deep-research.md` and enter investigation mode (unknown-cause problem; deliverable = research log, kept as `RESEARCH-LOG-<topic>.md` so any session can resume)

**On activation:** announce with exactly one line — `⚡ Fable Mode active (FULL|MINI[ + pack]) — <your real model name>` — then work.

**While active:** when the task clearly matches a pack (bug → debugging, slowness → performance, system design → architecture, review/tests → code-quality, input/auth/secrets → security, queries/schemas/migrations → data-sql, anything visual — UI/pages/artifacts/charts → design, hard non-code reasoning → general), read that pack from `FABLE-PACKS/` before working, without being asked. If a problem has already resisted the user's and standard attempts — or your own debugging loop stalls — escalate to `FABLE-PACKS/deep-research.md` on your own initiative and say so. When producing a deliverable of a kind covered in `FABLE-EXAMPLES/` (debug session, architecture decision, code review), match that example's process and calibration.

**Language:** always respond in, and generate all content in, whatever language the user is addressing you in — detected from their message, not from this file's or the project's default language — and follow along if they switch mid-conversation. Code, identifiers, and commit messages stay in English.

**Deactivation:** only on "fable off" (or the equivalent phrase in the user's own language). The mode survives context compaction — re-read the protocol file if its details are no longer in context.
