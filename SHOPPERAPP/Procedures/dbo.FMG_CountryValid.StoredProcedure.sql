USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CountryValid]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CountryValid]
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
