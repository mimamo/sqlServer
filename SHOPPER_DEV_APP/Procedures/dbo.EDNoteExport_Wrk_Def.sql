USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_Def]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDNoteExport_Wrk_Def] As
Select * From EDNoteExport_Wrk
GO
