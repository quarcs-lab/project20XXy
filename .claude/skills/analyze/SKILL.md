---
name: analyze
description: Scaffold a Quarto analysis notebook (generic or method-specific — DiD, IV, RDD, LASSO, Panel FE), register it in _quarto.yml, apply publication-quality figure styling, and generate dataset codebooks. Use when starting a new analysis notebook.
argument-hint: "<mode> [name/title/args] — mode: notebook | did | iv | rdd | lasso | panel-fe | figure | codebook"
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
version: 2.0.0
workflow_stage: analysis
tags:
  - notebook
  - Quarto
  - scaffold
  - econometrics
  - visualization
  - figures
  - codebook
---

# Analyze: scaffold notebooks, methods, figures, and codebooks

Consolidated entry point for creating analysis artifacts. A thin dispatcher on
the first argument; the detailed procedure for each mode lives in `references/`.

**What this skill does** — scaffolds files and applies project conventions:
notebook skeletons, method-specific econometric boilerplate, publication-quality
figure styling, and dataset codebooks.

**What this skill does NOT do:**
- It does **not** run the full notebook suite — that is `/project:execute`.
- It does **not** render the manuscript — that is `/project:render`.
- For a single new notebook it renders **only that file** to verify it compiles
  (`quarto render notebooks/<name>.qmd`), never the whole project.

## Modes

| Mode | Reads | Does |
| ---- | ----- | ---- |
| `notebook` | `references/notebook-scaffold.md` | Create a generic Quarto `.qmd`, register it in `_quarto.yml` |
| `did` / `iv` / `rdd` / `lasso` / `panel-fe` | `references/methods-boilerplate.md` | Scaffold a method-specific econometric notebook with boilerplate + pitfalls |
| `figure` | `references/figure-conventions.md` | Generate/style a publication-quality figure (6×4 in, 300 DPI → `images/`) |
| `codebook` | `references/codebook-spec.md` | Auto-generate a Markdown codebook from a dataset (CSV/DTA/Excel/Parquet) |

## Procedure

1. Parse the first token as the mode. If it is a method name (`did`, `iv`, `rdd`,
   `lasso`, `panel-fe`), route to the methods-boilerplate path; if `notebook`,
   use the generic scaffold; if `figure`/`codebook`, use those reference docs.
2. Read the matching `references/*.md` and follow it exactly — it carries the
   naming convention (`notebook-NN`), seed cells per kernel, the Import → EDA →
   Analysis structure, figure/table export rules, and embed/include shortcodes.
3. For notebook scaffolds: find the next free `notebook-NN`, ask which kernel
   (Python/R/Stata) if not given, write the file, **register it under
   `manuscript.notebooks` in `_quarto.yml`**, and render just that notebook to
   confirm it compiles.
4. Consider recording the approved scope at `notes/<notebook-slug>/<slug>_plan.md`
   so the audit trail (see `notes/README.md`) is seeded for `/project:review`.

## Follow-up

Offer next steps: `/project:execute` to run the suite, `/project:tables` for
results tables, `/project:write` for prose, or `/project:review <slug>` to audit.
