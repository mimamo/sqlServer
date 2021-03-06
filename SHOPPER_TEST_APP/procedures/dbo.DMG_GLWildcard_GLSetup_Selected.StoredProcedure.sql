USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_GLSetup_Selected]    Script Date: 12/21/2015 16:07:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_GLSetup_Selected]
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
		return 1	--Success
GO
