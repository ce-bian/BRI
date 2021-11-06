
* gravity
use all_reg_without_chn_v1.dta, clear

gen brientry_i=1 if country_brientry==1
replace brientry_i=0 if brientry_i==.
gen brientry_j=1 if partner_brientry==1
replace brientry_j=0 if brientry_j==.
gen brientry_ij=1 if country_brientry==1 & partner_brientry==1
replace brientry_ij=0 if brientry_ij==.

estpost sum brientry_i brientry_j brientry_ij import distcap country_gdp partner_gdp rta col45 contig comleg_posttrans
est store a

esttab a using desc.tex, replace ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") label nonumber f noobs alignment(S) booktabs
eststo clear



* DID
use "D:\BIAN CE\BRI_paper\BRI\gravity\Regression_gravity\all_reg_row_without_chn.dta", clear

estpost sum import_row export_row brientry gdp
est store a

esttab a using desc_1.tex, replace ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") label nonumber f noobs alignment(S) booktabs
eststo clear



use "D:\BIAN CE\BRI_paper\BRI\gravity\Regression_gravity\all_reg_row.dta", clear
estpost sum import_row export_row brientry gdp
est store b

esttab b using desc_2.tex, replace ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") label nonumber f noobs alignment(S) booktabs
eststo clear





use "D:\BIAN CE\BRI_paper\BRI\gravity\Regression_gravity\all_reg_row_without_chn.dta", clear

duplicates drop country_name bri entry_year,force
gen BRI="yes" if bri==1
keep country_name BRI entry_year
sort country_name
order(country_name BRI entry_year )

//texsave using desc_3.tex

