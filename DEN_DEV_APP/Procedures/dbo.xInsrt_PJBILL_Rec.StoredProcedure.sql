USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xInsrt_PJBILL_Rec]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xInsrt_PJBILL_Rec] 
	@parm1 Varchar (16),
	@parm2 Varchar (47)
 
AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

	insert into pjbill
	(
		approval_sw, approver, BillCuryId, biller, 
		billings_cycle_cd, billings_level, bill_type_cd, copy_num, 
		crtd_datetime, crtd_prog, crtd_user, curyratetype, 
		date_print_cd, fips_num, inv_attach_cd, inv_format_cd, 
		last_bill_date, lupd_datetime, lupd_prog, lupd_user, 
		noteid, 
		pb_id01, pb_id02, pb_id03, pb_id04, pb_id05, pb_id06, pb_id07, pb_id08, pb_id09,pb_id10, 
		pb_id11, pb_id12, pb_id13, pb_id14, pb_id15, pb_id16, pb_id17, pb_id18, pb_id19, pb_id20, 
		project, project_billwith, retention_method, retention_percent, 
		user1, user2, user3, user4
	)
	select  
		'','',baseCuryID,'',
		'','','','',
		getdate(),'BIBMM',@parm2,'',
		'','','','',
		'',getdate(),'BIBMM',@parm2,
		0,
		'','','','','',0,0,'','',0,'','','','','','','','','','',
		@parm1,'','',0,
		'','',0,0
	from glsetup 
	where			-- Avoid duplicate value error on Insert
		not exists (select project from PJBill where project = @parm1)

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
