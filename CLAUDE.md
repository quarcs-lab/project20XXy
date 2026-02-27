# CLAUDE.md -- AI Assistant Instructions

> **Template:** project20XXy -- a reusable research project template.
> Clone this repo for each new research project and fill in the `[FILL: ...]` placeholders below.
> For full documentation, see `README.md`.

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
| **Reference manager** | Zotero (exports to `references.bib`) |
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

### 3. Preserve raw data

Files in `data/rawData/` are source-of-truth inputs. Never modify them.
All transformations should produce new files in `data/` or other directories.

### 4. Document progress via handoff reports

Write a handoff report to `./handoffs/` after completing significant work,
before ending a session, or when context is building up. See **Session Management** below.

---

## Key Paths

The full directory structure and root-level files are documented in `README.md` under **Project Structure**. The most frequently referenced paths:

- `index.qmd` -- Main manuscript source
- `_quarto.yml` -- Quarto project config (output formats, notebook registrations)
- `references.bib` -- Bibliography (exported from Zotero)
- `config.py` / `config.R` -- Reproducibility config (seed = 42, project paths)
- `notebooks/` -- Jupyter notebooks (`.ipynb` + `.md:myst` pairs via Jupytext)
- `data/rawData/` -- Raw source data (never modify)
- `handoffs/` -- Session handoff reports
- `.env` -- API keys and secrets (gitignored, never commit)

---

## Claude Commands

Reusable procedures are defined as slash commands in `.claude/commands/`.

| Command | Purpose |
| ------- | ------- |
| `/project:render` | Clean render of the manuscript (HTML + PDF + Word) |
| `/project:new-notebook` | Create a new notebook with Jupytext pairing and register it |
| `/project:handoff` | Write a session handoff report |
| `/project:sync-tex` | Transfer collaborator LaTeX edits (Overleaf) back into `index.qmd` |

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

## Common Commands

```bash
# Render manuscript (all formats)
quarto render
bash scripts/render.sh              # clean render + Overleaf staging

# Render single format
quarto render index.qmd --to html   # or pdf, docx

# Execute a notebook (--inplace is REQUIRED)
uv run jupyter execute --inplace notebooks/<file>.ipynb

# Sync Jupytext pairs
uv run jupytext --sync notebooks/<file>.md

# Python packages (NEVER use pip install)
uv add <package>                    # adds to pyproject.toml + uv.lock
uv sync                             # reinstall from lockfile

# Run commands in project environment
uv run jupyter notebook
uv run python script.py
```

---

## Workflow Gotchas

These are non-obvious pitfalls. See `README.md` for full workflow documentation.

**Notebooks:**

- `--inplace` is required for `jupyter execute` — without it, outputs are discarded
- Register new notebooks in `_quarto.yml` under `manuscript.notebooks`
- Labeled outputs are embedded in the manuscript via `{{< embed >}}`

**Cell directives by language:**

- Python / R: `#| label: fig-name` (hash-pipe prefix)
- Stata: `*| label: fig-name` (star-pipe prefix, since `*` is Stata's comment character)

**Stata-specific:**

- Use **nbstata** kernel (not the legacy `stata_kernel`)
- Do NOT use the `tbl-` label prefix for Stata cells with text output — it triggers Quarto's table parser and crashes. Use a plain label instead (e.g., `stata-summary`)

**Python packages:**

- NEVER use `pip install` — it bypasses the lockfile. Always use `uv add`
- All `uv`-installed packages are available in `.venv/`, which the Jupyter kernel uses

**Overleaf sync constraints:**

- Only **prose edits** are transferred; `{{< embed >}}` shortcodes are preserved as-is
- Figure/table captions live in notebook cells and cannot be synced back from LaTeX
- The preamble (before `\begin{document}`) is auto-generated — collaborator edits there are ignored
- `latex/.baseline.tex` is gitignored (local-only diffing artifact)

**References:**

- Cite with `@key` for inline or `[@key]` for parenthetical
- Annotation notes go in `references/` (Markdown format)

**Credentials:**

- API keys and secrets live in `.env`. Never store secrets anywhere else. Never commit `.env` or credential files to git.
