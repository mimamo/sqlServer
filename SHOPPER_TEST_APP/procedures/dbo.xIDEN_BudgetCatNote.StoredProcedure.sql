USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDEN_BudgetCatNote]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Originally created by Altara
-- Create date: 
-- Updates:
-- CyGen - 5/1/09 - KJ - created this summary block
-- CyGen - 5/1/09 - KJ - replaced @@IDENTITY with SCOPE_IDENTITY() - item 11011
-- =============================================

CREATE PROCEDURE [dbo].[xIDEN_BudgetCatNote] @RevID varchar(10), @Project varchar(16), @Task varchar(30), @Account varchar(30)
AS

IF @RevID > 0
	BEGIN
		DECLARE @LockedRev varchar(10),
				@NewNoteID int,
				@OldNoteID int

		SELECT
			@LockedRev = pm_id25
		FROM
			PJPROJEX
		WHERE
			Project = @Project

		SELECT
			@OldNoteID = NoteID 
		FROM
			PJREVCAT
		WHERE
			Project = @Project and
			RevID = @LockedRev AND
			pjt_entity = @Task AND
			acct = @Account

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
				
				--SET @NewNoteID = @@IDENTITY
				SET @NewNoteID = SCOPE_IDENTITY()

			END
		ELSE
			BEGIN
				SET @NewNoteID = 0

			END


		SELECT @NewNoteID as NoteID
	END
GO
