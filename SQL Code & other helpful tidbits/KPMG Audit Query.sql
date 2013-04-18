--Here is the query that will pull activity for KPMG Audit. 
-- report server http://sqldev2/ReportServer
Select b.BatNbr as 'Batch Number'
, b.Crtd_DateTime as 'Batch Created Date'
, t.Acct as 'Account'
, t.Sub as 'Sub Account'
, t.ProjectID as 'Project'
, t.JrnlType as 'Journal Type'
, t.Module as 'Module'
, t.FiscYr as 'Fiscal Year'
, t.PerEnt as 'Period Entered'
, t.PerPost as 'Period Posted'
, b.BatType as 'Batch Type'
, t.CuryCrAmt as 'Credit Amount'
, t.CuryDrAmt as 'Debit Amount' 
, t.CuryId as 'Currency ID'
, t.TranDesc as 'Transaction Description'
, b.AutoRev as 'Auto Reversing'
, t.Crtd_User as 'Created User'
, t.Crtd_DateTime as 'Created Date'
, t.LUpd_DateTime as 'Updated Date'
from Batch b JOIN GLTran t ON b.BatNbr = t.BatNbr
Where 
--t.FiscYr = '2012' 
t.PerPost IN (@perPost)
and t.module IN (@Type)
and t.PerEnt = t.PerPost 
and t.LedgerID IN ('ACTUAL','STAT')

-- for Type select query
select distinct Module from GLTran
 order by Module 
 
 -- for perpost select query
 select distinct perpost from GLTran 
 where perpost <> '851903'
 and PerPost > '201012'
 order by PerPost desc
 
