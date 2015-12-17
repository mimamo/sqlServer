USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_TermsIDValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_TermsIDValid]
	@TermsID	varchar(2)
as
	if (
	select	count(*)
	from	Terms (NOLOCK)
	where	TermsID = @TermsID
	and	ApplyTo in ('B', 'V')
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
