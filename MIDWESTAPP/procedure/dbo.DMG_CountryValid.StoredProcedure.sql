USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CountryValid]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CountryValid]
	@CountryID	varchar(3)
as
	if (
	select	count(*)
	from	Country (NOLOCK)
	where	CountryID = @CountryID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
