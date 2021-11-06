

* ++++++++++++++++++++ (1) gravity model: bilateral trade flows among all sample countries (exluding China): 135 countries +++++++++++++++++++++++

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

encode pair, generate(country_pair)

eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i i.F_*, cluster(country_pair)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j i.F_*, cluster(country_pair)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij i.F_*, cluster(country_pair)



la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"
la var ln_import "Trade"
la var ln_cty_gdp "Importing country's GDP"
la var ln_ptn_gdp "Exporting country's GDP"

//esttab using im_all_OLS_brientry_alternative_1.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_alternative.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
//eststo clear



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

encode pair, generate(country_pair)

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_i, absorb(F_*) vce(cluster country_pair)
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_j, absorb(F_*) vce(cluster country_pair) 
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij, absorb(F_*) vce(cluster country_pair) 


la var brientry_i "BRI_it"
la var brientry_j "BRI_jt"
la var brientry_ij "BRI_ijt"
la var import "Trade"
la var ln_cty_gdp "Importing country's GDP"
la var ln_ptn_gdp "Exporting country's GDP"
la var ln_import "ln (Trade)"




esttab using gravity_20210422.csv, replace order(brientry_i brientry_j brientry_ij ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans) drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 pr2 aic label

esttab using gravity_20210422.tex, ///
replace order(brientry_i brientry_j brientry_ij ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans) ///
drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 pr2 aic label ///




//esttab using im_all_ppmlhdfe_brientry_alternative.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
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

encode pair, generate(country_pair)


eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lndistc, cluster(country_pair)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lngdp_c, cluster(country_pair)
eststo: reg ln_import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans i.F_* brientry_ij_lngdp_p, cluster(country_pair)

la var brientry_ij_lndistc "BRI_ijt*ln(capital distance)"
la var brientry_ij_lngdp_c "BRI_ijt*ln(country's GDP)"
la var brientry_ij_lngdp_p "BRI_ijt*ln(partner's GDP)"

//esttab using im_all_OLS_brientry_ijt_incremental.csv, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic label
//esttab using im_all_OLS_brientry_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
//eststo clear




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

encode pair, generate(country_pair)

eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lndistc, absorb(F_*) vce(cluster country_pair) 
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_c, absorb(F_*) vce(cluster country_pair) 
eststo: ppmlhdfe import ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans brientry_ij_lngdp_p, absorb(F_*) vce(cluster country_pair) 

la var brientry_ij_lndistc "BRI_ijt*ln(capital distance)"
la var brientry_ij_lngdp_c "BRI_ijt*ln(country's GDP)"
la var brientry_ij_lngdp_p "BRI_ijt*ln(partner's GDP)"
la var import "Trade"
la var ln_cty_gdp "Importing country's GDP"
la var ln_ptn_gdp "Exporting country's GDP"
la var ln_import "ln (Trade)"

esttab using incremental_20210422.csv, replace order(brientry_ij_lndistc brientry_ij_lngdp_c brientry_ij_lngdp_p ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans) drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 pr2 aic label

esttab using incremental_20210422.tex, ///
replace order(brientry_ij_lndistc brientry_ij_lngdp_c brientry_ij_lngdp_p ln_distcap ln_cty_gdp ln_ptn_gdp rta col45 contig comleg_posttrans) ///
drop(*.F_*) nocon star(* 0.10 ** 0.05 *** 0.01) se r2 pr2 aic label ///





esttab using im_all_ppmlhdfe_brientry_ijt_incremental.csv, star(* 0.10 ** 0.05 *** 0.01) se pr2 aic label
//esttab using im_all_ppmlhdfe_brientry_ijt_incremental.rtf, drop(*.F_*) star(* 0.10 ** 0.05 *** 0.01) se r2 aic replace label nogap onecell
eststo clear

