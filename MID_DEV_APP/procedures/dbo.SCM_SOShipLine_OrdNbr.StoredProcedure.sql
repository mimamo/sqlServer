USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOShipLine_OrdNbr]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_SOShipLine_OrdNbr]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
AS
	select	L.*
	from	SOShipLine L, SOShipHeader H
	where	L.CpnyID = H.CpnyID
	and	L.ShipperID = H.ShipperID
	and	L.CpnyID = @CpnyID
	and	L.OrdNbr = @OrdNbr
	and	H.Cancelled = 0
		order by L.OrdNbr, L.OrdLineRef, L.ShipperID
GO
