USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_Def]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDNoteExport_Wrk_Def] As
Select * From EDNoteExport_Wrk
GO
