USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_InventoryQtys_Costs]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_InventoryQtys_Costs]
	@InvtID	varchar(30)
as
	select	BMIStdCost,
		StdCost
	from	Inventory
	where	InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
