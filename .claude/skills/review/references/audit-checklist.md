> **Reference doc** for a consolidated pipeline skill. Sources: `data-audit` + `freeze-check` + `submission-prep`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Audit Data References

Scan all notebooks for data file references and verify they exist on disk.

## Steps

1. Scan all `.qmd` files in `notebooks/` for data loading patterns:
   - **Python:** `pd.read_csv(...)`, `pd.read_stata(...)`, `pd.read_excel(...)`, `pd.read_parquet(...)`, `open(...)`, `np.loadtxt(...)`
   - **R:** `read.csv(...)`, `read_csv(...)`, `read.dta(...)`, `haven::read_dta(...)`, `readxl::read_excel(...)`, `load(...)`
   - **Stata:** `use "..."`, `import delimited "..."`, `import excel "..."`, `insheet using "..."`

2. Extract every referenced file path and normalize it:
   - Resolve relative paths from the notebook's directory (`notebooks/`)
   - Resolve relative paths (e.g., `../data/rawData/`) from the notebook directory

3. Check that each referenced file exists in `data/rawData/` or `data/`

4. Scan `data/rawData/` and `data/` for all data files present on disk

5. Report three categories:

   **Resolved — referenced and found:**
   - File path, which notebook references it, line/cell number

   **Broken — referenced but not found:**
   - File path as written in code, which notebook, suggested fix (closest matching file, or note that it may need to be downloaded)

   **Undocumented — on disk but never referenced by any notebook:**
   - File path in `data/rawData/` or `data/` that no notebook loads

6. Print a summary: total references, resolved, broken, undocumented files

## Error handling

- If no notebooks exist, report "No notebooks found" and stop.
- If `data/rawData/` does not exist, warn but continue checking `data/`.

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

---


# Prepare for Submission

Run pre-submission checks and generate a submission checklist for a journal submission.

## Steps

1. **Render the manuscript** if `_manuscript/` does not exist or is stale:
   ```bash
   bash scripts/render.sh
   ```

2. **Word count** — Count words in the prose body of `index.qmd`:
   - Exclude YAML front matter, code blocks, embed shortcodes, and the References section
   - Report: total word count, and breakdown by section
   - Flag if over common limits (8,000 or 10,000 words)

3. **Anonymization check** — Scan `index.qmd` for content that may violate double-blind review:
   - Author names (from the YAML `author` field) appearing in the body text
   - First-person self-citations (e.g., "our previous work", "we showed in Author (Year)")
   - Acknowledgments section content that identifies the authors
   - Repository URLs that reveal author identity
   - Report each finding with line numbers

4. **Citation audit** — Cross-check citations and references:
   - Extract all `@key` and `[@key]` citations from `index.qmd`
   - Extract all keys from `references.bib`
   - Report:
     - Citations used in text but missing from `.bib` (errors)
     - Entries in `.bib` not cited in the manuscript (unused — informational only)

5. **Figures and tables inventory** — List all embedded outputs:
   - Extract all `{{< embed >}}` shortcodes from `index.qmd`
   - For each, check that the referenced notebook and cell label exist
   - Report a table: label, notebook, caption (from cell directive), type (figure/table)

6. **Placeholder check** — Scan for orphan `[FILL:]` placeholders in `index.qmd`:
   ```bash
   grep -n "\[FILL:" index.qmd
   ```
   Report each with line number and context.

7. **Cross-reference check** — Scan for `@sec-`, `@fig-`, `@tbl-` references in `index.qmd` and verify each target exists (section IDs in the document, figure/table labels in notebooks).

8. **Generate submission checklist:**

   ```markdown
   ## Submission Checklist

   - [ ] Word count within journal limit: <count> words
   - [ ] No anonymization issues (or list issues to fix)
   - [ ] All citations resolve to references.bib entries
   - [ ] No orphan [FILL:] placeholders in manuscript
   - [ ] All embedded figures/tables have valid notebook sources
   - [ ] All cross-references resolve
   - [ ] Abstract present and complete
   - [ ] Keywords listed
   - [ ] Acknowledgments section reviewed
   - [ ] Data availability statement included
   - [ ] PDF renders without errors
   - [ ] Figures are high resolution
   - [ ] Supplementary materials prepared (if applicable)
   ```

9. Report the full checklist with pass/fail status for each automated check, and leave manual items unchecked for the user.
