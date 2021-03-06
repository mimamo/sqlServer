USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Plan_QtyAlloc]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_Plan_QtyAlloc]
	@ComputerName	VarChar(21),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@DecPlQty	SmallInt
AS
	SET NOCOUNT ON

	/*
	This procedure will calculate and update the Quantity Allocated for the supplied Inventory ID
	and Site ID for the Location and LotSerMst tables.
	*/

	/* Insert any missing Location Records */
	INSERT INTO Location
		(InvtID, SiteID, WhseLoc, Crtd_Prog, Crtd_User, LUpd_DateTime, LUpd_Prog, LUpd_User)
		SELECT DISTINCT SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc, @LUpd_Prog, @LUpd_User, GetDate(), @LUpd_Prog, @LUpd_User

		FROM	SOPlan (NOLOCK)

		JOIN 	SOShipLot WITH (NOLOCK)
		  ON 	SOPlan.CpnyID = SOShipLot.CpnyID
		  AND 	SOPlan.SOShipperID = SOShipLot.ShipperID
		  AND 	SOPlan.SOShipperLineRef = SOShipLot.LineRef
			JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1

		WHERE	SOPlan.PlanType IN ('30', '32', '34')
		  AND	SOShipLot.WhseLoc <> ''
		  AND 	NOT EXISTS (SELECT *
			 		FROM	Location l (NOLOCK)
					WHERE	l.InvtID = SOPlan.InvtID
				  	AND 	l.SiteID = SOPlan.SiteID
				  	AND 	l.WhseLoc = SOShipLot.WhseLoc)

	/* Insert any missing LotSerMst Records */
	INSERT INTO LotSerMst
		(InvtID, SiteID, WhseLoc, LotSerNbr, Crtd_Prog, Crtd_User, LUpd_DateTime, LUpd_Prog, LUpd_User)
		SELECT DISTINCT SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc, SOShipLot.LotSerNbr, @LUpd_Prog, @LUpd_User, GetDate(), @LUpd_Prog, @LUpd_User

		FROM	SOPlan (NOLOCK)

		JOIN 	SOShipLot WITH(NOLOCK)
		  ON 	SOPlan.CpnyID = SOShipLot.CpnyID
		  AND 	SOPlan.SOShipperID = SOShipLot.ShipperID
		  AND 	SOPlan.SOShipperLineRef = SOShipLot.LineRef
			JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1

		WHERE	SOPlan.PlanType IN ('30', '32', '34')
		  AND	SOShipLot.WhseLoc <> ''
		  AND	SOShipLot.LotSerNbr <> ''
		  AND 	NOT EXISTS (SELECT *
					FROM LotSerMst LSM (NOLOCK)
					WHERE 	LSM.InvtID = SOPlan.InvtID
					  AND	LSM.SiteID = SOPlan.SiteID
					  AND	LSM.WhseLoc = SOShipLot.WhseLoc
					  AND	LSM.LotSerNbr = SOShipLot.LotSerNbr)
		/* Update Location Table */
	-- Clear Location records that have NO activity
	-- and recalculate Location records that do have activity
	UPDATE	Location
	SET	QtyAlloc = Coalesce(D.QtyAlloc, 0),	/* Quantity Allocated */
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
		FROM	Location (NOLOCK)

	JOIN 	INUpdateQty_Wrk INU (NOLOCK)
	  ON	INU.InvtID = Location.InvtID
	  AND	INU.SiteID = Location.SiteID
	  AND	INU.ComputerName + '' LIKE @ComputerName
	  AND	INU.UpdateSO = 1
		LEFT JOIN
		-- SOShipLine.CnvFact = SOShipLot.S4Future03
		-- SOShipLine.UnitMultDiv = SOShipLot.S4Future11
		(SELECT SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc,
			ROUND(SUM(CASE WHEN SOShipLot.S4Future03 = 0 THEN
				0
			ELSE
				CASE WHEN SOShipLot.S4Future11 = 'D' THEN
					ROUND(SOShipLot.Qtyship / SOShipLot.S4Future03, @DecPlQty)
				ELSE
					ROUND(SOShipLot.QtyShip * SOShipLot.S4Future03, @DecPlQty)
				END
			END), @DecPlQty) AS QtyAlloc

		FROM	(SELECT InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef FROM SOPlan (NOLOCK) GROUP BY InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef) SOPlan
			JOIN 	SOShipLot WITH(NOLOCK)
		  ON 	SOPlan.CpnyID = SOShipLot.CpnyID
		  AND 	SOPlan.SOShipperID = SOShipLot.ShipperID
		  AND 	SOPlan.SOShipperLineRef = SOShipLot.LineRef
			JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			WHERE	SOPlan.PlanType IN ('30', '32', '34')
		  AND	SOShipLot.WhseLoc <> ''

		GROUP BY SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc) AS D

	  ON 	D.InvtID = INU.InvtID		/* Inventory ID */
	  AND 	D.SiteID = INU.SiteID		/* Site ID */
	  AND 	D.WhseLoc = Location.WhseLoc		/* Warehouse Bin Location */
	  AND	INU.ComputerName + '' LIKE @ComputerName
	  AND	INU.UpdateSO = 1


	update	Location
	set	QtyAllocSO = Coalesce(D.QtyAlloc, 0),
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User

	from	Location

	join	INUpdateQty_Wrk INU (NOLOCK)
	  ON	INU.InvtID = Location.InvtID
	  AND	INU.SiteID = Location.SiteID
	  AND	INU.ComputerName + '' LIKE @ComputerName
	  AND	INU.UpdateSO = 1

	left join (	select	SOPlan.InvtID,
			SOPlan.SiteID,
			SOLot.WhseLoc,
			sum(	case when SOLine.UnitMultDiv = 'D' then
					case when SOLine.CnvFact <> 0 then
						round(SOLot.QtyShip / SOLine.CnvFact, @DecPlQty)
					else
						0
					end
				else
					round(SOLot.QtyShip * SOLine.CnvFact, @DecPlQty)
				end) as QtyAlloc

		from	SOPlan

		JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			join	SOLine
		on	SOLine.CpnyID = SOPlan.CpnyID
		and	SOLine.OrdNbr = SOPlan.SOOrdNbr
		and	SOLine.LineRef = SOPlan.SOLineRef

		join	SOLot
		on	SOLot.CpnyID = SOPlan.CpnyID
		and	SOLot.OrdNbr = SOPlan.SOOrdNbr
		and	SOLot.LineRef = SOPlan.SOLineRef
		and	SOLot.SchedRef = SOPlan.SOSchedRef

		where	SOPlan.PlanType in ('60', '61')	-- Order
		and	SOLot.Status = 'O'
		and	SOLot.WhseLoc <> ''

		group by SOPlan.InvtID, SOPlan.SiteID, SOLot.WhseLoc) as D

	on	D.InvtID = Location.InvtID
	and	D.SiteID = Location.SiteID
	and	D.WhseLoc = Location.WhseLoc

	/* Update LotSerMst Table */
	-- Clear LotSerMst records that have NO activity
	-- and recalculate LotSerMst records that do have activity
	UPDATE	LotSerMst
	SET	QtyAlloc = Coalesce(D.QtyAlloc, 0),	/* Quantity Allocated */
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
		FROM	LotSerMst (NOLOCK)
		JOIN 	INUpdateQty_Wrk INU (NOLOCK)
	  ON	INU.InvtID = LotSerMst.InvtID
	  AND	INU.SiteID = LotSerMst.SiteID
	  AND	INU.ComputerName + '' LIKE @ComputerName
	  AND	INU.UpdateSO = 1

	LEFT JOIN
		-- SOShipLine.CnvFact = SOShipLot.S4Future03
		-- SOShipLine.UnitMultDiv = SOShipLot.S4Future11
		(SELECT SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc, SOShipLot.LotSerNbr,
			ROUND(SUM(CASE WHEN SOShipLot.S4Future03 = 0 THEN
				0
			ELSE
				CASE WHEN SOShipLot.S4Future11 = 'D' THEN
					ROUND(SOShipLot.Qtyship / SOShipLot.S4Future03, @DecPlQty)
				ELSE
					ROUND(SOShipLot.QtyShip * SOShipLot.S4Future03, @DecPlQty)
				END
			END), @DecPlQty) AS QtyAlloc

		FROM	(SELECT InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef FROM SOPlan (NOLOCK) GROUP BY InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef) SOPlan
			JOIN 	SOShipLot WITH(NOLOCK)
		  ON 	SOPlan.CpnyID = SOShipLot.CpnyID
		  AND 	SOPlan.SOShipperID = SOShipLot.ShipperID
		  AND 	SOPlan.SOShipperLineRef = SOShipLot.LineRef
			JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			WHERE	SOPlan.PlanType IN ('30', '32', '34')
		  AND	SOShipLot.WhseLoc <> ''
		  AND 	SOShipLot.LotSerNbr <> ''

		GROUP BY SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc, SOShipLot.LotSerNbr) AS D

	  ON 	D.InvtID = INU.InvtID		/* Inventory ID */
	  AND 	D.SiteID = INU.SiteID		/* Site ID */
	  AND 	D.WhseLoc = LotSerMst.WhseLoc		/* Warehouse Bin Location */
	  AND 	D.LotSerNbr = LotSerMst.LotSerNbr	/* Lot/Serial Number */

	update	LotSerMst
	set	QtyAllocSO = Coalesce(D.QtyAlloc, 0),
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User

	from	LotSerMst

	join	INUpdateQty_Wrk INU (NOLOCK)
	  ON	INU.InvtID = LotSerMst.InvtID
	  AND	INU.SiteID = LotSerMst.SiteID
	  AND	INU.ComputerName + '' LIKE @ComputerName
	  AND	INU.UpdateSO = 1

	left join (	select	SOPlan.InvtID,
			SOPlan.SiteID,
			SOLot.WhseLoc,
			SOLot.LotSerNbr,
			sum(	case when SOLine.UnitMultDiv = 'D' then
					case when SOLine.CnvFact <> 0 then
						round(SOLot.QtyShip / SOLine.CnvFact, @DecPlQty)
					else
						0
					end
				else
					round(SOLot.QtyShip * SOLine.CnvFact, @DecPlQty)
				end) as QtyAlloc

		from	SOPlan

		JOIN	INUpdateQty_Wrk INU (NOLOCK)
		  ON 	INU.InvtID = SOPlan.InvtID
		  AND 	INU.SiteID = SOPlan.SiteID
		  AND	INU.ComputerName + '' LIKE @ComputerName
		  AND	INU.UpdateSO = 1
			join	SOLine
		on	SOLine.CpnyID = SOPlan.CpnyID
		and	SOLine.OrdNbr = SOPlan.SOOrdNbr
		and	SOLine.LineRef = SOPlan.SOLineRef

		join	SOLot
		on	SOLot.CpnyID = SOPlan.CpnyID
		and	SOLot.OrdNbr = SOPlan.SOOrdNbr
		and	SOLot.LineRef = SOPlan.SOLineRef
		and	SOLot.SchedRef = SOPlan.SOSchedRef

		where	SOPlan.PlanType in ('60', '61')	-- Order
		and	SOLot.Status = 'O'
		and	SOLot.WhseLoc <> ''
		and	SOLot.LotSerNbr <> ''

		group by SOPlan.InvtID, SOPlan.SiteID, SOLot.WhseLoc, SOLot.LotSerNbr) as D

	on	D.InvtID = LotSerMst.InvtID
	and	D.SiteID = LotSerMst.SiteID
	and	D.WhseLoc = LotSerMst.WhseLoc
	and	D.LotSerNbr = LotSerMst.LotSerNbr

	IF @LUpd_Prog = '10990'
		EXEC SCM_Plan_OtherQty @ComputerName, @LUpd_Prog, @LUpd_User, @DecPlQty
GO
