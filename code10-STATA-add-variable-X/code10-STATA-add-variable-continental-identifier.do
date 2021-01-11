*-------------------------------------------------------
***************** Standardize names of countries (via Kountry module)
*-------------------------------------------------------
use "../data/dataLong2years.dta", clear

* Correct some names

replace country = "Democratic Republic of Congo" in 93
replace country = "Democratic Republic of Congo" in 94
replace country = "Congo" in 79
replace country = "Congo" in 80
replace country = "Cote d'Ivoire" in 83
replace country = "Cote d'Ivoire" in 84

* Add regional classification (Based on the UN)
kountry country, from(other) geo(un) marker

* Add classification for Montenegro
replace GEO="Europe" if country=="Montenegro"

* Add classification for Taiwan because it not represented in the United Nations
replace GEO="Asia" if country=="Taiwan"

* Remove Northern Mariana Islands
drop if country == "Northern Mariana Islands"

* Remove Virgin Islands
drop if country == "Virgin Islands"


* Check for incomple classification
tabulate country if MARKER==0

* If everthing is ok, drop and rename variables
drop MARKER

drop country
rename NAMES_STD country
label variable country "Standardized country name"
order country, after(id)

rename GEO region
label variable region "Regional classification based on UNCTAD"

* Add isocode from PWT 7
kountry country, from(other) stuck marker
tabulate country if MARKER==0
drop MARKER

rename _ISO3N_ isoUNstats
kountry isoUNstats, from(iso3n) to(penn)
rename _PENN_ isoPWT
label variable isoPWT "ISO code from Penn World Table 7.0"

* Save dataset
save "../data/dataLong2years-geo-iso.dta", replace
export delimited using "../data/dataLong2years-geo-iso.csv", replace
