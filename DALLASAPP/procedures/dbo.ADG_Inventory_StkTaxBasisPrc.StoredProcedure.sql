USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_StkTaxBasisPrc]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Inventory_StkTaxBasisPrc]
	@InvtID	varchar(30)
as
	-- return the stock tax basis price for the passed inventory item
		select	StkTaxBasisPrc
	from	Inventory
	where	InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
