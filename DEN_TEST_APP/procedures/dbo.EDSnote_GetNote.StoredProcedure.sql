USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSnote_GetNote]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSnote_GetNote] @NoteId int As
Declare @NoteText char(8000)
Select @NoteText = Left(Cast(sNoteText As Char),8000) From Snote Where nId = @NoteId
Select @NoteText
GO
