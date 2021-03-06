USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_InsertARTran_Sales]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_InsertARTran_Sales]

as

/* insert for SALES transactions */

insert artran
(Acct, AcctDist, BatNbr, CmmnPct, CnvFact, ContractID, CostType, CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User, CuryExtCost, CuryId, CuryMultDiv, CuryRate, CuryTaxAmt00, CuryTaxAmt01, CuryTaxAmt02, CuryTaxAmt03, CuryTranAmt, CuryTxblAmt00, CuryTxblAmt01, CuryTxblAmt02, CuryTxblAmt03, CuryUnitPrice, CustId, DrCr, Excpt, ExtCost, ExtRefNbr, FiscYr, FlatRateLineNbr, InstallNbr, InvtId, JobRate, JrnlType, LineId, LineNbr, LineRef, LUpd_DateTime, LUpd_Prog, LUpd_User, MasterDocNbr, NoteId, OrdNbr, PC_Flag, PC_ID, PC_Status, PerEnt, PerPost, ProjectID, Qty, RefNbr, Rlsed, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, ServiceCallID, ServiceCallLineNbr, ServiceDate, ShipperCpnyID, ShipperID, ShipperLineRef, SiteId, SlsperId, SpecificCostID, Sub, TaskID, TaxAmt00, TaxAmt01, TaxAmt02, TaxAmt03, TaxCalced, TaxCat, TaxId00, TaxId01, TaxId02, TaxId03, TaxIdDflt, TranAmt, TranClass, TranDate, TranDesc, TranType, TxblAmt00, TxblAmt01, TxblAmt02, TxblAmt03, UnitDesc, UnitPrice, User1, User2, User3, User4, User5, User6, User7, User8, WhseLoc)
select
m.SalesAcct as 'Acct', --char(10) 
0 as 'AcctDist', --smallint
x.SolBatNbr as 'BatNbr', --char(10) 
0 as 'CmmnPct', --float
0 as 'CnvFact', --float
'' as 'ContractID', --char(10)
'' as 'CostType', --char(8)
'DALLAS' as 'CpnyID', --char(10)
getdate() as 'Crtd_DateTime', --smalldatetime
'IMPORT' as 'Crtd_Prog', --char(8)
'IMPORT' as 'Crtd_User', --char(10)
0 as 'CuryExtCost', --float
'USD' as 'CuryId', --char(4)
'M' as 'CuryMultDiv', --char(1)
1 as 'CuryRate', --float
0 as 'CuryTaxAmt00', --float
0 as 'CuryTaxAmt01', --float
0 as 'CuryTaxAmt02', --float
0 as 'CuryTaxAmt03', --float
abs(x.GrossAmount) as 'CuryTranAmt', --float 
0 as 'CuryTxblAmt00', --float
0 as 'CuryTxblAmt01', --float
0 as 'CuryTxblAmt02', --float
0 as 'CuryTxblAmt03', --float
0 as 'CuryUnitPrice', --float
p.customer as 'CustId', --char(15)
case when x.GrossAmount<0 then 'D' else 'C' end as 'DrCr', --char(1) ***** will be 'C' for INs and 'D' for CMs
0 as 'Excpt', --smallint
0 as 'ExtCost', --float
'' as 'ExtRefNbr', --char(15)
left(rtrim(s.CurrPerNbr),4) as 'FiscYr', --char(4)
0 as 'FlatRateLineNbr', --smallint
0 as 'InstallNbr', --smallint
'' as 'InvtId', --char(30)
0 as 'JobRate', --float
'AR' as 'JrnlType', --char(3)
1 as 'LineId', --int  ***** figure it out
-32768 as 'LineNbr', --smallint ***** figure it out
'' as 'LineRef', --char(5) 
getdate() as 'LUpd_DateTime', --smalldatetime
'IMPORT' as 'LUpd_Prog', --char(8)
'IMPORT' as 'LUpd_User', --char(10)
'' as 'MasterDocNbr', --char(10)
0 as 'NoteId', --int
'' as 'OrdNbr', --char(15)
'' as 'PC_Flag', --char(1)
'' as 'PC_ID', --char(20)
'0' as 'PC_Status', --char(1)
s.CurrPerNbr as 'PerEnt', --char(6)
s.CurrPerNbr as 'PerPost', --char(6)
'' as 'ProjectID', --char(16)
0 as 'Qty', --float
x.InvoiceNumber as 'RefNbr', --char(10)
0 as 'Rlsed', --smallint
'' as 'S4Future01', --char(30)
'' as 'S4Future02', --char(30)
0 as 'S4Future03', --float
0 as 'S4Future04', --float
0 as 'S4Future05', --float
0 as 'S4Future06', --float
'1/1/1900' as 'S4Future07', --smalldatetime
'1/1/1900' as 'S4Future08', --smalldatetime
0 as 'S4Future09', --int
0 as 'S4Future10', --int
'' as 'S4Future11', --char(10)
'' as 'S4Future12', --char(10)
'' as 'ServiceCallID', --char(10)
0 as 'ServiceCallLineNbr', --smallint
'1/1/1900' as 'ServiceDate', --smalldatetime
'' as 'ShipperCpnyID', --char(10)
'' as 'ShipperID', --char(15)
'' as 'ShipperLineRef', --char(5)
'' as 'SiteId', --char(10)
'' as 'SlsperId', --char(10)
'' as 'SpecificCostID', --char(25)
m.SalesSub as 'Sub', --char(24) ***** 1000 for Sales and COS, 0000 for 1040 and 2005
'' as 'TaskID', --char(32)
0 as 'TaxAmt00', --float
0 as 'TaxAmt01', --float
0 as 'TaxAmt02', --float
0 as 'TaxAmt03', --float
'' as 'TaxCalced', --char(1)
'' as 'TaxCat', --char(10)
'' as 'TaxId00', --char(10)
'' as 'TaxId01', --char(10)
'' as 'TaxId02', --char(10)
'' as 'TaxId03', --char(10)
'' as 'TaxIdDflt', --char(10)
abs(x.GrossAmount) as 'TranAmt', --float  ***** figure it out
'' as 'TranClass', --char(1)
getdate() as 'TranDate', --smalldatetime
'' as 'TranDesc', --char(30)
case when x.GrossAmount < 0 then 'CM' else 'IN' end as 'TranType', --char(2)  
0 as 'TxblAmt00', --float
0 as 'TxblAmt01', --float
0 as 'TxblAmt02', --float
0 as 'TxblAmt03', --float
'' as 'UnitDesc', --char(6)
0 as 'UnitPrice', --float
'' as 'User1', --char(30)
'' as 'User2', --char(30)
0 as 'User3', --float
0 as 'User4', --float
'' as 'User5', --char(10)
'' as 'User6', --char(10)
'1/1/1900' as 'User7', --smalldatetime
'1/1/1900' as 'User8', --smalldatetime
'' as 'WhseLoc' --char(10)
from x_DonovanAR_wrk x
join x_DonovanAR_MediaAcctXRef m on x.MediaType=m.MediaType
join pjproj p on x.SolProjectNbr=p.project
join customer c on p.customer=c.custid
cross join arsetup s

--test for errors
if @@error<>0
begin
print 'Error inserting into ARTran, Sales.'
return 1
end

return 0
GO
