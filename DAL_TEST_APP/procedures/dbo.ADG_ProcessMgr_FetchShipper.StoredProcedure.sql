USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_FetchShipper]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_ProcessMgr_FetchShipper]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select		CustID,
			OrdNbr
	from		SOShipHeader
	where		CpnyID = @CpnyID
	and		ShipperID = @ShipperID
GO
