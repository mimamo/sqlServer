USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrinter_Descr]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabelPrinter_Descr] @Name varchar(20) As
Select Descr From EDLabelPrinter Where Name = @Name
GO
