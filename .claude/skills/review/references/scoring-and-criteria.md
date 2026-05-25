# Scoring, Severity, and Report Format for Manuscript Reviews

> Part of the `review` skill. Read at the start of the audit (for calibration)
> and during report generation (for scoring + layout). Adapted from
> `example_project2025b`'s `scoring-and-criteria.md`, retuned for a Quarto
> manuscript template.

## Severity definitions

| Level | Meaning |
| ----- | ------- |
| **HIGH** | Blocks a correct build or submission: an embedded notebook is Stale/Unexecuted, a data path is Broken, a `{{< embed >}}`/`{{< include >}}` target is missing, or a cited `@key` is absent from `references.bib`. Must fix before rendering/submitting. |
| **MEDIUM** | Builds but is not submission-clean: orphaned/duplicate bib entries, `[FILL:]`/`[CITE:]` placeholders in body prose, dangling cross-references, or an identity leak in a double-blind submission. Should fix. |
| **LOW** | Style/polish: word count near a limit, undocumented (but resolvable) data paths, minor formatting. Nice to fix. |

## Verdict criteria

| Verdict | Criteria |
| ------- | -------- |
| **SUBMISSION-READY** | No HIGH, ≤ 2 MEDIUM. Manuscript builds and is clean. |
| **MINOR REVISION** | No HIGH but 3+ MEDIUM, or 1 easy-to-fix HIGH. Targeted fixes. |
| **MAJOR REVISION** | 2+ HIGH, or any broken data path / missing embed target / unexecuted embedded notebook. Needs rework before submission. |

## Reviewer guidelines

- **Be specific:** cite the exact file + line (`index.qmd:142`) or notebook label.
- **Be actionable:** every issue includes a concrete fix.
- **Read-only:** never edit notebooks, `index.qmd`, data, or config. The saved
  review report is the only file written. Honor CLAUDE.md (no moves/deletes).
- For a freshness HIGH, the fix is usually `/project:execute`; for a citation
  HIGH, `/project:literature cite`.

## Report format

Deliver inline AND save (see SKILL.md Phase 4 for the path):

```
# Manuscript Review: <project title or notebook-slug>

**Scope:** manuscript / notebook <slug>
**Reviewed:** <date>
**Render state:** <_manuscript/ present & fresh / stale / absent>

## Verdict: <SUBMISSION-READY / MINOR REVISION / MAJOR REVISION>

<1–2 sentence rationale>

## Dimension Results
| # | Dimension | Status | Detail |
|---|-----------|--------|--------|
| 1 | Freeze freshness    | PASS/WARN/FAIL | N current, N stale, N unexecuted |
| 2 | Data paths          | PASS/FAIL      | N resolved, N broken, N undocumented |
| 3 | Citations           | PASS/FAIL      | N missing, N orphaned, N duplicate |
| 4 | Figure/table exports| PASS/FAIL      | N embeds OK, N includes OK, N missing |
| 5 | Placeholders        | PASS/WARN      | N [FILL:]/[CITE:] in body |
| 6 | Anonymization       | PASS/WARN      | N potential identity leaks |
| 7 | Cross-references    | PASS/WARN      | N dangling refs |
| 8 | Word count          | INFO           | N words (limit 8000/10000) |

## Issues Found
| # | Dimension | Severity | Location | Issue | Suggested fix |
|---|-----------|----------|----------|-------|---------------|

## Manual Submission Checklist
(from references/submission-checklist.md — items the audit cannot verify)

## Priority Action Items
1. **[HIGH]** <most critical>
2. **[MED]**  <important>
3. **[LOW]**  <nice to have>
```
