USE [DEN_DEV_APP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'xpbEstimate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xpbEstimate]
GO

-- Use dynamic string parsing on WHERE clause, DJ NexusTek 2013-12-11
-- UPDATED to T-SQL Standard 10/12/2009 JWG & MSB 
CREATE PROCEDURE [dbo].[xpbEstimate]
@RI_ID int
AS

/*******************************************************************************************************
*   DEN_DEV_APP.dbo.xpbEstimate
*
*   Creator:	NexusTek
*   Date:		
*		
*
*   Notes:      
			select * from den_dev_app.dbo.xwrk_Estimates  
			select * from den_dev_app.dbo.rptRunTime
			
			truncate table den_dev_app.dbo.xwrk_Estimates
			truncate table den_dev_app.dbo.xwrk_TM007
				

			execute den_dev_app.dbo.xpbEstimate @RI_ID = 7500
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @Project varchar(16)
DECLARE @RptRevID varchar(4)
DECLARE @RptRevIDStatus varchar(2)
DECLARE @PrevRevID varchar(4)
DECLARE @Where varchar(255)
DECLARE @Search as varchar(255)     --PS/Altara 10/05/06
DECLARE @POS as int                 --PS/Altara 10/05/06
DECLARE @FirstTick As int  -- DJ/NexusTek 2013-12-11
DECLARE @SecondTick As int -- DJ/NexusTek 2013-12-11
DECLARE @ThirdTick As int  -- DJ/NexusTek 2013-12-11
DECLARE @FourthTick as int -- DJ/NexusTek 2013-12-11
	
---------------------------------------------
-- create temp tables
---------------------------------------------
 
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
set xact_abort on  -- only uncomment if the procedure has a transaction
 
---------------------------------------------
-- body of stored procedure
---------------------------------------------
--clear out the work table
DELETE FROM den_dev_app.dbo.xwrk_Estimates 
WHERE RI_ID = @RI_ID

BEGIN
           
BEGIN TRANSACTION

	BEGIN TRY

		--retrieve the where clause
						FROM den_dev_app.dbo.rptruntime 
						WHERE RI_ID = @RI_ID)

SET @FirstTick = CHARINDEX('''', @Where)                   -- DJ/NexusTek 2013-12-11
SET @SecondTick = CHARINDEX('''', @Where, @FirstTick + 1)  -- DJ/NexusTek 2013-12-11
SET @ThirdTick = CHARINDEX('''', @Where, @SecondTick + 1)  -- DJ/NexusTek 2013-12-11
SET @FourthTick = CHARINDEX('''', @Where, @ThirdTick + 1)  -- DJ/NexusTek 2013-12-11

--retrieve/set the project
-- SET @Project = SUBSTRING(@Where,22,11)
SET @Project = SUBSTRING(@Where, @FirstTick + 1, @SecondTick - @FirstTick - 1)  -- DJ/NexusTek 2013-12-11
PRINT 'Project: ' + @Project

--retrieve/set the reporting revision id
-- SET @RptRevID = SUBSTRING(@Where,59,4)
SET @RptRevID = SUBSTRING(@Where, @ThirdTick + 1, @FourthTick - @ThirdTick - 1) -- DJ/NexusTek 2013-12-11
PRINT 'RevID: ' + @RptRevID

--PS 10/05/2006 : Update RI_WHERE Clause
SELECT @Search = '(RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) + ')'

SELECT @POS = PATINDEX('%' + @Search + '%', @WHERE)

UPDATE den_dev_app.dbo.RptRunTime 
			SET RI_WHERE = CASE WHEN @WHERE IS NULL OR DATALENGTH(@WHERE) <= 0 THEN @Search
      -- WHEN @POS <= 0                              -- DJ/NexusTek 2013-12-11
      --      THEN @Search + ' AND (' + @WHERE + ')' -- DJ/NexusTek 2013-12-11
      ELSE @WHERE                                    -- DJ/NexusTek 2013-12-11
END
WHERE RI_ID = @RI_ID

--retrieve the records for the reporting revision id
INSERT den_dev_app.dbo.xwrk_Estimates 
		SELECT RI_ID,
			UserID,
			RunDate,
			RunTime,
			TerminalNum,
			RecordType,
			Project,
			RevID,
			RevStatus,
			FunctionCode,
			Amount,
			Units,
			AccountType,
			ProjectNoteID,
			TaskNoteID,
			ProjectNote = ISNULL(pnote.snotetext, ''),
			TaskNote = ISNULL(tnote.snotetext, '')	
		FROM (SELECT RI_ID = @RI_ID,
				UserID = r.UserID,
				RunDate = r.SystemDate,
				RunTime = r.SystemTime,
				TerminalNum = r.ComputerName,
				RecordType = 'RptRevID',
				Project = h.project,
				RevID = h.revid,
				RevStatus = h.[status],
				FunctionCode = CASE WHEN c.pjt_entity = '00925' THEN '00900'
									ELSE c.pjt_entity 
								END,
				Amount = sum(c.amount),
				Units = sum(c.units),
				AccountType = c.acct,
				ProjectNoteID = h.noteID,
				TaskNoteID = t.noteID
			from den_dev_app.dbo.pjrevhdr h
			inner join den_dev_app.dbo.pjrevtsk t	
				on h.project = t.project 
				and h.revid = t.revid	
			inner join den_dev_app.dbo.pjrevcat c
			on t.project = c.project 
				and t.revid = c.revid 
				and t.pjt_entity = c.pjt_entity			
		inner join den_dev_app.dbo.rptruntime r 
				on @RI_ID = r.RI_ID
			where h.project = @Project
				and h.revid = @RptRevID
			group by h.project, h.revid, h.[status], c.pjt_entity, c.acct, /*t.NoteID,*/ r.ComputerName, r.UserID, r.SystemDate, r.SystemTime, h.noteID, t.noteID
		--HAVING sum(c.amount)<>0
) RevData 
LEFT JOIN den_dev_app.dbo.sNote PNote 
	ON RevData.ProjectNoteID = PNote.nID
LEFT JOIN den_dev_app.dbo.sNote TNote 
	ON RevData.TaskNoteID = TNote.nID

--retrieve the status of the reporting revision id
SET @RptRevIDStatus = (SELECT s.[status] 
								FROM den_dev_app.dbo.pjrevhdr s 
						WHERE s.Project = @Project 
							AND s.RevID = @RptRevID)

--if the reporting revision id is Posted then the previous revision id
--should come from rh_id05 on the estimate header record, if not the 
--previous revision id should come from pm_id25 on the project record
--posted = "locked" - MSB 
IF @RptRevIDStatus = 'P'

BEGIN

PRINT 'Reporting Revision Status is Posted'

SET @PrevRevID = (SELECT rh_id05 
								FROM den_dev_app.dbo.pjrevhdr 
					WHERE project = @Project 
						AND revid = @RptRevID)
									
PRINT 'Previous Rev ID: ' + @PrevRevID
			
END

ELSE

BEGIN

PRINT 'Reporting Revision Status is NOT Posted'

SET @PrevRevID = (SELECT pm_id25 
							FROM den_dev_app.dbo.pjprojex 
					WHERE project = @Project)
							
PRINT 'Previous Revision ID: ' + @PrevRevID

END

--if this is the first revision on a project, there is the potential
--for the @PrevRevID to be blank.  Test for blank and only select the 
--previous revision if @PrevRevID is not blank
IF RTRIM(LTRIM(@PrevRevID)) <> ''

BEGIN

--retrieve the records for the previous revision id
		INSERT den_dev_app.dbo.xwrk_Estimates 
		SELECT RI_ID,
			UserID,
			RunDate,
			RunTime,
			TerminalNum,
			RecordType,
			Project,
			RevID,
			RevStatus,
			FunctionCode,
			Amount,
			Units,
			AccountType,
			ProjectNoteID,
			TaskNoteID,
			ProjectNote = ISNULL(pnote.snotetext, ''),
			TaskNote = ISNULL(tnote.snotetext, '')	
		FROM (SELECT RI_ID = @RI_ID,
						UserID = r.UserID,
						RunDate = r.SystemDate,
						RunTime = r.SystemTime,
						TerminalNum = r.ComputerName,
						RecordType = 'PrevRevID',
						Project = h.project,
						RevID = h.revid,
						RevStatus = h.[status],
						FunctionCode = CASE WHEN c.pjt_entity = '00925' THEN '00900'ELSE c.pjt_entity END,
						Amount = sum(c.amount),
						Units = sum(c.units),
						AccountType = c.acct,
						ProjectNoteID = h.noteID,
						TaskNoteID = t.noteID
					FROM (SELECT * 
						FROM den_dev_app.dbo.pjrevhdr 
						WHERE project = @Project 
							AND RevID = @PrevRevID) h
		inner join (SELECT * 
				FROM den_dev_app.dbo.pjrevtsk 
				WHERE project = @Project 
					AND RevID = @PrevRevID) t 
			on h.project = t.project 
			AND h.revid = t.revid
		inner join(SELECT * 
					FROM den_dev_app.dbo.pjrevcat 
					WHERE project = @Project 
						AND RevID = @PrevRevID) c 
			on t.project = c.project 
			AND t.revid=c.revid 
			AND t.pjt_entity = c.pjt_entity
		inner join den_dev_app.dbo.rptruntime r 
			ON @RI_ID = r.RI_ID
WHERE h.project = @Project
	AND h.revid = @PrevRevID
GROUP By h.project, h.revid, h.[status], c.pjt_entity, c.acct, /*t.NoteID,*/ r.ComputerName, r.UserID, r.SystemDate, r.SystemTime, h.noteID, t.noteID
--HAVING sum(c.amount)<>0
			ON RevData.ProjectNoteID = PNote.nID
			ON RevData.TaskNoteID = TNote.nID

END

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

		EXEC den_dev_app.dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA,
			@ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH


IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END
GO
