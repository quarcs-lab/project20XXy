# Introduction

Understanding the determinants of economic growth across countries remains a central question in development economics. Following the seminal work of Keola et al. (2015), a large empirical literature has examined how initial conditions, physical and human capital accumulation, and trade affect growth trajectories.

This paper uses a synthetic panel dataset of 40 countries over six five-year periods (1990–2015) to investigate the determinants of GDP per capita growth. We employ panel data fixed effects methods to account for unobserved country-specific heterogeneity and common time shocks.

This study contributes to the literature in two ways. First, we provide a multi-language reproducible workflow demonstrating panel data analysis in Python, R, and Stata. Second, we show how modern tools can enhance transparency in empirical research.

The rest of this article is organized as follows. Section [2](#sec-literature) provides an overview of the related literature. Section [3](#sec-data) introduces the data and methods. Section [4](#sec-results) presents the results and discussion. Finally, Section [5](#sec-conclusion) offers some concluding remarks.

# Related literature

The relationship between initial income and subsequent growth — the convergence hypothesis — has been extensively studied since the seminal work of Keola et al. (2015). Recent advances in panel data econometrics have enabled more nuanced analyses that control for unobserved heterogeneity across countries[^1].

# Data and methods

## Data

We use a balanced panel of 40 countries observed at five-year intervals from 1990 to 2015 (240 country-period observations). The dataset includes GDP per capita growth as the dependent variable and five regressors: log initial GDP per capita (capturing convergence), investment share, years of schooling, population growth, and trade openness. Full details on data construction are provided in [N1: Panel Data Analysis (Python)](notebooks/notebook-01.qmd).

The following figure shows the distribution of GDP growth rates across the six time periods.

Distribution of GDP per capita growth rates by period.

The convergence hypothesis predicts a negative relationship between initial income and subsequent growth. The following scatter plot illustrates this pattern in our data.

Conditional convergence: GDP growth vs. initial income level.

The correlation structure of the panel variables is summarized below, showing the pairwise relationships that motivate our regression specification.

Pairwise correlations between panel variables.

The following table reports descriptive statistics at the beginning and end of the sample period, highlighting how the panel evolves over time.

**Table 1: Descriptive statistics — initial and final period.**

[TABLE]

*Note:* Summary statistics for 40 countries at two points in time (1990 and 2015). GDP growth in percentage points. Investment and trade openness as shares of GDP. IQR = interquartile range.

## Methods

We estimate the following growth equation using panel data fixed effects:

``` math
\text{Growth}_{it} = \beta_1 \ln \text{GDP}_{it} + \beta_2 \text{Investment}_{it} + \beta_3 \text{Schooling}_{it} + \beta_4 \text{PopGrowth}_{it} + \beta_5 \text{Trade}_{it} + \alpha_i + \gamma_t + \varepsilon_{it}
```

where $`\alpha_i`$ captures country fixed effects and $`\gamma_t`$ captures time fixed effects. We report four specifications: pooled OLS, country FE, time FE, and two-way FE. Standard errors are clustered by country in all models.

# Results and discussion

The following table presents the main regression results estimated using Python (`pyfixest`). We progressively add fixed effects to control for unobserved heterogeneity.

**Table 2: Determinants of economic growth — panel fixed effects estimates (Python).**

|                 |  \(1\) OLS   | \(2\) Country FE | \(3\) Time FE | \(4\) Two-way FE |
|:----------------|:------------:|:----------------:|:-------------:|:----------------:|
| Log initial GDP | -0.759\*\*\* |   -0.901\*\*\*   | -0.742\*\*\*  |   -0.878\*\*\*   |
|                 |   (0.117)    |     (0.108)      |    (0.109)    |     (0.103)      |
| Investment      | 0.172\*\*\*  |   0.200\*\*\*    |  0.164\*\*\*  |   0.190\*\*\*    |
|                 |   (0.030)    |     (0.025)      |    (0.028)    |     (0.024)      |
| Schooling       | 0.187\*\*\*  |   0.168\*\*\*    |  0.202\*\*\*  |   0.186\*\*\*    |
|                 |   (0.044)    |     (0.040)      |    (0.048)    |     (0.038)      |
| Pop. growth     |  -0.442\*\*  |    -0.405\*\*    | -0.454\*\*\*  |   -0.431\*\*\*   |
|                 |   (0.169)    |     (0.159)      |    (0.159)    |     (0.151)      |
| Trade openness  |    0.013     |    0.014\*\*     |    0.015\*    |   0.017\*\*\*    |
|                 |   (0.009)    |     (0.006)      |    (0.008)    |     (0.006)      |
|                 |              |                  |               |                  |
| Country FE      |      No      |       Yes        |      No       |       Yes        |
| Year FE         |      No      |        No        |      Yes      |       Yes        |
| Observations    |     240      |       240        |      240      |       240        |
| R-squared       |    0.332     |      0.641       |     0.381     |      0.687       |

*Note:* Dependent variable: GDP per capita growth rate (%). All regressions include a constant (not reported). Standard errors clustered by country in parentheses. Significance levels: \* p\<0.10, \*\* p\<0.05, \*\*\* p\<0.01.

The results are replicated in R ([N2](notebooks/notebook-02.qmd)) and Stata ([N3](notebooks/notebook-03.qmd)) to demonstrate multi-language reproducibility.

**Table 3: Determinants of economic growth — panel fixed effects estimates (R).**

|                 |  \(1\) OLS   | \(2\) Country FE | \(3\) Time FE | \(4\) Two-way FE |
|:----------------|:------------:|:----------------:|:-------------:|:----------------:|
| Log initial GDP | -0.759\*\*\* |   -0.901\*\*\*   | -0.742\*\*\*  |   -0.878\*\*\*   |
|                 |   (0.117)    |     (0.108)      |    (0.109)    |     (0.103)      |
| Investment      | 0.172\*\*\*  |   0.200\*\*\*    |  0.164\*\*\*  |   0.190\*\*\*    |
|                 |   (0.030)    |     (0.025)      |    (0.028)    |     (0.024)      |
| Schooling       | 0.187\*\*\*  |   0.168\*\*\*    |  0.202\*\*\*  |   0.186\*\*\*    |
|                 |   (0.044)    |     (0.040)      |    (0.048)    |     (0.038)      |
| Pop. growth     |  -0.442\*\*  |    -0.405\*\*    | -0.454\*\*\*  |   -0.431\*\*\*   |
|                 |   (0.169)    |     (0.159)      |    (0.159)    |     (0.151)      |
| Trade openness  |    0.013     |    0.014\*\*     |    0.015\*    |   0.017\*\*\*    |
|                 |   (0.009)    |     (0.006)      |    (0.008)    |     (0.006)      |
|                 |              |                  |               |                  |
| Country FE      |      No      |       Yes        |      No       |       Yes        |
| Year FE         |      No      |        No        |      Yes      |       Yes        |
| Observations    |     240      |       240        |      240      |       240        |
| R-squared       |    0.332     |      0.641       |     0.381     |      0.687       |

*Note:* Same specification as Table 2, estimated using R `fixest`. All regressions include a constant (not reported). Standard errors clustered by country.

**Table 4: Determinants of economic growth — panel fixed effects estimates (Stata).**

|                 |  \(1\) OLS   | \(2\) Country FE | \(3\) Time FE | \(4\) Two-way FE |
|:----------------|:------------:|:----------------:|:-------------:|:----------------:|
| Log initial GDP | -0.759\*\*\* |   -0.901\*\*\*   | -0.742\*\*\*  |   -0.878\*\*\*   |
|                 |   (0.117)    |     (0.088)      |    (0.109)    |     (0.084)      |
| Investment      | 0.172\*\*\*  |   0.200\*\*\*    |  0.164\*\*\*  |   0.190\*\*\*    |
|                 |   (0.030)    |     (0.027)      |    (0.028)    |     (0.024)      |
| Schooling       | 0.187\*\*\*  |   0.168\*\*\*    |  0.202\*\*\*  |   0.186\*\*\*    |
|                 |   (0.044)    |     (0.037)      |    (0.048)    |     (0.036)      |
| Pop. growth     |  -0.442\*\*  |    -0.405\*\*    | -0.454\*\*\*  |   -0.431\*\*\*   |
|                 |   (0.169)    |     (0.168)      |    (0.159)    |     (0.152)      |
| Trade openness  |    0.013     |     0.014\*      |    0.015\*    |    0.017\*\*     |
|                 |   (0.009)    |     (0.008)      |    (0.008)    |     (0.008)      |
|                 |              |                  |               |                  |
| Country FE      |      No      |       Yes        |      No       |       Yes        |
| Year FE         |      No      |        No        |      Yes      |       Yes        |
| Observations    |     240      |       240        |      240      |       240        |
| Adj. R-squared  |    0.318     |      0.560       |     0.354     |      0.607       |

*Note:* Same specification as Table 2, estimated using Stata `reghdfe`. All regressions include a constant (not reported). Standard errors clustered by country.

\[FILL: Discuss implications and compare with existing literature.\]

# Concluding remarks

\[FILL: Summarize the main findings and their implications.\]

\[FILL: Discuss limitations and directions for future research.\]

# Acknowledgments

\[FILL: Acknowledge funding sources, collaborators, and data providers.\]

# Data and code availability

The data and code used in this study are available at \[FILL: repository URL\].

# References

Keola, Souknilanh, Magnus Andersson, and Ola Hall. 2015. “Monitoring Economic Development from Space: Using Nighttime Light and Land Cover Data to Measure Economic Growth.” *World Development* 66: 322–34.

[^1]: See also the World Bank regional development reports.
