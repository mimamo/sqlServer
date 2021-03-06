USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_StkTaxBasisPrc]    Script Date: 12/21/2015 15:42:40 ******/
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
