
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



* ppml (without fe)
use all_reg_without_chn_v1.dta, clear

eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans
esttab using im_all_ppml_no_fe_benchmark.csv, star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_ppml_no_fe_benchmark.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear


* +++++  main regression +++++++

* OLS
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

esttab using im_all_OLS_brientry_ijt_1.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear




* ppmlhdfe
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

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta col45 contig comleg_posttrans, absorb(F_*)

la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"

esttab using im_all_ppmlhdfe_brientry_ijt.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_brientry_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear





* ppml (without fe)
use all_reg_without_chn_v1.dta, clear

gen brientry_i=1 if country_brientry==1 & partner_brientry==0
replace brientry_i=0 if brientry_i==.
gen brientry_j=1 if country_brientry==0 & partner_brientry==1
replace brientry_j=0 if brientry_j==.
gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp brientry_i brientry_j brientry_ij rta col45 contig comleg_posttrans

la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"

esttab using im_all_ppml_no_fe_brientry.csv, star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_ppml_no_fe_brientry.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear






* ++++ alternative regression: time-invariant BRI ++++

* OLS
use all_reg_without_chn_v1.dta, clear

gen bri_i=1 if country_bri==1 & partner_bri==0
replace bri_i=0 if bri_i==.
gen bri_j=1 if country_bri==0 & partner_bri==1
replace bri_j=0 if bri_j==.
gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta i.F_*, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta col45 contig comleg_posttrans i.F_*, vce(robust)

la var bri_i "BRI_i"
la var bri_j "BRI_j"
la var bri_ij "BRI_ij"

esttab using im_all_OLS_bri_ijt.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_bri_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear


/*
* ppmlhdfe
use all_reg_without_chn_v1.dta, clear

gen bri_i=1 if country_bri==1 & partner_bri==0
replace bri_i=0 if bri_i==.
gen bri_j=1 if country_bri==0 & partner_bri==1
replace bri_j=0 if bri_j==.
gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta col45 contig comleg_posttrans, absorb(F_*)

la var bri_i "BRI_i"
la var bri_j "BRI_j"
la var bri_ij "BRI_ij"

esttab using im_all_ppmlhdfe_bri_ijt.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_bri_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear

*/
// note: 2 variables omitted because of collinearity: bri_j bri_ij


* ppml
use all_reg_without_chn_v1.dta, clear

gen bri_i=1 if country_bri==1 & partner_bri==0
replace bri_i=0 if bri_i==.
gen bri_j=1 if country_bri==0 & partner_bri==1
replace bri_j=0 if bri_j==.
gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp bri_i bri_j bri_ij rta col45 contig comleg_posttrans

la var bri_i "BRI_i"
la var bri_j "BRI_j"
la var bri_ij "BRI_ij"

esttab using im_all_ppml_no_fe_bri.csv, star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_ppml_no_fe_bri.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear










* +++++++++++++ (2) gravity model: bilateral trade flows among all sample countries (exluding China) --- incremental effects: 135 countries +++++++++++++++

* +++++  main regression +++++++

* OLS
use all_reg_without_chn_v1.dta, clear

gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

gen brientry_ij_lndistc=brientry_ij*ln_distcap
gen brientry_ij_lngdp_c=brientry_ij*ln_cty_gdp
gen brientry_ij_lngdp_p=brientry_ij*ln_ptn_gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lndistc, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lngdp_c, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lngdp_p, vce(robust)

la var brientry_ij_lndistc "BRI_ijt*ln(capital distance)"
la var brientry_ij_lngdp_c "BRI_ijt*ln(country's GDP)"
la var brientry_ij_lngdp_p "BRI_ijt*ln(partner's GDP)"

esttab using im_all_OLS_brientry_ijt_incremental.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear




* ppmlhdfe
use all_reg_without_chn_v1.dta, clear

gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

gen brientry_ij_lndistc=brientry_ij*ln_distcap
gen brientry_ij_lngdp_c=brientry_ij*ln_cty_gdp
gen brientry_ij_lngdp_p=brientry_ij*ln_ptn_gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lndistc, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_c, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_p, absorb(F_*)

la var brientry_ij_lndistc "BRI_ijt*ln(capital distance)"
la var brientry_ij_lngdp_c "BRI_ijt*ln(country's GDP)"
la var brientry_ij_lngdp_p "BRI_ijt*ln(partner's GDP)"

esttab using im_all_ppmlhdfe_brientry_ijt_incremental.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_brientry_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear





* ppml (without fe)
use all_reg_without_chn_v1.dta, clear

gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

gen brientry_ij_lndistc=brientry_ij*ln_distcap
gen brientry_ij_lngdp_c=brientry_ij*ln_cty_gdp
gen brientry_ij_lngdp_p=brientry_ij*ln_ptn_gdp

eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lndistc
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_c
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_p

la var brientry_ij_lndistc "BRI_ijt*ln(capital distance)"
la var brientry_ij_lngdp_c "BRI_ijt*ln(country's GDP)"
la var brientry_ij_lngdp_p "BRI_ijt*ln(partner's GDP)"

esttab using im_all_ppml_no_fe_brientry_incremental.csv, star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_ppml_no_fe_brientry_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear





* ++++ alternative regression: time-invariant BRI ++++

* OLS
use all_reg_without_chn_v1.dta, clear

gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

gen bri_ij_lndistc=bri_ij*ln_distcap
gen bri_ij_lngdp_c=bri_ij*ln_cty_gdp
gen bri_ij_lngdp_p=bri_ij*ln_ptn_gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* bri_ij_lndistc, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* bri_ij_lngdp_c, vce(robust)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* bri_ij_lngdp_p, vce(robust)

la var bri_ij_lndistc "BRI_ij*ln(capital distance)"
la var bri_ij_lngdp_c "BRI_ij*ln(country's GDP)"
la var bri_ij_lngdp_p "BRI_ij*ln(partner's GDP)"

esttab using im_all_OLS_bri_ijt_incremental.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_bri_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear



* ppmlhdfe
use all_reg_without_chn_v1.dta, clear

gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

gen bri_ij_lndistc=bri_ij*ln_distcap
gen bri_ij_lngdp_c=bri_ij*ln_cty_gdp
gen bri_ij_lngdp_p=bri_ij*ln_ptn_gdp

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3
xi,pre(F_d_) i.partner_iso3

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lndistc, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lngdp_c, absorb(F_*)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lngdp_p, absorb(F_*)

la var bri_ij_lndistc "BRI_ij*ln(capital distance)"
la var bri_ij_lngdp_c "BRI_ij*ln(country's GDP)"
la var bri_ij_lngdp_p "BRI_ij*ln(partner's GDP)"

esttab using im_all_ppmlhdfe_bri_ijt_incremental.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_bri_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear




* ppml (without fe)
use all_reg_without_chn_v1.dta, clear

gen bri_ij=1 if country_bri==1 & partner_bri==1
replace bri_ij=0 if bri_ij==.

gen bri_ij_lndistc=bri_ij*ln_distcap
gen bri_ij_lngdp_c=bri_ij*ln_cty_gdp
gen bri_ij_lngdp_p=bri_ij*ln_ptn_gdp

eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lndistc
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lngdp_c
eststo: ppml import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans bri_ij_lngdp_p

la var bri_ij_lndistc "BRI_ij*ln(capital distance)"
la var bri_ij_lngdp_c "BRI_ij*ln(country's GDP)"
la var bri_ij_lngdp_p "BRI_ij*ln(partner's GDP)"

esttab using im_all_ppml_no_fe_bri_incremental.csv, star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_ppml_no_fe_bri_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear












* ++++++++++++++++++++++++++ (3) regression: trade with ROW (exluding China): 135 countries +++++++++++++++++++++++++++++

* bri
use all_reg_row_without_chn.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_i_) i.iso3

eststo: reg ln_import_row bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row bri ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row bri ln_gdp i.F_*, vce(robust)

esttab using im_all_OLS_row_bri.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_row_bri.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear



* brientry
use all_reg_row_without_chn.dta, clear

xi,pre(F_t_) i.year
xi,pre(F_i_) i.iso3

eststo: reg ln_import_row brientry ln_gdp i.F_*, vce(robust)
eststo: reg ln_export_row brientry ln_gdp i.F_*, vce(robust)
eststo: reg ln_trade_row brientry ln_gdp i.F_*, vce(robust)

esttab using im_all_OLS_row_brientry.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_row_brientry.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear







/* not finished yet

* ++++++++++++++++++++++++++ (4) regression: trade with China+++++++++++++++++++++++++++++

* ++++ 1. bri + OLS ++++
use all_reg_only_chn_v1.dta, clear
keep if partner_iso3=="CHN"

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3

eststo: reg ln_import country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta i.F_*, vce(robust)
eststo: reg ln_export country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta i.F_*, vce(robust)
eststo: reg ln_trade country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta i.F_*, vce(robust)

la var ln_ptn_gdp "ln (China's GDP)"

esttab using im_all_OLS_chn_bri.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_chn_bri.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear



* ++++ 2. bri + ppml ++++
use all_reg_only_chn_v1.dta, clear
keep if partner_iso3=="CHN"

xi,pre(F_t_) i.year
xi,pre(F_o_) i.country_iso3

eststo: ppml import country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans F_*
eststo: ppml import country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_*
eststo: ppml import country_bri ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_*
esttab using im_all_ppmlhdfe_benchmark_ijt.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_benchmark_ijt.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear
































