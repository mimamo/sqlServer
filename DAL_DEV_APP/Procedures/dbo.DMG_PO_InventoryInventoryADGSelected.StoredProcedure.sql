USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_InventoryInventoryADGSelected]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_InventoryInventoryADGSelected]
	@InvtID		varchar(30),
        @ClassId	varchar(6) OUTPUT,
	@COGSAcct	varchar(10) OUTPUT,
	@COGSSub	varchar(24) OUTPUT,
	@Descr		varchar(60) OUTPUT,
	@DfltPOUnit	varchar(6) OUTPUT,
        @DfltSite	varchar(10) OUTPUT,
	@DirStdCost	decimal(25,9) OUTPUT,
	@InvtAcct	varchar(10) OUTPUT,
	@InvtSub	varchar(24) OUTPUT,
	@LotSerTrack	varchar(2) OUTPUT,
	@ShelfLife	smallint OUTPUT,
	@StkItem	smallint OUTPUT,
        @StkUnit	varchar(6) OUTPUT,
	@TaxCat		varchar(10) OUTPUT,
	@TranStatusCode	varchar(2) OUTPUT,
	@Weight		decimal(25,9) OUTPUT
as
	select	@ClassId = ltrim(rtrim(ClassId)),
		@COGSAcct = ltrim(rtrim(COGSAcct)),
		@COGSSub = ltrim(rtrim(COGSSub)),
		@Descr = ltrim(rtrim(Descr)),
		@DfltPOUnit = ltrim(rtrim(DfltPOUnit)),
		@DfltSite = ltrim(rtrim(DfltSite)),
		@DirStdCost = DirStdCost,
		@InvtAcct = ltrim(rtrim(InvtAcct)),
		@InvtSub = ltrim(rtrim(InvtSub)),
		@LotSerTrack = ltrim(rtrim(LotSerTrack)),
		@ShelfLife = ShelfLife,
		@StkItem = StkItem,
		@StkUnit = ltrim(rtrim(StkUnit)),
		@TaxCat = ltrim(rtrim(TaxCat)),
		@TranStatusCode = ltrim(rtrim(TranStatusCode)),
		@Weight = Weight
	from	Inventory (NOLOCK)
	join	InventoryADG (NOLOCK) on InventoryADG.InvtID = Inventory.InvtID
	where	Inventory.InvtID = @InvtID
	and	(TranStatusCode = 'AC'
	or	TranStatusCode = 'NU')

	if @@ROWCOUNT = 0 begin
		set @ClassId = ''
		set @COGSAcct = ''
		set @COGSSub = ''
		set @Descr = ''
		set @DfltPOUnit = ''
		set @DfltSite = ''
		set @DirStdCost = 0
		set @InvtAcct = ''
		set @InvtSub = ''
		set @LotSerTrack = ''
		set @ShelfLife = 0
		set @StkItem = 0
		set @StkUnit = ''
		set @TaxCat = ''
		set @TranStatusCode = ''
		set @Weight = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
