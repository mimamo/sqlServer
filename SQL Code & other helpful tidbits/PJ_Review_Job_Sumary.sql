select top 10 
StatusPA
, CustomerCode as 'ClientID'
, CustomerName as 'ClientName' 
, ProductCode as 'ProductID'
, ProductDesc 
, Type
, SubType
, PTODesignator as 'PTOJob'
, Differentiator as 'Diff'
, ECD
, OfferNum
, PM
, 'freight' as 'freight'
, ClientContact
, ContactEmailAddress as 'Contact Email'
, JobCat
, project as 'Job Number'	
, projectdesc as 'Job Descr'
, retailcustname as	'Retail Customer Name'
, ponumber as 'Client Ref #'	
, estimateamounttotal as 'Estimate'
, ISNULL((extcost - costvouched),0) as 'Open PO'	
, 
--, BTD	Actuals	Actuals to Bill	Remaining Est Amount	Open Date	On Shelf Date	Close Date	Account Service
from xvr_PA924_Main


select top 10 * from xvr_PA924_Main


select top 10 * from PJACTROL




IF ({xvr_PA924_Main.ControlCode}="BTD" OR {xvr_PA924_Main.AcctGroupCode} IN ["PB"]) AND {xvr_PA924_Main.FSYearNum}={@Fiscal Year} THEN

SELECT {@Fiscal Month}
    CASE "01": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}
    CASE "02": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}
    CASE "03": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}
    CASE "04": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}
    CASE "05": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}
    CASE "06": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}
    CASE "07": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}
    CASE "08": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}
    CASE "09": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}
    CASE "10": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}
    CASE "11": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}+{xvr_PA924_Main.Amount11}
    CASE "12": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}+{xvr_PA924_Main.Amount11}+{xvr_PA924_Main.Amount12}
    CASE "13": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}+{xvr_PA924_Main.Amount11}+{xvr_PA924_Main.Amount12}+{xvr_PA924_Main.Amount13}
    CASE "14": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}+{xvr_PA924_Main.Amount11}+{xvr_PA924_Main.Amount12}+{xvr_PA924_Main.Amount13}+{xvr_PA924_Main.Amount14}
    CASE "15": {xvr_PA924_Main.AmountBF}+{xvr_PA924_Main.Amount01}+{xvr_PA924_Main.Amount02}+{xvr_PA924_Main.Amount03}+{xvr_PA924_Main.Amount04}+{xvr_PA924_Main.Amount05}+{xvr_PA924_Main.Amount06}+{xvr_PA924_Main.Amount07}+{xvr_PA924_Main.Amount08}+{xvr_PA924_Main.Amount09}+{xvr_PA924_Main.Amount10}+{xvr_PA924_Main.Amount11}+{xvr_PA924_Main.Amount12}+{xvr_PA924_Main.Amount13}+{xvr_PA924_Main.Amount14}+{xvr_PA924_Main.Amount15}

ELSE 

0


select AcctGroupCode, ControlCode, FSYearNum, * from xvr_PA924_Main where (ControlCode = 'BTD' or AcctGroupCode IN ('PB')) and FSYearNum = 2012 and Project = '03671610agy'


select AcctGroupCode, ControlCode, FSYearNum, * from xvr_PA924_Main where Amount13 <> ''