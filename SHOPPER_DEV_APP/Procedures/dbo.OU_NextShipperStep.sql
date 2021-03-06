USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_NextShipperStep]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OU_NextShipperStep]
	@NextFunctionID		varchar(8),
	@NextClassID		varchar(4),
	@CpnyID			varchar(10),
	@ShipperID		varchar(15)
as
	select	*
	from	SOShipHeader
	where 	NextFunctionID = @NextFunctionID
	and	NextFunctionClass = @NextClassID
	and	CpnyID like @CpnyID
	and	ShipperID like @ShipperID
	order by CpnyID, ShipperID
GO
