USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_Imported]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_Imported] As Select A.CpnyId, A.EDIPOID, A.NoteId, B.OrdNbr From
ED850Header A, SOHeader B Where A.EDIPOID = B.EDIPOID And A.UpdateStatus = 'IN' And B.Cancelled = 0
GO
