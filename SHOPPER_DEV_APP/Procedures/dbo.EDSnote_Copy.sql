USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSnote_Copy]    Script Date: 12/16/2015 15:55:21 ******/
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
