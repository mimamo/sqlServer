USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CreditMgrValid]    Script Date: 12/21/2015 16:07:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CreditMgrValid]
	@CreditMgrID	varchar(10)
as
	if (
	select	count(*)
	from	CreditMgr (NOLOCK)
	where	CreditMgrID = @CreditMgrID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
