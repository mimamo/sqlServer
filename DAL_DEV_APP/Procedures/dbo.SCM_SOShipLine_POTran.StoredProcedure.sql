USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOShipLine_POTran]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_SOShipLine_POTran]
	@CpnyID		varchar( 10 ),
	@ShipperID	varchar( 15 ),
	@LineRef	varchar( 15 )
	AS

	SELECT		DISTINCT POTran.*
	FROM 		SOShipSched
			INNER JOIN SOSched
			ON SOShipsched.CpnyID = SOSched.CpnyID
			AND SOShipsched.OrdNbr = SOSched.OrdNbr
			AND SOShipSched.OrdLineRef = SOSched.LineRef
			AND SOShipSched.OrdSchedref = SOSched.SchedRef
			INNER JOIN POAlloc
			ON SOSched.CpnyID = POAlloc.CpnyID
			AND SOSched.OrdNbr = POAlloc.SOOrdNbr
			AND SOShipSched.OrdLineRef = POAlloc.SOLineRef
			AND SOSched.SchedRef = POAlloc.SOSchedRef
			INNER JOIN POTran
			ON POAlloc.CpnyID = POTran.CpnyID
			AND POAlloc.PONbr = POTran.PONbr
			AND POAlloc.POLineRef = POTran.POLineRef
		WHERE 		SOShipSched.CpnyID = @CpnyID
			AND SOShipSched.ShipperID = @ShipperID
			AND SOShipSched.ShipperLineRef Like @LineRef
GO
