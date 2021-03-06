USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetNoteText]    Script Date: 12/21/2015 16:07:00 ******/
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
