* ++++++++++++++++++ Trade with ROW ++++++++++++++++++++
* All countries
use all_reg_row_without_chn.dta, clear
gen briyear=1 if year>=2013
replace briyear=0 if briyear==.
gen post_did=briyear*bri

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group

eststo: reg ln_import_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row post_did briyear bri ln_gdp i.F_*, vce(robust)

esttab using all_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear


* Low income countries
use all_reg_row_without_chn.dta, clear
gen briyear=1 if year>=2017
replace briyear=0 if briyear==.
gen post_did=briyear*bri
keep if income_group=="Low income"
xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income

eststo: reg ln_import_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row post_did briyear bri ln_gdp i.F_*, vce(robust)

esttab using low_income_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear


* Lower middle income countries
use all_reg_row_without_chn.dta, clear
gen briyear=1 if year>=2015
replace briyear=0 if briyear==.
gen post_did=briyear*bri
keep if income_group=="Lower middle income"
xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income

eststo: reg ln_import_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row post_did briyear bri ln_gdp i.F_*, vce(robust)

esttab using lower_middle_income_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear


* Upper middle income countries
use all_reg_row_without_chn.dta, clear
gen briyear=1 if year>=2014
replace briyear=0 if briyear==.
gen post_did=briyear*bri
keep if income_group=="Upper middle income"
xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income

eststo: reg ln_import_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row post_did briyear bri ln_gdp i.F_*, vce(robust)

esttab using upper_middle_income_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear



*+++++++++++++++++++++++++++++++++++++++++++++ significant combination +++++++++++++++++++++++++++++++++
use bri_row_bri_without_chn.dta, clear
gen briyear=1 if year>=2013
replace briyear=0 if briyear==.
gen post_did=briyear*bri

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
xi,pre(F_r_) i.region
xi,pre(F_i_) i.income_group

eststo: reg ln_import_bri post_did ln_cty_gdp i.F_*, vce(robust)
eststo: reg ln_export_bri post_did ln_cty_gdp i.F_*, vce(robust)
eststo: reg ln_trade_bri post_did ln_cty_gdp i.F_*, vce(robust)

esttab using bri_OLS_post_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



use bri_row_bri_without_chn.dta, clear
gen briyear=1 if year>=2013
replace briyear=0 if briyear==.
gen post_did=briyear*bri

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
xi,pre(F_r_) i.region
xi,pre(F_i_) i.income_group

eststo: reg ln_import_bri country_brientry ln_cty_gdp i.F_*, vce(robust)
eststo: reg ln_export_bri country_brientry ln_cty_gdp i.F_*, vce(robust)
eststo: reg ln_trade_bri country_brientry ln_cty_gdp i.F_*, vce(robust)

esttab using bri_OLS_brientry_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear




* Trade share as dependent variable
use all_reg_row_without_chn.dta, clear
egen world_import=sum(import_row), by (year)
egen world_export=sum(export_row), by (year)
egen world_total=sum(trade_row), by (year)
gen import_share=import_row/world_import*100
gen export_share=export_row/world_export*100
gen trade_share=trade_row/world_total*100


gen briyear=1 if year>=2013
replace briyear=0 if briyear==.
gen post_did=briyear*bri

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group

eststo: reg import_share post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg export_share post_did briyear bri ln_gdp i.F_*, vce(robust)
eststo: reg trade_share post_did briyear bri ln_gdp i.F_*, vce(robust)

esttab using all_share_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear





use bri_row_bri_without_chn.dta, clear
gen importgdp_ratio=total_import/country_gdp
gen exportgdp_ratio=total_export/country_gdp
gen tradegdp_ratio=total_trade/country_gdp

gen briyear=1 if year>=2013
replace briyear=0 if briyear==.
gen post_did=briyear*bri
encode iso3, generate(country)

xi,pre(F_t_) i.year
//xi,pre(F_o_) i.iso3
xi,pre(F_r_) i.region
xi,pre(F_i_) i.income_group
//xi,pre(F_c_) i.country#i.year

//eststo: reghdfe importgdp_ratio country_brientry, absorb(i.F_* i.country#i.year)
eststo: reg importgdp_ratio country_brientry, i.F_* i.country#i.year
eststo: reg exportgdp_ratio country_brientry i.F_*, vce(robust)
eststo: reg tradegdp_ratio country_brientry  i.F_*, vce(robust)

esttab using all_OLS_row_did.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear





