---
name: freeze-check
description: Checks whether registered notebooks have current, stale, or missing outputs. Use before rendering or to verify freshness.
allowed-tools: Bash, Read, Glob, Grep
---

# Check Notebook Execution Freshness

Verify that all registered notebooks have been executed and their outputs are current.

## Steps

1. Read `_quarto.yml` and extract all notebook paths from `manuscript.notebooks`.

2. For each registered notebook, check:
   - **Last modified:** File modification timestamp of the `.qmd`
   - **Freeze cache:** Check if `_freeze/notebooks/<name>/` directory exists and contains cached output
   - **Cache freshness:** Compare `.qmd` modification time against `_freeze/` cache timestamps

3. Determine freshness status for each notebook:
   - **Current:** freeze cache exists and `.qmd` has not been modified since cache was generated
   - **Stale:** freeze cache exists but `.qmd` has been modified more recently
   - **Unexecuted:** no freeze cache exists
   - **No cache dir:** `_freeze/` directory does not exist at all

4. Report a summary table:

   ```
   Notebook              Freeze Cache   Last Modified        Status
   ─────────────────────────────────────────────────────────────────
   notebook-01.qmd       Yes            2026-02-28 14:30     Current
   notebook-02.qmd       Yes            2026-03-01 09:15     Stale
   notebook-03.qmd       No             2026-02-25 11:00     Unexecuted
   ```

5. If any notebooks are stale or unexecuted, flag them and offer to run `/project:execute` to re-execute all notebooks.

6. If all notebooks are current, report "All notebooks are up to date."

## Error handling

- If `_quarto.yml` has no notebooks registered, report "No notebooks found in _quarto.yml" and stop.
- If a registered notebook file does not exist on disk, flag it as missing.
