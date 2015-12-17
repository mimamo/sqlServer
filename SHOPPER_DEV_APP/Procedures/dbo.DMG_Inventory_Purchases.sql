USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_Purchases]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_Purchases]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	and	TranStatusCode in ('AC','NU')
	order by InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
