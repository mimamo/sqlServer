USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_All_NoInvt]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_All_NoInvt]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	order by InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
