USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_InsertBatch]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_InsertBatch]

as

insert batch
(Acct, AutoRev, AutoRevCopy, BalanceType, BankAcct, BankSub, BaseCuryID, BatNbr, BatType, clearamt, Cleared, CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User, CrTot, CtrlTot, CuryCrTot, CuryCtrlTot, CuryDepositAmt, CuryDrTot, CuryEffDate, CuryId, CuryMultDiv, CuryRate, CuryRateType, Cycle, DateClr, DateEnt, DepositAmt, Descr, DrTot, EditScrnNbr, GLPostOpt, JrnlType, LedgerID, LUpd_DateTime, LUpd_Prog, LUpd_User, Module, NbrCycle, NoteID, OrigBatNbr, OrigCpnyID, OrigScrnNbr, PerEnt, PerPost, Rlsed, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, Status, Sub, User1, User2, User3, User4, User5, User6, User7, User8)
select
'' as 'Acct', --char(10)
0 as 'AutoRev', --smallint
0 as 'AutoRevCopy', --smallint
'' as 'BalanceType', --char(1)
'' as 'BankAcct', --char(10)
'' as 'BankSub', --char(24)
'USD' as 'BaseCuryID', --char(4)
x.SolBatNbr as 'BatNbr', --char(10)
'N' as 'BatType', --char(1)
0 as 'clearamt', --float
0 as 'Cleared', --smallint
'DALLAS' as 'CpnyID', --char(10)
getdate() as 'Crtd_DateTime', --smalldatetime
'IMPORT' as 'Crtd_Prog', --char(8)
'IMPORT' as 'Crtd_User', --char(10)
sum(abs(x.GrossAmount)) as 'CrTot', --float
sum(abs(x.GrossAmount)) as 'CtrlTot', --float
sum(abs(x.GrossAmount)) as 'CuryCrTot', --float
sum(abs(x.GrossAmount)) as 'CuryCtrlTot', --float
0 as 'CuryDepositAmt', --float
0 as 'CuryDrTot', --float
getdate() as 'CuryEffDate', --smalldatetime
'USD' as 'CuryId', --char(4)
'M' as 'CuryMultDiv', --char(1)
1 as 'CuryRate', --float
'' as 'CuryRateType', --char(6)
0 as 'Cycle', --smallint
'1/1/1900' as 'DateClr', --smalldatetime
getdate() as 'DateEnt', --smalldatetime
0 as 'DepositAmt', --float
'' as 'Descr', --char(30)
0 as 'DrTot', --float
'08010' as 'EditScrnNbr', --char(5)
'D' as 'GLPostOpt', --char(1)
'AR' as 'JrnlType', --char(3)
'ACTUAL' as 'LedgerID', --char(10)
getdate() as 'LUpd_DateTime', --smalldatetime
'IMPORT' as 'LUpd_Prog', --char(8)
'IMPORT' as 'LUpd_User', --char(10)
'AR' as 'Module', --char(2)
0 as 'NbrCycle', --smallint
0 as 'NoteID', --int
'' as 'OrigBatNbr', --char(10)
'' as 'OrigCpnyID', --char(10)
'' as 'OrigScrnNbr', --char(5)
s.CurrPerNbr as 'PerEnt', --char(6)
s.CurrPerNbr as 'PerPost', --char(6)
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
'H' as 'Status', --char(1)
'' as 'Sub', --char(24)
'' as 'User1', --char(30)
'' as 'User2', --char(30)
0 as 'User3', --float
0 as 'User4', --float
'' as 'User5', --char(10)
'' as 'User6', --char(10)
'1/1/1900' as 'User7', --smalldatetime
'1/1/1900' as 'User8' --smalldatetime
from x_DonovanAR_wrk x
cross join ARSetup s
group by x.SolBatNbr, s.CurrPerNbr

--test for errors
if @@error<>0
begin
print 'Error Inserting into Batch table.'
return 1
end

return 0
GO
