USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCombineNote]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDCombineNote] @NoteID1 int, @NoteId2 int
AS
	Set NoCount on
	Declare @NewNoteId int
	Declare @ptrval1 varbinary(16)
	Declare @ptrval2 varbinary(16)

	Insert Into Snote Select GetDate(), 'Lines','soline',sNoteText,Null From SNote Where nID = @NoteID1
	Set @NewNoteId = @@Identity
	select @ptrval1 = textptr(snotetext) from Snote where Snote.nId = @NewNoteId
	select @ptrval2 = textptr(snotetext) from Snote where Snote.nId = @NoteId2
	UpdateText snote.snotetext @ptrval1 NULL 0 WITH LOG ' '
	UpdateText snote.snotetext @ptrval1 NULL 0 WITH LOG SNote.sNoteText @ptrval2
	Select @NewNoteId
GO
