USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetNotes]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetNotes]
	@nID integer,
	@sNoteText varchar(8000) OUTPUT
as
	select	@sNoteText = sNoteText
	from	Snote
	where	nID = @nID

	if @@ROWCOUNT = 0 begin
		set @sNoteText = ''
		return 0	--Failure
	end
	else
		--select @sNoteText
		return 1	--Success
GO
