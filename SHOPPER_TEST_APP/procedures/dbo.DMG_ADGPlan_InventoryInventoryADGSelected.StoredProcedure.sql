USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ADGPlan_InventoryInventoryADGSelected]    Script Date: 12/21/2015 16:07:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ADGPlan_InventoryInventoryADGSelected]
	@InvtID		varchar(30),
	@LotSerIssMthd	varchar(1) OUTPUT,
        @LotSerTrack	varchar(2) OUTPUT,
        @Pack		smallint OUTPUT,
	@PackCnvFact	decimal(25,9) OUTPUT,
        @PackMethod	varchar(2) OUTPUT,
        @PackSize	smallint OUTPUT,
	@PackUnitMultDiv varchar(1) OUTPUT,
        @SerAssign	varchar(1) OUTPUT,
	@ShelfLife	smallint OUTPUT,
        @StdCartonBreak	smallint OUTPUT
as
	declare @INInstalled smallint

	-- Get an indication if the Inventory module is installed
	select @INInstalled = count(*) from INSetup (NOLOCK) where Init = 1

	select	@LotSerIssMthd = ltrim(rtrim(LotSerIssMthd)),
		@LotSerTrack = ltrim(rtrim(LotSerTrack)),
		@Pack = InventoryADG.Pack,
		@PackCnvFact = InventoryADG.PackCnvFact,
		@PackMethod = ltrim(rtrim(PackMethod)),
		@PackSize = PackSize,
		@PackUnitMultDiv = ltrim(rtrim(InventoryADG.PackUnitMultDiv)),
		@SerAssign = ltrim(rtrim(SerAssign)),
		@ShelfLife = ShelfLife,
		@StdCartonBreak = StdCartonBreak
	from	Inventory (NOLOCK)
	join	InventoryADG (NOLOCK) on InventoryADG.InvtID = Inventory.InvtID
	where	Inventory.InvtID = @InvtID
	and	(TranStatusCode = 'AC'
	or	TranStatusCode = 'NP'
	or	TranStatusCode = 'OH' and @INInstalled <> 0)

	if @@ROWCOUNT = 0 begin
		set @LotSerIssMthd = ''
		set @LotSerTrack = ''
		set @Pack = 0
		set @PackCnvFact = 0
		set @PackMethod = ''
		set @PackSize = 0
		set @PackUnitMultDiv = ''
		set @SerAssign = ''
		set @ShelfLife = 0
		set @StdCartonBreak = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
