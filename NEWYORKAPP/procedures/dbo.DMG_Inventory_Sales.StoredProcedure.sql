USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_Sales]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_Sales]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	and	TranStatusCode in ('AC','NP','OH')
	order by InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
