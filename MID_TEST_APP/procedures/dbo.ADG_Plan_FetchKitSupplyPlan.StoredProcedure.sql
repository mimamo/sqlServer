USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_FetchKitSupplyPlan]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_FetchKitSupplyPlan]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15),
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	*
	from	SOPlan

	where	CpnyID = @CpnyID
	and	SOOrdNbr = @OrdNbr
	and	SOShipperID = @ShipperID
	and	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('25', '26')
GO
