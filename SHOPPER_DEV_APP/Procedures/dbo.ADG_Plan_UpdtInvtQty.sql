USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_UpdtInvtQty]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_UpdtInvtQty]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@Qty		float
as
	update		SOPlan

	set		Qty = @Qty

	where		InvtID = @InvtID
	and		SiteID = @SiteID
	and		PlanType = '10'
GO
