USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_BySiteLabel]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkLabelPrint_BySiteLabel] As
Select * From EDWrkLabelPrint Order By SiteId, INIFileName,LabelDBPath,LabelFileName,NbrCopy, ShipperId
GO
