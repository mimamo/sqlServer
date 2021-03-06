USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_PO_IS]    Script Date: 12/21/2015 16:07:02 ******/
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
