USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_AdjustInvtQtyShip]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_AdjustInvtQtyShip]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@QtyShipAdj	float
as
	update	SOPlan

	set	QtyShip = QtyShip + @QtyShipAdj

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType = '10'
GO
