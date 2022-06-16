
******************************************************************
* Title: Data cleaning - Eye-glasses & Productivity Project
* Author: HP (04/08/2020)
* Last edited by: (04/08/2020) 
******************************************************************

global original "C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets"
global temp 	"C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets\- Hector's work\temp"
global new		"C:\Users\hpc42\Dropbox\- Eye glasses and productivity\Datasets\- Hector's work\new"

**  ST_analysis_core --> Chris Minns (digitised about 10 years ago from the original ST records)
**  st_1710_1810.dta --> Karine van der Beek (much more complete after 1783 but less information, minor discrepancies with first dta until the 1770s at least)

** PST (Primary, Secondary, Tertiary system of occupational coding)
*https://www.campop.geog.cam.ac.uk/research/occupations/datasets/coding/

**  PSTdefinitions data:

* Import from excel and save as dta
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

** Master dataset:

use "$original\Stamp tax\ST_analysis_core.dta", clear

* collapse to keep only occupation names and PST codes:
{
gen x=1
collapse (mean) x, by(master_pst mr_occ1_exp)

drop if master_pst!="" // keep only the ones without PST codes already
drop if mr_occ=="" // drop those without occupation names

rename mr_occ occupation_name // edits for matchit 
sort occupation_name
egen occupation_id=group(occupation_name)
}

* edits "pst_codes" dataset for matchit:
{ 
preserve // this and restore is only to run the code in between "quietly" or to immediately return to the previous line of code.  
use "$new\pst_codes.dta", clear

replace occupation=section if occupation=="" & section!="" // if occupation is missing, use the other, more aggregated categories (section, group, etc.)
replace occupation=group if occupation=="" & section==""
replace occupation=sector if occupation=="" & section=="" & group==""

rename occupation occupation_name // edits for matchit 
sort occupation
egen occupation_id=group(occupation_name)

save "$new\pst_codes_match.dta", replace
restore
}

* fuzzy matching --> master (ST_analysis_core.dta), using (pst_codes_match.dta):

matchit occupation_id occupation_name using "$new\pst_codes_match.dta", idusing(occupation_id) txtusing(occupation_name) override

save "$new\matchit_occupations.dta", replace
