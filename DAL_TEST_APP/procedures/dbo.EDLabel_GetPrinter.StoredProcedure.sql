USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabel_GetPrinter]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabel_GetPrinter] @Name varchar(30), @SiteId varchar(10) As
Select PrinterName From EDLabel Where Name = @Name And SiteId = @SiteId
GO
