---
name: review
description: Audit a Quarto manuscript or a single notebook — freeze freshness, data-path existence, citation integrity, figure/table export presence, placeholder and anonymization checks. Produces a scored review report under notes/. Read-only — never modifies notebooks, data, or the manuscript.
argument-hint: "[scope] — 'manuscript' (default, full pre-submission audit) or '<notebook-slug>' (single notebook, e.g. notebook-02)"
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Glob, Grep, Write
version: 1.0.0
workflow_stage: quality
tags:
  - quality-check
  - audit
  - submission
  - freshness
  - citations
  - anonymization
---

# Review: scored audit of the manuscript or a notebook

A single thorough, **read-only** audit that produces a scored report with a
verdict, a dimension table, an issues table, and priority action items — modeled
on `example_project2025b`'s review skills. Absorbs the former `data-audit`,
`freeze-check`, and `submission-prep` skills.

**What this skill does:**
- Audits the manuscript (default) or one notebook across the dimensions below.
- Produces a verdict: **SUBMISSION-READY / MINOR REVISION / MAJOR REVISION**.
- Saves the report to the `notes/` audit trail (see `notes/README.md`).

**What this skill does NOT do:**
- Never modifies notebooks, `index.qmd`, data, or config. The **only** file it
  writes is the review report. Honor CLAUDE.md (no deletes, no moves).

## Example invocations

```
/project:review                 # full manuscript pre-submission audit
/project:review manuscript      # same as above
/project:review notebook-02     # audit a single notebook
```

## Phase 1 — Pre-flight

1. Parse the scope: `manuscript` (or empty) → full audit; otherwise treat the arg
   as a notebook slug and confirm `notebooks/<slug>.qmd` exists (stop if not).
2. Read `references/audit-checklist.md` (procedure for every dimension),
   `references/scoring-and-criteria.md` (severity + verdict logic), and
   `references/submission-checklist.md` (manual human-action items).
3. Inventory inputs: `_quarto.yml` (registered notebooks + render config),
   `index.qmd`, `references.bib`, `_freeze/`, `data/`, `images/`, `tables/`.

## Phase 2 — Announce scope (do not wait — read-only)

State what will be audited (manuscript vs `<slug>`) and which dimensions apply.

## Phase 3 — Audit dimensions

Run the dimensions from `references/audit-checklist.md`, recording each issue with
severity, location, and a concrete fix. Notebook scope runs only 1–4; manuscript
scope runs all:

1. **Freeze freshness** — each registered notebook's `.qmd` mtime vs its
   `_freeze/` cache: Current / Stale / Unexecuted.
2. **Data-path existence** — grep notebook load calls, resolve relative to
   `notebooks/`, classify Resolved / Broken / Undocumented against `data/`.
3. **Citation cross-check** — `@key`/`[@key]` in `index.qmd` (ignoring `@sec-`,
   `@fig-`, `@tbl-`, emails) vs `references.bib`: missing / orphaned / duplicate.
4. **Figure/table export presence** — every `{{< embed notebooks/...#fig-* >}}`
   and `{{< include tables/*.md >}}` target exists on disk.
5. **Placeholders** — `[FILL:` and `[CITE:` left in body prose.
6. **Anonymization** — author names, self-citations, identifying acknowledgments,
   repo URLs in the body (HIGH only if the venue is double-blind).
7. **Cross-references** — `@sec-`/`@fig-`/`@tbl-` targets resolve.
8. **Word count** — prose-body word count vs typical 8,000 / 10,000 limits (INFO).

## Phase 4 — Produce report

Use the format in `references/scoring-and-criteria.md` (verdict, dimension table,
issues table, manual submission checklist, priority action items). Deliver inline
**and** save it, creating the parent folder first (`mkdir -p notes/<...>/`):

- Notebook scope → `notes/<slug>/<slug>_review.md`
- Manuscript scope → `notes/manuscript/manuscript_review_<YYYYMMDD>.md`

## Follow-up

Offer to: elaborate on any issue; run `/project:execute` to refresh stale
notebooks; run `/project:literature check` for the authoritative citation pass;
or apply fixes (with explicit go-ahead, since this skill is otherwise read-only).
