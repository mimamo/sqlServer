USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemSite_LeadTime]    Script Date: 12/21/2015 13:56:50 ******/
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
