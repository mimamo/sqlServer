USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOShipLine_InvtID_Filter]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOShipLine_InvtID_Filter]
  	@InvtID     	varchar( 30 ),
   	@SiteID     	varchar( 10 ),
   	@CustID     	varchar( 15 ),
	@OrdDateFrom   	smallDateTime,
	@OrdDateTo	smallDateTime,
	@ShipDateFrom	smallDateTime,
	@ShipDateTo	smallDateTime,
	@Status		varchar( 1 ),
	@SOType		varchar( 4 ),
	@CompFG		varchar( 1 )

AS
	if @CompFG = 'C'
		-- Components - Sales Items
	   SELECT      	L.*,
			H.BuildActQty,
			H.BuildCmpltDate,
			H.BuildInvtId,
			H.BuildQty,
			H.CpnyId,
			H.CustId,
			H.CustOrdNbr,
			H.InvcNbr,
			H.OrdDate,
			H.ShipDateAct,
			H.ShipDatePlan,
			H.ShipperId,
			H.SiteId,
			H.SoTypeId,
			H.Status,
			SL.CpnyId,
			SL.LineRef,
			SL.OrdNbr,
			SL.QtyOrd
	   FROM		SOShipLine L LEFT JOIN SOShipHeader H
			ON L.CpnyID = H.CpnyID and L.ShipperID = H.ShipperID
			LEFT Join SOLine SL
			ON L.CpnyID = SL.CpnyID and L.OrdNbr = SL.OrdNbr and L.OrdLineRef = SL.LineRef
	   WHERE       	L.InvtID = @InvtID and
	               	L.SiteID LIKE @SiteID and
	               	H.CustID LIKE @CustID and
	               	H.OrdDate Between @OrdDateFrom and @OrdDateTo and
	               	H.ShipDateAct Between @ShipDateFrom and @ShipDateTo and
			L.Status LIKE @Status and
			H.SOTypeID LIKE @SOType
	   ORDER BY    	L.ShipperID DESC, L.LineRef
	else
		-- Kit Assemblies
	   SELECT      	L.*,
			H.BuildActQty,
			H.BuildCmpltDate,
			H.BuildInvtId,
			H.BuildQty,
			H.CpnyId,
			H.CustId,
			H.CustOrdNbr,
			H.InvcNbr,
			H.OrdDate,
			H.ShipDateAct,
			H.ShipDatePlan,
			H.ShipperId,
			H.SiteId,
			H.SoTypeId,
			H.Status,
			SL.CpnyId,
			SL.LineRef,
			SL.OrdNbr,
			SL.QtyOrd
	   FROM 	SOShipLine L LEFT JOIN SOShipHeader H
			ON L.CpnyID = H.CpnyID and L.ShipperID = H.ShipperID
			LEFT Join SOLine SL
			ON L.CpnyID = SL.CpnyID and L.OrdNbr = SL.OrdNbr and L.OrdLineRef = SL.LineRef
	   WHERE       	H.BuildInvtID = @InvtID and
	               	H.SiteID LIKE @SiteID and
	               	H.CustID LIKE @CustID and
	               	H.OrdDate Between @OrdDateFrom and @OrdDateTo and
	               	H.ShipDateAct Between @ShipDateFrom and @ShipDateTo and
			L.Status LIKE @Status and
			H.SOTypeID LIKE @SOType
	   ORDER BY    	L.ShipperID DESC, L.LineRef
GO
