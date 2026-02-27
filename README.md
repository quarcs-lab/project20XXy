# [FILL: Project Title]

[FILL: One-paragraph description of the project.]

## Objectives

[FILL: List the main research objectives.]

## Methods

[FILL: Brief description of data and analytical methods.]

## Setup

### Requirements

- [Quarto](https://quarto.org/) (>= 1.4)
- [uv](https://docs.astral.sh/uv/) (Python package manager)
- Python 3.12+
- R (for R notebooks)
- Stata (for Stata notebooks, optional)

### Installation

```bash
# Clone the repository
git clone [FILL: repository URL]
cd [FILL: project directory]

# Create virtual environment and install dependencies
uv sync

# Launch Jupyter
uv run jupyter notebook
```

### Rendering the manuscript

```bash
# Render all formats (HTML, PDF, Word)
quarto render

# Render a single format
quarto render index.qmd --to html
quarto render index.qmd --to pdf
quarto render index.qmd --to docx

# Clean render (clears caches first)
bash scripts/render.sh
```

## Project Structure

```text
index.qmd              # Main manuscript (Quarto)
_quarto.yml            # Quarto project configuration
references.bib         # Bibliography
config.py / config.R   # Reproducibility config (seeds, paths)
pyproject.toml         # Python dependencies
notebooks/             # Jupyter notebooks (.ipynb + .md pairs)
data/                  # Datasets (rawData/ for unmodified sources)
code/                  # Analysis scripts
images/                # Figures and plots
tables/                # Output tables
slides/                # Quarto presentations
references/            # Annotated bibliographies
templates/             # LaTeX manuscript template (alternative)
scripts/               # Build scripts
handoffs/              # Session progress logs
```

## Data

[FILL: Describe the data sources and how to obtain them.]
