USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSnote_GetNote]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSnote_GetNote] @NoteId int As
Declare @NoteText char(8000)
Select @NoteText = Left(Cast(sNoteText As Char),8000) From Snote Where nId = @NoteId
Select @NoteText
GO
