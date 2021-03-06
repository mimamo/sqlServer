USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_PutNotes]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_PutNotes]
	@nID integer OUTPUT,
	@sLevelName varchar(20),
	@sTableName varchar(20),
	@sNoteText varchar(8000)
as
	set nocount on

	-- If this is an existing note id
	if @nID <> 0 begin

		-- Update the note text
		Update	Snote
		Set	sNoteText = @sNoteText
		Where	nID = @nID

		if @@ROWCOUNT = 0
			return 0	--Failure
		else
			return 1	--Success
	end
	else begin
		-- Create a new note record
		Insert	Snote(dtRevisedDate, sLevelName, sTableName, sNoteText)
		Values	(cast(getdate() as smalldatetime), @sLevelName, @sTableName, @sNoteText)

		set @nID = @@IDENTITY
		--select @nID

		if @@ROWCOUNT = 0
			return 0	--Failure
		else
			return 1	--Success
	end
GO
