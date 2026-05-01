---
name: regression-table
description: Formats estimation output as a publication-quality regression table with stars, SEs, and fit statistics. Use when creating a results table.
argument-hint: <notebook> [description]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
version: 1.1.0
workflow_stage: writing
tags:
  - regression
  - tables
  - LaTeX
  - booktabs
---

# Format Regression Table

Create a publication-quality regression table from estimation output in a notebook.

## Arguments

- `$ARGUMENTS` — a notebook reference and/or description of the table (e.g., "notebook-02 OLS results" or "main regression table with 3 specifications")

## Steps

1. Identify the source notebook and the estimation output:
   - If a notebook name is provided, read that notebook
   - If no notebook is specified, ask the user which notebook contains the regression results
   - Look for cells with estimation commands (Python: `pyfixest`, `statsmodels`, `linearmodels`; R: `fixest`, `lm`, `felm`; Stata: `reg`, `reghdfe`, `ivregress`)

2. Ask the user for table specifications:
   - Which models/columns to include
   - Dependent variable name(s)
   - Which coefficients to display (or "all", excluding constant by default)
   - Fixed effects to report as Yes/No rows
   - Clustering level for standard errors
   - Any custom notes for the table footer

3. Build the table **manually as pipe-delimited Markdown** (do NOT use `pf.etable(type="md")`, `etable(markdown=TRUE)`, or `esttab md` — their output doesn't render correctly in the Quarto manuscript). Extract coefficients, SEs, and p-values from model objects and construct the table row by row:
   - **Header row:** Column numbers with model names: `| | (1) OLS | (2) FE | ... |`
   - **Coefficient rows:** Point estimate with significance stars on top, standard error in parentheses below
   - **Significance stars:** `*` p<0.10, `**` p<0.05, `***` p<0.01
   - **Separator row:** Empty row between coefficients and metadata
   - **Fixed effects rows:** Yes/No indicators
   - **Summary rows:** Observations, R-squared

4. Export the table in three formats to `../tables/`:
   - `<label>.md` — Markdown (for `{{< include >}}` in manuscript)
   - `<label>.csv` — CSV (for data reuse)
   - `<label>.tex` — LaTeX with booktabs, following AER-style formatting conventions:
     - Use `\toprule`, `\midrule`, `\bottomrule` only — never `\hline`
     - Use `\cmidrule{2-4}` for partial rules spanning column groups (e.g., Panel A vs Panel B)
     - Wrap in `\begin{threeparttable}` with notes in `\begin{tablenotes}[flushleft]\footnotesize` to keep notes at table width
     - Use `S` columns from `siunitx` for decimal-aligned numbers, or `d{2.3}` for fixed decimal positions
     - For wide tables (many columns): reduce `\tabcolsep` or use `\small`/`\footnotesize`
     - **Multi-panel tables:** Use `\multicolumn{N}{l}{\textit{Panel A: Description}}` as a spanning header, then `\midrule` before Panel B

5. To embed in `index.qmd`, use `{{< include >}}` (NOT `{{< embed >}}`):
   ```markdown
   **Table N: Caption text.**

   {{< include tables/<label>.md >}}

   ::: {.table-notes}
   *Note:* Dependent variable: ... Standard errors clustered by ... in parentheses.
   Significance levels: * p<0.10, ** p<0.05, *** p<0.01. All regressions include a constant (not reported).
   :::
   ```

## Error handling

- If the notebook has no estimation output, report this and ask the user to run the regressions first.
- If the estimation output format is not recognized, ask the user to provide the raw coefficients and standard errors.

## Common Pitfalls

- **Tables exceeding page margins:** Reduce font size (`\small`), reduce `\tabcolsep`, or split into Panel A/Panel B before shrinking further
- **Missing SE documentation:** Always state the type of standard errors (robust, clustered by X, HC1, etc.) in the table notes — reviewers will ask
- **Inconsistent significance stars:** Use the same convention across all tables in the paper: `*` p<0.10, `**` p<0.05, `***` p<0.01
- **Missing dependent variable:** Each column header should name or clearly indicate the dependent variable
- **Forgetting constant suppression note:** If the constant is excluded from the display, state "All regressions include a constant (not reported)" in notes
- **Using `\hline` in LaTeX:** Always use `booktabs` commands — `\hline` produces thicker, less professional lines
