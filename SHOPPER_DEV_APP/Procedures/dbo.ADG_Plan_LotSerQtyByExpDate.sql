USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_LotSerQtyByExpDate]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_LotSerQtyByExpDate]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)
as
	select		ls.ExpDate,
			sum(ls.QtyAlloc),
			sum(ls.QtyOnHand),
			sum(ls.QtyShipNotInv)

	from		LotSerMst ls

	join		LocTable lt
	on		lt.SiteID = ls.SiteID
	and		lt.WhseLoc = ls.WhseLoc

	where		ls.InvtID = @InvtID
	and		ls.SiteID = @SiteID
	and		lt.InclQtyAvail = 1

	group by	ls.ExpDate
GO
