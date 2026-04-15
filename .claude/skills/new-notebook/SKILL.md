---
name: new-notebook
description: Creates a Quarto notebook (.qmd) and registers it in _quarto.yml. Use when adding a new notebook.
argument-hint: <name> <title>
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Create New Notebook

Create a new Quarto notebook (`.qmd`) and register it in the manuscript.

## Arguments

- `$ARGUMENTS` — the notebook name and title (e.g., "notebook-02 Regression Analysis")

## Steps

1. Parse the name and title from the arguments. Follow the naming convention: `notebook-NN.qmd` (sequential numbering)
2. Check `notebooks/` for existing notebooks to determine the next number
3. Create the `.qmd` file in `notebooks/` with:
   - YAML frontmatter specifying `title` and `jupyter` kernel (ask user: Python → `python3`, R → `ir`, Stata → `nbstata`)
   - A first code cell with the setup appropriate for the chosen kernel:
     - **Python:** `import sys; sys.path.insert(0, ".."); from config import set_seeds, DATA_DIR; set_seeds()`
     - **R:** `source("../config.R"); set_seeds()`
     - **Stata:** `clear all` followed by `set seed 42`
   - A markdown section with the notebook title and overview
4. Register the notebook in `_quarto.yml` under `manuscript.notebooks`:
   ```yaml
   - notebook: notebooks/<name>.qmd
     title: "N<number>: <title>"
   ```
5. Confirm the notebook renders: `quarto render notebooks/<name>.qmd`
