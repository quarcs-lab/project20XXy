---
name: lit-review
description: Conducts a structured literature review with search strategy, synthesis, and gap identification. Use when surveying a research area.
argument-hint: "<research question or topic>"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
version: 1.0.0
workflow_stage: writing
tags:
  - literature-review
  - synthesis
  - citations
  - research-gaps
---

# Structured Literature Review

Conduct a systematic literature review: define scope, design search strategy, build a paper inventory, synthesize findings, and identify research gaps.

## Arguments

- `$ARGUMENTS` — a research question or topic to survey (e.g., "convergence in regional GDP per capita", "effects of trade liberalization on inequality", "spatial spillovers in economic growth")

## Steps

1. Parse the research question or topic from the arguments.

2. **Define scope.** Ask the user to clarify:
   - Subfield and disciplinary boundaries (e.g., growth economics, trade, labor)
   - Time frame for included papers (e.g., 2000–present, or seminal papers from any era)
   - Key journals to prioritize (e.g., AER, QJE, ReStud, JDE, WBER)
   - Seed papers — 2–3 known papers to anchor the search
   - Inclusion/exclusion criteria (e.g., empirical only, specific methods, specific geographies)

3. **Design search strategy.** Generate structured search strings for:
   - **Google Scholar:** combine key terms with Boolean operators (`"economic convergence" AND "panel data" AND (regional OR subnational)`)
   - **NBER Working Papers:** topic-based search for recent unpublished work
   - **EconLit / IDEAS/RePEc:** JEL code filters (e.g., O47 for economic growth, F14 for trade)
   - Document all search queries used — the strategy must be replicable

4. **Build paper inventory.** For each paper found, record a row in a summary table:

   | # | Authors (Year) | Journal | Method | Key Finding | Relevance (1–5) |
   |---|----------------|---------|--------|-------------|-----------------|

   Prioritize papers with relevance score >= 3. Aim for 15–30 papers for a focused review, 50+ for a comprehensive survey.

5. **Synthesize.** Group papers by theme and identify:
   - **Consensus findings:** What does the weight of evidence support?
   - **Contested findings:** Where do papers disagree, and why? (different samples, methods, time periods)
   - **Methodological evolution:** How have methods improved over time? (e.g., from OLS to DiD to staggered DiD)
   - **Geographic/temporal gaps:** Which regions, countries, or time periods are understudied?

6. **Generate output.** Save to `references/lit-review-<topic-slug>.md` with this structure:

   ```markdown
   # Literature Review: <Topic>

   **Date:** YYYY-MM-DD
   **Scope:** <subfield, time frame, criteria>

   ## Search Strategy

   - Google Scholar: `<query>`
   - NBER: `<query>`
   - EconLit JEL codes: `<codes>`
   - Seed papers: <list>

   ## Paper Inventory

   | # | Authors (Year) | Journal | Method | Key Finding | Relevance |
   |---|----------------|---------|--------|-------------|-----------|

   ## Synthesis by Theme

   ### Theme 1: <name>
   <discussion of findings, agreements, disagreements>

   ### Theme 2: <name>
   ...

   ## Identified Gaps

   - <gap 1>
   - <gap 2>

   ## Implications for This Project

   <how the review informs the current research — which methods to use, which gaps to fill, how to position the contribution>
   ```

7. **Integration with other skills.** For each high-relevance paper (score >= 4):
   - Offer to run `/project:cite` to add it to `references.bib`
   - Offer to run `/project:literature-note` to create a detailed annotation

## Error handling

- If the topic is too broad (e.g., "economics"), ask the user to narrow the scope.
- If no seed papers are provided, suggest 2–3 seminal papers based on the topic and ask for confirmation.

## Common Pitfalls

- **Confirmation bias:** Actively search for papers that contradict the expected finding — a review that only cites supporting evidence is incomplete
- **Ignoring working papers:** Recent NBER/CEPR/IZA working papers often contain the most current methods and findings; don't rely solely on published articles
- **Not documenting the search strategy:** Without documented queries, the review is not replicable. Record every search string and database used.
- **Selective citation:** Don't cherry-pick one estimate from a paper that reports many — note the range of results
- **Missing methodological context:** When comparing findings across papers, note differences in identification strategy, sample, and time period that explain divergent results
