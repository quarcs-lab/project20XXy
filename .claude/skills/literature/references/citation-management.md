> **Reference doc** for a consolidated pipeline skill. Sources: `cite` + `bib-check`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Add Citation

Find a paper, create a BibTeX entry, add it to `references.bib`, and provide the citation syntax.

## Arguments

- `$ARGUMENTS` — a paper description, title, author name, or DOI (e.g., "Acemoglu 2001 colonial origins" or "10.1257/aer.91.5.1369")

## Steps

1. Parse the argument to determine if it is a DOI or a descriptive search query.

2. Search for the paper:
   - If a DOI is provided, fetch the metadata directly (use web search or CrossRef)
   - If a description is provided, search the web to identify the paper and its DOI/metadata

3. Construct a valid BibTeX entry with these fields (at minimum):
   - `@article{key,` (or `@book`, `@incollection`, etc. as appropriate)
   - `author`, `title`, `journal` (or `booktitle`), `year`, `volume`, `number`, `pages`, `doi`
   - Use a citation key in the format: `lastname_yearword` (e.g., `acemoglu2001colonial`)

4. Read `references.bib` and check for duplicate keys:
   - If the exact key already exists, inform the user and show the existing entry
   - If a similar key exists (same author and year), warn the user

5. Append the new entry to `references.bib` (add a blank line before the new entry)

6. Show the user the citation syntax for use in `index.qmd`:
   - Narrative: `@key` → "Author (Year)"
   - Parenthetical: `[@key]` → "(Author, Year)"
   - Multiple: `[@key1; @key2]`

7. Ask if the user wants to create an annotation note in `references/` (see `/project:literature-note`)

## Error handling

- If the paper cannot be found, report the search results and ask the user to provide more details or a DOI.
- If `references.bib` does not exist, create it with the new entry.

---


# Audit Citations and References

Cross-check all citation keys in the manuscript against `references.bib` and report mismatches.

## Steps

1. Read `index.qmd` and extract every citation key:
   - Narrative citations: `@key`
   - Parenthetical citations: `[@key]`, `[@key1; @key2]`
   - Ignore email addresses and `@sec-`, `@fig-`, `@tbl-` cross-references

2. Read `references.bib` and extract every entry key (the identifier after `@article{`, `@book{`, etc.)

3. Check for duplicate keys within `references.bib` (same key defined more than once)

4. Report three categories:

   **Errors — cited in manuscript but missing from `.bib`:**
   - List each missing key with the line number in `index.qmd` where it appears
   - For each, suggest running `/project:cite <key>` to add the entry

   **Orphaned — in `.bib` but never cited in manuscript:**
   - List each unused key (informational, not necessarily a problem)

   **Duplicates — same key appears multiple times in `.bib`:**
   - List each duplicate with line numbers in `references.bib`

5. Print a summary: total cited keys, total `.bib` entries, errors, orphaned, duplicates

## Error handling

- If `references.bib` does not exist, report the error and stop.
- If `index.qmd` contains no citations, report "No citations found" and stop.
