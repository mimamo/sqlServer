USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteDelete]
	@NoteKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 3/25/08   CRG 1.0.0.0 Added update of NoteOrder based on Entity/EntityKey
*/

	Declare @CurOrder int,
			@CurNoteOrder int,
			@NoteGroupKey int,
			@Entity varchar(50),
			@EntityKey int

	Select	@NoteGroupKey = NoteGroupKey, 
			@CurOrder = DisplayOrder,
			@CurNoteOrder = NoteOrder,
			@Entity = Entity,
			@EntityKey = EntityKey
	from	tNote (nolock) 
	Where	NoteKey = @NoteKey
	
	Update	tNote
	Set		DisplayOrder = DisplayOrder - 1
	Where	NoteGroupKey = @NoteGroupKey and
			DisplayOrder > @CurOrder
			
	UPDATE	tNote
	SET		NoteOrder = NoteOrder - 1
	WHERE	Entity = @Entity
	AND		EntityKey = @EntityKey
	AND		NoteOrder > @CurNoteOrder

	Delete From tLink
	Where AssociatedEntity = 'Note' and
	EntityKey = @NoteKey

	DELETE
	FROM tNote
	WHERE
		NoteKey = @NoteKey 

	RETURN 1
GO
