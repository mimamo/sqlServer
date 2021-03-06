USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_GetPack]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_GetPack]
	@InvtID		varchar(30),
	@Pack		smallint OUTPUT,
	@PackCnvFact	decimal(25,9) OUTPUT,
	@PackMethod	varchar(2) OUTPUT,
	@PackSize	smallint OUTPUT,
	@PackUnitMultDiv varchar(1) OUTPUT,
	@StdCartonBreak smallint OUTPUT
as
	select	@Pack = Pack,
		@PackCnvFact = PackCnvFact,
		@PackMethod = ltrim(rtrim(PackMethod)),
		@PackSize = PackSize,
		@PackUnitMultDiv = ltrim(rtrim(PackUnitMultDiv)),
		@StdCartonBreak = StdCartonBreak
	from	InventoryADG (NOLOCK)
	where	InvtID = @InvtID

	if @@ROWCOUNT = 0 begin
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
