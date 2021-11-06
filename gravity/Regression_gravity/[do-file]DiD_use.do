* All countries
use all_reg_row_without_chn.dta, clear


xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group

eststo: reg ln_import_row brientry ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row brientry ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row brientry ln_gdp i.F_*, vce(robust)

esttab using all_OLS_row_did_brientry.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
eststo clear

* parallel test
gen period = year - entry_year
forvalues i = 5(-1)1{
	gen pre_`i' = (period == - `i' & bri == 1)
	}

gen current = (period == 0 & bri == 1)

forvalues j = 1(1)5{
	gen post_`j' = (period == `j' & bri == 1)
	}

//import
reg  ln_import_row pre_* current post_* ln_gdp i.F_*, vce(robust)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(95) title("Imports from the ROW (excluding China)")
//export
reg  ln_export_row pre_* current post_* ln_gdp i.F_*, vce(robust)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(95) title("Exports to the ROW (excluding China)")
//total
reg  ln_trade_row pre_* current post_* ln_gdp i.F_*, vce(robust)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(95) title("Total trade with the ROW (excluding China)")









* BRI countries
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
















