USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTRAPS_Timesheets]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB 
-- this SPROC is called from 1st step of the scheduled job "TRAPS Timesheet Import" (the DTS step) - MSB

CREATE PROCEDURE [dbo].[xTRAPS_Timesheets] 

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
DECLARE @DocNbr varchar(10),
		@TRAPSDocNbr varchar(10),
		@TrapsError varchar(2),
		@xTRAPS_TIMDETemployee varchar(10),
		@PJPROJlabor_gl_acct varchar(15)
	   ,@PJEmploygl_subacct varchar(30)
	   ,@PJEMPPJTlabor_class_cd varchar(15)
	   ,@xTRAPS_TIMDETot1_hours float
	   ,@xTRAPS_TIMDETot2_hours float
	   ,@xTRAPS_TIMDETpjt_entity varchar(32)
	   ,@xTRAPS_TIMDETproject varchar(16)
	   ,@xTRAPS_TIMDETreg_hours float
	   ,@xTRAPS_TIMDETtl_date smalldatetime
	   ,@xTRAPS_TIMDETtl_id17 varchar(4)
	   ,@xTRAPS_TIMDETdocnbr varchar(10),
		@LineNbr int



UPDATE xTRAPS_TIMHDR
SET trigger_status = 'RI'
WHERE trigger_status <> 'IM'


UPDATE xTRAPS_TIMDET
SET trigger_status = 'RI'
WHERE trigger_status <> 'IM'

DECLARE csr_TimeDocs CURSOR FOR
	SELECT
		docnbr
	FROM
		xTRAPS_TIMHDR
	WHERE
		trigger_status = 'RI'

OPEN csr_TimeDocs
FETCH NEXT FROM csr_TimeDocs INTO 
	@TRAPSDocNbr

WHILE @@FETCH_STATUS = 0
	BEGIN
		

		UPDATE xTRAPS_TIMDET
		SET trigger_Status = 'EM' --Employee Missing
		WHERE docnbr = @TRAPSDocNbr AND
			  trigger_status = 'RI' AND
			  employee NOT IN (SELECT employee FROM PJEMPLOY) --Employee Missing

		UPDATE xTRAPS_TIMDET
		SET trigger_Status = 'PR' --Project doesn't exist
		WHERE docnbr = @TRAPSDocNbr AND
			  trigger_status = 'RI' AND
			  Project NOT IN (SELECT project FROM PJproj) --Project doesn't exist

		UPDATE xTRAPS_TIMDET
		SET trigger_Status = 'LB' --Labor gl account missing
		WHERE docnbr = @TRAPSDocNbr AND
			  trigger_status = 'RI' AND
			  Project IN (SELECT project FROM PJproj WHERE RTRIM(labor_gl_acct) = '') --Labor gl account missing

		UPDATE xTRAPS_TIMDET
		SET trigger_Status = 'EP' --Employee missing labor class 
		WHERE docnbr = @TRAPSDocNbr AND
			  trigger_status = 'RI' AND
			  employee NOT IN (SELECT employee FROM xPJEMPPJT WHERE effect_date <= GETDATE()) --Employee missing labor class 

		UPDATE xTRAPS_TIMDET
		SET trigger_Status = 'PT' --Missing Function Code on Job
		WHERE docnbr = @TRAPSDocNbr AND
			  trigger_status = 'RI' AND
			  RTRIM(Project) + '-' + RTRIM(pjt_entity) NOT IN (SELECT RTRIM(Project) + '-' + RTRIM(pjt_entity) FROM PJPENT) --Missing Function Code on Job

		IF NOT EXISTS (SELECT * FROM xTRAPS_TIMDET WHERE docnbr = @TRAPSDocNbr AND trigger_status != 'RI')
			BEGIN		 
				SELECT
					@DocNbr = LastUsed_labhdr
				FROM
					PJDOCNUM
				WHERE
					id = 13


				SET @DocNbr = RIGHT('0000000000' + CAST((CAST(@DocNbr as int) + 1) as varchar(10)), 10)

				UPDATE PJDOCNUM
				SET LastUsed_labhdr = @DocNbr
				WHERE id = 13


				SET @LineNbr = -32768

				INSERT INTO [PJTIMHDR]
						   ([approver]
						   ,[BaseCuryId]
						   ,[cpnyId]
						   ,[crew_cd]
						   ,[crtd_datetime]
						   ,[crtd_prog]
						   ,[crtd_user]
						   ,[CuryEffDate]
						   ,[CuryId]
						   ,[CuryMultDiv]
						   ,[CuryRate]
						   ,[CuryRateType]
						   ,[docnbr]
						   ,[end_time]
						   ,[lupd_datetime]
						   ,[lupd_prog]
						   ,[lupd_user]
						   ,[multi_emp_sw]
						   ,[noteid]
						   ,[percent_comp]
						   ,[preparer_id]
						   ,[project]
						   ,[pjt_entity]
						   ,[shift]
						   ,[start_time]
						   ,[th_comment]
						   ,[th_date]
						   ,[th_key]
						   ,[th_id01]
						   ,[th_id02]
						   ,[th_id03]
						   ,[th_id04]
						   ,[th_id05]
						   ,[th_id06]
						   ,[th_id07]
						   ,[th_id08]
						   ,[th_id09]
						   ,[th_id10]
						   ,[th_id11]
						   ,[th_id12]
						   ,[th_id13]
						   ,[th_id14]
						   ,[th_id15]
						   ,[th_id16]
						   ,[th_id17]
						   ,[th_id18]
						   ,[th_id19]
						   ,[th_id20]
						   ,[th_status]
						   ,[th_type]
						   ,[user1]
						   ,[user2]
						   ,[user3]
						   ,[user4])
					 SELECT
						   ''
						   ,'USD'
						   ,'DENVER'
						   ,''
						   ,GETDATE()
						   ,'IMPORT'
						   ,'IMPORT'
						   ,' '
						   ,'USD'
						   ,'M'
						   ,1
						   ,''
						   ,@DocNbr
						   ,''
						   ,GETDATE()
						   ,'IMPORT'
						   ,'IMPORT'
						   ,''
						   ,0
						   ,0
						   ,preparer_id
						   ,project
						   ,''
						   ,''
						   ,''
						   ,th_comment
						   ,th_date
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,0
						   ,' '
						   ,0
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,''
						   ,0
						   ,' '
						   ,0
						   ,'C'
						   ,''
						   ,DocNbr
						   ,''
						   ,0
						   ,0
					FROM
						xTRAPS_TIMHDR
					WHERE
						docnbr = @TRAPSDocNbr
				DECLARE csr_TimeDetail CURSOR FOR
				SELECT xTRAPS_TIMDET.employee
				, PJPROJ.labor_gl_acct
				, PJEmploy.gl_subacct
				, xPJEMPPJT.labor_class_cd
				, xTRAPS_TIMDET.ot1_hours
				, xTRAPS_TIMDET.ot2_hours
				, xTRAPS_TIMDET.pjt_entity
				, xTRAPS_TIMDET.project
				, xTRAPS_TIMDET.reg_hours
				, xTRAPS_TIMDET.tl_date
				, xTRAPS_TIMDET.tl_id17
				, xTRAPS_TIMDET.docnbr
				FROM xTRAPS_TIMDET INNER JOIN PJEMPLOY ON xTRAPS_TIMDET.employee = PJEMPLOY.employee
					LEFT JOIN xPJEMPPJT ON xTRAPS_TIMDET.employee = xPJEMPPJT.employee --fixed to use xPJEMPPJT VIEW rather than PJEMPPJT TABLE to avoid duplication
					INNER JOIN PJPROJ ON xTRAPS_TIMDET.project = PJPROJ.Project
				WHERE
					xTRAPS_TIMDET.docnbr = @TRAPSDocNbr

				OPEN csr_TimeDetail 
				FETCH NEXT FROM csr_TimeDetail INTO
					@xTRAPS_TIMDETemployee, 
					@PJPROJlabor_gl_acct 
				   ,@PJEmploygl_subacct
				   ,@PJEMPPJTlabor_class_cd
				   ,@xTRAPS_TIMDETot1_hours
				   ,@xTRAPS_TIMDETot2_hours
				   ,@xTRAPS_TIMDETpjt_entity
				   ,@xTRAPS_TIMDETproject 
				   ,@xTRAPS_TIMDETreg_hours
				   ,@xTRAPS_TIMDETtl_date
				   ,@xTRAPS_TIMDETtl_id17
				   ,@xTRAPS_TIMDETdocnbr 
				
				WHILE @@FETCH_STATUS = 0
					BEGIN

						
							INSERT INTO [PJTIMDET]
									   ([cert_pay_sw]
									   ,[CpnyId_chrg]
									   ,[CpnyId_eq_home]
									   ,[CpnyId_home]
									   ,[crtd_datetime]
									   ,[crtd_prog]
									   ,[crtd_user]
									   ,[docnbr]
									   ,[earn_type_id]
									   ,[employee]
									   ,[elapsed_time]
									   ,[end_time]
									   ,[equip_amt]
									   ,[equip_home_subacct]
									   ,[equip_id]
									   ,[equip_rate]
									   ,[equip_rate_cd]
									   ,[equip_rate_indicator]
									   ,[equip_units]
									   ,[equip_uom]
									   ,[gl_acct]
									   ,[gl_subacct]
									   ,[group_code]
									   ,[labor_amt]
									   ,[labor_class_cd]
									   ,[labor_rate]
									   ,[labor_rate_indicator]
									   ,[linenbr]
									   ,[lupd_datetime]
									   ,[lupd_prog]
									   ,[lupd_user]
									   ,[noteid]
									   ,[ot1_hours]
									   ,[ot2_hours]
									   ,[pjt_entity]
									   ,[project]
									   ,[reg_hours]
									   ,[shift]
									   ,[start_time]
									   ,[tl_date]
									   ,[tl_id01]
									   ,[tl_id02]
									   ,[tl_id03]
									   ,[tl_id04]
									   ,[tl_id05]
									   ,[tl_id06]
									   ,[tl_id07]
									   ,[tl_id08]
									   ,[tl_id09]
									   ,[tl_id10]
									   ,[tl_id11]
									   ,[tl_id12]
									   ,[tl_id13]
									   ,[tl_id14]
									   ,[tl_id15]
									   ,[tl_id16]
									   ,[tl_id17]
									   ,[tl_id18]
									   ,[tl_id19]
									   ,[tl_id20]
									   ,[tl_status]
									   ,[union_cd]
									   ,[user1]
									   ,[user2]
									   ,[user3]
									   ,[user4]
									   ,[work_comp_cd]
									   ,[work_type])
							VALUES
									   ('N'
									   ,'DENVER'
									   ,''
									   ,'DENVER'
									   ,GETDATE()
									   ,'IMPORT'
									   ,'IMPORT'
									   ,@DocNbr
									   ,''
									   ,@xTRAPS_TIMDETemployee
									   ,''
									   ,''
									   ,0
									   ,''
									   ,''
									   ,0
									   ,'RATE1'
									   ,''
									   ,0
									   ,''
									   ,@PJPROJlabor_gl_acct
									   ,@PJEmploygl_subacct
									   ,''
									   ,0
									   ,@PJEMPPJTlabor_class_cd
									   ,0
									   ,''
									   ,@LineNbr	
									   ,GETDATE()
									   ,'IMPORT'
									   ,'IMPORT'
									   ,0
									   ,@xTRAPS_TIMDETot1_hours
									   ,@xTRAPS_TIMDETot2_hours
									   ,@xTRAPS_TIMDETpjt_entity
									   ,@xTRAPS_TIMDETproject
									   ,@xTRAPS_TIMDETreg_hours
									   ,''
									   ,''
									   ,@xTRAPS_TIMDETtl_date
									   ,''
									   ,''
									   ,''
									   ,''
									   ,''
									   ,''
									   ,''
									   ,0
									   ,' '
									   ,0
									   ,@PJEMPLOYgl_subacct
									   ,''
									   ,''
									   ,''
									   ,''
									   ,''
									   ,@xTRAPS_TIMDETtl_id17
									   ,0
									   ,''
									   ,0
									   ,''
									   ,''
									   ,@xTRAPS_TIMDETdocnbr
									   ,''
									   ,0
									   ,0
									   ,''
									   ,'')

					SET @LineNbr = @LineNbr + 10
					FETCH NEXT FROM csr_TimeDetail INTO
						@xTRAPS_TIMDETemployee, 
						@PJPROJlabor_gl_acct --ISSUE when employee switches departments
					   ,@PJEmploygl_subacct
					   ,@PJEMPPJTlabor_class_cd
					   ,@xTRAPS_TIMDETot1_hours
					   ,@xTRAPS_TIMDETot2_hours
					   ,@xTRAPS_TIMDETpjt_entity
					   ,@xTRAPS_TIMDETproject 
					   ,@xTRAPS_TIMDETreg_hours
					   ,@xTRAPS_TIMDETtl_date
					   ,@xTRAPS_TIMDETtl_id17
					   ,@xTRAPS_TIMDETdocnbr 


				END

				CLOSE csr_TimeDetail
				DEALLOCATE csr_TimeDetail

				UPDATE xTRAPS_TIMHDR
				SET trigger_status = 'IM'
				WHERE xTRAPS_TIMHDR.docnbr = @TRAPSDocNbr
				
				UPDATE xTRAPS_TIMDET
				SET trigger_status = 'IM'
				WHERE xTRAPS_TIMDET.docnbr = @TRAPSDocNbr

				
			END
		ELSE
			BEGIN
				UPDATE xTRAPS_TIMHDR
				SET trigger_status = 'NI'
				WHERE xTRAPS_TIMHDR.docnbr = @TRAPSDocNbr
			END
		FETCH NEXT FROM csr_TimeDocs INTO 
			@TRAPSDocNbr
	
	END

CLOSE csr_TimeDocs
DEALLOCATE csr_TimeDocs


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
