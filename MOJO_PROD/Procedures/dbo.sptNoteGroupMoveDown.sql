USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupMoveDown]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteGroupMoveDown]
	@NoteGroupKey int

AS --Encrypt

Declare @CurOrder int
Declare @BelowKey int
Declare @AssociatedEntity varchar(50)
Declare @EntityKey int


Select @CurOrder = DisplayOrder, @AssociatedEntity = AssociatedEntity, @EntityKey = EntityKey
From tNoteGroup (nolock)
Where NoteGroupKey = @NoteGroupKey

Select @BelowKey = NoteGroupKey from tNoteGroup (nolock)
Where
	AssociatedEntity = @AssociatedEntity and
	EntityKey = @EntityKey and
	DisplayOrder = @CurOrder + 1

if @BelowKey is null
	return 1

Update tNoteGroup
Set DisplayOrder = @CurOrder
Where NoteGroupKey = @BelowKey

Update tNoteGroup
Set DisplayOrder = @CurOrder + 1
Where NoteGroupKey = @NoteGroupKey
GO
