# [FILL: Project Title]

> **Template:** `project20XXy` — a reusable, multi-language research project template built on [Quarto](https://quarto.org/).

[FILL: One-paragraph description of the project — what question it investigates, why it matters, and what data/methods it uses.]

## What Is This Template?

`project20XXy` is a ready-to-clone template for reproducible academic research. It integrates:

- **Multi-language notebooks** — Python, R, and Stata in the same project, using Quarto notebooks (`.qmd`) — plain-text files with clean version control.
- **Quarto manuscript** — A single source file (`index.qmd`) that embeds figures and tables from notebooks and renders to HTML, PDF, and Word simultaneously.
- **Overleaf collaboration** — A sync workflow that lets LaTeX-only collaborators edit the manuscript in Overleaf while you keep working in Quarto.
- **Reproducibility by design** — Locked dependencies, protected raw data, and consistent random seeds.
- **AI-assisted workflow** — Claude Code integration with 24 skills for rendering, notebook creation, session handoffs, LaTeX sync, and more.

Clone this repository, fill in the `[FILL: ...]` placeholders, and start researching.

## Quick Start

```bash
# 1. Clone and enter the project
git clone [FILL: repository URL]
cd [FILL: project directory]

# 2. Install Python dependencies
uv sync

# 3. Render the manuscript (two-pass render: executes notebooks + builds HTML, PDF, Word)
bash scripts/render.sh

# 4. View the output
open _manuscript/index.html
```

> R and Stata kernels require additional setup — see [Installation](#installation) below.

---

## Using This Template

If you've just forked or cloned this repo and want to turn it into your own project, run through the checklist below in order. Each step links to a deeper section if you need details.

1. **Install the toolchain.** Quarto >= 1.9, `uv`, Python 3.12, and (optionally) R + Stata. See [Requirements](#requirements).
2. **Install Python deps.** `uv sync`. See [Python Environment](#python-environment).
3. **Install kernels you'll use.** [R kernel](#r-kernel-irkernel) and/or [Stata kernel](#stata-kernel-nbstata). Skip either if you don't need it — the pipeline runs with Python alone.
4. **Verify the environment.** In Claude Code, run `/project:check-env` to confirm every required tool and kernel is reachable.
5. **Render once from a clean clone** to confirm everything works end-to-end:

   ```bash
   bash scripts/render.sh
   open _manuscript/index.html
   ```

   You should see the demo manuscript render with all figures and tables.

6. **Fill in your project metadata.** Run `/project:init`, or edit by hand:
   - `README.md` — replace `[FILL: …]` placeholders at the top
   - `index.qmd` — set title, authors, abstract, keywords in the YAML header
   - `CLAUDE.md` — complete the **Project Context** table (Title, Authors, Stage, Data source)
   - `pyproject.toml` — update `name`, `description`, `authors`

   Find remaining placeholders at any time:

   ```bash
   grep -r "\[FILL:" --include="*.md" --include="*.qmd" --include="*.toml" .
   ```

7. **Bring in your data.** Put raw inputs in `data/rawData/` (never modified afterwards per CLAUDE.md rule #3) and document provenance in `data/rawData/README.md`. The demo `data/panel_growth.csv` is synthetic — move it to `legacy/` when you replace it.
8. **Replace or repurpose the sample notebooks.** The three notebooks in `notebooks/` are a panel-FE tutorial in Python, R, and Stata against the synthetic panel. Keep them as a reference, replace them with your analyses via `/project:new-notebook` or `/project:new-analysis`, and register anything new in `_quarto.yml` under `manuscript.notebooks`.
9. **Clear the template's session history.** Archive or delete everything in `handoffs/` so forkers start with their own context.
10. **Populate `references.bib`** from Zotero (or add entries one at a time with `/project:cite`). Run `/project:bib-check` to catch orphan / missing citations.

Once these are done, the remaining sections below (Manuscript Workflow, Notebook Workflow, Overleaf Collaboration, Reproducibility) describe the day-to-day loop.

---

## How It Works

Notebooks produce figures and tables. Figures are embedded directly in the manuscript via `{{< embed >}}`. Tables are exported as Markdown files and included via `{{< include >}}`. Quarto renders everything into HTML, PDF, and Word.

```mermaid
flowchart LR
    subgraph Notebooks ["notebooks/"]
        NB1["notebook-01.qmd<br/>(Python)"]
        NB2["notebook-02.qmd<br/>(R)"]
        NB3["notebook-03.qmd<br/>(Stata)"]
    end

    subgraph Exports ["Exported outputs"]
        IMG["images/<br/>PNG figures"]
        TBL["tables/<br/>CSV + MD + LaTeX"]
    end

    subgraph Manuscript ["index.qmd"]
        EMB["Figures via<br/>embed shortcode"]
        INC["Tables via<br/>include shortcode"]
    end

    subgraph Output ["quarto render"]
        HTML["index.html"]
        PDF["index.pdf"]
        DOCX["index.docx"]
    end

    NB1 --> IMG
    NB1 --> TBL
    NB2 --> TBL
    NB3 --> TBL
    IMG --> EMB
    TBL --> INC
    EMB --> Output
    INC --> Output
```

> **Why two passes?** The `scripts/render.sh` script runs `quarto render` twice. The first pass executes notebooks (generating table `.md` files in `tables/`). The second pass picks up those fresh files via `{{< include >}}` in the manuscript. A single `quarto render` may include stale table content.

---

## Requirements

| Tool | Purpose | Required? |
| ---- | ------- | --------- |
| [Quarto](https://quarto.org/) >= 1.9 | Manuscript rendering | Yes |
| [uv](https://docs.astral.sh/uv/) | Python package manager | Yes |
| Python 3.12+ | Notebooks, scripting | Yes |
| R | R notebooks | If using R |
| Stata | Stata notebooks | If using Stata |

Verify your setup:

```bash
quarto --version        # >= 1.9
uv --version            # any recent version
python3 --version       # >= 3.12
R --version             # optional
stata -v                # optional
```

---

## Installation

### Python Environment

```bash
uv sync    # Creates .venv/ with locked dependencies from uv.lock
```

This installs the core scientific stack (numpy, pandas, matplotlib, seaborn), the `pyfixest` econometrics package, and the `nbstata` Stata kernel. All Python commands should be prefixed with `uv run`.

### R Kernel (IRkernel)

```bash
R -e "install.packages(c('IRkernel', 'ggplot2', 'knitr', 'fixest'), repos='https://cloud.r-project.org')"
R -e "IRkernel::installspec()"
```

Verify: `jupyter kernelspec list` should show `ir`.

### Stata Kernel (nbstata)

> Use **nbstata**, not the legacy `stata_kernel` (which has a graph-capture bug with Stata 19+).

```bash
uv run python -m nbstata.install    # Register the kernel
```

Create `~/.config/nbstata/nbstata.conf`:

```ini
[nbstata]
stata_dir = /Applications/Stata
edition = se
```

Adjust `stata_dir` and `edition` (`be`, `se`, or `mp`) for your system. Verify: `jupyter kernelspec list` should show `nbstata`.

Install required Stata packages from a Stata session or notebook:

```stata
ssc install reghdfe
ssc install estout
```

### Adding Packages

| Language | Command | Notes |
| -------- | ------- | ----- |
| Python | `uv add <package>` | Updates `pyproject.toml` + `uv.lock`. Never use `pip install`. |
| R | `install.packages("pkg")` | System-level. Use [renv](https://rstudio.github.io/renv/) for isolation. |
| Stata | `ssc install <package>` | System-level `ado/plus/` directory. |

---

## Manuscript Workflow

### Writing

The manuscript lives in `index.qmd`. It uses standard Markdown with Quarto extensions:

- **Sections** with cross-reference IDs: `## Introduction {#sec-introduction}`
- **Citations** from `references.bib`: `@key` (narrative) or `[@key]` (parenthetical)
- **Figures** from notebooks: `{{< embed notebooks/notebook-01.qmd#fig-label >}}`
- **Tables** from exported files: `{{< include tables/tbl-label.md >}}`

### Rendering

```bash
# Recommended: two-pass clean render (all formats + Overleaf staging)
bash scripts/render.sh

# Quick single-notebook render (for development)
quarto render notebooks/notebook-01.qmd

# Single-format render
quarto render index.qmd --to html
```

The render script handles the full pipeline: clean caches, two-pass render, generate LLM-friendly markdown, stage LaTeX for Overleaf, and deploy to GitHub Pages.

```mermaid
flowchart TD
    A["bash scripts/render.sh"] --> B["Clear caches"]
    B --> C["Pass 1: quarto render<br/>(execute notebooks, generate table .md files)"]
    C --> D["Pass 2: quarto render<br/>(include fresh tables in manuscript)"]
    D --> E["Outputs: HTML + PDF + Word"]
    D --> F["Generate index.llms.md<br/>(LLM-friendly markdown via Pandoc)"]
    F --> G["LaTeX staged for Overleaf"]
    G --> H["Deploy to GitHub Pages<br/>(gh-pages branch)"]
```

---

## Notebook Workflow

### Content Structure

Each notebook is a **tutorial** that follows three sections:

1. **Data Import** — Load data, inspect panel structure, show dimensions
2. **Exploratory Data Analysis** — Descriptive statistics (initial vs final period), visualizations (box plots, scatter plots, correlation heatmap)
3. **Regression Analysis** — Fixed effects models with professional multi-column tables

Include pedagogical markdown text between code blocks explaining what the code does, why it matters, and how to interpret the output.

### Creating Notebooks

Use `/project:new-notebook` in Claude Code, or manually:

1. Create `notebooks/notebook-NN.qmd` with YAML frontmatter (`title` and `jupyter` kernel)
2. Set the random seed in the first code cell (see [Reproducibility](#reproducibility))
3. Register in `_quarto.yml` under `manuscript.notebooks`

### Exporting Figures

All figures: **6 inches wide x 4 inches tall**, 300 DPI.

| Language | Export command |
| -------- | ------------- |
| Python | `fig.savefig("../images/<label>.png", dpi=300, bbox_inches="tight")` |
| R | `ggsave("../images/<label>.png", plot = p, width = 6, height = 4, dpi = 300)` |
| Stata | `quietly graph export "../images/<label>.png", replace width(1800)` |

### Exporting Tables

Every table must be exported in **three formats**: CSV, Markdown, and LaTeX.

| Format | Python | R | Stata |
| ------ | ------ | - | ----- |
| CSV | `df.to_csv("../tables/<label>.csv")` | `write.csv(result, "../tables/<label>.csv")` | `export delimited` |
| Markdown | `df.to_markdown()` → write to `.md` | `knitr::kable(format = "pipe")` → write to `.md` | `file write` |
| LaTeX | `df.to_latex("../tables/<label>.tex")` | `knitr::kable(format = "latex", booktabs = TRUE)` → write to `.tex` | `file write` with booktabs |

### Embedding in the Manuscript

**Figures** use `{{< embed >}}` — Quarto extracts the figure output from the notebook:

```markdown
{{< embed notebooks/notebook-01.qmd#fig-convergence >}}
```

**Tables** use `{{< include >}}` — Quarto includes the exported Markdown file:

```markdown
**Table 1: Descriptive statistics.**

{{< include tables/tbl-descriptive.md >}}

::: {.table-notes}
*Note:* Explanation of variables, units, and data source.
:::
```

> **Why different methods?** Quarto's `{{< embed >}}` works well for figures (image outputs) but cannot reliably extract markdown display outputs from notebook cells. Tables are exported as `.md` files and included directly, which renders correctly in HTML, PDF, and Word.

### Regression Tables

Build multi-column regression tables **manually as pipe-delimited Markdown**. Do not use `pf.etable(type="md")`, `etable(markdown=TRUE)`, or `esttab md` — their output does not render correctly in the Quarto manuscript.

A typical regression table includes:

- Header row with column numbers and model names
- Coefficient with significance stars (\*\*\* p<0.01, \*\* p<0.05, \* p<0.10)
- Standard errors in parentheses
- Separator row between coefficients and metadata
- Fixed effects indicators (Yes/No)
- Observations and R-squared
- Table notes explaining clustering and significance conventions

See the existing notebooks for complete working examples.

---

## Overleaf Collaboration

For collaborators who prefer LaTeX, the project supports a sync workflow with [Overleaf](https://www.overleaf.com/) via GitHub integration.

```mermaid
flowchart TD
    A["1. Render locally<br/>bash scripts/render.sh"] --> B["latex/index.tex created"]
    B --> C["2. Push to GitHub<br/>Overleaf pulls index.tex"]
    C --> D["3. Collaborator edits in Overleaf"]
    D --> E["4. Pull changes from GitHub"]
    E --> F["5. Run /project:sync-tex<br/>Diff and apply to index.qmd"]
    F --> G["6. Re-render to verify"]
```

### Constraints

- **Prose only** — Only text edits are transferred. `{{< embed >}}` shortcodes are preserved.
- **Captions are not synced** — Figure/table captions live in notebook cells.
- **Preamble is ignored** — Everything before `\begin{document}` is auto-generated by Quarto.

---

## Reproducibility

### Seeds

Set the random seed in the first code cell of every notebook:

| Language | Code |
| -------- | ---- |
| Python | `random.seed(42)` and `np.random.seed(42)` |
| R | `set.seed(42)` |
| Stata | `set seed 42` |

### Dependencies

- **Python:** Locked via `uv` (`pyproject.toml` + `uv.lock`)
- **R:** System library or [renv](https://rstudio.github.io/renv/) for isolation
- **Stata:** System `ado/` directory

### Credentials

API keys and secrets go in `.env` (gitignored). Never commit `.env` to git.

---

## Project Structure

### Directories

| Directory | Purpose |
| --------- | ------- |
| `notebooks/` | Quarto notebooks (`.qmd`) in Python, R, and Stata |
| `data/` | Datasets (`panel_growth.csv` is the sample panel dataset) |
| `data/rawData/` | Raw source data — **never modify** |
| `images/` | Exported figures (PNG, 6x4 inches, 300 DPI) |
| `tables/` | Exported tables (CSV + Markdown + LaTeX) |
| `code/` | Standalone scripts outside notebooks |
| `latex/` | Overleaf sync staging (`index.tex` + `.baseline.tex`) |
| `slides/` | Quarto revealjs presentations |
| `references/` | Annotated bibliography notes |
| `notes/` | Research notes and brainstorming |
| `scripts/` | Build utilities (`render.sh`) |
| `handoffs/` | Session handoff reports (`YYYYMMDD_HHMM.md`) |
| `legacy/` | Archived old files (never deleted, always moved here) |
| `_manuscript/` | Rendered outputs: HTML, PDF, Word, LLM markdown, notebook previews |

### Root-Level Files

| File | Purpose |
| ---- | ------- |
| `index.qmd` | Main manuscript source |
| `_quarto.yml` | Quarto config (formats, notebooks, theme: `cosmo`, highlight: `github`) |
| `styles.css` | Custom HTML styling (tables, code blocks, notebook layout) |
| `references.bib` | BibTeX bibliography (from Zotero) |
| `pyproject.toml` | Python dependencies (includes `pyfixest`, `nbstata`) |
| `uv.lock` | Locked dependency versions (auto-generated) |
| `.python-version` | Pins Python to 3.12 |
| `.gitignore` | Git ignore rules |
| `.env` | API keys and secrets (**gitignored**) |
| `CLAUDE.md` | Instructions for Claude Code AI assistant |

---

## Customizing This Template

After cloning for a new project:

1. **`README.md`** — Replace all `[FILL:]` placeholders
2. **`index.qmd`** — Set title, authors, abstract, keywords
3. **`pyproject.toml`** — Update `name`, `description`, `authors`
4. **`CLAUDE.md`** — Fill in the Project Context table
5. **`_quarto.yml`** — Update notebook titles as you add new notebooks

Search for remaining placeholders:

```bash
grep -r "\[FILL:" --include="*.md" --include="*.qmd" --include="*.toml" .
```

### Theme and Styling

The HTML output uses the `cosmo` Bootstrap theme with `github` syntax highlighting. To change:

```yaml
# In _quarto.yml
format:
  html:
    theme: cosmo              # Try: flatly, journal, lux, simplex
    highlight-style: github    # Try: atom-one, dracula, nord, monokai
    css: styles.css            # Custom table and code block styling
```

---

## Workflow with Claude Code

This template includes [Claude Code](https://claude.com/claude-code) integration with 27 agentic skills. Type `/project:<name>` to invoke any skill.

Skills are defined in [`.claude/skills/`](.claude/skills/). Each has a `SKILL.md` with instructions and YAML frontmatter.

### Available Skills

#### Build and Execution

| Skill | Description |
| ----- | ----------- |
| `/project:render` | Runs the full render pipeline (HTML, PDF, Word) via `scripts/render.sh` — cleans caches, two-pass Quarto render, LLM markdown generation, Overleaf staging, and GitHub Pages deploy. |
| `/project:execute` | Re-runs all registered notebooks via Quarto render to refresh their cached outputs in `_freeze/`. Reports per-notebook status, timing, and errors. |
| `/project:init` | One-time project setup. Fills all `[FILL:]` placeholders across the template (title, authors, data sources) to initialize a freshly cloned project. |
| `/project:sync-tex` | Transfers prose edits made in the LaTeX source (`latex/index.tex`, e.g. from Overleaf) back into `index.qmd`, preserving embed/include shortcodes. |

#### Notebook and Presentation Creation

| Skill | Description |
| ----- | ----------- |
| `/project:new-notebook` | Creates a new Quarto notebook (`.qmd`) with the project's standard structure (data import, EDA, regressions) and registers it in `_quarto.yml`. |
| `/project:new-analysis` | Scaffolds a method-specific analysis notebook (DiD, IV, RDD, LASSO, Panel FE) with econometric boilerplate, diagnostics, and language-specific package guidance. |
| `/project:new-slide-deck` | Creates a Quarto revealjs slide deck in `slides/` following the project style guide. |
| `/project:econ-visualization` | Generates publication-quality economics figures (coefficient plots, event studies, RD plots, time series, scatter, distributions, bar charts, heatmaps) with colorblind-safe palettes and journal-ready styling. |

#### Writing and Results

| Skill | Description |
| ----- | ----------- |
| `/project:draft-section` | Drafts academic prose for any manuscript section (Introduction, Data, Results, Conclusion) from bullet points or an outline, integrating citations from `references.bib`. |
| `/project:abstract` | Reads the full manuscript and notebooks to generate a structured abstract (Motivation, Data, Results, Contribution) targeting a specified word count. |
| `/project:interpret-results` | Writes manuscript-ready prose interpreting regression output — covers statistical significance, economic magnitude, cross-specification comparisons, and uses appropriate hedging language. |
| `/project:regression-table` | Formats estimation output as a publication-quality regression table with significance stars, clustered SEs in parentheses, fixed-effects indicators, and fit statistics. Exports to CSV, Markdown, and LaTeX. |
| `/project:robustness-table` | Generates robustness check code (alternative samples, controls, specifications) and formats all results as a combined multi-column table. |
| `/project:referee-response` | Drafts a point-by-point response letter to referee comments, mapping each concern to specific manuscript locations and suggesting concrete edits. |

#### Research and Literature

| Skill | Description |
| ----- | ----------- |
| `/project:cite` | Finds a paper by title, author, or DOI; adds its BibTeX entry to `references.bib`; and shows the `@citekey` syntax for use in `index.qmd`. |
| `/project:literature-note` | Creates a structured annotation note in `references/` with sections for research question, identification strategy, data, findings, limitations, and connections to other project notes. |
| `/project:lit-review` | Conducts a structured literature review: designs a search strategy, builds a paper inventory, synthesizes findings thematically, and identifies gaps. Integrates with `/project:cite` and `/project:literature-note`. |
| `/project:research-ideation` | Generates research questions from an observation or phenomenon using four frameworks (Puzzle, Policy, Data, Extension) and evaluates them on data availability, identification credibility, novelty, and policy relevance. |
| `/project:codebook` | Auto-generates a Markdown codebook from a dataset file (CSV, DTA, Excel, Parquet) with variable names, types, and summary statistics. |

#### Quality Checks and Audits

| Skill | Description |
| ----- | ----------- |
| `/project:submission-prep` | Runs comprehensive pre-submission checks — word count, anonymization, citation completeness, placeholder detection, cross-reference validation — and generates a checklist. |
| `/project:bib-check` | Cross-checks citation keys used in `index.qmd` against `references.bib`, reporting missing, orphaned, and duplicate entries. |
| `/project:freeze-check` | Checks whether registered notebooks have current, stale, or missing cached outputs in `_freeze/`. Useful before rendering. |
| `/project:data-audit` | Scans all notebooks for data file references (Python, R, Stata patterns) and verifies each referenced file exists on disk. Reports broken paths and undocumented files. |
| `/project:check-env` | Verifies that required tools (Quarto, uv, Python, R, Stata, TeX) and Jupyter kernels are installed and reports their versions. |
| `/project:figures-gallery` | Generates an HTML gallery page of all project figures (from `images/` and notebook cells) with captions, source notebooks, and embed shortcodes. |

#### Session Management

| Skill | Description |
| ----- | ----------- |
| `/project:handoff` | Writes a session handoff report to `handoffs/` documenting project state, work completed, decisions made, and next steps. |
| `/project:env-snapshot` | Captures tool versions, Python/R packages, and kernel info as a timestamped reproducibility record in `notes/`. |

### Session Continuity

Handoff reports in `handoffs/` preserve context across sessions. Each report includes the project state, work completed, decisions made, and next steps. Claude reads the most recent handoff at the start of every session.
