USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_OpenShipperLineCnt]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_OpenShipperLineCnt]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@OrdLineRef	varchar(5),
	@OrdSchedRef	varchar(5),
	@ShipperID	varchar(15)		-- Current ShipperID (for exclusion).
as
	select	count(*)

	from	SOShipLine L join SOShipSched S
	on	L.CpnyID = S.CpnyID
	and	L.ShipperID = S.ShipperID
	and	L.LineRef = S.ShipperLineRef

	where	L.CpnyID = @CpnyID
	  and	L.OrdNbr = @OrdNbr
	  and	L.OrdLineRef = @OrdLineRef
	  and	S.OrdSchedRef = @OrdSchedRef
	  and	L.ShipperID <> @ShipperID
	  and	L.Status = 'O'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
