USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrinter_All]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDLabelPrinter_All] @Name varchar(20) As
Select * From EDLabelPrinter Where Name Like @Name Order By Name
GO
