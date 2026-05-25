---
name: write
description: Draft and revise manuscript prose for index.qmd — sections, the abstract, regression-result interpretation, and referee responses. Use when writing or revising the manuscript.
argument-hint: "<mode> <args> — mode: section | abstract | interpret | referee"
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
version: 2.0.0
workflow_stage: writing
tags:
  - manuscript
  - prose
  - writing
  - abstract
  - interpretation
  - referee
  - IMRAD
---

# Write: manuscript prose, abstract, interpretation, referee responses

Consolidated prose-writing entry point. A thin dispatcher on the first argument;
the detailed procedure and templates for each mode live in `references/`.

**What this skill does** — drafts manuscript-ready academic prose and, on
approval, inserts it into `index.qmd` (or saves letters to `notes/`).

## Modes

| Mode | Reads | Does |
| ---- | ----- | ---- |
| `section` | `references/section-drafting.md` | Draft/expand a manuscript section from bullets or an outline |
| `abstract` | `references/abstract-spec.md` | Generate a structured abstract from the manuscript + notebooks |
| `interpret` | `references/interpretation-guide.md` | Write prose interpreting regression output (significance, sign, magnitude, economic meaning) |
| `referee` | `references/referee-response.md` | Draft a point-by-point response letter to referee comments |

## Procedure

1. **Pre-flight (all modes):** read `index.qmd` to match its tone, structure,
   and citation conventions; skim `references.bib` for available `@keys`. Use the
   `[CITE: ...]` placeholder when a needed citation is missing rather than
   inventing one.
2. Parse the first token as the mode and read the matching `references/*.md`.
3. Follow that reference doc to produce the prose. Show the draft for approval
   before editing `index.qmd`; for `referee`, save to
   `notes/referee-response-R<N>.md`.
4. Respect the manuscript's crossref style (`@sec-`, `@fig-`, `@tbl-`) — never
   hard-code numbers that Quarto resolves.

## Follow-up

Offer `/project:tables` for any tables referenced, `/project:literature cite`
to resolve `[CITE: ...]` placeholders, or `/project:review manuscript` to audit.
