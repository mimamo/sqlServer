USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xInsert_GLTran_Rec]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xInsert_GLTran_Rec] 
	@parm1 Varchar (10),  	--Batch Number
	@parm2 VarChar (10),	--Cpny
	@parm3 Varchar (10),	--Acct
	@parm4 Varchar (16),	--Project
	@parm5 VarChar (32),	--Taskid
	@parm6 VarChar (24),	--Sub
	@Parm7 Float,		--Credit Amt
	@parm8 VarChar (30),	--Description Field
	@parm9 VarChar (10),	--PerEnt
	@parm10 varchar (10),	--BaseCuryId
	@parm11 SmallInt,	--Line Number
	@parm12 Float,		--Debit Amt
	@parm13 Varchar(10),	--reference number
	@parm14 VarChar(1),	--pc status
	@parm15 VarChar(1),     --pc flag
	@parm16 smalldatetime

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

insert into GLTRAN (
[Acct],[AppliedDate],[BalanceType],[BaseCuryID],[BatNbr],
[CpnyID],[CrAmt],[Crtd_DateTime],[Crtd_Prog],[Crtd_User],
[CuryCrAmt],[CuryDrAmt],[CuryEffDate],[CuryId],[CuryMultDiv],

[CuryRate],[CuryRateType],[DrAmt], [EmployeeID],[ExtRefNbr],
[FiscYr],[IC_Distribution],[Id],[JrnlType],[Labor_Class_Cd],
[LedgerID],[LineId],[LineNbr],[LineRef],[LUpd_DateTime], 
[LUpd_Prog],[LUpd_User],[Module],[NoteID],[OrigAcct],

[OrigBatNbr],[OrigCpnyID],[OrigSub],[PC_Flag],[PC_ID],
[PC_Status],[PerEnt],[PerPost],[Posted],[ProjectID],
[Qty],[RefNbr],[RevEntryOption],[Rlsed],[S4Future01],
[S4Future02],[S4Future03], [S4Future04], [S4Future05], [S4Future06], 

[S4Future07],[S4Future08], [S4Future09], [S4Future10], [S4Future11],
[S4Future12],[ServiceDate], [Sub],[TaskID],[TranDate], 
[TranDesc],[TranType],[Units], [User1],[User2],
[User3], [User4], [User5],[User6],[User7], 
[User8]

)

Values
( 
@parm3,'','A','BAS',@parm1,  --acct nbr
@parm2,@Parm7,getdate(),'01010','SYSADMIN', -- 99.99 TranAmt
@Parm7,@parm12,getdate(),@parm10,'M',  -- 99.99 TranAmt


'1.0','',@parm12,'','',
'1999','0','','TX','',   --1999 Trans Year
'','0',@parm11,'',getdate(),  -- line nbr
'01010','SYSADMIN','GL','0','',  --GL

'','','',@parm15,'',  --Company id
@parm14,@parm9,@parm9,'U',@parm4,  --period enter, post
'0',@parm13,'','0','',
'','','','','',
'','','','','',
'','',@parm6,@parm5,@parm16, 
@parm8,'GL','0','','',
'','','','','',
''  
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
