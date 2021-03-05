

*+++++++++++++++++ Trade +++++++++++++++++++++++
* directly downloaded from WITS (https://wits.worldbank.org) -> advanced query -> Trade data (UM Comtrade) 
* - Reporters: All countries All--All
* - Products: HS 1988/92 (Selected Classification); Total - total trade
* - Partners: All countries All--All 
* - Years: 2010-2018
* - Trade flow: Gross Imports, Gross Exports
use wits_raw_2010.dta, clear
append using wits_raw_2011.dta
append using wits_raw_2012.dta
append using wits_raw_2013.dta
append using wits_raw_2014.dta
append using wits_raw_2015.dta
append using wits_raw_2016.dta
append using wits_raw_2017.dta
append using wits_raw_2018.dta

drop nomenclature productcode
rename reporteriso3 country_iso3
rename reportername country_name
rename partneriso3 partner_iso3
rename partnername partner_name

gen tradevalue = tradevaluein1000usd*1000
gen import=tradevalue if tradeflowcode==1
gen export=tradevalue if tradeflowcode==2
sort country_iso3 partner_iso3
collapse (sum)import (sum)export, by (year country_iso3 country_name partner_iso3 partner_name)
gen trade=import+export
la var trade "import+export: current USD"

save wits_all_2010-2018.dta, replace

* drop country groups and countries with missing values
drop if country_iso3=="All" | partner_iso3=="All"
drop if country_iso3=="MNT" | partner_iso3=="MNT"
drop if country_iso3=="SER" | partner_iso3=="SER"
drop if country_iso3=="OAS" | partner_iso3=="OAS"
drop if country_iso3=="ROM" | partner_iso3=="ROM"
drop if country_iso3=="BMU" | partner_iso3=="BMU"
drop if country_iso3=="ABW" | partner_iso3=="ABW"

gen pair = cond(country_iso3 < partner_iso3, country_iso3+partner_iso3 , partner_iso3+country_iso3)
sort year pair
egen count_1=count(pair), by(pair)
keep if count_1==18
fillin country_iso3 partner_iso3 year
drop if country_iso3==partner_iso3
save wits_2010-2018_v1.dta, replace

* save the country list
use wits_2010-2018_v1.dta, clear
keep if country_name!=""
duplicates drop country_iso3, force
keep country_iso3 country_name
rename country_iso3 iso3
rename country_name country
save country_info.dta,replace

* construct n*n trade matrix
use wits_2010-2018_v1.dta, clear
drop country_name partner_name
rename country_iso3 iso3
merge m:1 iso3 using country_info.dta
rename country country_name
rename iso3 country_iso3
drop _merge
rename partner_iso3 iso3
merge m:1 iso3 using country_info.dta
rename country partner_name
rename iso3 partner_iso3
drop _merge count_1 _fillin

replace pair = cond(country_iso3 < partner_iso3, country_iso3+partner_iso3 , partner_iso3+country_iso3) if pair==""
replace import=0 if import==.
replace export=0 if export==.
replace trade=0 if trade==.

save wits_2010-2018_for_merge.dta, replace


* +++++++++++++++++++++++++++++++++++++++++++ Sample construction +++++++++++++++++++++++++++++++

* ++++++++++++++++ (1) dataset for n*n gravity model ++++++++++++

* RTA
* - Source: https://www.ewf.uni-bayreuth.de/en/research/RTA-data/index.html
use wits_2010-2018_for_merge.dta, clear
rename country_iso3 exporter
rename partner_iso3 importer
merge m:1 year exporter importer using "rta.dta"
drop if _merge!=3
drop _merge


* distance and other control variables
* - Source: http://www.cepii.fr/CEPII/en/bdd_modele/presentation.asp?id=6
rename exporter iso3_o
rename importer iso3_d
merge m:1 iso3_o iso3_d year using "gravity_cepii.dta", keepusing (distw distcap comlang_off col45 comleg_posttrans contig)
drop if _merge!=3
drop _merge
replace comleg_posttrans=0 if comleg_posttrans==. // for pair PSE & PLW


* GDP
* - Source: https://data.worldbank.org/indicator/NY.GDP.MKTP.CD
rename iso3_o iso3
merge m:1 year iso3 using "gdp_2010-2018.dta"
drop if _merge!=3
drop _merge country
rename gdp country_gdp
rename iso3 country_iso3

rename iso3_d iso3
merge m:1 year iso3 using "gdp_2010-2018.dta"
drop if _merge!=3
drop _merge country
rename gdp partner_gdp
rename iso3 partner_iso3

* BRI
* - Source: https://www.yidaiyilu.gov.cn/gbjg/gbgk/77073.htm
rename country_iso3 iso3
merge m:1 iso3 using "bri_list_new.dta"
drop if _merge==2
gen country_bri=1 if _merge==3 
replace country_bri=1 if iso3=="CHN"
replace country_bri=0 if country_bri==.
replace entry_year=2013 if iso3=="CHN"
drop _merge state_id
rename iso3 country_iso3
gen country_brientry=1 if country_bri==1 &year>=entry_year
replace country_brientry=0 if country_brientry==.
rename entry_year country_entry 

rename partner_iso3 iso3
merge m:1 iso3 using bri_list_new.dta
drop if _merge==2
gen partner_bri=1 if _merge==3 
replace partner_bri=1 if iso3=="CHN"
replace partner_bri=0 if partner_bri==.
replace entry_year=2013 if iso3=="CHN"
drop _merge state_id
rename iso3 partner_iso3
gen partner_brientry=1 if partner_bri==1 &year>=entry_year
replace partner_brientry=0 if partner_brientry==.
rename entry_year partner_entry


*+++++ Necessary variables ++++++
gen ln_import=ln(import)
gen ln_export=ln(export)
gen ln_trade=ln(trade)
gen ln_cty_gdp=ln(country_gdp)
gen ln_ptn_gdp=ln(partner_gdp)
gen ln_distcap=ln(distcap)
gen ln_distw=ln(distw)

la var rta "RTA"
la var import "Import"
la var export "Export"
la var trade "Trade"
la var ln_import "ln (import)"
la var ln_export "ln (export)"
la var ln_trade "ln (trade)"
la var ln_cty_gdp "ln (country's GDP)"
la var ln_ptn_gdp "ln (partner's GDP)"
la var ln_distw "ln_distw"
la var ln_distcap "ln (captial distance)"
la var contig "Contiguity"
la var col45 "col45"
la var comlang_off "comlang_off"
la var comleg_posttrans "comleg_posttrans"
la var country_bri "country_bri"
la var partner_bri "partner_bri"
la var country_brientry "country_brientry"
la var partner_brientry "partner_brientry"
la var country_entry "country's entry year"
la var partner_entry "partner's entry year"

* ++++++++++++++++++++ samples for regressions ++++++++++++++++
* all countries
save all_reg_v1.dta, replace

* all countries excluding China
use all_reg_v1.dta, clear
drop if country_iso3=="CHN" | partner_iso3=="CHN"
save all_reg_without_chn_v1.dta, replace




* ++++++++++++++++ (2) dataset for regressions: trade with China and ROW ++++++++++++

* ++++++++ bilateral trade with China ++++++++
use all_reg_v1.dta, clear
keep if country_iso3=="CHN" | partner_iso3=="CHN"
save all_reg_only_chn_v1.dta, replace


* ++++++++ trade with ROW (excluding China) +++++++
use wits_all_2010-2018.dta, clear

keep if partner_iso3=="All" | partner_iso3=="CHN"
drop if country_iso3=="All" & partner_iso3=="CHN"
drop if country_iso3=="CHN" & partner_iso3=="All"
drop if country_iso3=="CHN" | country_iso3=="All"

gen import_world=import if partner_iso3=="All"
gen export_world=export if partner_iso3=="All"
gen trade_world=trade if partner_iso3=="All"
gen import_chn=import if partner_iso3=="CHN"
gen export_chn=export if partner_iso3=="CHN"
gen trade_chn=trade if partner_iso3=="CHN"

collapse (sum)import_world (sum)export_world (sum)trade_world (sum)import_chn (sum)export_chn (sum)trade_chn, by (year country_iso3 country_name)

gen import_row=import_world-import_chn
gen export_row=export_world-export_chn
gen trade_row=trade_world-trade_chn

* replicate country list
rename country_iso3 iso3
merge m:1 iso3 using "country_info.dta"
drop if _merge!=3
keep iso3 country_name year import_row export_row trade_row

* GDP
merge 1:1 year iso3 using "gdp_2010-2018.dta"
drop if _merge!=3
drop _merge

* BRI
merge m:1 iso3 using "bri_list_new.dta"
drop if _merge==2
gen bri=1 if _merge==3 
replace bri=0 if bri==.
drop _merge state_id
gen brientry=1 if bri==1 &year>=entry_year
replace brientry=0 if brientry==.
 
gen ln_gdp=ln(gdp)
gen ln_import_row=ln(import_row)
gen ln_export_row=ln(export_row)
gen ln_trade_row=ln(trade_row)

la var ln_gdp "ln (GDP)"
la var ln_import_row "ln (import from ROW (excluding China))"
la var ln_export_row "ln (export to ROW (excluding China))"
la var ln_trade_row "ln (trade with ROW (excluding China))"
la var bri "BRI"
la var brientry "bri_entry"


save all_reg_row_without_chn.dta, replace
 
 
 
 








