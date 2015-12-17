USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_FrtTermsValid]    Script Date: 12/16/2015 15:55:22 ******/
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
