USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_RcptNbr_LandedCost]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_RcptNbr_LandedCost]
	@ReceiptNbr varchar( 10 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM POTran
	WHERE RcptNbr LIKE @ReceiptNbr
	   AND POLineNbr BETWEEN @parm2min AND @parm2max
	   AND PurchaseType IN ('GI','GP','GS','GN')
	ORDER BY PONbr,
	   POLineNbr
GO
