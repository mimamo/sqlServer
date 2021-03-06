USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_SumQty_LCVoucher]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_SumQty_LCVoucher]
	@ReceiptNbr varchar( 10 ),
	@SiteID varchar (10),
	@InvtID varchar (30),
	@SpecificCostID varchar (25)
AS
	SELECT Sum(Qty)
	FROM POTran (NOLOCK)
	WHERE
		RcptNbr LIKE @ReceiptNbr
	   	AND
		PurchaseType IN ('GI','GP','GS','GN')
		AND
		InvtID = @InvtID
		and
		SiteID = @siteID
		AND
		SpecificCostID Like @specificCostID
GO
