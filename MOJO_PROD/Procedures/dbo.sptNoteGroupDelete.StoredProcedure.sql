USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGroupDelete]
	@NoteGroupKey int

AS --Encrypt

	if exists(select 1 from tNote (nolock) Where NoteGroupKey = @NoteGroupKey)
		return -1


Declare @CurOrder int
Declare @EntityKey int
Declare @AssociatedEntity varchar(50)

Select @EntityKey = EntityKey, @AssociatedEntity = AssociatedEntity, @CurOrder = DisplayOrder 
from tNoteGroup (nolock) Where NoteGroupKey = @NoteGroupKey

	Update tNoteGroup
	Set DisplayOrder = DisplayOrder - 1
	Where
		AssociatedEntity = @AssociatedEntity and
		EntityKey = @EntityKey and
		DisplayOrder > @CurOrder
		

	DELETE
	FROM tNoteGroup
	WHERE
		NoteGroupKey = @NoteGroupKey 

	RETURN 1
GO
