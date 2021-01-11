Descriptive statistics from stargazer
================
Carlos Mendez
5/29/2020

## The data: attitude {datasets}

Default R data

From a survey of the clerical employees of a large financial
organization, the data are aggregated from the questionnaires of the
approximately 35 employees for each of 30 (randomly selected)
departments. The numbers give the percent proportion of favourable
responses to seven questions in each department.

A data frame with 30 observations on 7 variables. The first column are
the short names from the reference, the second one the variable names in
the data frame:

Y rating numeric Overall rating X\[1\] complaints numeric Handling of
employee complaints X\[2\] privileges numeric Does not allow special
privileges X\[3\] learning numeric Opportunity to learn X\[4\] raises
numeric Raises based on performance X\[5\] critical numeric Too critical
X\[6\] advancel numeric Advancement

``` r
df <- attitude
```

``` r
df
```

    ##    rating complaints privileges learning raises critical advance
    ## 1      43         51         30       39     61       92      45
    ## 2      63         64         51       54     63       73      47
    ## 3      71         70         68       69     76       86      48
    ## 4      61         63         45       47     54       84      35
    ## 5      81         78         56       66     71       83      47
    ## 6      43         55         49       44     54       49      34
    ## 7      58         67         42       56     66       68      35
    ## 8      71         75         50       55     70       66      41
    ## 9      72         82         72       67     71       83      31
    ## 10     67         61         45       47     62       80      41
    ## 11     64         53         53       58     58       67      34
    ## 12     67         60         47       39     59       74      41
    ## 13     69         62         57       42     55       63      25
    ## 14     68         83         83       45     59       77      35
    ## 15     77         77         54       72     79       77      46
    ## 16     81         90         50       72     60       54      36
    ## 17     74         85         64       69     79       79      63
    ## 18     65         60         65       75     55       80      60
    ## 19     65         70         46       57     75       85      46
    ## 20     50         58         68       54     64       78      52
    ## 21     50         40         33       34     43       64      33
    ## 22     64         61         52       62     66       80      41
    ## 23     53         66         52       50     63       80      37
    ## 24     40         37         42       58     50       57      49
    ## 25     63         54         42       48     66       75      33
    ## 26     66         77         66       63     88       76      72
    ## 27     78         75         58       74     80       78      49
    ## 28     48         57         44       45     51       83      38
    ## 29     85         85         71       71     77       74      55
    ## 30     82         82         39       59     64       78      39

``` r
df %>% 
  glimpse()
```

    ## Rows: 30
    ## Columns: 7
    ## $ rating     <dbl> 43, 63, 71, 61, 81, 43, 58, 71, 72, 67, 64, 67, 69, 68, 77…
    ## $ complaints <dbl> 51, 64, 70, 63, 78, 55, 67, 75, 82, 61, 53, 60, 62, 83, 77…
    ## $ privileges <dbl> 30, 51, 68, 45, 56, 49, 42, 50, 72, 45, 53, 47, 57, 83, 54…
    ## $ learning   <dbl> 39, 54, 69, 47, 66, 44, 56, 55, 67, 47, 58, 39, 42, 45, 72…
    ## $ raises     <dbl> 61, 63, 76, 54, 71, 54, 66, 70, 71, 62, 58, 59, 55, 59, 79…
    ## $ critical   <dbl> 92, 73, 86, 84, 83, 49, 68, 66, 83, 80, 67, 74, 63, 77, 77…
    ## $ advance    <dbl> 45, 47, 48, 35, 47, 34, 35, 41, 31, 41, 34, 41, 25, 35, 46…

## Descriptive statistics

### Latex

``` r
stargazer(attitude,
          covariate.labels=c("The Rating",
                   "Handling of Complaints",
                   "No Special Privileges",
                   "Opportunity to Learn",
                   "Performance-Based Raises",
                   "Too Critical",
                   "Advancement",
                   "Very High Rating"),
          title="Descriptive statistics",
          notes = "Notes: Here are some notes",
          median = TRUE,
          iqr = FALSE,
          digits = 2,
          align = TRUE,
          type = "text",
          no.space = TRUE,
          out = "../results/tab-descriptiveStats.tex")
```

    ## 
    ## Descriptive statistics
    ## ===========================================================================
    ## Statistic                N  Mean  St. Dev. Min Pctl(25) Median Pctl(75) Max
    ## ---------------------------------------------------------------------------
    ## The Rating               30 65.00  12.00   40    59.0    66.0    72.0   85 
    ## Handling of Complaints   30 67.00  13.00   37    58.0     65      77    90 
    ## No Special Privileges    30 53.00  12.00   30     45     52.0    62.0   83 
    ## Opportunity to Learn     30 56.00  12.00   34     47     56.0    67.0   75 
    ## Performance-Based Raises 30 65.00  10.00   43    58.0    64.0     71    88 
    ## Too Critical             30 75.00   9.90   49    69.0    78.0     80    92 
    ## Advancement              30 43.00  10.00   25     35      41     48.0   72 
    ## ---------------------------------------------------------------------------
    ## Notes: Here are some notes

## Regression models

``` r
## 2 OLS models
linear.1 <- lm(rating ~ complaints + privileges + learning + raises + critical, data=attitude)
linear.2 <- lm(rating ~ complaints + privileges + learning, data=attitude)
 
## create an indicator dependent variable, and run a probit model
 
attitude$high.rating <- (attitude$rating > 70)
probit.model <- glm(high.rating ~ learning + critical + advance, data=attitude, family = binomial(link = "probit"))
```

### Text

``` r
stargazer(linear.1, linear.2, probit.model, type="text", title="Regression Results", align=TRUE)
```

    ## 
    ## Regression Results
    ## =============================================================================
    ##                                        Dependent variable:                   
    ##                     ---------------------------------------------------------
    ##                                        rating                     high.rating
    ##                                          OLS                        probit   
    ##                              (1)                    (2)               (3)    
    ## -----------------------------------------------------------------------------
    ## complaints                 0.690***               0.680***                   
    ##                            (0.150)                (0.130)                    
    ##                                                                              
    ## privileges                  -0.100                 -0.100                    
    ##                            (0.140)                (0.130)                    
    ##                                                                              
    ## learning                    0.250                  0.240*          0.160***  
    ##                            (0.160)                (0.140)           (0.053)  
    ##                                                                              
    ## raises                      -0.033                                           
    ##                            (0.200)                                           
    ##                                                                              
    ## critical                    0.015                                   -0.001   
    ##                            (0.150)                                  (0.044)  
    ##                                                                              
    ## advance                                                             -0.062   
    ##                                                                     (0.042)  
    ##                                                                              
    ## Constant                    11.000                 11.000          -7.500**  
    ##                            (12.000)               (7.300)           (3.600)  
    ##                                                                              
    ## -----------------------------------------------------------------------------
    ## Observations                  30                     30               30     
    ## R2                          0.710                  0.710                     
    ## Adjusted R2                 0.660                  0.680                     
    ## Log Likelihood                                                      -9.100   
    ## Akaike Inf. Crit.                                                   26.000   
    ## Residual Std. Error    7.100 (df = 24)        6.900 (df = 26)                
    ## F Statistic         12.000*** (df = 5; 24) 22.000*** (df = 3; 26)            
    ## =============================================================================
    ## Note:                                             *p<0.1; **p<0.05; ***p<0.01

### Latex

``` r
stargazer(linear.1, linear.2, probit.model, title="Regression Results", align=TRUE)
```

    ## 
    ## % Table created by stargazer v.5.2.2 by Marek Hlavac, Harvard University. E-mail: hlavac at fas.harvard.edu
    ## % Date and time: Mon, Jan 11, 2021 - 12:32:04
    ## % Requires LaTeX packages: dcolumn 
    ## \begin{table}[!htbp] \centering 
    ##   \caption{Regression Results} 
    ##   \label{} 
    ## \begin{tabular}{@{\extracolsep{5pt}}lD{.}{.}{-3} D{.}{.}{-3} D{.}{.}{-3} } 
    ## \\[-1.8ex]\hline 
    ## \hline \\[-1.8ex] 
    ##  & \multicolumn{3}{c}{\textit{Dependent variable:}} \\ 
    ## \cline{2-4} 
    ## \\[-1.8ex] & \multicolumn{2}{c}{rating} & \multicolumn{1}{c}{high.rating} \\ 
    ## \\[-1.8ex] & \multicolumn{2}{c}{\textit{OLS}} & \multicolumn{1}{c}{\textit{probit}} \\ 
    ## \\[-1.8ex] & \multicolumn{1}{c}{(1)} & \multicolumn{1}{c}{(2)} & \multicolumn{1}{c}{(3)}\\ 
    ## \hline \\[-1.8ex] 
    ##  complaints & 0.690^{***} & 0.680^{***} &  \\ 
    ##   & (0.150) & (0.130) &  \\ 
    ##   & & & \\ 
    ##  privileges & -0.100 & -0.100 &  \\ 
    ##   & (0.140) & (0.130) &  \\ 
    ##   & & & \\ 
    ##  learning & 0.250 & 0.240^{*} & 0.160^{***} \\ 
    ##   & (0.160) & (0.140) & (0.053) \\ 
    ##   & & & \\ 
    ##  raises & -0.033 &  &  \\ 
    ##   & (0.200) &  &  \\ 
    ##   & & & \\ 
    ##  critical & 0.015 &  & -0.001 \\ 
    ##   & (0.150) &  & (0.044) \\ 
    ##   & & & \\ 
    ##  advance &  &  & -0.062 \\ 
    ##   &  &  & (0.042) \\ 
    ##   & & & \\ 
    ##  Constant & 11.000 & 11.000 & -7.500^{**} \\ 
    ##   & (12.000) & (7.300) & (3.600) \\ 
    ##   & & & \\ 
    ## \hline \\[-1.8ex] 
    ## Observations & \multicolumn{1}{c}{30} & \multicolumn{1}{c}{30} & \multicolumn{1}{c}{30} \\ 
    ## R$^{2}$ & \multicolumn{1}{c}{0.710} & \multicolumn{1}{c}{0.710} &  \\ 
    ## Adjusted R$^{2}$ & \multicolumn{1}{c}{0.660} & \multicolumn{1}{c}{0.680} &  \\ 
    ## Log Likelihood &  &  & \multicolumn{1}{c}{-9.100} \\ 
    ## Akaike Inf. Crit. &  &  & \multicolumn{1}{c}{26.000} \\ 
    ## Residual Std. Error & \multicolumn{1}{c}{7.100 (df = 24)} & \multicolumn{1}{c}{6.900 (df = 26)} &  \\ 
    ## F Statistic & \multicolumn{1}{c}{12.000$^{***}$ (df = 5; 24)} & \multicolumn{1}{c}{22.000$^{***}$ (df = 3; 26)} &  \\ 
    ## \hline 
    ## \hline \\[-1.8ex] 
    ## \textit{Note:}  & \multicolumn{3}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
    ## \end{tabular} 
    ## \end{table}

### Latex with longer names

``` r
stargazer(linear.1, linear.2, probit.model, title="Regression Results", align=TRUE, dep.var.labels=c("Overall Rating","High Rating"), covariate.labels=c("Handling of Complaints","No Special Privileges", "Opportunity to Learn","Performance-Based Raises","Too Critical","Advancement"), omit.stat=c("LL","ser","f"), no.space=TRUE)
```

    ## 
    ## % Table created by stargazer v.5.2.2 by Marek Hlavac, Harvard University. E-mail: hlavac at fas.harvard.edu
    ## % Date and time: Mon, Jan 11, 2021 - 12:32:04
    ## % Requires LaTeX packages: dcolumn 
    ## \begin{table}[!htbp] \centering 
    ##   \caption{Regression Results} 
    ##   \label{} 
    ## \begin{tabular}{@{\extracolsep{5pt}}lD{.}{.}{-3} D{.}{.}{-3} D{.}{.}{-3} } 
    ## \\[-1.8ex]\hline 
    ## \hline \\[-1.8ex] 
    ##  & \multicolumn{3}{c}{\textit{Dependent variable:}} \\ 
    ## \cline{2-4} 
    ## \\[-1.8ex] & \multicolumn{2}{c}{Overall Rating} & \multicolumn{1}{c}{High Rating} \\ 
    ## \\[-1.8ex] & \multicolumn{2}{c}{\textit{OLS}} & \multicolumn{1}{c}{\textit{probit}} \\ 
    ## \\[-1.8ex] & \multicolumn{1}{c}{(1)} & \multicolumn{1}{c}{(2)} & \multicolumn{1}{c}{(3)}\\ 
    ## \hline \\[-1.8ex] 
    ##  Handling of Complaints & 0.690^{***} & 0.680^{***} &  \\ 
    ##   & (0.150) & (0.130) &  \\ 
    ##   No Special Privileges & -0.100 & -0.100 &  \\ 
    ##   & (0.140) & (0.130) &  \\ 
    ##   Opportunity to Learn & 0.250 & 0.240^{*} & 0.160^{***} \\ 
    ##   & (0.160) & (0.140) & (0.053) \\ 
    ##   Performance-Based Raises & -0.033 &  &  \\ 
    ##   & (0.200) &  &  \\ 
    ##   Too Critical & 0.015 &  & -0.001 \\ 
    ##   & (0.150) &  & (0.044) \\ 
    ##   Advancement &  &  & -0.062 \\ 
    ##   &  &  & (0.042) \\ 
    ##   Constant & 11.000 & 11.000 & -7.500^{**} \\ 
    ##   & (12.000) & (7.300) & (3.600) \\ 
    ##  \hline \\[-1.8ex] 
    ## Observations & \multicolumn{1}{c}{30} & \multicolumn{1}{c}{30} & \multicolumn{1}{c}{30} \\ 
    ## R$^{2}$ & \multicolumn{1}{c}{0.710} & \multicolumn{1}{c}{0.710} &  \\ 
    ## Adjusted R$^{2}$ & \multicolumn{1}{c}{0.660} & \multicolumn{1}{c}{0.680} &  \\ 
    ## Akaike Inf. Crit. &  &  & \multicolumn{1}{c}{26.000} \\ 
    ## \hline 
    ## \hline \\[-1.8ex] 
    ## \textit{Note:}  & \multicolumn{3}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
    ## \end{tabular} 
    ## \end{table}

### HTML

``` r
stargazer(linear.1, linear.2, probit.model, type="html", title="Regression Results", align=TRUE)
```

<table style="text-align:center">

<caption>

<strong>Regression Results</strong>

</caption>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="3">

<em>Dependent variable:</em>

</td>

</tr>

<tr>

<td>

</td>

<td colspan="3" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="2">

rating

</td>

<td>

high.rating

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="2">

<em>OLS</em>

</td>

<td>

<em>probit</em>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(1)

</td>

<td>

(2)

</td>

<td>

(3)

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

complaints

</td>

<td>

0.690<sup>\*\*\*</sup>

</td>

<td>

0.680<sup>\*\*\*</sup>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.150)

</td>

<td>

(0.130)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

privileges

</td>

<td>

\-0.100

</td>

<td>

\-0.100

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.140)

</td>

<td>

(0.130)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

learning

</td>

<td>

0.250

</td>

<td>

0.240<sup>\*</sup>

</td>

<td>

0.160<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.160)

</td>

<td>

(0.140)

</td>

<td>

(0.053)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

raises

</td>

<td>

\-0.033

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.200)

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

critical

</td>

<td>

0.015

</td>

<td>

</td>

<td>

\-0.001

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.150)

</td>

<td>

</td>

<td>

(0.044)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

advance

</td>

<td>

</td>

<td>

</td>

<td>

\-0.062

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

(0.042)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Constant

</td>

<td>

11.000

</td>

<td>

11.000

</td>

<td>

\-7.500<sup>\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(12.000)

</td>

<td>

(7.300)

</td>

<td>

(3.600)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

30

</td>

<td>

30

</td>

<td>

30

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.710

</td>

<td>

0.710

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Adjusted R<sup>2</sup>

</td>

<td>

0.660

</td>

<td>

0.680

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Log Likelihood

</td>

<td>

</td>

<td>

</td>

<td>

\-9.100

</td>

</tr>

<tr>

<td style="text-align:left">

Akaike Inf. Crit.

</td>

<td>

</td>

<td>

</td>

<td>

26.000

</td>

</tr>

<tr>

<td style="text-align:left">

Residual Std. Error

</td>

<td>

7.100 (df = 24)

</td>

<td>

6.900 (df = 26)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

F Statistic

</td>

<td>

12.000<sup>\*\*\*</sup> (df = 5; 24)

</td>

<td>

22.000<sup>\*\*\*</sup> (df = 3; 26)

</td>

<td>

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td colspan="3" style="text-align:right">

<sup>*</sup>p\<0.1; <sup>**</sup>p\<0.05; <sup>***</sup>p\<0.01

</td>

</tr>

</table>

### Export latex table

``` r
stargazer(linear.1, linear.2, probit.model,
          title="Regression Results",
          align=TRUE,
          type = "html",
          no.space = TRUE,
          out = "../results/table.tex")
```

<table style="text-align:center">

<caption>

<strong>Regression Results</strong>

</caption>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="3">

<em>Dependent variable:</em>

</td>

</tr>

<tr>

<td>

</td>

<td colspan="3" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="2">

rating

</td>

<td>

high.rating

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="2">

<em>OLS</em>

</td>

<td>

<em>probit</em>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(1)

</td>

<td>

(2)

</td>

<td>

(3)

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

complaints

</td>

<td>

0.690<sup>\*\*\*</sup>

</td>

<td>

0.680<sup>\*\*\*</sup>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.150)

</td>

<td>

(0.130)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

privileges

</td>

<td>

\-0.100

</td>

<td>

\-0.100

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.140)

</td>

<td>

(0.130)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

learning

</td>

<td>

0.250

</td>

<td>

0.240<sup>\*</sup>

</td>

<td>

0.160<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.160)

</td>

<td>

(0.140)

</td>

<td>

(0.053)

</td>

</tr>

<tr>

<td style="text-align:left">

raises

</td>

<td>

\-0.033

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.200)

</td>

<td>

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

critical

</td>

<td>

0.015

</td>

<td>

</td>

<td>

\-0.001

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.150)

</td>

<td>

</td>

<td>

(0.044)

</td>

</tr>

<tr>

<td style="text-align:left">

advance

</td>

<td>

</td>

<td>

</td>

<td>

\-0.062

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

</td>

<td>

(0.042)

</td>

</tr>

<tr>

<td style="text-align:left">

Constant

</td>

<td>

11.000

</td>

<td>

11.000

</td>

<td>

\-7.500<sup>\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(12.000)

</td>

<td>

(7.300)

</td>

<td>

(3.600)

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

30

</td>

<td>

30

</td>

<td>

30

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.710

</td>

<td>

0.710

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Adjusted R<sup>2</sup>

</td>

<td>

0.660

</td>

<td>

0.680

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Log Likelihood

</td>

<td>

</td>

<td>

</td>

<td>

\-9.100

</td>

</tr>

<tr>

<td style="text-align:left">

Akaike Inf. Crit.

</td>

<td>

</td>

<td>

</td>

<td>

26.000

</td>

</tr>

<tr>

<td style="text-align:left">

Residual Std. Error

</td>

<td>

7.100 (df = 24)

</td>

<td>

6.900 (df = 26)

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

F Statistic

</td>

<td>

12.000<sup>\*\*\*</sup> (df = 5; 24)

</td>

<td>

22.000<sup>\*\*\*</sup> (df = 3; 26)

</td>

<td>

</td>

</tr>

<tr>

<td colspan="4" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td colspan="3" style="text-align:right">

<sup>*</sup>p\<0.1; <sup>**</sup>p\<0.05; <sup>***</sup>p\<0.01

</td>

</tr>

</table>

### Export html table

``` r
stargazer(linear.1, linear.2, probit.model,
          title="Regression Results",
          align=TRUE,
          type = "text",
          no.space = TRUE,
          out = "../results/table.html")
```

    ## 
    ## Regression Results
    ## =============================================================================
    ##                                        Dependent variable:                   
    ##                     ---------------------------------------------------------
    ##                                        rating                     high.rating
    ##                                          OLS                        probit   
    ##                              (1)                    (2)               (3)    
    ## -----------------------------------------------------------------------------
    ## complaints                 0.690***               0.680***                   
    ##                            (0.150)                (0.130)                    
    ## privileges                  -0.100                 -0.100                    
    ##                            (0.140)                (0.130)                    
    ## learning                    0.250                  0.240*          0.160***  
    ##                            (0.160)                (0.140)           (0.053)  
    ## raises                      -0.033                                           
    ##                            (0.200)                                           
    ## critical                    0.015                                   -0.001   
    ##                            (0.150)                                  (0.044)  
    ## advance                                                             -0.062   
    ##                                                                     (0.042)  
    ## Constant                    11.000                 11.000          -7.500**  
    ##                            (12.000)               (7.300)           (3.600)  
    ## -----------------------------------------------------------------------------
    ## Observations                  30                     30               30     
    ## R2                          0.710                  0.710                     
    ## Adjusted R2                 0.660                  0.680                     
    ## Log Likelihood                                                      -9.100   
    ## Akaike Inf. Crit.                                                   26.000   
    ## Residual Std. Error    7.100 (df = 24)        6.900 (df = 26)                
    ## F Statistic         12.000*** (df = 5; 24) 22.000*** (df = 3; 26)            
    ## =============================================================================
    ## Note:                                             *p<0.1; **p<0.05; ***p<0.01

### Export text table

``` r
stargazer(linear.1, linear.2, probit.model,
          title="Regression Results",
          align=TRUE,
          type = "text",
          no.space = TRUE,
          out = "table.text")
```

    ## 
    ## Regression Results
    ## =============================================================================
    ##                                        Dependent variable:                   
    ##                     ---------------------------------------------------------
    ##                                        rating                     high.rating
    ##                                          OLS                        probit   
    ##                              (1)                    (2)               (3)    
    ## -----------------------------------------------------------------------------
    ## complaints                 0.690***               0.680***                   
    ##                            (0.150)                (0.130)                    
    ## privileges                  -0.100                 -0.100                    
    ##                            (0.140)                (0.130)                    
    ## learning                    0.250                  0.240*          0.160***  
    ##                            (0.160)                (0.140)           (0.053)  
    ## raises                      -0.033                                           
    ##                            (0.200)                                           
    ## critical                    0.015                                   -0.001   
    ##                            (0.150)                                  (0.044)  
    ## advance                                                             -0.062   
    ##                                                                     (0.042)  
    ## Constant                    11.000                 11.000          -7.500**  
    ##                            (12.000)               (7.300)           (3.600)  
    ## -----------------------------------------------------------------------------
    ## Observations                  30                     30               30     
    ## R2                          0.710                  0.710                     
    ## Adjusted R2                 0.660                  0.680                     
    ## Log Likelihood                                                      -9.100   
    ## Akaike Inf. Crit.                                                   26.000   
    ## Residual Std. Error    7.100 (df = 24)        6.900 (df = 26)                
    ## F Statistic         12.000*** (df = 5; 24) 22.000*** (df = 3; 26)            
    ## =============================================================================
    ## Note:                                             *p<0.1; **p<0.05; ***p<0.01

## Input external tables

### From latex code

<!-- To compile to pdf add the following:  \input{table.tex} -->

## Word tables

    ## 
    ## Regression Results
    ## =============================================================================
    ##                                        Dependent variable:                   
    ##                     ---------------------------------------------------------
    ##                                        rating                     high.rating
    ##                                          OLS                        probit   
    ##                              (1)                    (2)               (3)    
    ## -----------------------------------------------------------------------------
    ## complaints                 0.690***               0.680***                   
    ##                            (0.150)                (0.130)                    
    ## privileges                  -0.100                 -0.100                    
    ##                            (0.140)                (0.130)                    
    ## learning                    0.250                  0.240*          0.160***  
    ##                            (0.160)                (0.140)           (0.053)  
    ## raises                      -0.033                                           
    ##                            (0.200)                                           
    ## critical                    0.015                                   -0.001   
    ##                            (0.150)                                  (0.044)  
    ## advance                                                             -0.062   
    ##                                                                     (0.042)  
    ## Constant                    11.000                 11.000          -7.500**  
    ##                            (12.000)               (7.300)           (3.600)  
    ## -----------------------------------------------------------------------------
    ## Observations                  30                     30               30     
    ## R2                          0.710                  0.710                     
    ## Adjusted R2                 0.660                  0.680                     
    ## Log Likelihood                                                      -9.100   
    ## Akaike Inf. Crit.                                                   26.000   
    ## Residual Std. Error    7.100 (df = 24)        6.900 (df = 26)                
    ## F Statistic         12.000*** (df = 5; 24) 22.000*** (df = 3; 26)            
    ## =============================================================================
    ## Note:                                             *p<0.1; **p<0.05; ***p<0.01
