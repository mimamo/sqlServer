USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrinter_Descr]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabelPrinter_Descr] @Name varchar(20) As
Select Descr From EDLabelPrinter Where Name = @Name
GO
