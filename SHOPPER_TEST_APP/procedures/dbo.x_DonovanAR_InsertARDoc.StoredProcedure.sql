USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_InsertARDoc]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_InsertARDoc]

as

insert ardoc
(AcctNbr, AgentID, ApplAmt, ApplBatNbr, ApplBatSeq, BankAcct, BankID, BankSub, BatNbr, BatSeq, Cleardate, CmmnAmt, CmmnPct, ContractID, CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User, CurrentNbr, CuryApplAmt, CuryClearAmt, CuryCmmnAmt, CuryDiscApplAmt, CuryDiscBal, CuryDocBal, CuryEffDate, CuryId, CuryMultDiv, CuryOrigDocAmt, CuryRate, CuryRateType, CuryStmtBal, CuryTaxTot00, CuryTaxTot01, CuryTaxTot02, CuryTaxTot03, CuryTxblTot00, CuryTxblTot01, CuryTxblTot02, CuryTxblTot03, CustId, CustOrdNbr, Cycle, DiscApplAmt, DiscBal, DiscDate, DocBal, DocClass, DocDate, DocDesc, DocType, DraftIssued, DueDate, InstallNbr, JobCntr, LineCntr, LUpd_DateTime, LUpd_Prog, LUpd_User, MasterDocNbr, NbrCycle, NoPrtStmt, NoteId, OpenDoc, OrdNbr, OrigBankAcct, OrigBankSub, OrigCpnyID, OrigDocAmt, OrigDocNbr, PC_Status, PerClosed, PerEnt, PerPost, PmtMethod, ProjectID, RefNbr, RGOLAmt, Rlsed, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, ServiceCallID, ShipmentNbr, SlsperId, Status, StmtBal, StmtDate, TaskID, TaxCntr00, TaxCntr01, TaxCntr02, TaxCntr03, TaxId00, TaxId01, TaxId02, TaxId03, TaxTot00, TaxTot01, TaxTot02, TaxTot03, Terms, TxblTot00, TxblTot01, TxblTot02, TxblTot03, User1, User2, User3, User4, User5, User6, User7, User8)
select
'' as 'AcctNbr', --char(30)
'' as 'AgentID', --char(10)
0 as 'ApplAmt', --float
'' as 'ApplBatNbr', --char(10)
0 as 'ApplBatSeq', --int 
m.ARAcct as 'BankAcct', --char(10) 
'' as 'BankID', --char(10)
m.ARSub as 'BankSub', --char(24) 
x.SolBatNbr as 'BatNbr', --char(10) 
0 as 'BatSeq', --int 
'1/1/1900' as 'Cleardate', --smalldatetime
0 as 'CmmnAmt', --float
0 as 'CmmnPct', --float
'' as 'ContractID', --char(10)
'DALLAS' as 'CpnyID', --char(10)
getdate() as 'Crtd_DateTime', --smalldatetime
'IMPORT' as 'Crtd_Prog', --char(8)
'IMPORT' as 'Crtd_User', --char(10)
0 as 'CurrentNbr', --smallint 
0 as 'CuryApplAmt', --float
0 as 'CuryClearAmt', --float
0 as 'CuryCmmnAmt', --float
0 as 'CuryDiscApplAmt', --float
0 as 'CuryDiscBal', --float
abs(x.GrossAmount) as 'CuryDocBal', --float
getdate() as 'CuryEffDate', --smalldatetime
'USD' as 'CuryId', --char(4)
'M' as 'CuryMultDiv', --char(1)
abs(x.GrossAmount) as 'CuryOrigDocAmt', --float
1 as 'CuryRate', --float
'' as 'CuryRateType', --char(6)
0 as 'CuryStmtBal', --float
0 as 'CuryTaxTot00', --float
0 as 'CuryTaxTot01', --float
0 as 'CuryTaxTot02', --float
0 as 'CuryTaxTot03', --float
0 as 'CuryTxblTot00', --float
0 as 'CuryTxblTot01', --float
0 as 'CuryTxblTot02', --float
0 as 'CuryTxblTot03', --float
p.customer as 'CustId', --char(15) *****need value, from pjproj.customer OR pjproj.pm_id01
'' as 'CustOrdNbr', --char(25)
0 as 'Cycle', --smallint
0 as 'DiscApplAmt', --float
0 as 'DiscBal', --float
getdate() as 'DiscDate', --smalldatetime
abs(x.GrossAmount) as 'DocBal', --float
'N' as 'DocClass', --char(1) 
x.InvoiceDate as 'DocDate', --smalldatetime
'Donovan Import' as 'DocDesc', --char(30)
case when x.GrossAmount<0 then 'CM' else 'IN' end as 'DocType', --char(2)
0 as 'DraftIssued', --smallint
dateadd(dd,t.dueintrv,x.InvoiceDate) as 'DueDate', --smalldatetime *****need value, base on terms?
0 as 'InstallNbr', --smallint
0 as 'JobCntr', --smallint
3 as 'LineCntr', --int *****need value, verify number of lines in artran
getdate() as 'LUpd_DateTime', --smalldatetime
'IMPORT' as 'LUpd_Prog', --char(8)
'IMPORT' as 'LUpd_User', --char(10)
'' as 'MasterDocNbr', --char(10)
0 as 'NbrCycle', --smallint 
0 as 'NoPrtStmt', --smallint
0 as 'NoteId', --int
1 as 'OpenDoc', --smallint
'' as 'OrdNbr', --char(15)
'' as 'OrigBankAcct', --char(10)
'' as 'OrigBankSub', --char(24)
'' as 'OrigCpnyID', --char(10)
abs(x.GrossAmount) as 'OrigDocAmt', --float
'' as 'OrigDocNbr', --char(10)
'1' as 'PC_Status', --char(1)
'' as 'PerClosed', --char(6) *****need value, verify blank
s.CurrPerNbr as 'PerEnt', --char(6) *****need value, get from arsetup
s.CurrPerNbr as 'PerPost', --char(6) *****need value, get from arsetup
'' as 'PmtMethod', --char(1)
x.SolProjectNbr as 'ProjectID', --char(16)
x.InvoiceNumber as 'RefNbr', --char(10)
0 as 'RGOLAmt', --float
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
0 as 'ShipmentNbr', --smallint
'' as 'SlsperId', --char(10)
'' as 'Status', --char(1)
0 as 'StmtBal', --float
'1/1/1900' as 'StmtDate', --smalldatetime
'' as 'TaskID', --char(32)
0 as 'TaxCntr00', --smallint
0 as 'TaxCntr01', --smallint
0 as 'TaxCntr02', --smallint
0 as 'TaxCntr03', --smallint
'' as 'TaxId00', --char(10)
'' as 'TaxId01', --char(10)
'' as 'TaxId02', --char(10)
'' as 'TaxId03', --char(10)
0 as 'TaxTot00', --float
0 as 'TaxTot01', --float
0 as 'TaxTot02', --float
0 as 'TaxTot03', --float
c.terms as 'Terms', --char(2)
0 as 'TxblTot00', --float
0 as 'TxblTot01', --float
0 as 'TxblTot02', --float
0 as 'TxblTot03', --float
'' as 'User1', --char(30)
'' as 'User2', --char(30)
0 as 'User3', --float
0 as 'User4', --float
'' as 'User5', --char(10)
'' as 'User6', --char(10)
'1/1/1900' as 'User7', --smalldatetime
'1/1/1900' as 'User8' --smalldatetime
from x_DonovanAR_wrk x
join x_DonovanAR_MediaAcctXRef m on x.MediaType=m.MediaType
join pjproj p on x.SolProjectNbr=p.project
join customer c on p.customer=c.custid
join terms t on c.terms=t.termsid
cross join ARSetup s

--test for error
if @@error<>0
begin
print 'Error Inserting into ARDoc.'
return 1
end

return 0
GO
