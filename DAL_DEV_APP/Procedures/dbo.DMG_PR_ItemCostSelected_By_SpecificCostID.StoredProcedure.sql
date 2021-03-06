USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_ItemCostSelected_By_SpecificCostID]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_ItemCostSelected_By_SpecificCostID]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@SpecificCostID	varchar(25),
	@Qty		decimal(25,9) OUTPUT,
	@UnitCost	decimal(25,9) OUTPUT
as
	select	@Qty = Qty,
		@UnitCost = UnitCost
	from	ItemCost (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	SpecificCostID = @SpecificCostID

	if @@ROWCOUNT = 0 begin
		set @Qty = 0
		set @UnitCost = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
