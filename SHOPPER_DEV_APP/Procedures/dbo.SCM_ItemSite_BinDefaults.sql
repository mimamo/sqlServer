USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_BinDefaults]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_ItemSite_BinDefaults]
	@InvtID		varchar( 30 ),
	@SiteID		varchar( 10 )
	AS

	SELECT		DfltPickBin, DfltPutAwayBin, DfltRepairBin, DfltVendorBin
	FROM		ITEMSITE
	WHERE		InvtID = @InvtID
	  and		SiteID = @SiteID
GO
