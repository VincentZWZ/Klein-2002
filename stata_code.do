use "/Users/zhaowenzhuo/Library/CloudStorage/OneDrive-BentleyUniversity/Bentley PHD/Paper replication/Audit committee board of director characteristics and earnings management/data_for_replication.dta", replace



gen ACCR_at_abs=abs(ACCR_at)
gen NID=NId/at_l1


forvalues i=2006(1)2022{
	winsor2  ACC  ACC_abs  ACCR_at ACCR_at_abs AAAC out  NId debt asset MB  if fyear==`i' , replace cuts(1 99)

}

label var ACC  "Abnormal accruals (AAC)"
label var ACC_abs  "Abs(AAC)"
label var AAAC  "Abs(AAC) Adjusted for (total accruals)"
label var ACCR_at  "Total accruals"
label var ACCR_at_abs  "Abs(total accruals)"
label var ib_at  "Net income"
label var oancf_at  "Operating cash flows"



asdoc sum ACC  ACC_abs AAAC ACCR_at ACCR_at_abs ib_at oancf_at, replace  label  save(descriptive)
 
reg ACC  ACCR_at
 
global fe TwoDigSIC fyear
global DV AAAC
global control OUTblockholder ceo_holding MB NID NegNI debt asset

label var BD51  "BD 51%"
label var out  "Out%"
label var OUTblockholder  "5%Blockholder on audit comm."
label var  ceo_holding  "%CEO shares%"
label var Audit100  "Audit100%"
label var Audit51  "Audit51%"
label var audit_out  "%Audout"
label var MB  "MV/BV"
label var NID  "Abs(deltaNI)"
label var NegNI  "Neg. NI"
label var asset  "Log(asset)"
label var Non_discretionary_accrul  "Non-discretionary accruals"
label var at  "Assets (in $millions)"


asdoc reghdfe $DV  BD51  $control , a($fe) cluster(permno) nest replace add(Industry Effects, Yes, Year Effects, Yes) label  save(results)

gen sam =e(sample)

asdoc reghdfe $DV  out   $control, a($fe) cluster(permno) nest append add(Industry Effects, Yes, Year Effects, Yes)  label

asdoc reghdfe $DV  Audit100   $control, a($fe) cluster(permno) nest append add(Industry Effects, Yes, Year Effects, Yes) label

asdoc reghdfe $DV  Audit51   $control, a($fe) cluster(permno) nest append add(Industry Effects, Yes, Year Effects, Yes)  label

asdoc reghdfe $DV  audit_out   $control, a($fe) cluster(permno) nest append add(Industry Effects, Yes, Year Effects, Yes) label



asdoc sum ACC  ACC_abs AAAC ACCR_at ACCR_at_abs Non_discretionary_accrul ib_at oancf_at at if sam==1, replace  label  save(descriptive)
