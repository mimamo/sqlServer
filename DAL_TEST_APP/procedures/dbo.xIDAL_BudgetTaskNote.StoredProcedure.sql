USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_BudgetTaskNote]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_BudgetTaskNote] @RevID varchar(10), @Project varchar(16), @Task varchar(30)
AS

IF @RevID > 0
	BEGIN
		DECLARE @LockedRev varchar(10),
				@NewNoteID int,
				@OldNoteID int,
				@LastUpdatedDate smalldatetime

		SELECT
			@LastUpdatedDate = MAX(lupd_datetime)
		FROM
			PJREVHDR
		WHERE
			Project = @Project AND
			Status = 'P'

		SELECT
			@LockedRev = MAX(RevID)
		FROM
			PJREVHDR
		WHERE
			Project = @Project AND
			Status = 'P' AND
			lupd_datetime = @LastUpdatedDate

		SELECT
			@OldNoteID = NoteID 
		FROM
			PJREVTSK
		WHERE
			Project = @Project and
			RevID = @LockedRev AND
			pjt_entity = @Task

		IF @OldNoteID > 0 
			BEGIN
				INSERT INTO
						sNOTE
						(dtRevisedDate,
						sLevelName,
						sTableName,
						sNoteText)
				SELECT
					GETDATE(),
					sLevelName,
					sTableName,
					sNoteText
				FROM
					sNote
				WHERE
					nID = @OldNoteID	
				
				SET @NewNoteID = @@IDENTITY

			END
		ELSE
			BEGIN
				SET @NewNoteID = 0

			END


		SELECT @NewNoteID as NoteID
	END

IF EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID('[dbo].[xIDAL_BudgetTaskNote]') AND [type] = 'P')
	BEGIN
		PRINT 'Procedure [dbo].[xIDAL_BudgetTaskNote] created successfully'
	END
ELSE
	BEGIN 
		PRINT 'Problem creating procedure [dbo].[xIDAL_BudgetTaskNote], please stop and contact technical support'
	END
GO
