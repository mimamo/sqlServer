USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_BinDefaults]    Script Date: 12/21/2015 13:57:14 ******/
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
