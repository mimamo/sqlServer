USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XSKNotes_Put]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XSKNotes_Put]
	@nID 			int,
	@sLevelName 		varchar(20),
	@sTableName 		varchar(20),
	@sNoteText 		varchar(8000)
as
	set nocount on

	-- If this is an existing note id
	if @nID <> 0
	BEGIN

		-- Update the note text
		UPDATE		Snote
		SET		sNoteText = @sNoteText,
				dtRevisedDate = getdate()
		WHERE		nID = @nID

	END
	
	else
	
	BEGIN
		-- Create a new note record
		Insert	Snote(dtRevisedDate, sLevelName, sTableName, sNoteText)
		Values	(cast(getdate() as smalldatetime), @sLevelName, @sTableName, @sNoteText)

		set @nID = @@IDENTITY
	END

	SELECT	@nID
GO
