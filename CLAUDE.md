# CLAUDE.md -- AI Assistant Instructions

> **Template:** project20XXy -- a reusable research project template.
> Clone this repo for each new research project and fill in the `[FILL: ...]` placeholders below.

## Quick Start

**Your role:** Research assistant and workflow orchestrator for an academic research project.

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
| **Reference manager** | Mendeley (exports to `.bib`) |
| **Manuscript** | `index.qmd` (Quarto manuscript project) |
| **Environment** | `uv` + `pyproject.toml` (Python 3.12) |
| **Data source** | `[FILL: e.g., OSF repository, survey, API]` |

---

## Critical Rules

These are non-negotiable behavioral constraints.

### 1. Never delete data or code

Do not delete any files in `data/`, `code/`, `notebooks/`, `references/`, or `templates/`.
When replacing files, rename the old version or move it to `legacy/`.

### 2. Stay within this directory

All work must remain inside this project folder. Never navigate above the project root.
If you need external resources, ask for permission first.

### 3. Do not overwrite workflows without permission

Files in `workflows/` are curated SOPs. You may update them when you learn something new,
but never delete or replace a workflow without explicit approval.

### 4. Preserve raw data

Files in `data/rawData/` are source-of-truth inputs. Never modify them.
All transformations should produce new files in `data/` or other directories.

### 5. Document progress via handoff reports

Write a handoff report to `./handoffs/` after completing significant work,
before ending a session, or when context is building up. See **Session Management** below.

---

## Directory Structure

| Directory | Purpose |
| --------- | ------- |
| `code/` | Analysis scripts (R, Python, Stata) |
| `data/` | Processed datasets |
| `data/rawData/` | Raw, unmodified source data (never edit these) |
| `handoffs/` | Session handoff reports for cross-session continuity |
| `ideas/` | Research ideas and brainstorming notes |
| `images/` | Figures, plots, and visual outputs |
| `legacy/` | Archived materials from previous versions |
| `notebooks/` | Jupyter notebooks (`.ipynb` + `.md` pairs via Jupytext) |
| `notes/` | Research notes |
| `references/` | Bibliography files (`.bib`), annotated bibliographies |
| `slides/` | Quarto presentations (see `slides/README.md` for style guide) |
| `tables/` | Output tables (LaTeX, CSV, or other formats) |
| `scripts/` | Build and utility scripts (`render.sh`) |
| `templates/` | LaTeX manuscript template (`chadManuscript/`, alternative) |
| `tools/` | Python scripts for deterministic task execution |
| `workflows/` | Markdown SOPs defining procedures |
| `.github/` | GitHub agents, prompts, and skills |

**Key files:**

- `index.qmd` -- Main manuscript source (Quarto)
- `_quarto.yml` -- Quarto project configuration
- `references.bib` -- Bibliography
- `pyproject.toml` -- Python dependencies (managed by `uv`)
- `config.py` / `config.R` -- Reproducibility config (seeds, paths)
- `jupytext.toml` -- Notebook pairing configuration
- `.python-version` -- Python version pin (3.12)
- `.env` -- API keys and secrets (gitignored, never commit)

---

## WAT Framework

This project uses the **WAT architecture** (Workflows, Agents, Tools) to separate reasoning from execution.

- **Workflows** (`workflows/`): Markdown SOPs that define objectives, inputs, tools, outputs, and edge cases
- **Agents** (you): Read workflows, orchestrate tool execution, handle errors, ask when uncertain
- **Tools** (`tools/`): Deterministic Python scripts for API calls, data transforms, file operations

### Operating Principles

1. **Check for existing tools first.** Before writing new code, look in `tools/` for something that already does what you need. Only create new scripts when nothing exists for the task.

2. **Follow the workflow.** If a workflow exists for your task in `workflows/`, follow it. If no workflow exists, proceed with your best judgment and document what you did.

3. **Fix and document failures.** When a tool fails: read the full error, fix the script, verify the fix, then update the workflow with what you learned. If the tool uses paid API calls, ask before re-running.

4. **Improve the system.** When you discover better methods or encounter recurring issues, update the relevant workflow. But never delete or replace a workflow without permission (Rule 3).

### Credentials

API keys and secrets live in `.env`. Never store secrets anywhere else. Never commit `.env` or credential files to git.

---

## Session Management

### Starting a Session

1. Read this `CLAUDE.md`
2. Read the most recent file in `./handoffs/`
3. Confirm understanding of current state before proceeding

### Writing Handoff Reports

Create a file in `./handoffs/` named `YYYYMMDD_HHMM.md` whenever you:

- Complete significant work
- Are about to end a session
- Make major decisions that need to be preserved
- Accumulate context that would be lost on session reset

**Include in every handoff:**

- Current project state (one paragraph)
- Work completed this session (bullet list with key results)
- Decisions made and their rationale
- Open issues or blockers
- Concrete next steps

### Ending a Session

1. Write a handoff report
2. Verify all outputs are saved
3. Summarize next steps for the user

---

## Academic Workflow

### Manuscript

- Source: `index.qmd` (Quarto manuscript project type)
- Config: `_quarto.yml` defines output formats and notebook registration
- Outputs: HTML (interactive), PDF (letter, KOMA-Script), Word
- Render all: `quarto render` or `bash scripts/render.sh` (clean render)
- Render one format: `quarto render index.qmd --to html|pdf|docx`
- Alternative LaTeX template available in `templates/chadManuscript/`

### Notebooks

- Location: `notebooks/` (Python, R, or Stata kernels)
- Each `.ipynb` is paired with a `.md:myst` file via **Jupytext** (for version control)
- Sync: `uv run jupytext --sync notebooks/<file>.md`
- Labeled outputs (e.g., `#| label: fig-sample`) are embedded in the manuscript via `{{< embed >}}`
- Register new notebooks in `_quarto.yml` under `manuscript.notebooks`
- See `notebooks/README.md` for conventions

### Environment

- Setup: `uv sync` (creates `.venv/` with locked dependencies)
- Run commands: `uv run jupyter notebook`, `uv run python script.py`
- Add packages: `uv add <package>` (updates `pyproject.toml` and lockfile)
- Python version pinned in `.python-version` (3.12)
- Reproducibility seeds: `config.py` (Python) and `config.R` (R), seed = 42

### References

- Managed via **Mendeley** (see `notes/README.md`)
- Exported to `.bib` format: `references.bib` (root) and `references/`
- In Quarto, cite with `@key` for inline or `[@key]` for parenthetical

### Presentations

- Built with **Quarto** (revealjs format) in `slides/`
- See `slides/README.md` for style guide and conventions

### Figures and Tables

- Figures saved to `images/`, tables saved to `tables/`
- Use descriptive filenames: `fig01-variable-trend.png`, `tab01-summary-stats.csv`
