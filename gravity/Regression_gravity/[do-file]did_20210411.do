* All countries
* dependent variable: trade
use all_reg_row.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group
encode iso3, generate(country)
eststo: reg ln_import_row brientry ln_gdp i.F_*, cluster(country)
eststo: reg ln_export_row brientry ln_gdp i.F_*,cluster(country)

/*
esttab using all_OLS_row_did_brientry_1.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
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
reg  ln_import_row pre_* current post_* ln_gdp i.F_*, cluster(country)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(90) title("Imports from the ROW")
*/


* dependent variable: trade/gdp

use all_reg_row.dta, clear
gen importtogdp=import_row/gdp
gen exporttogdp=export_row/gdp
gen tradetogdp=trade_row/gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group
encode iso3, generate(country)
eststo: reg importtogdp brientry i.F_*, cluster(country)
eststo: reg exporttogdp brientry i.F_*,cluster(country)
la var importtogdp "Imports to GDP ratio"
la var exporttogdp "Exports to GDP ratio"
/*
esttab using all_OLS_row_did_brientry_openness.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label replace
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
reg importtogdp pre_* current post_* i.F_*, cluster(country)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(90) title("Imports from the ROW/GDP, 90% level")

//export
reg exporttogdp pre_* current post_* i.F_*, cluster(country)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(90) title("Exports from the ROW/GDP, 90% level")

//trade
reg tradetogdp pre_* current post_* i.F_*, cluster(country)
est sto reg
coefplot reg, keep(pre_* current post_*) vertical recast(connect) yline(0) levels(90) title("Trade with the ROW/GDP, 90% level")

*/


* ++++++++++++++ excluding china +++++++++++++++++
use all_reg_row_without_chn.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group
encode iso3, generate(country)
eststo: reg ln_import_row brientry ln_gdp i.F_*, cluster(country)
eststo: reg ln_export_row brientry ln_gdp i.F_*,cluster(country)



use all_reg_row_without_chn.dta, clear
gen importtogdp=import_row/gdp
gen exporttogdp=export_row/gdp
gen tradetogdp=trade_row/gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.iso3
//xi,pre(F_r_) i.region
//xi,pre(F_i_) i.income_group
encode iso3, generate(country)
eststo: reg importtogdp brientry i.F_*, cluster(country)
eststo: reg exporttogdp brientry i.F_*,cluster(country)

la var importtogdp "Imports to GDP ratio"
la var exporttogdp "Exports to GDP ratio"


esttab using did.csv, ///
replace drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 aic label ///
esttab using did.tex, ///
replace drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 aic label ///



