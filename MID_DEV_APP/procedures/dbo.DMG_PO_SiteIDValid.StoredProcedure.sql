USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SiteIDValid]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SiteIDValid]
	@CpnyID varchar(10),
	@SiteID	varchar(10)
as
	if (
	select	count(*)
	from	Site (NOLOCK)
	where	CpnyID = @CpnyID
	and	SiteID = @SiteID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
