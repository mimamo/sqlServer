USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_GetShipperItem]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_GetShipperItem]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	InvtID,
		SiteID,
		sum(Qty)

	from	SOPlan

	where	CpnyID = @CpnyID
	and	SOShipperID = @ShipperID
	and	PlanType in ('30', '32', '34')	-- reserved shippers only

	group by
		InvtID,
		SiteID
GO
