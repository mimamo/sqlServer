USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_ItemCostSelected_By_Date]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_ItemCostSelected_By_Date]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@RcptNbr	varchar(10),
	@RcptDate	smalldatetime,
	@Qty		decimal(25,9) OUTPUT,
	@RcptDateRet	smalldatetime OUTPUT,
	@TotCost	decimal(25,9) OUTPUT,
	@UnitCost	decimal(25,9) OUTPUT
as
	select	@Qty = Qty,
		@RcptDateRet = RcptDate,
		@TotCost = TotCost,
		@UnitCost = UnitCost
	from	ItemCost (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	RcptNbr = @RcptNbr
	and	datediff(d,RcptDate,@RcptDate) = 0

	if @@ROWCOUNT = 0 begin
		set @Qty = 0
		set @RcptDate = cast('1/1/1900' as smalldatetime)
		set @TotCost = 0
		set @UnitCost = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
