USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShipNowSites]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShipNowSites]
as
	declare	@ShipNowCount	int
	declare	@ShipNowSites	smallint

	select	@ShipNowCount = count(*)
	from	Site
	where	S4Future09 = 1	-- Ship Regardless of Availability

	if (@ShipNowCount > 0)
		select @ShipNowSites = 1
	else
		select @ShipNowSites = 0

	select @ShipNowSites
GO
