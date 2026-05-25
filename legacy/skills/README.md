# Legacy Skills — archived during the 27 → 14 consolidation

On 2026-05-25 the skill set was consolidated from 27 narrow, topic-oriented
skills into **5 pipeline skills + 9 kept infra/utility skills**. The 18 skills
below were absorbed into the pipeline skills and moved here per the never-delete
rule (CLAUDE.md Critical Rule #1). Their detailed bodies now live verbatim in the
corresponding `references/*.md` under `.claude/skills/<pipeline>/references/`.

Nothing here is loaded by Claude Code — `legacy/` is excluded from rendering and
these folders are no longer registered skills. They are kept for provenance.

## Old skill → new home

| Archived skill | Now lives in | Reference doc |
| -------------- | ------------ | ------------- |
| `new-notebook` | `analyze` | `references/notebook-scaffold.md` |
| `new-analysis` | `analyze` | `references/methods-boilerplate.md` |
| `econ-visualization` | `analyze` | `references/figure-conventions.md` |
| `codebook` | `analyze` | `references/codebook-spec.md` |
| `draft-section` | `write` | `references/section-drafting.md` |
| `abstract` | `write` | `references/abstract-spec.md` |
| `interpret-results` | `write` | `references/interpretation-guide.md` |
| `referee-response` | `write` | `references/referee-response.md` |
| `regression-table` | `tables` | `references/regression-table.md` |
| `robustness-table` | `tables` | `references/robustness-table.md` |
| `cite` | `literature` (mode `cite`) | `references/citation-management.md` |
| `bib-check` | `literature` (mode `check`) | `references/citation-management.md` |
| `literature-note` | `literature` (mode `note`) | `references/literature-note.md` |
| `lit-review` | `literature` (mode `review`) | `references/lit-review.md` |
| `research-ideation` | `literature` (mode `ideate`) | `references/research-ideation.md` |
| `data-audit` | `review` | `references/audit-checklist.md` |
| `freeze-check` | `review` | `references/audit-checklist.md` |
| `submission-prep` | `review` | `references/audit-checklist.md` + `references/submission-checklist.md` |

## Kept as standalone skills (not consolidated)

`render`, `execute`, `init`, `sync-tex` (side-effect infra), `check-env`,
`env-snapshot` (setup), `handoff` (session), `figures-gallery` (communication),
and `new-slide-deck` (distinct `slides/` output surface).
