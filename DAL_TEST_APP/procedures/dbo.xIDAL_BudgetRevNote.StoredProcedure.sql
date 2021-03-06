USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_BudgetRevNote]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_BudgetRevNote] @RevID varchar(10), @Project varchar(16)
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
					PJREVHDR 
				WHERE
					Project = @Project and
					RevID = @LockedRev

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
GO
