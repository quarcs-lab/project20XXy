# Notebooks

Computational notebooks that provide inputs (figures, tables) for the manuscript.

## Conventions

### Naming

- Use sequential numbering: `notebook-01.ipynb`, `notebook-02.ipynb`, etc.
- Each `.ipynb` file has a paired `.md` file (MyST Markdown) managed by Jupytext.

### Jupytext Pairing

Every notebook is stored in two formats:

- `.ipynb` — Standard Jupyter format (for execution and interactive use)
- `.md` — MyST Markdown format (for version control, clean diffs in git)

Sync changes between formats:

```bash
# After editing the .md file
uv run jupytext --sync notebooks/notebook-01.md

# After editing the .ipynb file
uv run jupytext --sync notebooks/notebook-01.ipynb
```

### Labeling Outputs for the Manuscript

To embed a figure or table in `index.qmd`, add a label in the notebook cell:

```python
#| label: fig-my-figure
#| fig-cap: "Description of the figure"

# Your plotting code here
plt.show()
```

Then reference it in the manuscript:

```markdown
{{< embed notebooks/notebook-01.ipynb#fig-my-figure >}}
```

### Registering Notebooks

New notebooks must be registered in `_quarto.yml` under `manuscript.notebooks`:

```yaml
manuscript:
  notebooks:
    - notebook: notebooks/notebook-01.ipynb
      title: "N1: Notebook title"
    - notebook: notebooks/notebook-02.ipynb
      title: "N2: New notebook title"
```

### Reproducibility

Always import and call `set_seeds()` at the top of every notebook:

**Python:**

```python
import sys
sys.path.insert(0, "..")
from config import set_seeds, DATA_DIR
set_seeds()
```

**R:**

```r
source("../config.R")
set_seeds()
```

### Supported Kernels

- **Python** — Managed via `uv` virtual environment
- **R** — Requires R installation + `IRkernel` package
- **Stata** — Requires Stata license + `stata_kernel` pip package
