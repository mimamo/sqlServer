USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGetList]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGetList]

	@CompanyKey int,
	@AssociatedEntity varchar(50),
	@EntityKey int


AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/29/08 GHL 8.512 Fixed ambiguity on EntityKey                 
  */
  
		SELECT tNote.*
		FROM tNoteGroup (nolock) 
			inner join tNote (nolock) on tNoteGroup.NoteGroupKey = tNote.NoteGroupKey
		WHERE
		tNoteGroup.CompanyKey = @CompanyKey and
		tNoteGroup.AssociatedEntity = @AssociatedEntity and
		tNoteGroup.EntityKey = @EntityKey
		Order By tNote.NoteGroupKey, tNote.DisplayOrder

	RETURN 1
GO
