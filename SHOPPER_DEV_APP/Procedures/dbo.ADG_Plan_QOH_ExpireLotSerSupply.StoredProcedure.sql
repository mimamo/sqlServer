USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_QOH_ExpireLotSerSupply]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_QOH_ExpireLotSerSupply]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	LotSerMst.ExpDate 'ExpireDate',
		LotSerMst.LotSerNbr,
		'SupplyQty' = (LotSerMst.QtyOnHand
		- LotSerMst.QtyAllocBM
		- LotSerMst.QtyAllocIN
		- LotSerMst.QtyAllocPORet
		- LotSerMst.QtyAllocSD
		- LotSerMst.QtyShipNotInv
		- case when left(isnull(WOSetup.S4Future11,' '),1) in ('F','R') then LotSerMst.QtyWORlsedDemand else 0 End
		)

	from	LotSerMst

	join	LocTable
	on	LocTable.SiteID = LotSerMst.SiteID
	and	LocTable.WhseLoc = LotSerMst.WhseLoc

	left join WOSetup (nolock) on SetupID = 'WO' and Init = 'Y'

	where	LotSerMst.InvtID = @InvtID
	and	LotSerMst.SiteID = @SiteID
	and	LocTable.InclQtyAvail = 1

	order by
		LotSerMst.ExpDate,
		LotSerMst.LotSerNbr
GO
