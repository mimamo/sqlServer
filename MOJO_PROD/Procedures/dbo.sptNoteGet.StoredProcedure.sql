USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGet]
	@NoteKey int

AS --Encrypt

		SELECT tNote.*, tNoteGroup.GroupName
		FROM tNote (nolock) inner join tNoteGroup (nolock) on tNote.NoteGroupKey = tNoteGroup.NoteGroupKey
		WHERE
			NoteKey = @NoteKey

	RETURN 1
GO
