# Description of datasets

- `dataLong2years`: Contains data for 195 countries for two years: 1990 and 2016.

| Name | Definition                             |
|----------|-------------------------------------|
| id       | Country id                          |
| country  | Country name                        |
| year     | year                                |
| ehc      | Expected human capital              |
| sur      | Expected years lived (0-45 years)   |
| fh       | Functional health status (0-100)    |
| edu      | Educational attainment (0-18 years) |
| lea      | Learning (0-100)                    |


- `dataLong2years-geo-iso`: Contains data for 195 countries for two years: 1990 and 2016.

| var_name   | var_def                                 | type    |
|------------|-----------------------------------------|---------|
| id         | Country id                              | numeric |
| country    | Country name                            | cs_id   |
| year       | year                                    | ts_id   |
| ehc        | Expected human capital                  | numeric |
| sur        | Expected years lived (0-45 years)       | numeric |
| fh         | Functional health status (0-100)        | numeric |
| edu        | Educational attainment (0-18 years)     | numeric |
| lea        | Learning (0-100)                        | numeric |
| region     | Regional classification based on UNCTAD | factor  |
| isoUNstats | ISO 3166 numeric code                   | factor  |
| isoPWT     | ISO code from Penn World Table 7.0      | factor  |
