USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TermsIDValid]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_TermsIDValid]
	@TermsID	varchar(2)
as
	if (
	select	count(*)
	from	Terms (NOLOCK)
	where	TermsID = @TermsID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
