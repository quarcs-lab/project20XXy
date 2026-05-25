> **Reference doc** for a consolidated pipeline skill. Source: `econ-visualization`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Economics Visualization

Create publication-quality figures with consistent academic styling, optimized for economics journals.

## Arguments

- `$ARGUMENTS` — chart type and data description (e.g., "coefficient plot from notebook-02 regressions", "event study DiD results", "time series GDP per capita by country", "scatter income vs growth with fitted line", "RD plot running variable")

## Steps

1. Parse the chart type from the arguments. Supported chart types:
   - **Scatter plot** — bivariate relationships, with optional fitted line and confidence band
   - **Time series** — one or more series over time, with optional recession shading or event markers
   - **Coefficient plot** — forest-plot style with point estimates and confidence intervals
   - **Event study plot** — pre/post treatment coefficients with confidence bands
   - **RD plot** — regression discontinuity with binned scatter and fitted polynomials both sides of cutoff
   - **Distribution** — kernel density, histogram, or box plot
   - **Bar chart** — grouped or stacked, for categorical comparisons
   - **Heatmap** — correlation matrix or spatial data
   - If the chart type is not recognized, ask the user to describe the desired visualization.

2. Ask the user for the language preference: **Python**, **R**, or **Stata**.

3. Apply project-wide figure standards (from CLAUDE.md):
   - **Dimensions:** 6 inches wide × 4 inches tall
   - **Resolution:** 300 DPI
   - **Export path:** `../images/<label>.png`
   - **Quarto cell options:** `#| label: fig-<name>` and `#| fig-cap: "<caption>"`

4. Generate code with academic styling conventions:

   **Python (matplotlib/seaborn):**
   ```python
   fig, ax = plt.subplots(figsize=(6, 4))
   # Use clean, minimal style
   ax.spines['top'].set_visible(False)
   ax.spines['right'].set_visible(False)
   ax.set_xlabel("X Label", fontsize=12)
   ax.set_ylabel("Y Label", fontsize=12)
   ax.tick_params(labelsize=10)
   fig.savefig("../images/<label>.png", dpi=300, bbox_inches="tight")
   ```

   **R (ggplot2):**
   ```r
   p <- ggplot(data, aes(x, y)) +
     geom_point() +
     theme_minimal(base_size = 12) +
     theme(
       panel.grid.minor = element_blank(),
       plot.title = element_text(size = 14, face = "bold")
     ) +
     labs(x = "X Label", y = "Y Label")
   ggsave("../images/<label>.png", plot = p, width = 6, height = 4, dpi = 300)
   ```

   **Stata:**
   ```stata
   twoway (scatter y x), ///
     scheme(s2color) ///
     xtitle("X Label") ytitle("Y Label")
   quietly graph export "../images/<label>.png", replace width(1800)
   ```

5. Apply chart-type-specific templates:

   - **Coefficient plot:** Horizontal forest plot with point estimates as dots, 95% CI as horizontal lines, vertical zero reference line (dashed). Order coefficients by magnitude or logical grouping. Use `geom_pointrange()` (R) or `ax.errorbar()` (Python).

   - **Event study plot:** X-axis = periods relative to treatment (t-3, t-2, ..., t+3). Point estimates with 95% CI error bars. Vertical dashed line at t=0 (treatment). Horizontal dashed line at y=0 (null effect). Normalize t-1 to zero (omitted period). Shade post-treatment region lightly.

   - **RD plot:** Binned scatter plot (evenly spaced bins or quantile bins). Fitted polynomial curves on each side of the cutoff. Vertical line at the cutoff. Different colors for below/above cutoff. Show the discontinuity visually.

   - **Time series:** Multiple series with distinct colors from a colorblind-safe palette. Legend placed inside the plot area (top-right or bottom-left to avoid clutter). Optional vertical lines for key events. Date formatting on x-axis.

   - **Distribution:** Kernel density with `bw_method='scott'` or histogram with Freedman-Diaconis bins. Vertical dashed lines for mean and median, labeled. If comparing groups, use semi-transparent overlapping densities.

   - **Scatter plot:** Point opacity at 0.5–0.7 for dense data. Optional OLS fit line with `geom_smooth(method="lm")` or `np.polyfit`. Label outliers if relevant. Consider log scales for skewed variables.

   - **Heatmap:** Diverging color palette (blue-white-red for correlations). Annotate cells with values. Mask the upper triangle for correlation matrices. Use `sns.heatmap()` (Python) or `corrplot` (R).

6. Apply universal styling rules:
   - **Colors:** Use colorblind-safe palettes: `Set2`, `Dark2` (categorical) or `viridis`, `RdBu` (sequential/diverging). Never use rainbow.
   - **Typography:** Axis labels 12pt, tick labels 10pt, title 14pt. Sans-serif font for screen; serif acceptable for print.
   - **Grid:** Minimal or no gridlines. Never major+minor grids simultaneously.
   - **Legend:** Inside the plot when possible. No box border around legend.
   - **Aspect ratio:** Wider than tall (3:2) for most plots. Square for scatter/heatmap.

7. Show the embed shortcode for manuscript integration:
   ```markdown
   {{< embed notebooks/<notebook>.qmd#fig-<name> >}}
   ```

## Error handling

- If the data source is not specified, ask the user which notebook or dataset contains the data.
- If the chart type doesn't match the data structure (e.g., event study with no time dimension), suggest an alternative.

## Common Pitfalls

- **Cluttered legends:** Move the legend inside the plot; remove the border; reduce to essential entries only
- **Axis labels too small for print:** Journal figures are often printed at column width (~3.5 inches). Labels that look fine at 6 inches become unreadable at 3.5. Use 12pt minimum.
- **Rainbow color palettes:** ~8% of men have color vision deficiency. Use `viridis`, `Set2`, or `RdBu` instead of `jet` or `rainbow`.
- **3D charts:** Never use 3D bar charts or 3D scatter plots in academic work. They distort perception and add no information.
- **Missing units on axes:** Every axis must have a unit (%, USD, log points, standard deviations). Bare numbers are ambiguous.
- **Inconsistent styling:** All figures in the same paper should use the same font sizes, color palette, and grid style. Establish a style early and reuse it.
- **Overplotting:** For large datasets, use transparency (`alpha=0.3`), jitter, hex bins, or contour plots instead of opaque points.

## References

- Schwabish (2014) "An Economist's Guide to Visualizing Data" — *Journal of Economic Perspectives*
- Tufte (2001) "The Visual Display of Quantitative Information"
- Wilke (2019) "Fundamentals of Data Visualization"
