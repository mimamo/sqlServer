USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_WhseLoc]    Script Date: 12/21/2015 16:00:45 ******/
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
