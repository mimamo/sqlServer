USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_ExcludePrinter]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkLabelPrint_ExcludePrinter] @PrinterName varchar(20) As
Select * From EDWrkLabelPrint Where PrinterName <> @PrinterName
Order By SiteId, INIFileName,LabelDBPath,LabelFileName,NbrCopy, PrinterName, ShipperId
GO
