USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_POQtyNotShipped]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_POQtyNotShipped]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
Select  sum(sl.QtyOrd) - (sum(sl.QtyOrd) - sum(po.RcptQty)) UseValue
	from soheader sh
		join soline sl
			on sh.ordnbr = sl.ordnbr
		join potranalloc po
			on po.soordnbr = sh.ordnbr
	where NOT EXISTS(SELECT OrdNbr
					FROM SOShipHeader s
					WHERE sh.OrdNbr = s.OrdNbr
						AND sh.cpnyid = s.cpnyid)
		and sl.invtid = @InvtID
		and sl.siteid = @SiteID
GO
