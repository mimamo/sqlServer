USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_PO_IS]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_PO_IS]
	@InvtIDParm	varchar (30),
	@SiteIDParm	varchar (10)
as
	select		h.CpnyID, h.PONbr
	from		Purchord h
	where		h.Status in ('O', 'P')
		and exists (
			SELECT *
			FROM PurOrdDet d
			WHERE		d.PONbr = h.PONbr
				and	d.InvtID like @InvtIDParm
				and	d.SiteID like @SiteIDParm )
	order by	PONbr
GO
