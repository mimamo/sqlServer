USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShKit]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShKit]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	BuildInvtID,
		SiteID

	from	SOShipHeader

	where	CpnyID = @CpnyID
	and	ShipperID = @ShipperID
GO
