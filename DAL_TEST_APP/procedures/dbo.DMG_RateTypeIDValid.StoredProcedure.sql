USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_RateTypeIDValid]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_RateTypeIDValid]
	@RateTypeID varchar(6)
as
	if (
	select	count(*)
	from	CuryRtTp (NOLOCK)
	where	RateTypeID = @RateTypeID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
