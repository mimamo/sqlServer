USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_DelShipperItemPlan]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_DelShipperItemPlan]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	delete	SOPlan

	where	CpnyID = @CpnyID
	and	SOShipperID = @ShipperID
	and	InvtID = @InvtID
	and	SiteID = @SiteID
GO
