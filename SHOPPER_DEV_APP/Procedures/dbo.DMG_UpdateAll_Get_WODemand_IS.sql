USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_WODemand_IS]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_WODemand_IS]
	@InvtIDParm	varchar (30),
	@SiteIDParm	varchar (10)
as
	select		h.CpnyID, h.WONbr
	from		WOHeader h
	where		h.Status not in ('P')		 	-- Not Purge
		and exists (
			select *
			from WOMatlReq m
			where		m.WONbr = h.WONbr
				and m.InvtID like @InvtIDParm
				and m.InvtID like @SiteIDParm)

	order by	h.WONbr								-- For Demand cannot constrain on Proc Stage (PWOs)
GO
