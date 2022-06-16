	*************************************************
	*				MASTER - Template   			*
	*************************************************
	
/* 	Description

*/

version 15
local stdate $S_DATE
local sttime $S_TIME

clear all
clear matrix
clear mata
set maxvar 32767
set more off, permanently
capture log close

******************************************
* 1 Paths
******************************************

*Global path (the folder with all my files)

global path "E:\Dropbox\_Pre-Doc\Active_Projects\Eye sight and productivity\0_analysis"

global do		"$path\1_do"		//do-files
global log		"$path\2_log"
global raw		"$path\3_raw"		//raw data
global data		"$path\4_data"		//generated data
global results	"$path\5_results"	//all results

* create directories
foreach dir in log results {
	cap cd "${`dir'}"
	if _rc==170 mkdir "${`dir'}"
}

cd "$path"

******************************************
* 2 setup 
******************************************

global run_ado_installations  	= 0 

* ADO installations 
if $run_ado_installations ==1 {
	ssc install outreg2
	ssc install estout
	ssc install mdesc
	ssc install mvpatterns
	ssc install gtools
}

*declare format globals
global tabfmt "rtf" 	//"tex" => export all tables in LATEX format
						//"rtf" => export all tables in WORD format
global figfmt "png" 	//"jpg" => export all graphs in JPG format

* create log 
cap log close
set logtype text
local date = substr("$S_DATE",-4,4)+"_"+ substr("$S_DATE",4,3)+ ///
			 substr("$S_DATE",1,2)
log using "$log\task_`date'.txt", append

exit

******************************************
* 3 do-files
******************************************
/*
*...
do "${do}/2_clean.do"

*...
do "${do}/3_~~~~.do"

*...
do "${do}/4_~~~~.do"
*/

