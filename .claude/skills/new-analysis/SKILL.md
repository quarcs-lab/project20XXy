---
name: new-analysis
description: Scaffolds a method-specific analysis notebook (DiD, IV, RDD, LASSO, Panel FE) with boilerplate. Use when starting a new econometric analysis.
argument-hint: <method> [title]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Scaffold Analysis Notebook

Create a new notebook pre-populated with method-specific boilerplate for a common econometric technique.

## Arguments

- `$ARGUMENTS` — the method name and optional title (e.g., "DiD Event Study", "IV Analysis of Colonial Origins", "RDD Minimum Wage", "LASSO Variable Selection", "Panel FE Growth Regressions")

## Steps

1. Parse the method from the arguments. Recognized methods:
   - **DiD** (difference-in-differences)
   - **IV** (instrumental variables)
   - **RDD** (regression discontinuity design)
   - **LASSO** (regularized regression / variable selection)
   - **Panel FE** (panel fixed effects)
   - If the method is not recognized, ask the user to clarify.

2. Follow the same notebook creation conventions as `/project:new-notebook`:
   - Check `notebooks/` for existing files to determine the next sequential number
   - Ask the user for the kernel: Python, R, or Stata
   - Create the `.qmd` with YAML frontmatter (`title` and `jupyter` kernel) and the setup cell
   - Include pedagogical markdown narrative explaining each step

3. Add method-specific sections as markdown and code cells:

   **All methods include these sections:**
   - Data Loading (code cell)
   - Variable Construction (code cell)
   - Summary Statistics (descriptive table exported to `../tables/`)
   - Estimation (regression table built manually as pipe-delimited Markdown)
   - Visualization (figure exported at 6×4 inches, 300 DPI, to `../images/`)
   - Robustness Checks (markdown header + empty code cell)

   **All figures:** 6 inches wide × 4 inches tall, 300 DPI, exported to `../images/`.
   **All tables:** Export to `../tables/` in three formats (CSV + Markdown + LaTeX). Build regression tables manually — do NOT use `pf.etable(type="md")`, `etable(markdown=TRUE)`, or `esttab md` as their output doesn't render correctly in the manuscript.

   **Method-specific boilerplate:**

   - **DiD:** parallel trends test, event study plot, TWFE regression, staggered treatment note
   - **IV:** first-stage regression, reduced-form, 2SLS estimation, weak instrument diagnostics (F-statistic, Anderson-Rubin), overidentification test stub
   - **RDD:** running variable histogram, McCrary density test, bandwidth selection (Imbens-Kalyanaraman), local polynomial estimation, RD plot
   - **LASSO:** cross-validation for lambda, coefficient path plot, selected variables, post-LASSO OLS
   - **Panel FE:** within estimator, entity and time FE, clustered standard errors, Hausman test (FE vs RE)

4. Register in `_quarto.yml` under `manuscript.notebooks`:
   ```yaml
   - notebook: notebooks/<name>.qmd
     title: "<title>"
   ```

5. To embed in `index.qmd`:
   - **Figures:** `{{< embed notebooks/<name>.qmd#fig-label >}}`
   - **Tables:** `{{< include tables/<label>.md >}}`

6. Confirm the notebook renders: `quarto render notebooks/<name>.qmd`

7. Report the file path and list the embed-ready labels created.
