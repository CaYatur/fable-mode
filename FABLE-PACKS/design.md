# FABLE PACK — Design & UI Craft

> Expert-pattern module for Fable Mode. **Load when:** building or reviewing anything visual — web UI, HTML pages, artifacts, dashboards, slides, charts, even README aesthetics. **How to use:** the gap between amateur and professional UI is ~20 repeatable decisions; they are below. Define tokens first, build from the catalogs, run the polish checklist before "done" (§9).

## Foundations — decide once, as tokens

- Define CSS variables **before** any component: one accent hue, one neutral ramp (5–7 steps), a type scale, one radius family (e.g. 6/10/16 px), one shadow scale, spacing on a 4/8 px grid. Every later choice picks *from* these — zero ad-hoc values.
- Type: base 16px; scale ratio 1.2–1.333; body line-height 1.5–1.7, headings 1.1–1.25; line length 45–75 characters (`max-width: 65ch`); at most two font families (or one family, several weights).
- Never pure-black-on-pure-white: ~`#1a1a1a` text on ~`#fafafa`. Dark mode: ~`#e4e4e4` text on ~`#121212` — a pure `#000` background makes elevation impossible.

## Hierarchy — the actual skill

- A viewer should know where to look within one second: exactly **one** primary action per view, one element louder than everything else.
- Build hierarchy with size + weight + color **together**: a large number over a small muted label beats two medium texts. Labels are quieter than data (muted, smaller, optionally uppercase + letter-spacing).
- **De-emphasize instead of emphasizing:** when everything shouts, mute the secondary elements rather than enlarging the primary one.
- Proximity law: space **between** groups > space **within** groups. Group with whitespace first — boxes and borders are the fallback, not the default.

## Spacing & layout

- "It looks off" almost always means inconsistent spacing: audit every gap against the 4/8 grid. Padding scales with importance (buttons 8–12, cards 16–24, page sections 48–96).
- Everything aligns with something: pick edges and keep them. Center only short content (heroes, empty states); body text stays left-aligned.
- Separation tools, in order of preference: whitespace → background shift → border. Try deleting borders and widening gaps before adding lines.
- Design the narrow layout first. Wide content (tables, code) scrolls inside its own `overflow-x: auto` container — the page itself never scrolls horizontally.

## Color

- Formula: neutrals do 90% of the work; **one** accent for brand/interaction; green/amber/red reserved for meaning (success/warning/danger) — never decoration.
- Think in HSL: hover/active = same hue, shifted lightness; tinted backgrounds = same hue, high lightness, low saturation. One hue family keeps a page harmonious for free.
- Contrast floors: body text ≥ 4.5:1, large/bold ≥ 3:1 — **including muted text against its real background**. Grey-on-grey below contrast is the most common accessibility failure.
- Dark mode is a redesign, not an inversion: desaturate accents slightly, convey elevation with *lighter* surfaces (not shadows), soften shadows into subtle borders, pull pure white down to ~`#e4e4e4`.

## Components & micro-craft

- Nested radii: inner radius ≈ outer radius − padding; one radius family site-wide.
- Shadows: two subtle layers (`0 1px 2px rgba(0,0,0,.06), 0 4px 12px rgba(0,0,0,.08)`) beat one big blur; light comes from above — keep the direction consistent everywhere.
- Interactive states are not optional: hover (slight shade/lift), active (pressed), `:focus-visible` (a visible ring — never `outline: none` without a replacement), disabled (reduced opacity, no pointer events).
- Motion: 150–250 ms; ease-out entering, ease-in exiting; animate only `transform` and `opacity`; honor `prefers-reduced-motion`.
- Empty, loading, error, and overflow states are part of the design — a component with only a happy state is half-designed (the visual mirror of §7's failure paths).

## Charts & data (compact rules)

- One accent + neutrals; color carries meaning or stays neutral. Direct-label lines/bars when ≤ 4 series instead of a legend.
- Bars start at zero (truncated bars lie); lines needn't. No 3D, no dual y-axes, no pies beyond ~4 slices (use bars).
- Gridlines whisper (very low contrast); data speaks. Axis labels horizontal; numbers humanized (1.2M, not 1200000).
- Sequential data → single-hue ramp; diverging → two hues through a neutral midpoint; categorical → ≤ 6–8 distinguishable hues, colorblind-safe (never red-vs-green alone).

## Amateur tells → fixes (scan any design against this)

| Tell | Fix |
|---|---|
| Rainbow palette; each section a new color | one accent + neutrals; semantic colors for meaning only |
| Pure #000 on #fff, or grey-on-grey under 4.5:1 | near-black/near-white; check contrast both themes |
| Borders around everything | whitespace and background shifts first |
| Five font sizes, no system | one ratio, snap every size to it |
| Cramped inside cards, huge gaps outside (or the reverse) | padding proportional to nesting level |
| Centered paragraphs; full-width text lines | left-align; 65ch measure |
| Radii and shadows different on every element | token scales |
| `outline: none`, no focus style | `:focus-visible` ring |
| Emoji doing an icon system's job | one icon set, used sparingly |
| Dark mode = inverted colors | redesign: desaturate, elevate with lightness |

## Polish checklist (run before "done" — pairs with §9)

1. Squint test: does the hierarchy survive blur? Is the primary action still obvious?
2. Spacing audit: every gap from the scale? groups separated more than their contents?
3. Contrast checked — including muted text — in both light and dark?
4. All states present: hover / focus / disabled / empty / loading / overflow?
5. Narrow screen: nothing scrolls the page horizontally?
6. Zero magic values bypassing the tokens?
