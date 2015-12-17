USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsTaxHist_TaxId_YrMon_Sum]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsTaxHist_TaxId_YrMon_Sum    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SlsTaxHist_TaxId_YrMon_Sum] @parm1 varchar ( 10), @parm2 varchar ( 6) as

		select * From SlsTaxHist
			Where TaxId = @parm1
			and SlsTaxHist.YrMon like @parm2
			Order by Taxid, YrMon
GO
