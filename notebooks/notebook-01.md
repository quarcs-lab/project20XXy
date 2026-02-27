---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.1
kernelspec:
  display_name: project20xxy
  language: python
  name: python3
---

+++ {"_sphinx_cell_id": "fe987973-1466-48df-995e-6c4bf97fe398"}

---
title: "N1: Sample Data Exploration"
---

## Overview

This notebook demonstrates the template workflow: generating synthetic data,
producing labeled figures and tables that are embedded in the manuscript via
Quarto's `{{< embed >}}` shortcode.

```{code-cell} ipython3
---
_sphinx_cell_id: a5165839-e2e8-4c44-92ab-19142af690f2
---
import sys
sys.path.insert(0, "..")
from config import set_seeds, DATA_DIR

set_seeds()
```

```{code-cell} ipython3
---
_sphinx_cell_id: 6b6eb2fb-7340-486b-91f5-acd4ce7be6e8
---
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")
```

```{code-cell} ipython3
---
_sphinx_cell_id: 6ae42ab7-5bba-421d-87db-1619def44ace
---
#| label: fig-sample
#| fig-cap: "Synthetic regional indicators: GDP per capita vs. life expectancy across 80 simulated regions, colored by geographic cluster."

# Generate synthetic cross-sectional data
rng = np.random.default_rng(42)
n = 80
clusters = np.repeat(["North", "South", "East", "West"], n // 4)

gdp = rng.lognormal(mean=9.5, sigma=0.6, size=n)
life_exp = 50 + 15 * (1 - np.exp(-gdp / 20000)) + rng.normal(0, 2, n)

df = pd.DataFrame({
    "GDP per capita (USD)": gdp,
    "Life expectancy (years)": life_exp,
    "Region": clusters,
})

fig, ax = plt.subplots(figsize=(8, 5))
sns.scatterplot(
    data=df,
    x="GDP per capita (USD)",
    y="Life expectancy (years)",
    hue="Region",
    style="Region",
    s=60,
    alpha=0.8,
    ax=ax,
)
ax.set_title("GDP per Capita vs. Life Expectancy")
ax.legend(title="Region", frameon=True)
plt.tight_layout()
plt.show()
```

```{code-cell} ipython3
---
_sphinx_cell_id: 027751de-4ea9-4ef0-98c8-f2ea4091e030
---
#| label: tbl-summary
#| tbl-cap: "Summary statistics by region."

summary = (
    df.groupby("Region")[["GDP per capita (USD)", "Life expectancy (years)"]]
    .agg(["mean", "std", "count"])
    .round(1)
)
summary.columns = [f"{col} ({stat})" for col, stat in summary.columns]
from IPython.display import Markdown
Markdown(summary.to_markdown())
```
