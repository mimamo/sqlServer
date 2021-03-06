USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetNoteText]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_GetNoteText]
	@NoteID		integer
AS
	DECLARE	@sNoteText	char(8000)

	SELECT	@sNoteText = sNoteText
	FROM	Snote
	WHERE	nID = @NoteID

	IF @@ROWCOUNT = 0
		SELECT	@sNoteText = ''
	ELSE
		SELECT	convert(text,@sNoteText)
GO
