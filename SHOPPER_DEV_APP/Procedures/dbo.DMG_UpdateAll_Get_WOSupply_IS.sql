USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_WOSupply_IS]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_WOSupply_IS]
	@InvtIDParm	varchar (30),
	@SiteIDParm	varchar (10)
as
	select		h.CpnyID, h.WONbr
	from		WOHeader h
	where		h.ProcStage not in ('P','C') and		-- For supply, no plan/fin-closed WOs
	  		h.Status not in ('P')		 	-- Not Purge
		and exists (
			select *
			from WOBuildTo b
			where b.WONbr = h.WONbr
				and b.InvtID like @InvtIDParm
				and b.SiteID like @SiteIDParm )
	order by	WONbr
GO
