USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdatePO_Get_PO_IS]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdatePO_Get_PO_IS]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@POLineRef	varchar(5),
	@InvtIDParm	varchar(30),
	@SiteIDPArm	varchar(10)
as
	IF PATINDEX('%[%]%', @POLineRef) > 0
		select
			l.LineRef,
			a.AllocRef,
			l.QtyOrd,
			l.QtyRcvd,
			l.CnvFact,
			l.UnitMultDiv,
			l.PromDate,
			a.SOOrdNbr,
			a.SOLineRef,
			a.SOSchedRef,
   		convert(smallint, l.S4Future09),	-- ShelfLife (temporary)
	--		'ShelfLife' = convert(smallint,0)
  	 	l.invtid,
   		l.siteid,
   		l.purchasetype
			from	PurOrdDet l

			left join POAlloc a
		  	on a.PONbr = l.PONbr and
		  	a.POLineRef = l.LineRef

			join
			PurchOrd h
			on	l.PONbr = h.PONbr
			where 	h.CpnyID = @CpnyID and
		  	l.PONbr = @PONbr and
		  	l.LineRef + '' LIKE @POLineRef and
		  	l.PurchaseType in ('GI', 'GN', 'GS', 'GD') and 	-- Goods for Inventory, Non-Inventory Goods, Sales Order, Drop Ship
		  	l.OpenLine = 1 and
		  	h.POType in ('OR', 'DP') and							-- Regular, Drop Ship
		  	h.Status in ('O', 'P') 									-- Open Order, Purchase Order
		and	l.InvtID like @InvtIDParm
		and	l.SiteID like @SiteIDParm

		order by l.invtid, l.siteid, l.promdate
		-- this order allows assignment of planref values
	ELSE
		select
			l.LineRef,
			a.AllocRef,
			l.QtyOrd,
			l.QtyRcvd,
			l.CnvFact,
			l.UnitMultDiv,
			l.PromDate,
			a.SOOrdNbr,
			a.SOLineRef,
			a.SOSchedRef,
   		convert(smallint, l.S4Future09),	-- ShelfLife (temporary)
	--		'ShelfLife' = convert(smallint,0)
  	 	l.invtid,
   		l.siteid,
   		l.purchasetype
			from	PurOrdDet l

			left join POAlloc a
		  	on a.PONbr = l.PONbr and
		  	a.POLineRef = l.LineRef

			join
			PurchOrd h
			on	l.PONbr = h.PONbr
			where 	h.CpnyID = @CpnyID and
		  	l.PONbr = @PONbr and
		  	l.LineRef = @POLineRef and
		  	l.PurchaseType in ('GI', 'GN', 'GS', 'GD') and 	-- Goods for Inventory, Non-Inventory Goods, Sales Order, Drop Ship
		  	l.OpenLine = 1 and
		  	h.POType in ('OR', 'DP') and							-- Regular, Drop Ship
		  	h.Status in ('O', 'P') 									-- Open Order, Purchase Order
		and	l.InvtID like @InvtIDParm
		and	l.SiteID like @SiteIDParm

		order by l.invtid, l.siteid, l.promdate
		-- this order allows assignment of planref values
GO
