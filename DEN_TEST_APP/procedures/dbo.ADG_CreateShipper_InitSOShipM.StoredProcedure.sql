USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_InitSOShipM]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_InitSOShipM]
as
	select	*
	from	SOShipMark
	where	CpnyID = '0'
	  and	ShipperID = '0'
GO
