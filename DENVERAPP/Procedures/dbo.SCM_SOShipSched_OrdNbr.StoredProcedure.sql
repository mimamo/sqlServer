USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOShipSched_OrdNbr]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_SOShipSched_OrdNbr]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
AS
	select	S.*
	from	SOShipSched S, SOShipHeader H
	where	S.CpnyID = H.CpnyID
	and	S.ShipperID = H.ShipperID
	and	S.CpnyID = @CpnyID
	and	S.OrdNbr = @OrdNbr
	and	H.Cancelled = 0
		order by S.OrdNbr, S.OrdLineRef, S.OrdSchedRef, S.ShipperID, S.ShipperLineRef
GO
