USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xGLTran_Trans_Debit]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/09/2009 JWG & MSB

CREATE proc [dbo].[xGLTran_Trans_Debit]
 @batnbr varchar(10),
 @userid varchar (10)

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
		Acct			=	d.credit_gl_acct,			
		AppliedDate		=	'1900-01-01 00:00:00',			
		BalanceType		=	'A',		
		BaseCuryID		=	(select baseCuryId from glsetup),			
		BatNbr			=	c.batnbr,			
		CpnyID			=	d.credit_cpnyid,			
		CrAmt			=	0,			
		Crtd_DateTime	=	getdate(),			
		Crtd_Prog		=	'PARPT',			
		Crtd_User		=	@userId,			
		CuryCrAmt		=	0,			
		CuryDrAmt		=	d.cury_alloc_amount,			
		CuryEffDate		=	d.curyeffdate,			
		CuryId			=	d.curyid,			
		CuryMultDiv		=	b.CuryMultDiv,			
		CuryRate		=	d.curyrate,			
		CuryRateType	=	d.curyratetype,			
		DrAmt			=	d.alloc_amount,			
		EmployeeID		=	case when d.emp_detail_flag = 'Y' THEN b.employee ELSE '' end,			
		ExtRefNbr		=	b.tr_id02,			
		FiscYr			=	LEFT(c.perpost,4),			
		IC_Distribution	=	0,			
		Id				=	b.vendor_num,			
		JrnlType		=	'TFR',			
		Labor_Class_Cd	=	b.tr_id05,			
		LedgerID		=	c.ledgerid,			
		LineId			=	a.lineid + a.LastSeqNbr + (d.audit_detail_num * 2 - 1),			
		LineNbr			=	a.lineid + a.LastSeqNbr + (d.audit_detail_num * 2 - 1),				
		LineRef			=	cast(LineId as char (5)),			
		LUpd_DateTime	=	getdate(),			
		LUpd_Prog		=	'PARPT',			
		LUpd_User		=	@userId,			
		Module			=	'PA',			
		NoteID			=	a.noteid,			
		OrigAcct		=	'',			
		OrigBatNbr		=	'',			
		OrigCpnyID		=	'',			
		OrigSub			=	'',			
		PC_Flag			=	case when b.tr_status = 'N' THEN b.tr_status ELSE '' end,
		PC_ID			=	'',			
		PC_Status		=	2,			
		PerEnt			=	c.PerEnt,			
		PerPost			=	c.PerPost,			
		Posted			=	0,			
		ProjectID		=	d.post_project,			
		Qty				=	d.alloc_units,			
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
		S4Future11		=	'',			
		S4Future12		=	'',			
		ServiceDate		=	'1900-01-01 00:00:00',			
		Sub				=	d.credit_gl_subacct,			
		TaskID			=	d.post_pjt_entity,			
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
		PJTrnsfr a 
join			
		PJTran b 
on
		a.Origfiscalno = b.fiscalno and
		a.Origsystem_cd = b.system_cd and
		a.Origbatch_id = b.batch_id and
		a.Origdetail_num = b.detail_num
join			
		Batch c 
on
		a.batch_id = c.batnbr and 
		c.module = 'PA'
Join			
		PJAllAud d 
on
		a.Origfiscalno = d.fiscalno and
		a.Origsystem_cd = d.system_cd and
		a.Origbatch_id = d.batch_id and
		a.Origdetail_num = d.detail_num and
		d.debit_gl_acct <> '' and
		d.recalc_flag = ''
where				
		c.batnbr = @batnbr and
		c.module = 'PA'and 
		d.credit_gl_acct <> '' 

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
