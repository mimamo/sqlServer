USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_All_NoCancelled]    Script Date: 12/21/2015 15:49:16 ******/
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
