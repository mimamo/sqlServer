USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_BySiteLabel]    Script Date: 12/21/2015 15:49:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkLabelPrint_BySiteLabel] As
Select * From EDWrkLabelPrint Order By SiteId, INIFileName,LabelDBPath,LabelFileName,NbrCopy, ShipperId
GO
