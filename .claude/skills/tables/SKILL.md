---
name: tables
description: Build publication-quality regression and robustness tables from notebook estimation output, exported to tables/ as CSV + Markdown + LaTeX. Use when creating a results table.
argument-hint: "<mode> <notebook> [spec] — mode: regression | robustness"
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
version: 2.0.0
workflow_stage: writing
tags:
  - regression
  - robustness
  - tables
  - LaTeX
  - booktabs
---

# Tables: regression and robustness tables

Consolidated table-building entry point. A thin dispatcher on the first
argument; the detailed templates live in `references/`.

## Modes

| Mode | Reads | Does |
| ---- | ----- | ---- |
| `regression` | `references/regression-table.md` | Format estimation output as a publication-quality table (stars, SEs, fit stats) |
| `robustness` | `references/robustness-table.md` | Generate robustness-check code and a combined sensitivity table |

## Procedure

1. Parse the first token as the mode and the next as the source notebook
   (e.g. `notebook-02`). Locate the estimation cell in that notebook.
2. Read the matching `references/*.md` and follow it.
3. **Critical project rule (applies to both modes):** build multi-column tables
   **manually** as pipe-delimited Markdown. Do **NOT** rely on `pf.etable(type="md")`,
   `etable(markdown=TRUE)`, or `esttab md` — their output does not render in Quarto
   manuscripts. Extract coefficients, SEs, and p-values from the model objects and
   construct the table row by row.
4. Export every table to `tables/<label>.{csv,md,tex}` (three formats) and embed
   in `index.qmd` via `{{< include tables/<label>.md >}}` — never `{{< embed >}}`
   for tables, and never a `tbl-` label on the notebook cell.

## Follow-up

Offer `/project:write interpret` to draft prose for the table, or
`/project:render` to rebuild the manuscript.
