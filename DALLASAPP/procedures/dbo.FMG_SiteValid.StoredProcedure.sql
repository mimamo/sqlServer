USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_SiteValid]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_SiteValid]
	@SiteID	varchar(10)
as
	if (
	select	count(*)
	from	Site (NOLOCK)
	where	SiteID = @SiteID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
