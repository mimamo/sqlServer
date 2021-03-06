USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSiteSelected]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ItemSiteSelected]
	@InvtID			varchar(30),
	@SiteID			varchar(10),
	@AutoPODropShip		smallint OUTPUT,
	@AutoPOPolicy		varchar(2) OUTPUT,
	@IRTransferSiteID	varchar(10) OUTPUT,
	@LastCost		decimal(25,9) OUTPUT,
	@LeadTime		decimal(25,9) OUTPUT,
	@PrimVendID		varchar(15) OUTPUT,
	@S4Future01		varchar(30) OUTPUT,
	@StdCost		decimal(25,9) OUTPUT
as
	select	@AutoPODropShip = AutoPODropShip,
		@AutoPOPolicy = ltrim(rtrim(AutoPOPolicy)),
		@IRTransferSiteID = ltrim(rtrim(IRTransferSiteID)),
		@LastCost = LastCost,
		@LeadTime = LeadTime,
		@PrimVendID = ltrim(rtrim(PrimVendID)),
		@S4Future01 = ltrim(rtrim(S4Future01)),
		@StdCost = StdCost

	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	if @@ROWCOUNT = 0 begin
		set @AutoPODropShip = 0
		set @AutoPOPolicy = ''
		set @IRTransferSiteID = ''
		set @LastCost = 0
		set @LeadTime = 0
		set @PrimVendID = ''
		set @S4Future01 = ''
		set @StdCost = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
