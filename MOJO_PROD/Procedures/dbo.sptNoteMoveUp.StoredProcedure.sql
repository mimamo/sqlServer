USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteMoveUp]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteMoveUp]
	@NoteKey int

AS --Encrypt

Declare @CurOrder int
Declare @AboveKey int
Declare @NoteGroupKey int


Select @CurOrder = DisplayOrder, @NoteGroupKey = NoteGroupKey
From tNote (nolock)
Where NoteKey = @NoteKey

Select @AboveKey = NoteKey from tNote (nolock)
Where
	@NoteGroupKey = NoteGroupKey and
	DisplayOrder = @CurOrder - 1

if @AboveKey is null
	return 1

Update tNote
Set DisplayOrder = @CurOrder
Where NoteKey = @AboveKey

Update tNote
Set DisplayOrder = @CurOrder - 1
Where NoteKey = @NoteKey
GO
