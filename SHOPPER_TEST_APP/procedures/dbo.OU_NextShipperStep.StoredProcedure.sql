USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_NextShipperStep]    Script Date: 12/21/2015 16:07:11 ******/
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
