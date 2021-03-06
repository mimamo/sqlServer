USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xInsert_BatchRec_GL]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xInsert_BatchRec_GL]
@LastBatNbr as Char(10),
@BatchAmt as float,
@CpnyID as char(10),
@PerEnt as Char(10),
@BaseCuryID as char(10)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

insert Batch (
[Acct],[AutoRev],[AutoRevCopy],[BalanceType],
[BankAcct],[BankSub],[BaseCuryID],[BatNbr],
[BatType],[clearamt],[Cleared],[CpnyID],
[Crtd_DateTime],[Crtd_Prog],[Crtd_User],[CrTot],
[CtrlTot],[CuryCrTot],[CuryCtrlTot],[CuryDepositAmt],
[CuryDrTot],[CuryEffDate],[CuryId],[CuryMultDiv],
[CuryRate],[CuryRateType],[Cycle],[DateClr],
[DateEnt],[DepositAmt],[Descr],[DrTot],
[EditScrnNbr],[GLPostOpt],[JrnlType],[LedgerID],
[LUpd_DateTime],[LUpd_Prog],[LUpd_User],[Module],
[NbrCycle],[NoteID],[OrigBatNbr],[OrigCpnyID],
[OrigScrnNbr],[PerEnt],[PerPost],[Rlsed],
[S4Future01],[S4Future02],[S4Future03],[S4Future04],[S4Future05],[S4Future06],[S4Future07],[S4Future08],[S4Future09],[S4Future10],[S4Future11],[S4Future12],
[Status],[Sub],
[User1],[User2],[User3],[User4],[User5],[User6],[User7],[User8]
)
values(
'','','','A',
'','',@BaseCuryID,@LastBatNbr,
'N','','',@CpnyID,
getdate(),'01010','SYSADMIN',@BatchAmt,
@BatchAmt,@BatchAmt,@BatchAmt,'',
@BatchAmt,getdate(),@BaseCuryID,'M',
'1','','','',
getdate(),'','Sales Tax Import',@BatchAmt,
'01010','D','TX','ACTUAL',
GETDATE(),'01010','SYSADMIN','GL',
'0','','','',
'',@PerEnt,@PerEnt,0,
'','','','','','','','','','','','',
'H','',
'','','','','','','',''
)

 
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

DECLARE @ErrorNumberA int
DECLARE @ErrorSeverityA int
DECLARE @ErrorStateA varchar(255)
DECLARE @ErrorProcedureA varchar(255)
DECLARE @ErrorLineA int
DECLARE @ErrorMessageA varchar(max)
DECLARE @ErrorDateA smalldatetime
DECLARE @UserNameA varchar(50)
DECLARE @ErrorAppA varchar(50)
DECLARE @UserMachineName varchar(50)

SET @ErrorNumberA = Error_number()
SET @ErrorSeverityA = Error_severity()
SET @ErrorStateA = Error_state()
SET @ErrorProcedureA = Error_procedure()
SET @ErrorLineA = Error_line()
SET @ErrorMessageA = Error_message()
SET @ErrorDateA = GetDate()
SET @UserNameA = suser_sname() 
SET @ErrorAppA = app_name()
SET @UserMachineName = host_name()

EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH


IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END
GO
