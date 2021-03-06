USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTRAPS_Budget]    Script Date: 12/21/2015 13:36:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB 
--Fixed 3 errors on Revision ID 10/20/11 IWT:Gregory Houston

CREATE PROCEDURE [dbo].[xTRAPS_Budget] 

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
DECLARE @TRAPSRevID varchar(4),
		@TRAPSProject varchar(16),
		@RevID varchar(4),
		@NoteID int,
		@Note varchar(8000)


UPDATE xTRAPS_REVHDR
SET trigger_status = 'RI'
WHERE trigger_status <> 'IM'

UPDATE xTRAPS_REVTSK
SET trigger_status = 'RI'
WHERE trigger_status <> 'IM'

UPDATE xTRAPS_REVCAT
SET trigger_status = 'RI'
WHERE trigger_status <> 'IM'



DECLARE csr_Budget CURSOR FOR
	SELECT
		Project,
		RevID
	FROM
		xTRAPS_REVHDR
	WHERE
		trigger_status = 'RI'

OPEN csr_Budget

FETCH NEXT FROM csr_Budget INTO
	@TRAPSProject,
	@TRAPSRevID

WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT
			@RevID = ISNULL(MAX(CAST(RevID as int)), '-1')
		FROM
			PJREVHDR
		WHERE
			Project = @TRAPSProject

		SET @RevID = RIGHT('0000' + CAST(CAST(@RevID as int) + 1 as varchar(10)), 4)


		SELECT
			@NoteID = NoteID
		FROM
			xTRAPS_REVHDR
		WHERE
			xTRAPS_REVHDR.Project = @TRAPSProject AND
			xTRAPS_REVHDR.RevID = @TRAPSRevID

		IF ISNULL(@NoteID, 0) > 0
			BEGIN
				INSERT INTO 
					sNote(dtRevisedDate, sLevelName, sTableName, sNoteText)
				SELECT GETDATE(), 'Revision', 'pjrevhdr', note
				FROM xTRAPS_Note
				WHERE NoteID = @NoteID

				SET @NoteID = @@IDENTITY
					

			END
			
		
		INSERT INTO [PJREVHDR]
				   ([approved_by1]
				   ,[approved_by2]
				   ,[approved_by3]
				   ,[approver]
				   ,[Change_Order_Num]
				   ,[Create_Date]
				   ,[crtd_datetime]
				   ,[crtd_prog]
				   ,[crtd_user]
				   ,[end_date]
				   ,[Est_Approve_Date]
				   ,[lupd_datetime]
				   ,[lupd_prog]
				   ,[lupd_user]
				   ,[NoteId]
				   ,[Post_Date]
				   ,[Post_Period]
				   ,[Preparer]
				   ,[Project]
				   ,[RevId]
				   ,[RevisionType]
				   ,[Revision_Desc]
				   ,[rh_id01]
				   ,[rh_id02]
				   ,[rh_id03]
				   ,[rh_id04]
				   ,[rh_id05]
				   ,[rh_id06]
				   ,[rh_id07]
				   ,[rh_id08]
				   ,[rh_id09]
				   ,[rh_id10]
				   ,[start_date]
				   ,[status]
				   ,[update_type]
				   ,[User1]
				   ,[User2]
				   ,[User3]
				   ,[User4]
				   ,[User5]
				   ,[User6]
				   ,[User7]
				   ,[User8])
			 SELECT
				   ''
				   ,''
				   ,''
				   ,xTRAPS_REVHDR.approver
				   ,''
				   ,xTRAPS_REVHDR.Create_Date
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,xTRAPS_REVHDR.end_date
				   ,xTRAPS_REVHDR.Est_Approve_Date
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,ISNULL(@NoteID, 0)
				   ,xTRAPS_REVHDR.Post_Date
				   ,xTRAPS_REVHDR.Post_Period
				   ,xTRAPS_REVHDR.Preparer
				   ,xTRAPS_REVHDR.Project
				   ,@RevID --replaced @TRAPSRevID variable 10/20/11
				   ,xTRAPS_REVHDR.RevisionType
				   ,xTRAPS_REVHDR.Revision_Desc
				   ,''
				   ,''
				   ,''
				   ,''
				   ,''
				   ,0
				   ,0
				   ,' '
				   ,' '
				   ,0
				   ,xTRAPS_REVHDR.start_date
				   ,'I'
				   ,xTRAPS_REVHDR.update_type
				   ,''
				   ,''
				   ,0
				   ,0
				   ,'BU960'
				   ,''
				   ,' '
				   ,' '
			FROM
				xTRAPS_REVHDR
			WHERE
				xTRAPS_REVHDR.Project = @TRAPSProject AND
				xTRAPS_REVHDR.RevID = @TRAPSRevID


		INSERT INTO [PJREVCAT]
				   ([Acct]
				   ,[Amount]
				   ,[crtd_datetime]
				   ,[crtd_prog]
				   ,[crtd_user]
				   ,[lupd_datetime]
				   ,[lupd_prog]
				   ,[lupd_user]
				   ,[NoteId]
				   ,[pjt_entity]
				   ,[project]
				   ,[Rate]
				   ,[rc_id01]
				   ,[rc_id02]
				   ,[rc_id03]
				   ,[rc_id04]
				   ,[rc_id05]
				   ,[rc_id06]
				   ,[rc_id07]
				   ,[rc_id08]
				   ,[rc_id09]
				   ,[rc_id10]
				   ,[RevId]
				   ,[Units]
				   ,[user1]
				   ,[user2]
				   ,[user3]
				   ,[user4]
				   ,[User5]
				   ,[User6]
				   ,[User7]
				   ,[User8])
			 SELECT
				   CASE 
						WHEN xTRAPS_REVCAT.pjt_entity = '99992' THEN 'ESTIMATE TAX'
						ELSE 'ESTIMATE'
					END
				   ,xTRAPS_REVCAT.Amount
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,0
				   ,xTRAPS_REVCAT.pjt_entity
				   ,xTRAPS_REVCAT.project
				   ,xTRAPS_REVCAT.Rate
				   ,''
				   ,''
				   ,''
				   ,''
				   ,''
				   ,0
				   ,0
				   ,' '
				   ,' '
				   ,0
				   ,@RevID --replaced @TRAPSRevID variable 10/20/11
				   ,xTRAPS_REVCAT.Units
				   ,''
				   ,''
				   ,0
				   ,0
				   ,''
				   ,''
				   ,' '
				   ,' '
			FROM
				xTRAPS_REVCAT
			WHERE
				xTRAPS_REVCAT.REvID = @TRAPSRevID AND
				xTRAPS_REVCAT.Project = @TRAPSProject

		INSERT INTO [PJREVTSK]
				   ([contract_type]
				   ,[crtd_datetime]
				   ,[crtd_prog]
				   ,[crtd_user]
				   ,[end_date]
				   ,[fips_num]
				   ,[lupd_datetime]
				   ,[lupd_prog]
				   ,[lupd_user]
				   ,[manager1]
				   ,[NoteId]
				   ,[pe_id01]
				   ,[pe_id02]
				   ,[pe_id03]
				   ,[pe_id04]
				   ,[pe_id05]
				   ,[pe_id06]
				   ,[pe_id07]
				   ,[pe_id08]
				   ,[pe_id09]
				   ,[pe_id10]
				   ,[pjt_entity]
				   ,[pjt_entity_desc]
				   ,[project]
				   ,[revid]
				   ,[rt_id01]
				   ,[rt_id02]
				   ,[rt_id03]
				   ,[rt_id04]
				   ,[rt_id05]
				   ,[rt_id06]
				   ,[rt_id07]
				   ,[rt_id08]
				   ,[rt_id09]
				   ,[rt_id10]
				   ,[start_date]
				   ,[user1]
				   ,[user2]
				   ,[user3]
				   ,[user4]
				   ,[User5]
				   ,[User6]
				   ,[User7]
				   ,[User8])
			 SELECT
				   xTRAPS_REVTSK.contract_type
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,xTRAPS_REVTSK.end_date
				   ,xTRAPS_REVTSK.fips_num
				   ,GETDATE()
				   ,'IMPORT'
				   ,'IMPORT'
				   ,xTRAPS_REVTSK.manager1
				   ,0
				   ,''
				   ,''
				   ,''
				   ,''
				   ,''
				   ,0
				   ,0
				   ,' '
				   ,' '
				   ,0
				   ,xTRAPS_REVTSK.pjt_entity
				   ,xTRAPS_REVTSK.pjt_entity_desc
				   ,xTRAPS_REVTSK.project
				   ,@RevID  --replaced @TRAPSRevID variable 10/20/11
				   ,''
				   ,''
				   ,''
				   ,''
				   ,''
				   ,0
				   ,0
				   ,' '
				   ,' '
				   ,0
				   ,xTRAPS_REVTSK.start_date
				   ,''
				   ,''
				   ,0
				   ,0
				   ,''
				   ,''
				   ,' '
				   ,' '
			FROM
				xTRAPS_REVTSK
			WHERE
				xTRAPS_REVTSK.RevID = @TRAPSRevID AND
				xTRAPS_REVTSK.Project = @TRAPSProject


			UPDATE xTRAPS_REVTSK
			SET trigger_status = 'IM'
			WHERE RevID = @TRAPSRevID AND
				  Project = @TRAPSProject

			UPDATE xTRAPS_REVCAT
			SET trigger_status = 'IM'
			WHERE RevID = @TRAPSRevID AND
				  Project = @TRAPSProject

			UPDATE xTRAPS_REVHDR
			SET trigger_status = 'IM'
			WHERE RevID = @TRAPSRevID AND
				  Project = @TRAPSProject


		FETCH NEXT FROM csr_Budget INTO
			@TRAPSProject,
			@TRAPSRevID

	END
		
CLOSE csr_Budget
DEALLOCATE csr_Budget


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
