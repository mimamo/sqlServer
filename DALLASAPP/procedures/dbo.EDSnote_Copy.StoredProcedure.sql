USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSnote_Copy]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSnote_Copy] @nid int As
Declare @NoteId int
Insert Into Snote (dtRevisedDate,sLevelName,sTableName,sNoteText) Select dtRevisedDate,sLevelName,sTableName,sNoteText From SNote Where Nid = @nid
Select @NoteId = @@Identity
Select @NoteId
GO
