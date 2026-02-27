# [FILL: Project Title]

[FILL: One-paragraph description of the project.]

## Objectives

[FILL: List the main research objectives.]

## Methods

[FILL: Brief description of data and analytical methods.]

## Setup

### Customizing This Template

After cloning this repository for a new project, update these files:

1. **`README.md`** -- Replace all `[FILL:]` placeholders (title, description, objectives, methods, data)
2. **`index.qmd`** -- Set the manuscript title, authors, affiliations, abstract, and keywords
3. **`pyproject.toml`** -- Update `name`, `description`, and `authors`
4. **`CLAUDE.md`** -- Fill in the Project Context table (title, authors, stage, data source)
5. **`_quarto.yml`** -- Update notebook titles as you add new notebooks

Search for all remaining placeholders:

```bash
grep -r "\[FILL:" --include="*.md" --include="*.qmd" --include="*.toml" .
```

### Requirements

- [Quarto](https://quarto.org/) (>= 1.4)
- [uv](https://docs.astral.sh/uv/) (Python package manager)
- Python 3.12+
- R (for R notebooks)
- Stata (for Stata notebooks, optional)

Verify your setup (all commands should return version numbers):

```bash
quarto --version        # >= 1.4
uv --version            # any recent version
python3 --version       # >= 3.12
R --version             # optional, for R notebooks
stata -v                # optional, for Stata notebooks
```

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

### Notebook Kernels

The Python kernel is installed automatically by `uv sync`. R and Stata kernels
require additional setup.

**R kernel (IRkernel):**

```bash
R -e "install.packages(c('IRkernel', 'ggplot2', 'knitr'), repos='https://cloud.r-project.org')"
R -e "IRkernel::installspec()"
```

**Stata kernel (nbstata):**

```bash
pip install nbstata
python -m nbstata.install
```

Then create `~/.config/nbstata/nbstata.conf`:

```ini
[nbstata]
stata_dir = /Applications/Stata
edition = se
```

Adjust `stata_dir` and `edition` for your OS and Stata version.

See [notebooks/README.md](notebooks/README.md) for full details, platform-specific
paths, and important Quarto integration notes.

### Rendering the manuscript

```bash
# Render all formats (HTML, PDF, Word) → outputs in _manuscript/
quarto render

# Render a single format
quarto render index.qmd --to html
quarto render index.qmd --to pdf
quarto render index.qmd --to docx

# Clean render (clears caches first)
bash scripts/render.sh
```

Rendered files (including notebook preview pages) are placed in `_manuscript/`.

## Workflow

The full workflow from a fresh clone to a rendered manuscript:

1. **Install Python dependencies:** `uv sync`
2. **Install notebook kernels** for R and Stata (see Notebook Kernels above)
3. **Execute notebooks** to generate outputs:

   ```bash
   uv run jupyter execute --inplace notebooks/notebook-01.ipynb
   uv run jupyter execute --inplace notebooks/notebook-02.ipynb
   uv run jupyter execute --inplace notebooks/notebook-03.ipynb
   ```

4. **Render the manuscript:**

   ```bash
   quarto render
   ```

5. **View the output:** open `_manuscript/index.html` in a browser

See [notebooks/README.md](notebooks/README.md) for details on kernel setup,
cell labeling, and Jupytext pairing.

## Project Structure

```text
index.qmd              # Main manuscript (Quarto)
_quarto.yml            # Quarto project configuration
references.bib         # Bibliography
config.py / config.R   # Reproducibility config (seeds, paths)
pyproject.toml         # Python dependencies
notebooks/             # Jupyter notebooks (.ipynb + .md pairs)
_manuscript/           # Rendered outputs (HTML, PDF, Word, notebook previews)
data/                  # Datasets (rawData/ for unmodified sources)
code/                  # Standalone analysis scripts
notes/                 # Research notes, brainstorming, and ideas
images/                # Figures and plots
tables/                # Output tables
slides/                # Quarto presentations
references/            # Annotated bibliographies and reference notes
templates/             # LaTeX manuscript template (alternative)
scripts/               # Build scripts
handoffs/              # Session progress logs
```

## Data

[FILL: Describe the data sources and how to obtain them.]
