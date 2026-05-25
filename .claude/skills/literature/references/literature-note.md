> **Reference doc** for a consolidated pipeline skill. Source: `literature-note`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Create Literature Note

Create a structured annotation note for a paper in `references/`.

## Arguments

- `$ARGUMENTS` — a citation key from `references.bib`, a DOI, or a paper description (e.g., "acemoglu2001colonial" or "Acemoglu 2001 colonial origins")

## Steps

1. Parse the argument:
   - If it matches an existing key in `references.bib`, use that entry's metadata
   - If it is a DOI or description, search for the paper and optionally add it to `references.bib` first (offer to run the `/project:cite` workflow)

2. If a URL or DOI is provided, attempt to fetch and read the paper to extract key information.

3. Create a Markdown file in `references/` named `<citation-key>.md` with this structure:

   ```markdown
   # <Author (Year)> — <Short Title>

   **Citation key:** `<key>`
   **Full reference:** <formatted reference>

   ## Research Question

   [What question does this paper address?]

   ## Identification Strategy

   [How do the authors establish causality? What is the main source of variation?]

   ## Data and Sample

   [What data do they use? What is the sample period, unit of observation, and sample size?]

   ## Key Findings

   - [Finding 1]
   - [Finding 2]
   - [Finding 3]

   ## Methodology Notes

   [Econometric methods, estimators, robustness checks worth noting]

   ## Relevance to This Project

   [How does this paper relate to the current research? What can we build on or contrast with?]

   ## Limitations and Critiques

   [What are the paper's acknowledged limitations? What critiques have others raised? What questions remain unanswered?]

   ## Citation Network

   - **Builds on:** [Key papers this work extends or responds to]
   - **Cited by:** [Notable subsequent papers that cite this work]
   - **Related:** [Papers using similar methods on different questions, or the same question with different methods]
   ```

4. If information about the paper was retrieved (from the web or a PDF), pre-fill the sections with extracted content. Otherwise, leave the bracket placeholders for the user to fill in.

5. **Cross-reference with existing notes:** After creating the note, scan `references/` for other literature notes and identify connections — shared methods, overlapping datasets, complementary or contradictory findings. Append a "Connections" subsection listing related notes in the project:
   ```markdown
   ## Connections to Other Notes

   - [`<key1>.md`](key1.md) — uses same dataset / complementary identification strategy
   - [`<key2>.md`](key2.md) — contradicts finding on X; uses different sample period
   ```

6. Report the file path and remind the user to fill in any remaining placeholder sections.

## Error handling

- If the citation key is not found in `references.bib` and cannot be resolved, ask the user for more details.
- If `references/<key>.md` already exists, show the existing note and ask if the user wants to update it.

## Common Pitfalls

- **Summarizing without evaluating:** A literature note should critically assess the paper's contribution, not just describe it. Note strengths and weaknesses of the identification strategy.
- **Missing the identification strategy:** For empirical papers, this is the most important section. Always identify the source of exogenous variation and whether it is credible.
- **Not connecting to the current project:** Every note should explicitly state how the paper relates to your research — even if the connection is "this paper studies a different context but uses a method we should consider."
- **Ignoring recent contradictions:** Check whether more recent papers have challenged the findings or proposed better methods for the same question.
