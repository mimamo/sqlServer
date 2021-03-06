USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_IT]    Script Date: 12/21/2015 16:07:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_IT]
	@InvtID		varchar(30),
	@COGSAcct	varchar(10) OUTPUT,
	@COGSSub	varchar(31) OUTPUT,
	@DiscAcct	varchar(10) OUTPUT,
	@DiscSub	varchar(31) OUTPUT,
	@SlsAcct	varchar(10) OUTPUT,
	@SlsSub		varchar(31) OUTPUT
as
	select	@COGSAcct = ltrim(rtrim(OMCOGSAcct)),
		@COGSSub = ltrim(rtrim(OMCOGSSub)),
		@DiscAcct = ltrim(rtrim(DiscAcct)),
		@DiscSub = ltrim(rtrim(DiscSub)),
		@SlsAcct = ltrim(rtrim(OMSalesAcct)),
		@SlsSub = ltrim(rtrim(OMSalesSub))
	from	Inventory (NOLOCK)
	join	InventoryADG (NOLOCK) on InventoryADG.InvtID = Inventory.InvtID
	where	Inventory.InvtID = @InvtID

	if @@ROWCOUNT = 0 begin
		set @COGSAcct = ''
		set @COGSSub = ''
		set @DiscAcct = ''
		set @DiscSub = ''
		set @SlsAcct = ''
		set @SlsSub = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
