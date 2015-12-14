USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteMoveDown]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteMoveDown]
	@NoteKey int

AS --Encrypt

Declare @CurOrder int
Declare @BelowKey int
Declare @NoteGroupKey int


Select @CurOrder = DisplayOrder, @NoteGroupKey = NoteGroupKey
From tNote (nolock)
Where NoteKey = @NoteKey

Select @BelowKey = NoteKey from tNote (nolock)
Where
	@NoteGroupKey = NoteGroupKey and
	DisplayOrder = @CurOrder + 1

if @BelowKey is null
	return 1

Update tNote
Set DisplayOrder = @CurOrder
Where NoteKey = @BelowKey

Update tNote
Set DisplayOrder = @CurOrder + 1
Where NoteKey = @NoteKey
GO
