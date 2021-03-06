USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetCurrencyPrecision]    Script Date: 12/21/2015 13:56:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetCurrencyPrecision]
	@CuryID	varchar(4),
	@DecPl	smallint OUTPUT
as
	select	@DecPl = DecPl
	from	Currncy (NOLOCK)
	where	CuryID = @CuryID

	if @@ROWCOUNT = 0 begin
		set @DecPl = 0
		return 0	--Failure
	end
	else begin
		--select @DecPl
		return 1	--Success
	end
GO
