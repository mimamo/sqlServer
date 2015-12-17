USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemSite_LeadTime]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ItemSite_LeadTime]
	@invtid		varchar(30),
	@siteid		varchar(10)
as
	select	LeadTime
	from	ItemSite WITH (NOLOCK)
	where	InvtID = @invtid
	  and	SiteID = @siteid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
