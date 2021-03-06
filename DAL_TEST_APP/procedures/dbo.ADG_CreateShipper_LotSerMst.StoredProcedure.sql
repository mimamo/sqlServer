USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_LotSerMst]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_LotSerMst]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@WhseLoc	varchar(10),
	@LotSerNbr	varchar(25)
as
	select	MfgrLotSerNbr,
		ShipContCode

	from	LotSerMst  l

	where	l.InvtID = @InvtID
	  and	l.SiteID = @SiteID
	  and	l.WhseLoc = @WhseLoc
	  and	l.LotSerNbr = @LotSerNbr
GO
