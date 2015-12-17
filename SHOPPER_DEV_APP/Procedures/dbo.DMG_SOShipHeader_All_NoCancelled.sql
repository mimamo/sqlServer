USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_All_NoCancelled]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOShipHeader_All_NoCancelled]
as
	set nocount on

	select	*

	from	SOShipHeader

	where	Cancelled = 0

	order by CpnyID, ShipperID
GO
