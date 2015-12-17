USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_StkTaxBasisPrc]    Script Date: 12/16/2015 15:55:17 ******/
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
