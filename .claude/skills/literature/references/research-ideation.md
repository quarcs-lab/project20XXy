> **Reference doc** for a consolidated pipeline skill. Source: `research-ideation`.
> Migrated during the 27→14 skill consolidation on 2026-05-25; originals archived in `legacy/skills/`.

---


# Research Ideation

Generate and evaluate research questions from an economic phenomenon or observation using four structured frameworks.

## Arguments

- `$ARGUMENTS` — a starting observation, puzzle, or phenomenon (e.g., "regional inequality is increasing despite national convergence", "minimum wage increases didn't reduce employment in recent studies", "new satellite nightlight data is available at high resolution")

## Steps

1. Parse the starting observation or phenomenon from the arguments.

2. Read `index.qmd` and scan `references/` for existing literature notes to understand the project's current research context and what questions have already been explored.

3. Apply four ideation frameworks to generate candidate research questions:

   ### Framework 1: Puzzle Approach
   - What contradicts existing theory or prior empirical findings?
   - What stylized fact lacks a satisfying explanation?
   - What anomaly appears in the data that current models cannot account for?
   - Generate 2–3 candidate questions.

   ### Framework 2: Policy Approach
   - What policy change, natural experiment, or institutional reform could be evaluated?
   - Is there an unexploited source of exogenous variation (a new law, a discontinuity, a randomization)?
   - What policy-relevant question lacks credible causal evidence?
   - Generate 2–3 candidate questions.

   ### Framework 3: Data Approach
   - What new dataset, measurement, or data linkage enables a previously impossible analysis?
   - Can existing administrative data be combined in a novel way?
   - Does new technology (satellite imagery, web scraping, text analysis) open measurement possibilities?
   - Generate 2–3 candidate questions.

   ### Framework 4: Extension Approach
   - How can a known result be tested in a new context (different country, time period, population)?
   - Can a result from one subfield be applied to another?
   - What happens when a known mechanism interacts with a new moderating factor?
   - Generate 2–3 candidate questions.

4. **Evaluate each candidate question** against these criteria:

   | Question | Data Availability | Identification Credibility | Novelty | Policy Relevance | Feasibility |
   |----------|-------------------|---------------------------|---------|------------------|-------------|
   | Q1       | High/Med/Low      | High/Med/Low              | ...     | ...              | ...         |

   - **Data availability:** Can the data be obtained within a reasonable time/budget?
   - **Identification credibility:** Is there a plausible source of exogenous variation? Can causality be established?
   - **Novelty:** Has this question been answered already? If so, what is new about this approach?
   - **Policy relevance:** Do policymakers or practitioners care about the answer?
   - **Feasibility:** Can this be completed within the project timeline and resources?

5. **Rank the top 3 questions** and for each provide:
   - A one-paragraph research pitch (the "elevator pitch")
   - The proposed identification strategy
   - The key data requirements
   - The expected contribution to the literature

6. Save output to `notes/ideation-<topic-slug>.md`.

7. For the top-ranked question, offer to run `/project:lit-review` to survey existing literature on the topic.

## Error handling

- If the starting observation is too vague (e.g., "inequality"), ask the user to be more specific about the context, geography, or time period.
- If no frameworks produce viable questions, discuss with the user what constraints are most binding (data, identification, novelty) and adjust.

## Common Pitfalls

- **Questions too broad:** "What causes economic growth?" is not a research question — it's a field. Narrow to a specific mechanism, context, and outcome.
- **No identification strategy:** A question is not researchable if there is no plausible way to establish causality or isolate the effect of interest.
- **Already answered:** Before investing in a question, search for existing papers that may have already addressed it. A contribution must add something new — a different context, better data, or improved methods.
- **Data doesn't exist:** Exciting questions that require unavailable data are not feasible. Verify data access before committing.
- **Confusing correlation with a research question:** "Is X correlated with Y?" is descriptive, not causal. Reframe as "Does X cause Y?" and identify the variation that would answer it.
