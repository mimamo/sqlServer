USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Item2Hist_Invt_Site_SumYtdIssd]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Item2Hist_Invt_Site_SumYtdIssd]
	@parm1 varchar ( 30),
	@parm2 varchar ( 10)
AS
SELECT Sum(YtdQtyIssd)+ Sum(YtdQtySls) FROM Item2Hist
	WHERE InvtId  = @parm1
	AND SiteID = @parm2
	GROUP BY InvtID,SiteID
GO
