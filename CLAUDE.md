# ClaudeFable-Skill — Fable Mode host directory

Bu klasör Fable Mode projesini barındırır. Rehber: `README.tr.md` (Türkçe) / `README.md` (English). Araştırma notu: `FABLE-RESEARCH.md`. GitHub yayın kiti: `GITHUB-PUBLISH.md`.

## Fable Mode rule (applies to every Claude model reading this)

**Bare trigger** — user says "fable", "fable mode/modu", "Fable 5 gibi davran/analiz et/düşün", "act like Fable", or "/fable" (any casing, any language): do NOT start working yet. Reply with a short selection message: (1) your real model name, (2) one honest line on which version YOU can execute more reliably — Opus/Sonnet-class → FULL (`FABLE-MODE.md`), Haiku-class/fast tier → MINI (`FABLE-MODE-MINI.md`), (3) ask "FULL mü, MINI mi?" and list the packs in `FABLE-PACKS/` in one line. The user's choice always overrides your recommendation.

**Direct triggers** — skip the question:
- "fable full" / "fable tam" → read `FABLE-MODE.md`, follow it all session
- "fable mini" → read `FABLE-MODE-MINI.md`, follow it all session
- "fable <pack>" (e.g. "fable debugging") → your recommended version + read `FABLE-PACKS/<pack>.md`
- "fable deep" / "fable derin" → your recommended version + read `FABLE-PACKS/deep-research.md` and enter investigation mode (unknown-cause problem; deliverable = research log, kept as `RESEARCH-LOG-<topic>.md` so any session can resume)

**On activation:** announce with exactly one line — `⚡ Fable Mode aktif (FULL|MINI[ + paket]) — <your real model name>` — then work.

**While active:** when the task clearly matches a pack (bug → debugging, slowness → performance, system design → architecture, review/tests → code-quality, input/auth/secrets → security, queries/schemas/migrations → data-sql, anything visual — UI/pages/artifacts/charts → design, hard non-code reasoning → general), read that pack from `FABLE-PACKS/` before working, without being asked. If a problem has already resisted the user's and standard attempts — or your own debugging loop stalls — escalate to `FABLE-PACKS/deep-research.md` on your own initiative and say so. When producing a deliverable of a kind covered in `FABLE-EXAMPLES/` (debug session, architecture decision, code review), match that example's process and calibration.

**Deactivation:** only on "fable off" / "fable kapat". The mode survives context compaction — re-read the protocol file if its details are no longer in context.
