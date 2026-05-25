> **Reference doc** for a consolidated pipeline skill. Source: `new-analysis`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

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

   - **DiD:** parallel trends test (event-study coefficients for pre-treatment periods), event study plot, TWFE regression, staggered treatment note. **Staggered treatment warning:** if treatment timing varies across units, naive TWFE can produce biased estimates due to negative weights. Use `did` package (R, Callaway & Sant'Anna 2021), `csdid` (Stata), or `did2s` (Python, Gardner 2022) instead. Include Bacon decomposition to diagnose heterogeneity in treatment timing.
   - **IV:** first-stage regression with F-statistic (rule of thumb: F > 10; use Kleibergen-Paap rk Wald F when SEs are clustered), reduced-form regression (as a credibility check — if reduced form is insignificant, IV results are suspect), 2SLS estimation, Anderson-Rubin confidence intervals (robust to weak instruments), Hansen J overidentification test (when overidentified). Always report first-stage F prominently.
   - **RDD:** running variable histogram (check for manipulation), McCrary density test (required — manipulation of the running variable invalidates the design), bandwidth selection (Calonico-Cattaneo-Titiunik optimal bandwidth preferred over Imbens-Kalyanaraman), local polynomial estimation with robust bias-corrected CIs, RD plot with binned scatter and fitted polynomials both sides of cutoff. Include bandwidth sensitivity plot and donut-hole RDD as robustness checks.
   - **LASSO:** cross-validation for lambda, coefficient path plot, selected variables, post-LASSO OLS (Belloni, Chernozhukov & Hansen 2014)
   - **Panel FE:** within estimator, entity and time FE, clustered standard errors (cluster at the entity level by default — clustering at a lower level underestimates SEs), Hausman test (FE vs RE). Report within-R² (not overall R²) as the relevant goodness-of-fit measure.

4. Include language-specific package guidance in the notebook preamble:

   - **Python:** `pyfixest` for fixed effects and DiD, `linearmodels` for IV and panel models, `rdrobust` for RDD, `scikit-learn` for LASSO
   - **R:** `fixest` (preferred for all FE models — supports `sunab()` for staggered DiD, `feols()` for IV), `rdrobust` for RDD, `ivreg` for IV, `glmnet` for LASSO
   - **Stata:** `reghdfe` for high-dimensional FE, `ivregress` for IV, `rdrobust` for RDD, `csdid` for staggered DiD, `lasso2` for LASSO

5. Register in `_quarto.yml` under `manuscript.notebooks`:
   ```yaml
   - notebook: notebooks/<name>.qmd
     title: "<title>"
   ```

6. To embed in `index.qmd`:
   - **Figures:** `{{< embed notebooks/<name>.qmd#fig-label >}}`
   - **Tables:** `{{< include tables/<label>.md >}}`

7. Confirm the notebook renders: `quarto render notebooks/<name>.qmd`

8. Report the file path and list the embed-ready labels created.

## Common Pitfalls

- **Staggered DiD with TWFE:** Naive two-way fixed effects produces biased estimates when treatment timing varies — negative weights on already-treated units contaminate the ATT. Always check for staggered adoption and use appropriate estimators.
- **Weak instruments:** A first-stage F-statistic below 10 signals weak instruments. Standard 2SLS inference is unreliable — use Anderson-Rubin CIs or LIML instead.
- **RDD bandwidth sensitivity:** Results that hold only at the MSE-optimal bandwidth are fragile. Always show estimates across a range of bandwidths (50%–200% of optimal).
- **Clustering level:** Cluster standard errors at the level of treatment assignment. Clustering at a finer level (e.g., individual when treatment is at the state level) underestimates SEs and inflates significance.
- **Pre-trends in DiD:** Statistically insignificant pre-trend coefficients do not prove parallel trends — low power can mask violations. Discuss the magnitude of pre-trend estimates relative to the treatment effect.

## References

- Callaway & Sant'Anna (2021) "Difference-in-Differences with Multiple Time Periods" — staggered DiD
- de Chaisemartin & D'Haultfoeuille (2020) "Two-Way Fixed Effects Estimators with Heterogeneous Treatment Effects" — TWFE bias
- Andrews, Stock & Sun (2019) "Weak Instruments in IV Regression" — weak instrument diagnostics
- Cattaneo, Idrobo & Titiunik (2019) "A Practical Introduction to Regression Discontinuity Designs" — RDD best practices
- Belloni, Chernozhukov & Hansen (2014) "Inference on Treatment Effects after Selection among High-Dimensional Controls" — post-LASSO
