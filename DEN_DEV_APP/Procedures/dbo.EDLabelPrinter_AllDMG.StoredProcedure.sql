USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrinter_AllDMG]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabelPrinter_AllDMG] As
Select * From EDLabelPrinter Order By Name
GO
