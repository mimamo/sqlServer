USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGroupGet]
	@NoteGroupKey int

AS --Encrypt

		SELECT *
		FROM tNoteGroup (nolock)
		WHERE
			NoteGroupKey = @NoteGroupKey

	RETURN 1
GO
