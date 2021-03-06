USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_GLSetup]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_GLSetup]
	@ValidateAcctSub	smallint OUTPUT,
	@ValidateAtPosting	smallint OUTPUT
as
	select	@ValidateAcctSub = ValidateAcctSub,
		@ValidateAtPosting = ValidateAtPosting
	from	GLSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @ValidateAcctSub = 0
		set @ValidateAtPosting = 0
		return 0	--Failure
	end
	else
		--select @ValidateAcctSub,@ValidateAtPosting
		return 1	--Success
GO
