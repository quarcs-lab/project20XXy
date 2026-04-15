# CLAUDE.md -- AI Assistant Instructions

**Your role:** Research assistant and workflow orchestrator for an academic research project.
For full documentation (installation, workflows, Overleaf sync, reproducibility), see `README.md`.

**First actions for every session:**

1. Read this file completely
2. Check `./handoffs/` for the most recent entry to understand prior work
3. Review the project context below for current status
4. Begin work or ask clarifying questions

---

## Project Context

| Field | Value |
| ----- | ----- |
| **Title** | `[FILL: Project title]` |
| **Authors** | `[FILL: Author names and affiliations]` |
| **Stage** | `[FILL: Idea / Data collection / Analysis / Writing / Revision]` |
| **Primary tools** | R, Python, Stata, Quarto, LaTeX |
| **Reference manager** | Zotero (exports to `references.bib`) |
| **Manuscript** | `index.qmd` (Quarto manuscript project) |
| **Environment** | `uv` + `pyproject.toml` (Python 3.12) |
| **Data source** | `[FILL: e.g., OSF repository, survey, API]` |

---

## Critical Rules

These are non-negotiable behavioral constraints.

1. **Never delete data or code** -- Do not delete files in `data/`, `code/`, `notebooks/`, `references/`, or `templates/`. Move old versions to `legacy/`.
2. **Stay within this directory** -- All work must remain inside this project folder. Ask before accessing external resources.
3. **Preserve raw data** -- Files in `data/rawData/` are source-of-truth inputs. Never modify them.
4. **Document progress** -- Write a handoff report to `./handoffs/` after significant work or before ending a session.

---

## Key Paths

| Path | Purpose |
| ---- | ------- |
| `index.qmd` | Main manuscript source |
| `_quarto.yml` | Quarto config (formats, notebook registrations, theme) |
| `styles.css` | Custom HTML styling (tables, code blocks, notebook layout) |
| `references.bib` | Bibliography (from Zotero) |
| `pyproject.toml` / `uv.lock` | Python dependencies (includes `pyfixest`) |
| `notebooks/` | Quarto notebooks (`.qmd`) — Python, R, Stata |
| `data/panel_growth.csv` | Synthetic panel dataset (40 countries × 6 periods) |
| `images/` | Exported figures (PNG, 300 DPI, 6×4 inches) |
| `tables/` | Exported tables (CSV + Markdown + LaTeX) |
| `data/rawData/` | Raw source data (never modify) |
| `scripts/render.sh` | Two-pass clean render + Overleaf staging + GitHub Pages deploy |
| `handoffs/` | Session handoff reports |
| `.claude/skills/` | 24 skill definitions (SKILL.md with YAML frontmatter) |
| `.env` | API keys and secrets (gitignored, never commit) |

---

## Skills

Invoke with `/project:<name>`. See `README.md` § Available Skills for full descriptions and SKILL.md links.

**Build & Execution** -- Side-effect skills, manual invocation only.

| `/project:render` | `/project:execute` | `/project:init` | `/project:sync-tex` |
| --- | --- | --- | --- |

**Notebook & Presentation Creation** -- Create new files; accept arguments.

| `/project:new-notebook` | `/project:new-analysis` | `/project:new-slide-deck` |
| --- | --- | --- |

**Writing & Results** -- Draft prose, interpret output, format tables.

| `/project:draft-section` | `/project:abstract` | `/project:interpret-results` |
| --- | --- | --- |
| `/project:regression-table` | `/project:robustness-table` | `/project:referee-response` |

**References & Data** -- Manage citations, literature notes, data docs.

| `/project:cite` | `/project:literature-note` | `/project:codebook` |
| --- | --- | --- |

**Quality Checks & Audits** -- Read-only; can be auto-invoked when relevant.

| `/project:bib-check` | `/project:data-audit` | `/project:freeze-check` |
| --- | --- | --- |
| `/project:check-env` | `/project:submission-prep` | `/project:figures-gallery` |

**Session Management** -- `/project:handoff` and `/project:env-snapshot`

---

## Session Management

**Handoff reports** go in `./handoffs/` as `YYYYMMDD_HHMM.md`. Write one when you complete significant work, make major decisions, or end a session. Every handoff must include:

- Current project state (one paragraph)
- Work completed (bullet list)
- Decisions made and rationale
- Open issues or blockers
- Concrete next steps

---

## Essential Commands

See `README.md` § Manuscript Workflow and § Notebook Workflow for full details.

```bash
bash scripts/render.sh                                      # two-pass clean render (all formats)
quarto render notebooks/<file>.qmd                           # render individual notebook
uv add <package>                                             # add Python package (NEVER use pip)
```

---

## Notebook Conventions

Every notebook must follow these patterns. See existing notebooks for reference.

### Content Structure

Each notebook is a **tutorial** that follows three sections:

1. **Data Import** -- Load data, show panel structure, verify dimensions
2. **Exploratory Data Analysis** -- Descriptive statistics table (compare initial vs final period), visualizations (box plots, scatter plots, correlation heatmap)
3. **Panel Data Regressions** -- Fixed effects models (OLS, Country FE, Time FE, Two-way FE)

Include **pedagogical markdown text** between code blocks explaining:
- What the code does and why
- How to interpret the output
- Key methodological concepts (convergence, fixed effects, clustering)

### Kernel and Seed

Each `.qmd` notebook has YAML frontmatter with `title` and `jupyter` kernel:

- **Python:** `` ```{python} `` with `jupyter: python3`
- **R:** `` ```{r} `` with `jupyter: ir`
- **Stata:** `` ```{stata} `` with `jupyter: nbstata`

Set the random seed in the first code cell:

- **Python:** `random.seed(42)` and `np.random.seed(42)`
- **R:** `set.seed(42)`
- **Stata:** `set seed 42`

### Exporting Figures

All figures: **6 inches wide × 4 inches tall**, 300 DPI, exported to `../images/`:

- **Python:** `fig, ax = plt.subplots(figsize=(6, 4))` then `fig.savefig("../images/<label>.png", dpi=300, bbox_inches="tight")`
- **R:** `ggsave("../images/<label>.png", plot = p, width = 6, height = 4, dpi = 300)`
- **Stata:** `quietly graph export "../images/<label>.png", replace width(1800)`

### Exporting Tables

Export every table to `../tables/` in **three formats** (CSV + Markdown + LaTeX):

- **Python:**
  ```
  df.to_csv("../tables/<label>.csv", index=False)
  with open("../tables/<label>.md", "w") as f:
      f.write(df.to_markdown(index=False))
  df.to_latex("../tables/<label>.tex", index=False, float_format="%.2f")
  ```
- **R:**
  ```
  write.csv(result, "../tables/<label>.csv", row.names = FALSE)
  writeLines(knitr::kable(result, format = "pipe"), "../tables/<label>.md")
  writeLines(knitr::kable(result, format = "latex", booktabs = TRUE), "../tables/<label>.tex")
  ```
- **Stata:** Use `export delimited` for CSV, `file write` for Markdown and LaTeX (with booktabs)

### Regression Tables

Build multi-column regression tables **manually** as pipe-delimited Markdown. Do NOT rely on `pf.etable(type="md")` or `etable(markdown=TRUE)` or `esttab md` — their output doesn't render correctly in Quarto manuscripts. Instead, extract coefficients, SEs, and p-values from model objects and construct the table row by row.

Each regression table should include:
- Coefficient + significance stars (*** p<0.01, ** p<0.05, * p<0.10)
- Standard errors in parentheses
- Separator row between coefficients and metadata
- Fixed effects indicators (Yes/No)
- Observations and R-squared
- Table notes explaining clustering and significance levels

### Embedding in Manuscript

**Figures** use `{{< embed >}}` shortcodes in `index.qmd`:

```markdown
{{< embed notebooks/notebook-01.qmd#fig-growth-time >}}
```

**Tables** use `{{< include >}}` to pull the exported Markdown file:

```markdown
**Table 1: Caption text.**

{{< include tables/tbl-descriptive.md >}}

::: {.table-notes}
*Note:* Explanation text here.
:::
```

Do NOT use `{{< embed >}}` for tables — Quarto cannot extract markdown display outputs from notebook cells. Do NOT use `#| label: tbl-*` on table cells in notebooks — it conflicts with the `{{< include >}}` approach.

---

## Workflow Gotchas

These are non-obvious pitfalls. See `README.md` for full context.

- **Two-pass render required** -- `scripts/render.sh` runs `quarto render` twice. The first pass executes notebooks (generating table `.md` files); the second pass includes the fresh files in the manuscript via `{{< include >}}`
- **Register new notebooks** in `_quarto.yml` under `manuscript.notebooks`
- **All languages use `#|`** for cell options in `.qmd` fenced code blocks (including Stata)
- **Never use `tbl-` prefix** for Stata text output cells (e.g., `tabstat`, `summarize`) -- it triggers Quarto's table parser and crashes. This does NOT apply to properly formatted markdown tables
- **Never use `pip install`** -- it bypasses the lockfile. Always use `uv add`
- **HTML theme** -- `cosmo` theme with `github` syntax highlighting, configured in `_quarto.yml`
- **Credentials** go in `.env` only. Never commit secrets to git
