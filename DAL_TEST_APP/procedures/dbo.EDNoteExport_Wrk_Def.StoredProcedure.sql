USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_Def]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDNoteExport_Wrk_Def] As
Select * From EDNoteExport_Wrk
GO
