
* - Version: Stata/SE 16.0
* - Pakages: ppml, ppmlhdfe, estout


* ++++++++++++++++++++ (1) gravity model: bilateral trade flows among all sample countries (exluding China): 135 countries +++++++++++++++++++++++

* +++++ benchmark regression ++++++++

* OLS
use all_reg_without_chn_v1.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_*, vce(robust)

esttab using im_all_OLS_benchmark_ijt.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_benchmark_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear


* ppmlhdfe
use all_reg_without_chn_v1.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans, absorb(F_*)
esttab using im_all_ppmlhdfe_benchmark_ijt.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_benchmark_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear




* +++++  main regression +++++++

* OLS: brientry_i brientry_j brientry_ij
use all_reg_without_chn_v1.dta, clear

gen brientry_i=1 if country_brientry==1 & partner_brientry==0
replace brientry_i=0 if brientry_i==.
gen brientry_j=1 if country_brientry==0 & partner_brientry==1
replace brientry_j=0 if brientry_j==.
gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta col45 contig comleg_posttrans i.F_*, vce(robust)

la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"

esttab using im_all_OLS_brientry_ijt.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear







* OLS
use all_reg_without_chn_v1.dta, clear

gen brientry_i=1 if country_brientry==1
replace brientry_i=0 if brientry_i==.
gen brientry_j=1 if partner_brientry==1
replace brientry_j=0 if brientry_j==.
gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i brientry_ij i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j brientry_ij i.F_*, vce(robust)



la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"

esttab using im_all_OLS_brientry_alternative.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_alternative.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear







* ppmlhdfe
use all_reg_without_chn_v1.dta, clear

gen brientry_i=1 if country_brientry==1
replace brientry_i=0 if brientry_i==.
gen brientry_j=1 if partner_brientry==1
replace brientry_j=0 if brientry_j==.
gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i brientry_ij, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j brientry_ij, absorb(F_*)


la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"

esttab using im_all_ppmlhdfe_brientry_alternative.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_brientry_alternative.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear













