USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_NoteCopy]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOHeader_NoteCopy] @AccessNbr smallint As
Update SOHeader Set NoteId = B.NoteId From SOHeader A Inner Join ED850Header B On A.CpnyId =
B.CpnyId And A.EDIPOID = B.EDIPOID Where A.EDIPOID In (Select EDIPOID From EDWrkPOToSO Where
AccessNbr = @AccessNbr)
GO
