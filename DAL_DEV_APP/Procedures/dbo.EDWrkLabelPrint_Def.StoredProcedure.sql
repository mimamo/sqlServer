USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_Def]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDWrkLabelPrint_Def] As
Select * From EDWrkLabelPrint
GO
