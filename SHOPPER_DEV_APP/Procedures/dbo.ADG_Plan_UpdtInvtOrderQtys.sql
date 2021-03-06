USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_UpdtInvtOrderQtys]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_UpdtInvtOrderQtys]
	@InvtID			varchar(30),
	@SiteID			varchar(10),
	@QtyAvailUpdateMode	smallint,	-- 0: CPS Off; 1: CPS On
	@QtyAvail		float,		-- from planning engine when CPS On
	@QtyPrec		smallint
as
	set nocount on
        SET DEADLOCK_PRIORITY LOW ---Added this statement to eliminate 1205 errors during inventory release process - Microsoft (MBSC)

	declare	@BODate		smalldatetime
	declare @LotSerTrack	varchar(2)
	declare	@ProcessLotSer	smallint	-- logical
	declare	@QtyAlloc	float
	declare	@QtyAllocBM	float
	declare	@QtyAllocIN	float
	declare	@QtyAllocPORet	float
	declare	@QtyAllocSD	float
	declare	@QtyAllocSO	float
	declare	@QtyCustOrd	float
	declare	@QtyOnBO	float
	declare	@QtyOnKitAssy	float
	declare	@QtyOnTransfer	float
	declare @SerAssign	varchar(1)
	declare @StkItem	smallint
	declare	@OptWOFirmRlsedDemand char (1)

	select		@OptWOFirmRlsedDemand = Left(S4Future11,1)

	from		WOSetup (NOLOCK)
	where		Init = 'Y'

	-- Fetch information from Inventory.
	select	@LotSerTrack = LotSerTrack,
		@SerAssign = SerAssign,
		@StkItem = StkItem
	from	Inventory (nolock)
	where	InvtID = @InvtID

	-- Initialization
	select	@QtyAlloc = 0
	select	@QtyAllocBM = 0
	select	@QtyAllocIN = 0
	select	@QtyAllocPORet = 0
	select	@QtyAllocSD = 0
	select	@QtyAllocSO = 0
	select	@QtyCustOrd = 0
	select	@QtyOnBO = 0

	-- Set the backorder date to today at midnight,
	select	@BODate = getdate()
	select	@BODate = convert(smalldatetime, convert(varchar(2), datepart(mm, @BODate))
				+ '/' + convert(varchar(2), datepart(dd, @BODate))
				+ '/' + convert(varchar(4), datepart(yy, @BODate)))

	-- Determine if this is a lot/serial item where the lot/serial
	-- number is assigned at time of receipt. Lot/serial numbers
	-- are only processed for such items.
	if ((@LotSerTrack in ('LI', 'SI')) and (@SerAssign = 'R'))
		select	@ProcessLotSer = 1
	else
		select	@ProcessLotSer = 0

	-- Create any missing ItemSite, Location, LocTable, and/or LotSerMst records.
	exec ADG_Plan_NewInvtItem @InvtID, @SiteID, 'PLAN', 'PLAN', @ProcessLotSer

	-- Exit if the item is not a stock item.
	-- This is a failsafe; this condition shouldn't happen.
	-- OM 1820 (DE219228) [RRM] Moved from above in order to allow missing
	-- ItemSite records to be created for non-stock items before exiting
	if (@StkItem <> 1)
		return

	-- --------------------------------------------------------------------------------
	-- LotSerMst - update the quantity allocated for each lot/serial number, if applicable.
	-- --------------------------------------------------------------------------------
	if (@ProcessLotSer = 1)
	begin
		-- Clear LotSerMst.QtyAlloc.
		update	LotSerMst
		set	QtyAlloc = 0, QtyAllocBM = 0, QtyAllocIN = 0, QtyAllocPORet = 0, QtyAllocSD = 0, QtyAllocSO = 0
		where	InvtID = @InvtID
		and	SiteID = @SiteID

		-- Update the quantity allocated using the inventory plan and shipper information.
		/* Trigger on SOShipLine updates
		 *	SOShipLot.S4Future11 with SOShipLine.UnitMultDiv
		 *and SOShipLot.S4Future03 with SOShipLine.ConvFact */
		update	LotSerMst
		set	QtyAlloc = D.QtyAlloc
		from	LotSerMst

		join (	select	SOPlan.InvtID,
				SOShipLot.LotSerNbr,
				SOPlan.SiteID,
				SOShipLot.WhseLoc,
				sum(	case when SOShipLot.S4Future11 = 'D' then
						case when SOShipLot.S4Future03 <> 0 then
							round(SOShipLot.QtyShip / SOShipLot.S4Future03, @QtyPrec)
						else
							0
						end
					else
						round(SOShipLot.QtyShip * SOShipLot.S4Future03, @QtyPrec)
					end) as QtyAlloc

			FROM	(SELECT InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef
                                   FROM SOPlan (NOLOCK)
                                  WHERE SOPlan.InvtID = @InvtID
                                    AND SOPlan.SiteID = @SiteID
                                  GROUP BY InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef) SOPlan

			join	SOShipLot WITH(NOLOCK)
			on	SOShipLot.CpnyID = SOPlan.CpnyID
			and	SOShipLot.ShipperID = SOPlan.SOShipperID
			and	SOShipLot.LineRef = SOPlan.SOShipperLineRef

			where	SOPlan.PlanType in ('30', '32', '34')	-- Shipper
			and	SOShipLot.LotSerNbr > ''
			and	SOPlan.InvtID = @InvtID
			and	SOPlan.SiteID = @SiteID

			group by SOPlan.InvtID, SOPlan.SiteID, SOShipLot.WhseLoc, SOShipLot.LotSerNbr) as D

		on	D.InvtID = LotSerMst.InvtID
		and	D.LotSerNbr = LotSerMst.LotSerNbr
		and	D.SiteID = LotSerMst.SiteID
		and	D.WhseLoc = LotSerMst.WhseLoc

		update	LotSerMst
		set	QtyAllocSO = D.QtyAlloc
		from	LotSerMst

		join (	select	SOPlan.InvtID,
				SOLot.LotSerNbr,
				SOPlan.SiteID,
				SOLot.WhseLoc,
				sum(	case when SOLine.UnitMultDiv = 'D' then
						case when SOLine.CnvFact <> 0 then
							round(SOLot.QtyShip / SOLine.CnvFact, @QtyPrec)
						else
							0
						end
					else
						round(SOLot.QtyShip * SOLine.CnvFact, @QtyPrec)
					end) as QtyAlloc

			from	SOPlan

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
			and	SOLot.LotSerNbr > ''
			and	SOPlan.InvtID = @InvtID
			and	SOPlan.SiteID = @SiteID

			group by SOPlan.InvtID, SOPlan.SiteID, SOLot.WhseLoc, SOLot.LotSerNbr) as D

		on	D.InvtID = LotSerMst.InvtID
		and	D.LotSerNbr = LotSerMst.LotSerNbr
		and	D.SiteID = LotSerMst.SiteID
		and	D.WhseLoc = LotSerMst.WhseLoc

		update	LotSerMst
		set	QtyAllocSD = isnull((select round(sum(
						case when COALESCE(u1.MultDiv, u2.MultDiv, u3.MultDiv, 'M') = 'D' then
						case when COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1) <> 0 then
							round(smServDetail.Quantity / COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1), @QtyPrec)
						else
							0
						end
						else
							round(smServDetail.Quantity * COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1), @QtyPrec)
						end), @QtyPrec)
				FROM	smServCall
				JOIN	smServDetail ON
					smServCall.ServiceCallID = smServDetail.ServiceCallID
				JOIN	Inventory ON smServDetail.InvtID = Inventory.InvtID
				LEFT JOIN INUnit u1 ON
					u1.FromUnit = Inventory.DfltSOUnit
					AND u1.ToUnit = Inventory.StkUnit
					AND u1.UnitType = '3'
					AND u1.InvtID = Inventory.InvtID
				LEFT JOIN INUnit u2 ON
					u2.FromUnit = Inventory.DfltSOUnit
					AND u2.ToUnit = Inventory.StkUnit
					AND u2.UnitType = '2'
					AND u2.ClassID = Inventory.ClassID
				LEFT JOIN INUnit u3 ON
					u3.FromUnit = Inventory.DfltSOUnit
					AND u3.ToUnit = Inventory.StkUnit
					AND u3.UnitType = '1'
				WHERE	smServDetail.InvtId = @InvtID
					AND smServDetail.SiteID = @SiteID
					AND smServDetail.WhseLoc = LotSerMst.WhseLoc
					AND smServDetail.LotSerialRep = LotSerMst.LotSerNbr
					AND smServDetail.LotSerialRep <> ''
					AND smServDetail.INBatNbr = '' -- grab only the trans that aren't in an IN batch yet
					AND smServDetail.Quantity > 0
					AND EXISTS (SELECT *
					              FROM LocTable l
					             WHERE l.SiteID = smServDetail.SiteID
					               AND l.WhseLoc = smServDetail.WhseLoc
					               AND l.InclQtyAvail = 1)), 0)
		where	LotSerMst.InvtID = @InvtID
		and	LotSerMst.SiteID = @SiteID

		update	M
		set	QtyAllocBM = round(isnull(D.QtyAllocBM, 0), @QtyPrec),
			QtyAllocIN = round(isnull(D.QtyAllocIN, 0), @QtyPrec),
			QtyAllocPORet = round(isnull(D.QtyAllocPORet, 0), @QtyPrec),
			QtyAllocSD = round(M.QtyAllocSD + isnull(D.QtyAllocSD, 0), @QtyPrec)
		from	LotSerMst M
		left join
			(select LotSerT.InvtID, LotSerT.SiteID, LotSerT.WhseLoc, LotSerT.LotSerNbr,
					QtyAllocBM = round(sum(case when LotSerT.TranSrc = 'BM' then
							-LotSerT.InvtMult * LotSerT.Qty else 0 end), @QtyPrec),
					QtyAllocIN = round(sum(case when LotSerT.TranSrc = 'IN' and LotSerT.Crtd_Prog not like 'SD%' then
							-LotSerT.InvtMult * LotSerT.Qty else 0 end), @QtyPrec),
					QtyAllocPORet = round(sum(case when LotSerT.TranSrc = 'PO' then
							-LotSerT.InvtMult * LotSerT.Qty else 0 end), @QtyPrec),
					QtyAllocSD = round(sum(case when LotSerT.Crtd_Prog LIKE 'SD%' then
							-LotSerT.InvtMult * LotSerT.Qty else 0 end), @QtyPrec)
			   FROM	LotSerT
			  WHERE	LotSerT.InvtID = @InvtID
			    AND LotSerT.SiteID = @SiteID
			    AND LotSerT.Rlsed = 0
			    AND LotSerT.InvtMult * LotSerT.Qty < 0
			    AND	LotSerT.TranType IN ('II','IN','DM','TR','AS','AJ')
			    AND EXISTS(SELECT *
			                 FROM LocTable l
			                WHERE l.SiteID = LotSerT.SiteID
			                  AND l.WhseLoc = LotSerT.WhseLoc
			                  AND l.InclQtyAvail = 1)
			 GROUP BY LotSerT.InvtID, LotSerT.SiteID, LotSerT.WhseLoc, LotSerT.LotSerNbr) D
		on	M.InvtID = D.InvtID
		and	M.SiteID = D.SiteID
		and	M.WhseLoc = D.WhseLoc
		and	M.LotSerNbr = D.LotSerNbr
		where	M.InvtID = @InvtID
		and	M.SiteID = @SiteID

		update	LotSerMst
		set	QtyAvail = round(QtyOnHand
			- QtyAlloc
			- QtyAllocBM
			- QtyAllocIN
			- QtyAllocPORet
			- QtyAllocSD
			- QtyAllocSO
			- QtyShipNotInv
			- case when @OptWOFirmRlsedDemand in ('F','R') then QtyWORlsedDemand else 0 End,
			@QtyPrec)
		where	InvtID = @InvtID
		  and	SiteID = @SiteID
		  and	EXISTS (SELECT *
		                  FROM LocTable l
		                 WHERE l.SiteID = @SiteID
		                   AND l.WhseLoc = LotSerMst.WhseLoc
		                   AND l.InclQtyAvail = 1)

	end

	-- --------------------------------------------------------------------------------
	-- Location - Update the quantity allocated for each bin.
	-- --------------------------------------------------------------------------------

	-- Clear Location.QtyAlloc.
	update	Location
	set	QtyAlloc = 0, QtyAllocBM = 0, QtyAllocIN = 0, QtyAllocPORet = 0, QtyAllocSD = 0, QtyAllocSO = 0
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	-- Update the quantity allocated using the inventory plan and shipper information.
	/* Trigger on SOShipLine updates
	 *	SOShipLot.S4Future11 with SOShipLine.UnitMultDiv
	 *and SOShipLot.S4Future03 with SOShipLine.ConvFact */
	update	Location
	set	QtyAlloc = isnull((select sum(	case when SOShipLot.S4Future11 = 'D' then
							case when SOShipLot.S4Future03 <> 0 then
								round((SOShipLot.QtyShip / SOShipLot.S4Future03), @QtyPrec)
							else
								0
							end
						else
							round((SOShipLot.QtyShip * SOShipLot.S4Future03), @QtyPrec)
						end)

				FROM	(SELECT InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef
                                           FROM SOPlan (NOLOCK)
                                          WHERE SOPlan.InvtID = @InvtID
                                            AND SOPlan.SiteID = @SiteID
                                            AND SOPlan.PlanType in ('30', '32', '34')
                                          GROUP BY InvtID, SiteID, PlanType, CpnyID, SOShipperID, SOShipperLineRef) SOPlan

				join	SOShipLot WITH(NOLOCK)
				on	SOShipLot.CpnyID = SOPlan.CpnyID
				and	SOShipLot.ShipperID = SOPlan.SOShipperID
				and	SOShipLot.LineRef = SOPlan.SOShipperLineRef

				where	SOPlan.PlanType in ('30', '32', '34')	-- Shipper
				and	SOPlan.InvtID = @InvtID
				and	SOPlan.SiteID = @SiteID
				and	SOShipLot.InvtID = @InvtID
				and	SOShipLot.WhseLoc = Location.WhseLoc), 0)

	where	Location.InvtID = @InvtID
	and	Location.SiteID = @SiteID

	update	Location
	set	QtyAllocSO = isnull((select sum(case when SOLine.UnitMultDiv = 'D' then
						case when SOLine.CnvFact <> 0 then
							round(SOLot.QtyShip / SOLine.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(SOLot.QtyShip * SOLine.CnvFact, @QtyPrec)
						end)

					from	SOPlan

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
				and	SOPlan.InvtID = @InvtID
				and	SOPlan.SiteID = @SiteID
				and	SOLot.Invtid = @InvtID
				and	SOLot.WhseLoc = Location.WhseLoc), 0)

	where	Location.InvtID = @InvtID
	and	Location.SiteID = @SiteID

	/*Only update if BM is installed and being used.*/
	IF EXISTS(SELECT * FROM BMSetup WHERE SetupID = 'BM')
	  BEGIN
	   UPDATE Location
	      SET QtyAllocBM = isnull((SELECT round(sum(BOMTran.CmpnentQty), @QtyPrec)
	                                 FROM BOMDoc JOIN BOMTran
	                                             ON BOMDoc.RefNbr = BOMTran.RefNbr
	                                WHERE BOMTran.CmpnentID = @InvtID
	                                  AND BOMTran.SiteID = @SiteID
	                                  AND BOMTran.WhseLoc = Location.WhseLoc
	                                  AND BOMDoc.Rlsed = 0
	                                  AND BOMTran.CmpnentQty > 0
	                                  AND EXISTS (SELECT *
	                                                FROM LocTable l
	                                               WHERE l.SiteID = BOMTran.SiteID
	                                                 AND l.WhseLoc = BOMTran.WhseLoc
	                                                 AND l.InclQtyAvail = 1)
	                                  AND NOT EXISTS(SELECT *
	                                                   FROM INTran i
	                                                  WHERE i.BatNbr = BOMTran.BatNbr
	                                                    AND i.LineRef = BOMTran.LineRef
                                                            AND i.invtID = @InvtID
                                                            AND i.SiteID = @SiteID)), 0)
	  WHERE Location.InvtID = @InvtID
	    AND Location.SiteID = @SiteID
	END

	update	Location
	set	QtyAllocPORet = isnull((select round(sum(case when POTran.UnitMultDiv = 'D' then
						case when POTran.CnvFact <> 0 then
							round(POTran.Qty / POTran.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(POTran.Qty * POTran.CnvFact, @QtyPrec)
						end), @QtyPrec)
				                FROM	POTran
				               WHERE	POTran.InvtID = @InvtID
				                 AND	POTran.SiteID = @SiteID
				                 AND	POTran.WhseLoc = Location.WhseLoc
				                 AND	POTran.TranType = 'X'
				                 AND	POTran.PurchaseType = 'GI'
				                 AND EXISTS(SELECT *
				                              FROM POReceipt r
				                             WHERE r.RcptNbr = POTran.RcptNbr
				                               AND r.Rlsed = 0)
				                 AND EXISTS(SELECT *
				                              FROM LocTable l
				                             WHERE l.SiteID = POTran.SiteID
				                               AND l.WhseLoc = POTran.WhseLoc
				                               AND InclQtyAvail = 1)), 0)
	where	Location.InvtID = @InvtID
	and	Location.SiteID = @SiteID

	-- Only update if Service Dispatch is installed and being used.
	IF EXISTS(SELECT * FROM smProServSetup WHERE SetupID = 'PROSETUP')
	  BEGIN
	   UPDATE Location
	      SET QtyAllocSD = isnull((SELECT round(sum(
						   CASE WHEN COALESCE(u1.MultDiv, u2.MultDiv, u3.MultDiv, 'M') = 'D' THEN
						        CASE WHEN COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1) <> 0 THEN
							    round(smServDetail.Quantity / COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1), @QtyPrec)
						        ELSE
							       0
						        END
						   ELSE
							   round(smServDetail.Quantity * COALESCE(u1.CnvFact, u2.CnvFact, u3.CnvFact, 1), @QtyPrec)
						   END), @QtyPrec)

				                 FROM smServCall
				                      JOIN smServDetail ON
					                       smServCall.ServiceCallID = smServDetail.ServiceCallID
				                      JOIN	Inventory ON smServDetail.InvtID = Inventory.InvtID
				LEFT JOIN INUnit u1 ON
					u1.FromUnit = Inventory.DfltSOUnit
					AND u1.ToUnit = Inventory.StkUnit
					AND u1.UnitType = '3'
					AND u1.InvtID = Inventory.InvtID
				LEFT JOIN INUnit u2 ON
					u2.FromUnit = Inventory.DfltSOUnit
					AND u2.ToUnit = Inventory.StkUnit
					AND u2.UnitType = '2'
					AND u2.ClassID = Inventory.ClassID
				LEFT JOIN INUnit u3 ON
					u3.FromUnit = Inventory.DfltSOUnit
					AND u3.ToUnit = Inventory.StkUnit
					AND u3.UnitType = '1'
				WHERE	smServDetail.InvtId = @InvtID
					AND smServDetail.SiteID = @SiteID
					AND smServDetail.WhseLoc = Location.WhseLoc
					AND smServDetail.INBatNbr = '' -- grab only the trans that aren't in an IN batch yet
					AND smServDetail.Quantity > 0
						AND EXISTS (SELECT *
						              FROM LocTable l
						             WHERE l.SiteID = smServDetail.SiteID
						               AND l.WhseLoc = smServDetail.WhseLoc
                                       AND l.InclQtyAvail = 1)), 0)
	   WHERE Location.InvtID = @InvtID
	     AND Location.SiteID = @SiteID
	  END

	update	L
	set	QtyAllocBM = round(L.QtyAllocBM + isnull(D.QtyAllocBM, 0), @QtyPrec),
		QtyAllocIN = round(isnull(D.QtyAllocIN, 0), @QtyPrec),
		QtyAllocPORet = round(L.QtyAllocPORet + isnull(D.QtyAllocPORet, 0), @QtyPrec),
		QtyAllocSD = round(L.QtyAllocSD + isnull(D.QtyAllocSD, 0), @QtyPrec)
	from	Location L
	left join
		(select INTran.InvtID, INTran.SiteID, INTran.WhseLoc,
				QtyAllocBM = round(sum(case when INTran.JrnlType = 'BM' then
						case when INTran.UnitMultDiv = 'D' then
						case when INTran.CnvFact <> 0 then
							round(-INTran.InvtMult*INTran.Qty / INTran.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(-INTran.InvtMult*INTran.Qty * INTran.CnvFact, @QtyPrec)
						end else 0 end), @QtyPrec),
				QtyAllocIN = round(sum(case when INTran.JrnlType = 'IN' and INTran.Crtd_Prog not like 'SD%' then
						case when INTran.UnitMultDiv = 'D' then
						case when INTran.CnvFact <> 0 then
							round(-INTran.InvtMult*INTran.Qty / INTran.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(-INTran.InvtMult*INTran.Qty * INTran.CnvFact, @QtyPrec)
						end else 0 end), @QtyPrec),
				QtyAllocPORet = round(sum(case when INTran.JrnlType = 'PO' then
						case when INTran.UnitMultDiv = 'D' then
						case when INTran.CnvFact <> 0 then
							round(-INTran.InvtMult*INTran.Qty / INTran.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(-INTran.InvtMult*INTran.Qty * INTran.CnvFact, @QtyPrec)
						end else 0 end), @QtyPrec),
				QtyAllocSD = round(sum(case when INTran.Crtd_Prog LIKE 'SD%' then
						case when INTran.UnitMultDiv = 'D' then
						case when INTran.CnvFact <> 0 then
							round(-INTran.InvtMult*INTran.Qty / INTran.CnvFact, @QtyPrec)
						else
							0
						end
						else
							round(-INTran.InvtMult*INTran.Qty * INTran.CnvFact, @QtyPrec)
						end else 0 end), @QtyPrec)
				 FROM	INTran
				where	INTran.S4Future09 = 0
				and	INTran.Rlsed = 0
				and INTran.InvtID = @InvtID
				and INTran.SiteID = @SiteID
				and	(INTran.TranType IN ('II','IN','DM','TR')
				or	(INTran.TranType = 'AS' and INTran.InvtMult = -1)
				or	(INTran.TranType = 'AJ' and INTran.Qty < 0))
				AND EXISTS(SELECT *
				             FROM Loctable l
				            WHERE l.SiteID = Intran.SiteID
				              AND l.WhseLoc = INtran.Whseloc
				              AND l.InclQtyAvail = 1
            AND Intran.InvtID = @InvtID
                                              AND Intran.SiteID = @SiteID)
				group by INTran.InvtID, INTran.SiteID, INTran.WhseLoc) D
	on	L.InvtID = D.InvtID
	and	L.SiteID = D.SiteID
	and	L.WhseLoc = D.WhseLoc
	where	L.InvtID = @InvtID
	and	L.SiteID = @SiteID
		update	Location
	set	QtyAvail = round(QtyOnHand
		- QtyAlloc
		- QtyAllocBM
		- QtyAllocIN
		- QtyAllocPORet
		- QtyAllocSD
		- QtyAllocSO
		- QtyShipNotInv
		- case when @OptWOFirmRlsedDemand in ('F','R') then QtyWORlsedDemand else 0 End
		- case when @OptWOFirmRlsedDemand = 'F' then S4Future03 else 0 end,
		@QtyPrec)
	where	InvtID = @InvtID
	  and	SiteID = @SiteID
	  and	EXISTS (SELECT *
	                  FROM LocTable l
	                 WHERE l.SiteID = @SiteID
	                   AND l.WhseLoc = Location.WhseLoc
	                   AND l.InclQtyAvail = 1)

	-- --------------------------------------------------------------------------------
	-- ItemSite -
	-- --------------------------------------------------------------------------------

	-- Get the quantity allocated at the ItemSite level.
	select	@QtyAlloc = isnull(sum(QtyAlloc), 0),
		@QtyAllocBM = isnull(sum(QtyAllocBM), 0),
		@QtyAllocIN = isnull(sum(QtyAllocIN), 0),
		@QtyAllocPORet = isnull(sum(QtyAllocPORet), 0),
		@QtyAllocSD = isnull(sum(QtyAllocSD), 0),
		@QtyAllocSO = isnull(sum(QtyAllocSO), 0)
	from	Location
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	-- Calculate the remaining ItemSite inventory quantities.
	select	@QtyCustOrd = coalesce(-sum(case when PlanType in ('30', '32', '34', '50', '52', '54', '60', '61', '62', '64') then Qty else 0 end), 0),
		@QtyOnBO = coalesce(-sum(case when PlanType in ('50', '52', '54', '60', '61', '62', '64') and SOReqPickDate < @BODate then Qty else 0 end), 0),
		@QtyOnKitAssy = coalesce(sum(case when PlanType in ('25', '26') then Qty else 0 end), 0),
		@QtyOnTransfer = coalesce(sum(case when PlanType in ('28', '29') then Qty else 0 end), 0)

	from 	SOPlan
	where 	InvtID = @InvtID
	and	SiteID = @SiteID

	-- Update ItemSite
	update	ItemSite
	set	AllocQty = @QtyAlloc,
		QtyAlloc = @QtyAlloc,
		QtyAllocBM = @QtyAllocBM,
		QtyAllocIN = @QtyAllocIN,
		QtyAllocPORet = @QtyAllocPORet,
		QtyAllocSD = @QtyAllocSD,
		QtyAllocSO = @QtyAllocSO,
		QtyAvail =	case when @QtyAvailUpdateMode = 1 then @QtyAvail
				else QtyAvail
				end,
		QtyCustOrd = @QtyCustOrd,
		QtyOnBO = @QtyOnBO,
		QtyOnKitAssyOrders = @QtyOnKitAssy,
		QtyOnTransferOrders = @QtyOnTransfer
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	-- Recalculate the quantity available if CPS is off.
	if (@QtyAvailUpdateMode = 0)
		exec ADG_Invt_CalcQtyAvail @InvtID, @SiteID, 'PLAN', 'PLAN'
GO
