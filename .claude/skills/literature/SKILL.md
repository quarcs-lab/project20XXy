---
name: literature
description: Manage the project's literature workflow — ideate research questions, run structured literature reviews, add citations to references.bib, write annotation notes in references/, and audit citation integrity. Use for any bibliography or literature task.
argument-hint: "<mode> <args> — mode: ideate | review | cite | note | check"
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
version: 2.0.0
workflow_stage: writing
tags:
  - literature
  - citations
  - bibliography
  - BibTeX
  - literature-review
  - ideation
  - quality-check
---

# Literature: ideation, reviews, citations, notes, integrity checks

Consolidated literature/bibliography entry point. A thin dispatcher on the first
argument; the detailed procedure for each mode lives in `references/`. This skill
carries `WebSearch` + `WebFetch` because several modes look papers up online.

## Modes

| Mode | Reads | Does |
| ---- | ----- | ---- |
| `ideate` | `references/research-ideation.md` | Generate research questions via four frameworks (Puzzle/Policy/Data/Extension) → `notes/ideation-<slug>.md` |
| `review` | `references/lit-review.md` | Structured literature review (search strategy, synthesis, gaps) → `references/lit-review-<slug>.md` |
| `cite` | `references/citation-management.md` | Find a paper, add BibTeX to `references.bib`, show citation syntax |
| `note` | `references/literature-note.md` | Write a structured annotation note → `references/<key>.md` |
| `check` | `references/citation-management.md` | Cross-check `index.qmd` `@keys` vs `references.bib` (missing/orphaned/duplicate) — formerly `bib-check` |

## Procedure

1. Parse the first token as the mode and read the matching `references/*.md`.
2. Follow that reference doc. Modes chain internally: after `cite`, offer `note`;
   after `review`, offer `cite`/`note` for newly surfaced papers.
3. Never fabricate BibTeX or DOIs — verify via WebSearch/WebFetch; if a source
   cannot be confirmed, say so and leave a `[CITE: ...]` placeholder for the prose.

## Follow-up

Offer `/project:write` to fold citations into prose, or
`/project:review manuscript` for a full citation-integrity audit.
