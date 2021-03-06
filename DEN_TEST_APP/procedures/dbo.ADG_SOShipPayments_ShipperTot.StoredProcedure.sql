USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipPayments_ShipperTot]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOShipPayments_ShipperTot]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	sum(CuryPmtAmt),
		sum(PmtAmt)

	from	SOShipPayments
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	group by
		CpnyID,
		ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
