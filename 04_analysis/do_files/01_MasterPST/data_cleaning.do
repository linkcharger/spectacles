
******************************************************************
* Title: Data cleaning - Eye-glasses & Productivity Project
* Author: HP (07/07/2020)
* Last edited by: (07/07/2020) 
******************************************************************

global original "C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets"
global temp 	"C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets\- Hector's work\temp"
global new		"C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets\- Hector's work\new"

* Stamp Tax Datasets

**  ST_analysis_core --> Chris Minns (digitised about 10 years ago from the original ST records)
**  st_1710_1810.dta --> Karine van der Beek (much more complete after 1783 but less information, minor discrepancies with first dta until the 1770s at least)

** PST (Primary, Secondary, Tertiary system of occupational coding)
*https://www.campop.geog.cam.ac.uk/research/occupations/datasets/coding/

{
import excel using "$original\- Hector's work\pst\pstdefinitions.xls", first clear

drop if PSTrecon=="."

rename PSTrecon master_pst

rename Sector sector
rename Group group
rename Section section
rename Occupation occupation

replace master_pst = subinstr(master_pst, " ", "", .)

save "$new\pst_codes.dta", replace
}

**  ST_analysis_core

use "$original\Stamp tax\ST_analysis_core.dta", clear

*master_pst --> 13,607 missings / 333,793 que corresponde a 3,210 etiquetas/nombres de ocupaciones

** Adding countie's latitude/longitude
*Source: http://www.county-borders.co.uk/
{
preserve
import delimited "$original\- Hector's work\counties\counties_uk.csv", varnames(1) clear
rename name master_county_final
save "$new\uk_counties.dta", replace
restore

use "$original\Stamp tax\ST_analysis_core.dta", clear

*master_county_final:

replace master_county="" if master_county=="FOREIGN" | master_county=="Ireland" | master_county=="Scotland" | master_county=="Wales" | master_county=="do[PARENT]" 

replace master_county="Brecknockshire" if master_county=="Brecons"
replace master_county="Caernarfonshire" if master_county=="Caernarvon"
replace master_county="Carmarthenshire" if master_county=="Carmarthanshire"
replace master_county="Fife" if master_county=="Fifeshire"
replace master_county="Glamorgan" if master_county=="Glamorganshire"
replace master_county="Pembrokeshire" if master_county=="Pembroke"
replace master_county="Renfrewshire" if master_county=="Renfrew"

replace master_county="Hampshire" if master_county=="Isle of Wight" // note
replace master_county="Middlesex" if master_county=="London" // note

merge m:1 master_county_final using "$new\uk_counties.dta"
drop if _m==2
drop _m

rename x x_county_master
rename y y_county_master

save "$new\ST_analysis_core_clean.dta.dta", replace

*parent_county_final:

preserve
import delimited "$original\- Hector's work\counties\counties_uk.csv", varnames(1) clear
rename name parent_county_final
save "$new\uk_counties.dta", replace
restore

replace parent_county="" if parent_county=="FOREIGN" | parent_county=="Ireland" | parent_county=="Scotland" | parent_county=="Wales" | parent_county=="do[PARENT]" | parent_county=="Channel Islands and Other Islands around UK" | parent_county=="Westmeath" //(Ireland)

replace parent_county="Brecknockshire" if parent_county=="Brecons"
replace parent_county="Caernarfonshire" if parent_county=="Caernarvon"
replace parent_county="Carmarthenshire" if parent_county=="Carmarthanshire"
*replace parent_county="Fife" if parent_county=="Fifeshire"
replace parent_county="Glamorgan" if parent_county=="Glamorganshire"
replace parent_county="Pembrokeshire" if parent_county=="Pembroke"
*replace parent_county="Renfrewshire" if parent_county=="Renfrew"

replace parent_county="Perthshire" if parent_county=="Perth"

replace parent_county="Hampshire" if parent_county=="Isle of Wight" // note
replace parent_county="Middlesex" if parent_county=="London" // note

*gen clean = strpos(parent_county, "erth")

merge m:1 parent_county_final using "$new\uk_counties.dta"
drop if _m==2
drop _m

rename x x_county_parent
rename y y_county_parent

save "$new\ST_analysis_core_clean.dta", replace
}

** Adding PST labels

use "$new\ST_analysis_core_clean.dta", clear

*drop if mr_occ1_exp==""

replace year="." if year=="no_year"
destring year, replace

replace master_pst = subinstr(master_pst, " ", "", .)

{
/*
*pre-match 
{
preserve

gen comp=.
replace comp=1 if master_pst=="1,2,0,3"
replace comp=1 if master_pst=="1,20,15,1"
replace comp=1 if master_pst=="2,2,3,3"
replace comp=1 if master_pst=="2,20,3,6"
replace comp=1 if master_pst=="2,25,5,1"
replace comp=1 if master_pst=="2,40,1,60"
replace comp=1 if master_pst=="2,41,1,1"
replace comp=1 if master_pst=="2,41,1,60"
replace comp=1 if master_pst=="2,50,4,60"
replace comp=1 if master_pst=="2,60,0,1"
replace comp=1 if master_pst=="2,60,0,60"
replace comp=1 if master_pst=="2,60,1,1"
replace comp=1 if master_pst=="2,60,1,2"
replace comp=1 if master_pst=="2,60,1,60"
replace comp=1 if master_pst=="2,60,1,80"
replace comp=1 if master_pst=="2,60,2,1"
replace comp=1 if master_pst=="2,60,3,1"
replace comp=1 if master_pst=="2,60,3,2"
replace comp=1 if master_pst=="2,60,3,3"
replace comp=1 if master_pst=="2,60,3,4"
replace comp=1 if master_pst=="2,60,3,5"
replace comp=1 if master_pst=="2,60,3,6"
replace comp=1 if master_pst=="2,60,3,60"
replace comp=1 if master_pst=="2,60,3,7"
replace comp=1 if master_pst=="2,62,1,3"
replace comp=1 if master_pst=="2,71,99,80"
replace comp=1 if master_pst=="2,75,1,1"
replace comp=1 if master_pst=="2,75,1,2"
replace comp=1 if master_pst=="2,80,6,4"
replace comp=1 if master_pst=="2,80,8,60"
replace comp=1 if master_pst=="2,80,99,60"
replace comp=1 if master_pst=="3,20,0,60"
replace comp=1 if master_pst=="3,20,1,2"
replace comp=1 if master_pst=="3,20,5,2"
replace comp=1 if master_pst=="3,20,6,1"
replace comp=1 if master_pst=="3,60,1,0"
replace comp=1 if master_pst=="3,60,3,0"
replace comp=1 if master_pst=="3,82,0,1"
replace comp=1 if master_pst=="4,0,1,1"
replace comp=1 if master_pst=="4,0,1,2"
replace comp=1 if master_pst=="4,41,2,1"
replace comp=1 if master_pst=="4,41,2,60"
replace comp=1 if master_pst=="4,50,4,0"
replace comp=1 if master_pst=="4,60,0,1"
replace comp=1 if master_pst=="4,82,0,4"
replace comp=1 if master_pst=="5,1,10,1"
replace comp=1 if master_pst=="5,1,10,2"
replace comp=1 if master_pst=="5,1,2,80"
replace comp=1 if master_pst=="5,1,3,4"
replace comp=1 if master_pst=="5,10,1,2"
replace comp=1 if master_pst=="5,10,1,60"
replace comp=1 if master_pst=="5,10,2,0"
replace comp=1 if master_pst=="5,10,2,1"
replace comp=1 if master_pst=="5,10,2,2"
replace comp=1 if master_pst=="5,10,3,0"
replace comp=1 if master_pst=="5,10,3,1"
replace comp=1 if master_pst=="5,20,4,1"
replace comp=1 if master_pst=="5,30,3,2"
replace comp=1 if master_pst=="5,30,3,3"
replace comp=1 if master_pst=="5,30,6,1"
replace comp=1 if master_pst=="5,30,6,3"
replace comp=1 if master_pst=="5,5,0,1"
replace comp=1 if master_pst=="5,5,99,60"
replace comp=1 if master_pst=="5,60,99,60"
}

keep if comp==1

collapse (mean) circa , by(master_pst mr_occ1_exp)

rename mr_occ1_exp occupation
egen occup_id=group(occupation)

save "$temp\occup_match1.dta", replace

restore
}
*/
}

*use "$new\pst_codes.dta",clear
*egen occup_id=group(occupation) 
*matchit occup_id occupation using "$temp\occup_match1.dta" , idusing(occup_id) txtusing(occupation) over

*Pre-match
{
replace master_pst="1, 2, 0, 2" if mr_occ1_exp=="game keeper"
replace master_pst="1, 2, 0, 2" if mr_occ1_exp=="keeper"
replace master_pst="1,20,50, 0" if mr_occ1_exp=="quarrier"
replace master_pst="1,20,50, 0" if mr_occ1_exp=="quarryman"
replace master_pst="2, 1, 6, 2" if mr_occ1_exp=="chocolate maker"
replace master_pst="2,10, 1, 0" if mr_occ1_exp=="clothier"
replace master_pst="2,10, 1, 1" if mr_occ1_exp=="white clothier"
replace master_pst="2,25, 5, 0" if mr_occ1_exp=="cork cutter"
replace master_pst="2,25, 5, 0" if mr_occ1_exp=="corkcutter"
replace master_pst="2,40, 0, 0" if mr_occ1_exp=="paper stainer"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="copper plate printer"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="copperplate printer"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="letter press printer"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="printer"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="book binder"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="bookbinder"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="copper plate engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="copperplate engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="music engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="plate engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="pocket book maker"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="pocketbook maker"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="pressman"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="seal engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="vellum binder"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="writing engraver"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="diamond cutter"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="lapidar?"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="lapidary"
replace master_pst="2,41, 0, 1" if mr_occ1_exp=="lapidiary"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="blacksmith"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="blacksmth"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="ironsmith"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="jobbing smith"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="master smith"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="smith"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="farrier"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="ferrier"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="horse farrier"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="patten ring maker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="iron maker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="slitter"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="slitter of iron"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="caster"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="fire worker"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="forgeman"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="forger"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="founder"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="furnace man"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="iron founder"
replace master_pst="2,61, 3, 1" if mr_occ1_exp=="ironfounder"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="?armaker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="fine drawer"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="finer"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="finery man"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="hammerman"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="iron plate worker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="iron turner"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="ironplate worker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="ironmaster"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="steel maker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="steel worker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="na?lor"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="nail maker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="nailer"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="nailmaker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="nailor"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="screw filer"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="screw maker"
replace master_pst="2,61, 0, 1" if mr_occ1_exp=="wood screw maker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="needle maker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="needle worker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="needlemaker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="needler"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="needlework"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="pin cleaver"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="pin maker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="pin manufacturer"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="pinmaker"
replace master_pst="2,61, 3, 3" if mr_occ1_exp=="pinner"
replace master_pst="2,61, 3, 4" if mr_occ1_exp=="chain maker"
replace master_pst="2,61, 3, 4" if mr_occ1_exp=="chainmaker"
replace master_pst="2,61, 3, 5" if mr_occ1_exp=="bucket maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="armourer"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gu?maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun barrel filer"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun barrel forger"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun finisher"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun lock filer"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun lock forger"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun lock maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun lock smith"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun smith"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gun stock maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gunmaker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gunsmith"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="gunstock maker"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="pistol finisher"
replace master_pst="2,61, 3, 6" if mr_occ1_exp=="pistol maker"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wire drawer"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wire maker"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wire manufacturer"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wire worker"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wiredrawer"
replace master_pst="2,61, 3, 7" if mr_occ1_exp=="wireworker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="bit maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="bitmaker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="bolt maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="cock founder"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="curb maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="curry comb maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="fender maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="fendermaker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="fire shovel pan maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="frying pan maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="grate maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="hinge maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="hingemaker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="hook maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="jacksmith"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="lorimer"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="mo?ld maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="skewer maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="snaffle maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="spring maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="springer"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="spur maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="spurrier"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="stirrup maker"
replace master_pst="2,65, 2, 0" if mr_occ1_exp=="stove grate maker"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="cutler"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="cutter"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="cuttler"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="fork grinder"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="fork maker"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="forkmaker"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="forksmith"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="spoon maker"
replace master_pst="2,65, 2, 1" if mr_occ1_exp=="working cutler"
replace master_pst="2,62, 1, 2" if mr_occ1_exp=="bell founder"
replace master_pst="2,71, 1, 1" if mr_occ1_exp=="quarter man"
replace master_pst="2,71, 1, 1" if mr_occ1_exp=="quarterman"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="brick burner"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="brick cutter"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="brick maker"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="brickmaker"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="buck maker"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="tile cutter"
replace master_pst="2,75, 0, 0" if mr_occ1_exp=="tilemaker"
replace master_pst="2,80, 6, 2" if mr_occ1_exp=="paper hanger"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="dredger"
replace master_pst="5,50, 2, 1" if mr_occ1_exp=="navigator"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="paver"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="pavie?"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="pavier"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="pavior"
replace master_pst="2,81, 1, 1" if mr_occ1_exp=="paviour"
replace master_pst="2,80, 6, 1" if mr_occ1_exp=="pargeter"
replace master_pst="3, 0, 0, 3" if mr_occ1_exp=="smallware man"
replace master_pst="3, 0, 0, 3" if mr_occ1_exp=="stuff merchant"
replace master_pst="3,20, 1, 1" if mr_occ1_exp=="woollen draper"
replace master_pst="3,20, 5,15" if mr_occ1_exp=="linen draper"
replace master_pst="3,20, 5,15" if mr_occ1_exp=="linen factor"
replace master_pst="3,20, 5,15" if mr_occ1_exp=="linen merchant"
replace master_pst="3,20, 5,15" if mr_occ1_exp=="linnen draper"
replace master_pst="3,20, 5,15" if mr_occ1_exp=="wholesale linen draper"
replace master_pst="3,20, 7, 1" if mr_occ1_exp=="dealer in silk"
replace master_pst="3,20, 7, 1" if mr_occ1_exp=="silk broker"
replace master_pst="3,20, 7, 1" if mr_occ1_exp=="silk mercer"
replace master_pst="3,20, 7, 1" if mr_occ1_exp=="silk merchant"
replace master_pst="3,61, 1, 1" if mr_occ1_exp=="iron merchant"
replace master_pst="3,61, 3, 1" if mr_occ1_exp=="hardware dealer"
replace master_pst="3,58, 1, 0" if mr_occ1_exp=="coal dealer"
replace master_pst="3,58, 1, 0" if mr_occ1_exp=="coal merchant"
replace master_pst="3,58, 1, 0" if mr_occ1_exp=="hoastman"
replace master_pst="3,58, 1, 0" if mr_occ1_exp=="hostman"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="shipkeeper"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="shop keeper"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="shopkeeper"
replace master_pst="4, 0, 0, 2" if mr_occ1_exp=="chandler"
replace master_pst="4,41, 0, 2" if mr_occ1_exp=="book seller"
replace master_pst="4,41, 0, 2" if mr_occ1_exp=="bookseller"
replace master_pst="4,52, 3, 0" if mr_occ1_exp=="music seller"
replace master_pst="4,52, 3, 0" if mr_occ1_exp=="print seller"
replace master_pst="4,50,10, 0" if mr_occ1_exp=="jeweller"
replace master_pst="4,50,10, 0" if mr_occ1_exp=="working jeweller"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="furnishing ironmonger"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="hardware man"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="hardwareman"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="i?onmonger"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="ironmonger"
replace master_pst="4,61, 3, 1" if mr_occ1_exp=="nail ironmonger"
replace master_pst="1,10, 0, 1" if mr_occ1_exp=="turfman"
replace master_pst="5,20, 6, 4" if mr_occ1_exp=="backer"
replace master_pst="5,20, 6, 4" if mr_occ1_exp=="porter"
replace master_pst="6,50, 0, 1" if mr_occ1_exp=="courier"
replace master_pst="6,50, 0, 1" if mr_occ1_exp=="poster"
replace master_pst="2,71, 2, 0" if mr_occ1_exp=="barge master"
replace master_pst="2,71, 2, 0" if mr_occ1_exp=="bargemaster"
replace master_pst="6, 4, 0,10" if mr_occ1_exp=="wharfinger"
replace master_pst="5, 1, 0, 1" if mr_occ1_exp=="innholder"
replace master_pst="5, 1, 0, 1" if mr_occ1_exp=="innkeeper"
replace master_pst="2,15, 1, 0" if mr_occ1_exp=="boot"
replace master_pst="2,80, 6, 0" if mr_occ1_exp=="drawer"
replace master_pst="5, 1, 2, 1" if mr_occ1_exp=="publican"
replace master_pst="5,25, 1, 2" if mr_occ1_exp=="alehouse keeper"
replace master_pst="5, 1, 1, 4" if mr_occ1_exp=="waiter"
replace master_pst="5, 1, 1, 1" if mr_occ1_exp=="victualler"
replace master_pst="5,20, 3, 2" if mr_occ1_exp=="chimney sw?ep"
replace master_pst="5,20, 3, 2" if mr_occ1_exp=="chimney sweep"
replace master_pst="5,20, 3, 2" if mr_occ1_exp=="chimney sweeper"
replace master_pst="5,20, 3, 2" if mr_occ1_exp=="sweep"
replace master_pst="5,20, 3, 2" if mr_occ1_exp=="sweeper"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="accomptant"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="broker"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="coal crimp"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="insurance broker"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="shipbroker"
replace master_pst="5,30, 2, 1" if mr_occ1_exp=="stock broker"
replace master_pst="5,30, 5, 1" if mr_occ1_exp=="auctioneer"
replace master_pst="3, 0, 0, 3" if mr_occ1_exp=="merchant traveller"
replace master_pst="3, 0, 0, 3" if mr_occ1_exp=="traveller"
replace master_pst="5,10, 0, 1" if mr_occ1_exp=="warehouse keeper"
replace master_pst="5,10, 0, 1" if mr_occ1_exp=="warehouse man"
replace master_pst="5,10, 0, 1" if mr_occ1_exp=="warehouseman"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="packer"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="store keeper"
replace master_pst="4, 0, 0, 3" if mr_occ1_exp=="storekeeper"
replace master_pst="5,60, 0, 0" if mr_occ1_exp=="owner"

replace master_pst = subinstr(master_pst, " ", "", .)
}

merge m:1 master_pst using "$new\pst_codes.dta" // 65 more to match
drop if _m==2

save "$new\ST_analysis_core_clean.dta", replace


* st_1710_1810.dta
{
use "$original\Stamp tax\st_1710_1810.dta", clear

keep if year>=1710 & year<=1810 // 511,774 obs


** missings
{
*new_obs 				id
*period  				1,2
*year	 				1710-1810
*apprentice_surname		54 miss
*app_forename			767 miss
*master_surname			1173 miss
*master_forename		259 miss
*master_location		9,519 miss
*location_1				336,869 miss
*county					19,344 miss
*trade1					9,530 miss
*tuition				7,138 miss
}

** duplicates:
{ 
*same apprentice with >1 master per year? (1)
*app
duplicates t apprentice_surname app_forename year, gen(dup1)
*app
duplicates t master_surname master_forename year, gen(dup2)
}	

** job names

*uniformization
drop if trade1=="" // (2)
gen trade_clean=lower(trade1)
strip trade_clean, of("¿?,.!-_*()") gen(temp)
replace trade_clean=temp
drop temp
replace trade_clean=stritrim(trade_clean)

{
preserve
collapse (sum) tuition, by(trade_clean)
keep if _n<=3693
count
egen idnum=group(trade_clean)
save "$temp\jobs1.dta", replace
restore

preserve
collapse (sum) tuition, by(trade_clean)
keep if _n>3693
count
egen idnum=group(trade_clean)
save "$temp\jobs2.dta", replace
restore

use "$temp\jobs1.dta", clear
matchit idnum trade_clean using "$temp\jobs2.dta" , idusing(idnum) txtusing(trade_clean)

* Adding HISCO system (Historical International Classification of Occupations)
* https://historyofwork.iisg.nl/coding.php?m=newreg
* https://github.com/cedarfoundation/hisco

}


}


** HISCO
{
import delimited "$original\hisco\hisco.csv", varnames(1) clear

gen x=1
rename en_hisco_tex hisco_name 
rename hisco hisco_code

collapse (mean) x, by(hisco_name hisco_code)

duplicates drop hisco_name, force
drop if hisco_name==""
drop x

tostring hisco_code, gen(hisco_st)
replace hisco_st="0"+hisco_st if hisco_code<10000 & hisco_code>0

gen hisco1=substr(hisco_st,1,1)

{
gen hisco1_name=""
replace hisco1_name="PROFESSIONAL, TECHNICAL AND RELATED WORKERS" if hisco1=="0"
replace hisco1_name="PROFESSIONAL, TECHNICAL AND RELATED WORKERS" if hisco1=="1"
replace hisco1_name="ADMINISTRATIVE AND MANAGERIAL WORKERS" if hisco1=="2"
replace hisco1_name="CLERICAL AND RELATED WORKERS" if hisco1=="3"
replace hisco1_name="SALES WORKERS" if hisco1=="4"
replace hisco1_name="SERVICE WORKERS" if hisco1=="5"
replace hisco1_name="AGRICULTURAL, ANIMAL HUSBANDRY AND FORESTRY WORKERS, FISHERMEN AND HUNTERS" if hisco1=="6"
replace hisco1_name="PRODUCTION AND RELATED WORKERS, TRANSPORT EQUIPMENT OPERATORS AND LABOURERS" if hisco1=="7"
replace hisco1_name="PRODUCTION AND RELATED WORKERS, TRANSPORT EQUIPMENT OPERATORS AND LABOURERS" if hisco1=="8"
replace hisco1_name="PRODUCTION AND RELATED WORKERS, TRANSPORT EQUIPMENT OPERATORS AND LABOURERS" if hisco1=="9"
}

gen hisco2=substr(hisco_st,1,2)

{
gen hisco2_name=""
replace hisco2_name="Physical Scientists and Related Technicians" if hisco2=="01"
replace hisco2_name="Architects, Engineers and Related Technicians" if hisco2=="02"
replace hisco2_name="Architects, Engineers and Related Technicians" if hisco2=="03"
replace hisco2_name="Aircraft and Ships' Officers" if hisco2=="04"
replace hisco2_name="Life Scientists and Related Technicians" if hisco2=="05"
replace hisco2_name="Medical, Dental, Veterinary and Related Workers" if hisco2=="06"
replace hisco2_name="Medical, Dental, Veterinary and Related Workers" if hisco2=="07"
replace hisco2_name="Statisticians, Mathematicians, Systems Analysts and Related Technicians" if hisco2=="08"
replace hisco2_name="Economists" if hisco2=="09"
replace hisco2_name="Accountants" if hisco2=="11"
replace hisco2_name="Jurists" if hisco2=="12"
replace hisco2_name="Teachers" if hisco2=="13"
replace hisco2_name="Workers in Religion" if hisco2=="14"
replace hisco2_name="Authors, Journalists and Related Writers" if hisco2=="15"
replace hisco2_name="Sculptors, Painters, Photographers and Related Creative Artists" if hisco2=="16"
replace hisco2_name="Composers and Performing Artists" if hisco2=="17"
replace hisco2_name="Athletes, Sportsmen and Related Workers" if hisco2=="18"
replace hisco2_name="Professional, Technical and Related Workers Not Elsewhere Classified" if hisco2=="19"
replace hisco2_name="Legislative Officials and Government Administrators" if hisco2=="20"
replace hisco2_name="Managers" if hisco2=="21"
replace hisco2_name="Supervisors, Foremen and Inspectors" if hisco2=="22"
replace hisco2_name="Clerical and Related Workers, Specialisation Unknown" if hisco2=="30"
replace hisco2_name="Government Executive Officials" if hisco2=="31"
replace hisco2_name="Stenographers, Typists and Card‑ and Tape‑Punching Machine Operators" if hisco2=="32"
replace hisco2_name="Bookkeepers, Cashiers and Related Workers" if hisco2=="33"
replace hisco2_name="Computing Machine Operators" if hisco2=="34"
replace hisco2_name="Transport Conductors" if hisco2=="36"
replace hisco2_name="Mail Distribution Clerks" if hisco2=="37"
replace hisco2_name="Telephone and Telegraph Operators" if hisco2=="38"
replace hisco2_name="Clerical and Related Workers Not Elsewhere Classified" if hisco2=="39"
replace hisco2_name="Working Proprietors (Wholesale and Retail Trade)" if hisco2=="41"
replace hisco2_name="Buyers" if hisco2=="42"
replace hisco2_name="Technical Salesmen, Commercial Travellers and Manufacturers Agents" if hisco2=="43"
replace hisco2_name="Insurance Real Estate, Securities and Business Services Salesmen and Auctioneers" if hisco2=="44"
replace hisco2_name="Sales Workers Not Elsewhere Classified" if hisco2=="45"
replace hisco2_name="Working Proprietors (Catering, Lodging and Leisure Services)" if hisco2=="51"
replace hisco2_name="Cooks, Waiters, Bartenders and Related Workers" if hisco2=="53"
replace hisco2_name="Maids and Related Housekeeping Service Workers Not Elsewhere Classified" if hisco2=="54"
replace hisco2_name="Building Caretakers, Charworkers, Cleaners and Related Workers" if hisco2=="55"
replace hisco2_name="Launderers, Dry-Cleaners and Pressers" if hisco2=="56"
replace hisco2_name="Hairdressers, Barbers, Beauticians and Related Workers" if hisco2=="57"
replace hisco2_name="Protective Service Workers" if hisco2=="58"
replace hisco2_name="Service Workers Not Elsewhere Classified" if hisco2=="59"
replace hisco2_name="Farmers" if hisco2=="61"
replace hisco2_name="Agricultural and Animal Husbandry Workers" if hisco2=="62"
replace hisco2_name="Forestry Workers" if hisco2=="63"
replace hisco2_name="Fishermen, Hunters and Related Workers" if hisco2=="64"
replace hisco2_name="Miners, Quarrymen, Well Drillers and Related Workers" if hisco2=="71"
replace hisco2_name="Metal Processors" if hisco2=="72"
replace hisco2_name="Wood Preparation Workers and Paper Makers" if hisco2=="73"
replace hisco2_name="Chemical Processors and Related Workers" if hisco2=="74"
replace hisco2_name="Spinners, Weavers, Knitters, Dyers and Related Workers" if hisco2=="75"
replace hisco2_name="Tanners, Fellmongers and Pelt Dressers" if hisco2=="76"
replace hisco2_name="Food and Beverage Processors" if hisco2=="77"
replace hisco2_name="Tobacco Preparers and Tobacco Product Makers" if hisco2=="78"
replace hisco2_name="Tailors, Dressmakers, Sewers, Upholsterers and Related Workers" if hisco2=="79"
replace hisco2_name="Shoemakers and Leather Goods Makers" if hisco2=="80"
replace hisco2_name="Cabinetmakers and Related Woodworkers" if hisco2=="81"
replace hisco2_name="Stone Cutters and Carvers" if hisco2=="82"
replace hisco2_name="Blacksmiths, Toolmakers and Machine Tool Operators" if hisco2=="83"
replace hisco2_name="Machinery Fitters, Machine Assemblers and Precision-Instrument Makers (except Electrical)" if hisco2=="84"
replace hisco2_name="Electrical Fitters and Related Electrical and Electronics Workers" if hisco2=="85"
replace hisco2_name="Broadcasting Station and Sound Equipment Operators and Cinema Projectionists" if hisco2=="86"
replace hisco2_name="Plumbers, Welders, Sheet Metal and Structural Metal Preparers and Erectors" if hisco2=="87"
replace hisco2_name="Jewellery and Precious Metal Workers" if hisco2=="88"
replace hisco2_name="Glass Formers, Potters and Related Workers" if hisco2=="89"
replace hisco2_name="Rubber and Plastics Product Makers" if hisco2=="90"
replace hisco2_name="Paper and Paperboard Products Makers" if hisco2=="91"
replace hisco2_name="Printers and Related Workers" if hisco2=="92"
replace hisco2_name="Painters" if hisco2=="93"
replace hisco2_name="Production and Related Workers Not Elsewhere Classified" if hisco2=="94"
replace hisco2_name="Bricklayers, Carpenters and Other Construction Workers" if hisco2=="95"
replace hisco2_name="Stationary Engine and Related Equipment Operators" if hisco2=="96"
replace hisco2_name="Material Handling and Related Equipment Operators, Dockers and Freight Handlers" if hisco2=="97"
replace hisco2_name="Transport Equipment Operators" if hisco2=="98"
replace hisco2_name="Labourers Not Elsewhere Classified" if hisco2=="99"
}

gen hisco3=substr(hisco_st,3,3)

drop hisco_st
sort hisco_code
rename hisco_name hisco3_name

save "$new\hisco_labels.dta", replace
}


** OCCUPATION NAMES

**  ST_analysis_core

use "$original\Stamp tax\ST_analysis_core.dta", clear

gen x=1
collapse (mean) x, by(master_pst mr_occ1_exp)

drop if master_pst!=""
drop if mr_occ==""

rename mr_occup occupation_name
sort occupation_name
egen occupation_id=group(occupation_name)


preserve
use "$new\pst_codes.dta", clear

replace occupation=section if occupation=="" & section!=""
replace occupation=group if occupation=="" & section==""
replace occupation=sector if occupation=="" & section=="" & group==""

rename occupation occupation_name
sort occupation
egen occupation_id=group(occupation_name)

save "$new\pst_codes_match.dta", replace
restore

matchit occupation_id occupation_name using Y.dta, idusing(occupation_id) txtusing(occupation_name) override
