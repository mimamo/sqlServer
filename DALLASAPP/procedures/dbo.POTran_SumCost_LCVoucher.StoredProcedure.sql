USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_SumCost_LCVoucher]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_SumCost_LCVoucher]
	@ReceiptNbr varchar( 10 ),
	@SiteID varchar (10),
	@InvtID varchar (30),
	@SpecificCostID varchar (25)
AS
	SELECT Sum(ExtCost)
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

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
