USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Plan_SOQty]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[SCM_Plan_SOQty]
	@ComputerName	VarChar(21),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@DecPlQty	SmallInt,
	@UpdateAll	SmallInt
AS
	SET NOCOUNT ON
		/* Declare And Initialize all necessary variables. */
	DECLARE	@BODate			SmallDateTime

	SELECT @BODate = Cast(Convert(Char(10), GetDate(), 101) AS SMALLDATETIME)
		/* IMPORTANT NOTE
	   SCM_Plan_OMQtyShipNotInv must occur before SCM_Plan_INQtyShipNotInv
	   because:
		SCM_Plan_OMQtyShipNotInv - Clears and overwrites QtyShipNotInv bucket
		SCM_Plan_INQtyShipNotInv - Appends to QtyShipNotInv bucket
	*/
	IF @UpdateAll = 1
	BEGIN
		/* Calculate the Order Management side of Quantity Shipped Not Invoiced */

		EXECUTE SCM_Plan_OM_QtyShipNotInv @ComputerName, @LUpd_Prog, @LUpd_User, @DecPlQty

		/* Calculate the Inventory side of Quantity Shipped Not Invoiced */
		EXECUTE SCM_Plan_IN_QtyShipNotInv @ComputerName, @LUpd_Prog, @LUpd_User, @DecPlQty

		/* Call SCM_Plan_QtyAlloc - Update QtyAlloc in Location and LotSerMst. */
		EXECUTE	SCM_Plan_QtyAlloc @ComputerName, @LUpd_Prog, @LUpd_User, @DecPlQty

		UPDATE	ItemSite
		SET	AllocQty = Coalesce(D1.QtyAlloc, 0),			/* Obsolete Field */
			QtyAlloc = Coalesce(D1.QtyAlloc, 0),			/* Quantity On Packing Slips */
			QtyAllocSO = Coalesce(D1.QtyAllocSO, 0),
			QtyCustOrd = Coalesce(D4.QtyCustOrd, 0),		/* Quantity On All Open Sales Orders */
			QtyInTransit = Coalesce(D3.QtyInTransit, 0),		/* In-Transit Supply */
			QtyNotAvail = Coalesce(D2.QtyNotAvail, 0),		/* Quantity In LocatioIns Where Sales are not valid */
			QtyOnBO = Coalesce(D4.QtyOnBO, 0),			/* Quantity on Back Orders (late Sales Orders) */
			QtyOnKitAssyOrders = Coalesce(D4.QtyOnKitAssyOrders, 0),	/* Quantity on Kit Assembly Sales Orders */
			QtyOnTransferOrders = Coalesce(D4.QtyOnTransferOrders, 0),	/* Supply From Transfer Sales Orders */
			QtyShipNotInv = Coalesce(D1.QtyShipNotInv, 0),		/* Quantity On Updated Shippers Not Journalled And Released */
			LUpd_DateTime = GETDATE(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User

		FROM	ItemSite

		JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = ItemSite.InvtID
		  AND 	INU.SiteID = ItemSite.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			LEFT JOIN
			(SELECT	SUM(ROUND(QtyAlloc, @DecPlQty)) AS QtyAlloc,
				SUM(ROUND(QtyAllocSO, @DecPlQty)) AS QtyAllocSO,
				SUM(ROUND(QtyShipNotInv, @DecPlQty)) AS QtyShipNotInv,
				l.InvtID, l.SiteID

			FROM	Location l (NOLOCK)
			GROUP BY l.InvtID, l.SiteID) AS D1
			  ON 	D1.InvtID = INU.InvtID
		  AND 	D1.SiteID = INU.SiteID
			LEFT JOIN
			(SELECT SUM(ROUND(l.QtyOnHand - l.QtyShipNotInv, @DecPlQty)) AS QtyNotAvail,
				l.InvtID, l.SiteID

			FROM	Location l (NOLOCK)

			JOIN 	LocTable (NOLOCK)
			  ON 	l.SiteID = LocTable.SiteID
			  AND 	l.WhseLoc = LocTable.WhseLoc
			  And 	LocTable.InclQtyAvail = 0

			GROUP BY l.InvtID, l.SiteID) AS D2

		  ON 	D2.InvtID = INU.InvtID
		  AND	D2.SiteID = INU.SiteID
			LEFT JOIN
			(SELECT	SUM(
				CASE WHEN INTran.TranDesc = 'Standard Cost Variance' THEN
					0
				ELSE
					CASE WHEN INTran.CnvFact = 0 THEN
						ROUND(INTran.Qty * INTran.InvtMult * -1, @DecPlQty)
					ELSE
						CASE WHEN INTran.UnitMultDiv = 'D' THEN
							ROUND(INTran.Qty / INTran.CnvFact * INTran.InvtMult * -1, @DecPlQty)
						ELSE
							ROUND(INTran.Qty * INTran.CnvFact * INTran.InvtMult * -1, @DecPlQty)
						END
					END
				END) AS QtyInTransit,
				INTran.InvtID, INTran.ToSiteID

			FROM	INTran (NOLOCK)

			JOIN	TrnsfrDoc (NOLOCK)
			  ON 	INTran.CpnyID = TrnsfrDoc.CpnyID
			  AND 	INTran.BatNbr = TrnsfrDoc.BatNbr

				WHERE 	INTran.TranType = 'TR'		/* Transfer Transaction Type */
			  AND 	INTran.Rlsed = 1			/* Only Released Transactions */
			  AND 	INTran.JrnlType <> 'OM'		/* Exclude Order Management Transactions */
			  AND 	INTran.S4Future09 = 0		/* Must Update Inventory (stock items only) */
			  AND 	TrnsfrDoc.Source <> 'OM'		/* Exclude Order Management Transactions */
			  AND 	TrnsfrDoc.TransferType = '2'	/* Only 2-Step Transfers */
			  AND 	TrnsfrDoc.Status = 'I'		/* Only In-Transit Status */

			GROUP BY INTran.InvtID, INTran.ToSiteID) AS D3

		  ON 	D3.InvtID = INU.InvtID
		  AND 	D3.ToSiteID = INU.SiteID
			LEFT JOIN
			(
			SELECT	InvtId, SiteID,
					/* Calculate Quantity On Kit Assembly Orders */
				SUM(
				CASE WHEN PlanType In ('25', '26') THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnKitAssyOrders,
					/* Calculate Quantity On Transfer Orders */
				SUM(
				CASE WHEN PlanType In ('28', '29')THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnTransferOrders,

				/* Calculate Quantity on Customer Orders (Sales Orders) */
				-SUM(
				CASE WHEN PlanType In ('30', '32', '34', '50', '52', '54', '60', '61', '62', '64') THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyCustOrd,

				/* Calculate Quantity On Back Orders */
				-SUM(
				CASE WHEN PlanType In ('50', '52', '54', '60', '61', '62', '64') And SOReqShipDate < @BODate THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnBO

			FROM	SOPlan

			GROUP BY InvtId, SiteID) AS D4

		  ON 	D4.InvtID = INU.InvtID
		  AND 	D4.SiteID = INU.SiteID
	END
	ELSE
	BEGIN
		/* Call SCM_Plan_QtyAlloc - Update QtyAlloc in Location and LotSerMst. */
		EXECUTE	SCM_Plan_QtyAlloc @ComputerName, @LUpd_Prog, @LUpd_User, @DecPlQty

		UPDATE	ItemSite
		SET	AllocQty = Coalesce(D1.QtyAlloc, 0),			/* Obsolete Field */
			QtyAlloc = Coalesce(D1.QtyAlloc, 0),			/* Quantity On Packing Slips */
			QtyAllocSO = Coalesce(D1.QtyAllocSO, 0),
			QtyCustOrd = Coalesce(D4.QtyCustOrd, 0),		/* Quantity On All Open Sales Orders */
			QtyNotAvail = Coalesce(D2.QtyNotAvail, 0),		/* Quantity In LocatioIns Where Sales are not valid */
			QtyOnBO = Coalesce(D4.QtyOnBO, 0),			/* Quantity on Back Orders (late Sales Orders) */
			QtyOnKitAssyOrders = Coalesce(D4.QtyOnKitAssyOrders, 0),	/* Quantity on Kit Assembly Sales Orders */
			QtyOnTransferOrders = Coalesce(D4.QtyOnTransferOrders, 0),	/* Supply From Transfer Sales Orders */
			LUpd_DateTime = GETDATE(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User

		FROM	ItemSite

		JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = ItemSite.InvtID
		  AND 	INU.SiteID = ItemSite.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			LEFT JOIN
			(SELECT	SUM(ROUND(QtyAlloc, @DecPlQty)) AS QtyAlloc,
				SUM(ROUND(QtyAllocSO, @DecPlQty)) AS QtyAllocSO,
				l.InvtID, l.SiteID

			FROM	Location l (NOLOCK)
			GROUP BY l.InvtID, l.SiteID) AS D1
			  ON 	D1.InvtID = INU.InvtID
		  AND 	D1.SiteID = INU.SiteID
			LEFT JOIN
			(SELECT SUM(ROUND(l.QtyOnHand - l.QtyShipNotInv, @DecPlQty)) AS QtyNotAvail,
				l.InvtID, l.SiteID

			FROM	Location l (NOLOCK)

			JOIN 	LocTable (NOLOCK)
			  ON 	l.SiteID = LocTable.SiteID
			  AND 	l.WhseLoc = LocTable.WhseLoc
			  And 	LocTable.InclQtyAvail = 0

			GROUP BY l.InvtID, l.SiteID) AS D2

		  ON 	D2.InvtID = INU.InvtID
		  AND	D2.SiteID = INU.SiteID

		LEFT JOIN
			(
			SELECT	InvtId, SiteID,
					/* Calculate Quantity On Kit Assembly Orders */
				SUM(
				CASE WHEN PlanType In ('25', '26') THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnKitAssyOrders,
					/* Calculate Quantity On Transfer Orders */
				SUM(
				CASE WHEN PlanType In ('28', '29')THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnTransferOrders,

				/* Calculate Quantity on Customer Orders (Sales Orders) */
				-SUM(
				CASE WHEN PlanType In ('30', '32', '34', '50', '52', '54', '60', '61', '62', '64') THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyCustOrd,

				/* Calculate Quantity On Back Orders */
				-SUM(
				CASE WHEN PlanType In ('50', '52', '54', '60', '61', '62', '64') And SOReqShipDate < @BODate THEN
					Round(Qty, @DecPlQty)
				ELSE
					0
				END) AS QtyOnBO

			FROM	SOPlan

			GROUP BY InvtId, SiteID) AS D4

		  ON 	D4.InvtID = INU.InvtID
		  AND 	D4.SiteID = INU.SiteID
	END


/*Add back the Quantity that a Shipper was reduced from a Shipper generated from a Sales Order*/
    UPDATE ItemSite
       SET QtyCustOrd = ROUND(ItemSite.QtyCustOrd + Coalesce(D4.QtyCustOrd, 0), @DecPlQty)		
      FROM ItemSite JOIN INUpdateQty_Wrk INU (NOLOCK)
                      ON INU.InvtID = ItemSite.InvtID
                     AND INU.SiteID = ItemSite.SiteID
                     AND INU.ComputerName + '' LIKE @ComputerName
                     AND INU.UpdateSO = 1
                    JOIN (SELECT s.InvtID,s.SiteID, SUM(Round(l.QtyPick - l.QtyShip, 2)) AS QtyCustOrd
                            FROM SOPlan s JOIN SOShipLine l
                              ON s.SOShipperID = l.ShipperID 
                             AND s.CpnyID = l.CpnyID
                             AND s.SOShipperLineRef = l.LineRef
                             AND l.QtyPick > l.QtyShip
                           WHERE s.PlanType = '30'
                             AND s.SOOrdNbr <> ' '
                           GROUP BY s.InvtId, s.SiteID) AS D4
 		              ON D4.InvtID = INU.InvtID
                             AND D4.SiteID = INU.SiteID
GO
