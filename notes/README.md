# Notes

Working notes and the per-analysis **audit trail**. This folder is
version-controlled (durable knowledge artifacts) and is **not** part of the
rendered manuscript (excluded in `_quarto.yml`).

## Top-level files

Loose Markdown files, one per topic. Several skills write here:

| File pattern | Produced by | Purpose |
| ------------ | ----------- | ------- |
| `<topic>.md` | you / brainstorming | Free-form research notes and ideas |
| `environment-YYYYMMDD.md` | `/project:env-snapshot` | Reproducibility record (tool/package/kernel versions) |
| `ideation-<slug>.md` | `/project:literature ideate` | Research-question brainstorming |
| `referee-response-R<N>.md` | `/project:write referee` | Point-by-point referee response letter |

Use descriptive filenames: `topic-description.md`.

## Audit trail (one subfolder per analysis slug)

Each analysis gets a slug-named subfolder (the slug maps to a notebook, e.g.
`notes/notebook-01/`). Each subfolder collects the *plan → review → report* trail
for that notebook, mirroring the discipline used in `example_project2025b`.

| File pattern | Produced by | Purpose |
| ------------ | ----------- | ------- |
| `<slug>/<slug>_plan.md` | planning / `/project:analyze` | Approved scope before writing the notebook |
| `<slug>/<slug>_review.md` | `/project:review` | Scored correctness/quality review of the notebook |
| `<slug>/<slug>_results_report.md` | `/project:write interpret` | Results write-up with figures, tables, interpretation |

`/project:review` writes `notes/<slug>/<slug>_review.md` automatically
(manuscript-scope reviews go to `notes/manuscript/manuscript_review_<YYYYMMDD>.md`),
creating the subfolder if it does not exist.
