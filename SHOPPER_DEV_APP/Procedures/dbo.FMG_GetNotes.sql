USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_GetNotes]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_GetNotes]
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
