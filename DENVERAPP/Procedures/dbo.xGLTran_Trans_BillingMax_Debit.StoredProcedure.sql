USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xGLTran_Trans_BillingMax_Debit]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/09/2009 JWG & MSB

CREATE proc [dbo].[xGLTran_Trans_BillingMax_Debit]
 @batnbr varchar(10),
 @userid varchar (10),
 @basecuryid varchar (4),
 @maxgllineid int,
 @minpjdetnum int

AS 

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

insert into 
		GLTRAN 
select 
		Acct			=	CASE
							WHEN b.amount > 0 THEN
								substring(d.tr_id20, charindex(' ', d.tr_id20) + 1, charindex(' ', d.tr_id20, charindex(' ', d.tr_id20, charindex(' ', d.tr_id20) + 1)) - (charindex(' ', d.tr_id20) + 1))
							ELSE
								b.gl_acct
							END,			
		AppliedDate		=	'1900-01-01 00:00:00',			
		BalanceType		=	'A',		
		BaseCuryID		=	@basecuryid,			
		BatNbr			=	c.batnbr,			
		CpnyID			=	b.cpnyid,			
		CrAmt			=	0,			
		Crtd_DateTime	=	getdate(),			
		Crtd_Prog		=	'PARPT',			
		Crtd_User		=	@userId,			
		CuryCrAmt		=	0,			
		CuryDrAmt		=	abs(b.amount),			
		CuryEffDate		=	'1900-01-01 00:00:00',			
		CuryId			=	@basecuryid,			
		CuryMultDiv		=	'M',			
		CuryRate		=	1,			
		CuryRateType	=	'',			
		DrAmt			=	abs(b.amount),			
		EmployeeID		=	b.employee,			
		ExtRefNbr		=	b.tr_id02,			
		FiscYr			=	LEFT(c.perpost,4),			
		IC_Distribution	=	0,			
		Id				=	b.vendor_num,			
		JrnlType		=	'TFR',			
		Labor_Class_Cd	=	b.tr_id05,			
		LedgerID		=	c.ledgerid,			
		LineId			=	@maxgllineid + ((b.detail_num - @minpjdetnum + 1) * 2) - 1,			
		LineNbr			=	@maxgllineid + ((b.detail_num - @minpjdetnum + 1) * 2) - 1,				
		LineRef			=	cast((@maxgllineid + ((b.detail_num - @minpjdetnum + 1) * 2) - 1) as char (5)),			
		LUpd_DateTime	=	getdate(),			
		LUpd_Prog		=	'PARPT',			
		LUpd_User		=	@userId,			
		Module			=	'PA',			
		NoteID			=	b.noteid,			
		OrigAcct		=	'',			
		OrigBatNbr		=	'',			
		OrigCpnyID		=	'',			
		OrigSub			=	'',			
		PC_Flag			=	'',
		PC_ID			=	'',			
		PC_Status		=	2,			
		PerEnt			=	c.PerEnt,			
		PerPost			=	c.PerPost,			
		Posted			=	0,			
		ProjectID		=	b.project,			
		Qty				=	0,			
		RefNbr			=	b.voucher_num,			
		RevEntryOption	=	'',			
		Rlsed			=	0,			
		S4Future01		=	'',			
		S4Future02		=	'',			
		S4Future03		=	0,			
		S4Future04		=	0,			
		S4Future05		=	0,			
		S4Future06		=	0,			
		S4Future07		=	'1900-01-01 00:00:00',			
		S4Future08		=	'1900-01-01 00:00:00',			
		S4Future09		=	0,			
		S4Future10		=	0,			
		S4Future11		=	'C',			
		S4Future12		=	'',			
		ServiceDate		=	'1900-01-01 00:00:00',			
		Sub				=	b.gl_subacct,			
		TaskID			=	b.pjt_entity,			
		TranDate		=	b.trans_date,			
		TranDesc		=	b.tr_comment,			
		TranType		=	'PT',			
		Units			=	0,			
		User1			=	'',			
		User2			=	'',			
		User3			=	0,			
		User4			=	0,			
		User5			=	'',			
		User6			=	'',			
		User7			=	'1900-01-01 00:00:00',			
		User8			=	'1900-01-01 00:00:00',			
		tstamp			=	NULL
from			
		PJTran b 
join			
		Batch c 
on
		b.batch_id = c.batnbr and 
		b.system_cd = c.module and
		c.module = 'PA'
join
		pjtranex d
on
		b.fiscalno = d.fiscalno and
		b.system_cd = d.system_cd and
		b.batch_id = d.batch_id and
		b.detail_num = d.detail_num and
		d.tr_id20 <> ''
where				
		b.tr_status = 'M1' and		
		c.batnbr = @batnbr				

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
