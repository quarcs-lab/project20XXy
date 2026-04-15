---
name: robustness-table
description: Generates robustness check code and formats results as a combined table. Use for sensitivity analysis.
argument-hint: <notebook> <baseline spec>
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Generate Robustness Checks and Table

Given a baseline regression, generate code for standard robustness checks and format the results as a publication-ready table.

## Arguments

- `$ARGUMENTS` — notebook reference and baseline specification description (e.g., "notebook-01 baseline two-way FE growth regression")

## Steps

1. Read the specified notebook and locate the baseline regression:
   - Look for estimation commands (Python: `pyfixest`, `statsmodels`, `linearmodels`; R: `fixest`, `lm`, `felm`; Stata: `reg`, `reghdfe`, `ivregress`)
   - Identify the dependent variable, independent variables, fixed effects, and clustering

2. Ask the user which robustness checks to include:
   - Alternative control variable sets (drop/add controls)
   - Alternative fixed effects specifications
   - Different standard error clustering levels
   - Subsample analysis (e.g., by region, time period, income group)
   - Winsorized or trimmed dependent variable
   - Alternative dependent variable (e.g., log vs level)
   - Placebo tests (randomized treatment, pre-period outcome)
   - Alternative estimation methods (e.g., OLS vs Poisson, logit vs probit)

3. Generate code cells in the notebook for each robustness specification:
   - Each cell should be self-contained (loads data, runs regression, stores results)
   - Use consistent variable naming for results collection

4. Build the summary table **manually as pipe-delimited Markdown** (do NOT use `pf.etable(type="md")`, `etable(markdown=TRUE)`, or `esttab md`). Extract coefficients, SEs, and p-values from model objects:
   - Format: baseline in column (1), each robustness check in subsequent columns
   - Follow academic conventions: coefficient (SE), significance stars, N, R², FE indicators
   - Include a separator row between coefficients and metadata

5. Export the table in three formats to `../tables/`:
   - `<label>.md`, `<label>.csv`, `<label>.tex`

6. Optionally export the table to `tables/` as a standalone file (LaTeX or CSV)

7. To embed in `index.qmd`, use `{{< include >}}`:
   ```markdown
   **Table N: Robustness checks.**

   {{< include tables/<label>.md >}}

   ::: {.table-notes}
   *Note:* ...
   :::
   ```

## Error handling

- If the baseline regression is not found, ask the user to point to the specific cell.
- If the notebook uses a language not recognized, ask for guidance on the estimation syntax.
