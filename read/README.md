# Read — reference papers & replication kits

Full-text reference materials: the PDFs you are reading and any replication
kits (data + `.do`/`.R`/`.qmd` code) that ship with a paper.

**Suggested layout:** one subfolder per paper, named `Author-Year-Short-Title/`.

## How this differs from other reference locations

| Location | Holds |
| -------- | ----- |
| `read/` (this folder) | Source PDFs and downloaded replication kits |
| `references.bib` (root) | Active BibTeX entries (exported from Zotero) |
| `references/` | Your own annotated reading notes (Markdown, via `/project:literature note`) |

This folder is **not** part of the rendered manuscript (excluded in
`_quarto.yml`).

**Git policy (default):** reference PDFs/kits are committed so the project is
self-contained and reproducible. If your reference PDFs are large and you
prefer a lean repo, add the following to `.gitignore` instead:

```gitignore
read/**/*.pdf
!read/README.md
```

[FILL: list the reference papers stored here once you add them.]
