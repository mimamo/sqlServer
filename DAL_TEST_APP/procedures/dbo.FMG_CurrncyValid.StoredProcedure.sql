USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CurrncyValid]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CurrncyValid]
	@CuryId	varchar(4)
as
	if (
	select	count(*)
	from	Currncy (NOLOCK)
	where	CuryId = @CuryId
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
