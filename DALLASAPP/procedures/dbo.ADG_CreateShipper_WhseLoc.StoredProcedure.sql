USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_WhseLoc]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_WhseLoc]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	DfltPickBin,
		DfltPutAwayBin,
		DfltRepairBin,
		DfltVendorBin

	from	ItemSite I

	where	I.InvtID = @InvtID
	  and	I.SiteID = @SiteID
GO
