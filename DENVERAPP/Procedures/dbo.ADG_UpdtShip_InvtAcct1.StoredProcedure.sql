USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_InvtAcct1]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_InvtAcct1]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	InvtAcct,
		InvtSub
	from	ItemSite
	where	InvtID = @InvtID
	  and	SiteID = @SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
