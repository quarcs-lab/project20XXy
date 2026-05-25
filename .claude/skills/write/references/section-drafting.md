> **Reference doc** for a consolidated pipeline skill. Source: `draft-section`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Draft Manuscript Section

Draft academic prose for a manuscript section from bullet points or an outline.

## Arguments

- `$ARGUMENTS` — section name and content notes (e.g., "Introduction: regional GDP disparities, panel data from 2000-2020, spatial econometrics, contributes to convergence literature")

## Steps

1. Parse the section name and content bullets/notes from the arguments.

2. Read `index.qmd` to understand:
   - The manuscript's existing tone and writing style
   - What sections already exist and their content
   - Citation conventions used (narrative `@key` vs parenthetical `[@key]`)
   - What figures and tables are embedded (to reference them)

3. Read `references.bib` to know which citations are available for use.

4. Draft 2–5 paragraphs of academic prose:
   - Write in the register of empirical economics journals (AER, QJE, ReStud style)
   - Use formal but accessible language
   - Structure paragraphs logically: general → specific, or claim → evidence → implication
   - Include Quarto cross-references where appropriate (`@sec-`, `@fig-`, `@tbl-`)
   - Insert citations from `references.bib` where they strengthen the argument
   - Where a citation would be helpful but none exists in `.bib`, insert a placeholder: `[CITE: description of needed reference]`

5. Apply section-specific templates depending on the target section:

   - **Introduction:** Hook (relevance or puzzle) → Research question statement → Main result preview (one sentence) → Brief methodology description → Literature positioning (identify 2–3 strands the paper contributes to) → Roadmap paragraph ("The remainder of this paper is organized as follows...")
   - **Data / Empirical Strategy:** Data source and sample construction → Variable definitions → Summary statistics reference → Estimation equation with clear notation → Identification assumptions and threats
   - **Results:** Lead with the main coefficient and its interpretation → Progress from simple to complex specifications → Discuss economic significance alongside statistical significance → Heterogeneity results → Brief robustness summary (point to appendix or robustness section)
   - **Conclusion:** Restate research question and answer → Policy implications → Theoretical implications → Honest limitations → Future research directions. A conclusion should NOT merely summarize — it should interpret.

6. Follow economics writing conventions:
   - Use present tense for established facts and theory; past tense for own empirical analysis ("We find..." → "We found..." or "Column (2) shows...")
   - Use precise causal vs. associational language: "is associated with" for correlations, "causes" or "leads to" only with credible identification
   - Always interpret economic magnitude alongside statistical significance (e.g., "a one standard deviation increase in X is associated with a Y-unit change in the outcome, equivalent to Z% of the sample mean")
   - Lead with results, not methodology
   - Use hedging language: "results suggest", "we find evidence consistent with", "the estimates imply"

7. If the section matches an existing section in `index.qmd` (e.g., "Introduction" matches `## Introduction {#sec-introduction}`):
   - Show how the draft would replace the current `[FILL:]` placeholders or extend existing content
   - Preserve any `{{< embed >}}` shortcodes already in that section

8. Present the draft to the user for review. On approval, insert or replace the content in `index.qmd`.

## Error handling

- If no section name is provided, ask the user which section to draft.
- If the arguments are too vague, ask for more specific content points.

## Common Pitfalls

- Burying the main result deep in the paper — lead with the finding, then build support
- Confusing statistical significance with economic significance — always report magnitudes in interpretable units
- Overclaiming causality without proper identification — match language to research design
- Writing a conclusion that merely summarizes results — a conclusion should add interpretation, implications, and limitations
- Excessive passive voice — prefer active constructions ("We estimate..." over "It is estimated that...")

## References

- Cochrane (2005) "Writing Tips for Ph.D. Students"
- Shapiro (2022) "How to Give an Applied Micro Talk"
- Thomson (2011) "A Guide for the Young Economist"
- Nikolov (2013) "Writing Tips for Economics Research Papers"
