USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CuryIDValid]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CuryIDValid]
	@CuryID varchar(4)
as
	if (
	select	count(*)
	from	Currncy (NOLOCK)
	where	CuryID = @CuryID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
