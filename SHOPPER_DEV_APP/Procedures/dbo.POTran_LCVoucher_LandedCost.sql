USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_LCVoucher_LandedCost]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_LCVoucher_LandedCost]
	@ReceiptNbr varchar( 10 ),
	@SiteID varchar (10),
	@InvtID varchar (30),
	@SpecificCostID varchar (25)
AS
	SELECT *
	FROM POTran
	WHERE
		RcptNbr LIKE @ReceiptNbr
		AND
		SiteID LIKE @SiteID
		AND
		InvtID LIKE @InvtID
		AND
		SpecificCostID Like @specificCostID
		and
		PurchaseType IN ('GI','GP','GS','GN')
	ORDER BY
		PONbr,
	   	POLineNbr
GO
