USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_FrtTermsValid]    Script Date: 12/21/2015 16:07:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_FrtTermsValid]
	@FrtTermsID	varchar(10)
as
	if (
	select	count(*)
	from	FrtTerms (NOLOCK)
	where	FrtTermsID = @FrtTermsID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
