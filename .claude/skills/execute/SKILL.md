---
name: execute
description: Executes all registered notebooks via Quarto render. Use when asked to re-run notebooks or refresh outputs.
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Execute All Notebooks

Render all registered notebooks to refresh their outputs.

## Steps

1. Read `_quarto.yml` and extract all notebook paths from `manuscript.notebooks`
2. For each notebook, render it:
   ```bash
   quarto render notebooks/<name>.qmd
   ```
   Record execution time and success/failure for each notebook.
3. Report a summary table:
   - Notebook name
   - Status (success / failure)
   - Execution time
   - Any errors or warnings

## Error handling

- If a notebook fails to render, continue with the remaining notebooks. Report the error at the end.
- If `_quarto.yml` has no notebooks registered, report "No notebooks found in _quarto.yml" and stop.
