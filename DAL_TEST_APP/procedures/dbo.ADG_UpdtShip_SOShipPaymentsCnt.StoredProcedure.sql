USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipPaymentsCnt]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipPaymentsCnt]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	count(*)
	from	SOShipPayments
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
