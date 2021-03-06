USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_StkTaxBasisPrc]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Inventory_StkTaxBasisPrc]
	@InvtID		varchar(30),
	@StkTaxBasisPrc	decimal(25,9) OUTPUT
as
	select	@StkTaxBasisPrc = StkTaxBasisPrc
	from	Inventory (NOLOCK)
	where	InvtID = @InvtID

	if @@ROWCOUNT = 0 begin
		set @StkTaxBasisPrc = 0
		return 0	--Failure
	end
	else
		--select @StkTaxBasisPrc
		return 1	--Success
GO
