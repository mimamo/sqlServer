USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CurrncyValid]    Script Date: 12/16/2015 15:55:22 ******/
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
