# Notebooks

Computational notebooks that provide inputs (figures, tables) for the manuscript.

## Quick Reference

```bash
# Render a single notebook
quarto render notebooks/notebook-01.qmd

# Render all notebooks + manuscript
quarto render

# List installed kernels
jupyter kernelspec list
```

## Selecting the Right Kernel

Each notebook specifies its kernel in the YAML frontmatter (`jupyter: <kernel>`).
Use this table to know which kernel each notebook requires:

| Notebook | Language | Kernel (`jupyter:` value) |
| --- | --- | --- |
| `notebook-01.qmd` | Python | `python3` |
| `notebook-02.qmd` | R | `ir` |
| `notebook-03.qmd` | Stata | `nbstata` |

> **Tip:** You can identify a notebook's language from its fenced code blocks:
> `` ```{python} `` → Python, `` ```{r} `` → R, `` ```{stata} `` → Stata.

---

## Kernel Setup

The template supports three Jupyter kernels. Each must be installed before its
notebooks can be executed.

### Python (automatic)

The Python kernel is installed automatically when you run `uv sync`. No extra
setup is needed.

### R (IRkernel)

**Requirements:** R must be installed on the system.

From an R console (or terminal):

```bash
R -e "install.packages(c('IRkernel', 'ggplot2', 'knitr'), repos='https://cloud.r-project.org')"
R -e "IRkernel::installspec()"
```

This installs the kernel and the R packages used by the sample notebook. Add any
additional R packages your project needs to the first `install.packages()` call.

**Verify:** `jupyter kernelspec list` should show `ir`.

### Stata (nbstata)

**Requirements:** Stata must be installed and licensed on the system.

> **Important:** Use [nbstata](https://github.com/hugetim/nbstata), not the
> older `stata_kernel`. The legacy `stata_kernel` (v1.14.2) has a graph-capture
> bug that crashes with Stata 19+.

**Step 1 — Register the nbstata kernel:**

`nbstata` is already included in `pyproject.toml`, so `uv sync` installs it
into the project's `.venv`. You only need to register the Jupyter kernel:

```bash
uv run python -m nbstata.install
```

**Step 2 — Configure Stata path:**

Create `~/.config/nbstata/nbstata.conf`:

```ini
[nbstata]
stata_dir = /Applications/Stata
edition = se
```

Adjust `stata_dir` and `edition` for your system:

| OS | Typical `stata_dir` |
| --- | --- |
| macOS | `/Applications/Stata` |
| Linux | `/usr/local/stata19` |
| Windows | `C:\Program Files\Stata19` |

Valid editions: `be` (Basic), `se` (Standard), `mp` (Multiprocessor).

**Verify:** `jupyter kernelspec list` should show `nbstata`.

## Conventions

### Naming

- Use sequential numbering: `notebook-01.qmd`, `notebook-02.qmd`, etc.
- Each notebook is a plain-text `.qmd` file (no binary formats, clean git diffs).

### Notebook Structure

Each `.qmd` notebook has:

1. **YAML frontmatter** with `title` and `jupyter` kernel specification
2. **Markdown sections** as regular text between code blocks
3. **Fenced code blocks** using the language-specific syntax

Example frontmatter:

```yaml
---
title: "N4: My Analysis"
jupyter: python3
---
```

### Labeling Outputs for the Manuscript

To embed a figure or table in `index.qmd`, add a label in the notebook cell.

All languages use the `#|` (hash-pipe) prefix for cell options in `.qmd` files:

**Python:**

```python
#| label: fig-my-figure
#| fig-cap: "Description of the figure"

plt.show()
```

**R:**

```r
#| label: fig-r-figure
#| fig-cap: "Description of the figure"

ggplot(df, aes(x, y)) + geom_point()
```

**Stata:**

```stata
#| label: fig-stata-figure
#| fig-cap: "Description of the figure"

twoway scatter y x
```

Then reference it in the manuscript:

```markdown
{{< embed notebooks/notebook-01.qmd#fig-my-figure >}}
```

### Stata Label Restriction

Do **not** use the `tbl-` prefix for Stata cell labels that produce stream text
output (e.g., `tabstat`, `table`, `summarize`). The `tbl-` prefix triggers
Quarto's table parser, which expects a markdown-formatted table and will crash
on Stata's plain-text output.

Instead, use a plain label:

```stata
#| label: stata-summary

tabstat gdp_per_capita life_expectancy, by(region) stat(mean sd count)
```

This restriction does not apply to Python or R cells that output proper markdown
tables (e.g., via `pandas` or `knitr::kable()`).

### Registering Notebooks

New notebooks must be registered in `_quarto.yml` under `manuscript.notebooks`
(so Quarto links them in the manuscript sidebar):

```yaml
manuscript:
  notebooks:
    - notebook: notebooks/notebook-04.qmd
      title: "N4: Your notebook title"
```

The `project.render` section already includes a `notebooks/*.qmd` wildcard,
so new notebooks are automatically picked up for rendering without additional
configuration.

### Quarto Configuration Notes

> **Do NOT set `output-dir: .` in `_quarto.yml`.** This prevents Quarto from
> generating the notebook preview HTML pages (`*-preview.html`) that are linked
> from the manuscript sidebar. Use the default output directory (`_manuscript/`).

Rendered outputs are placed in `_manuscript/`:

```text
_manuscript/
  index.html                          # Main manuscript
  index.pdf
  index.docx
  notebooks/
    notebook-01-preview.html          # Clickable notebook previews
    notebook-02-preview.html
    notebook-03-preview.html
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

**Stata:**

```stata
clear all
set seed 42
```
