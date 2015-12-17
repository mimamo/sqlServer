USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_AcctSub_PJ_Account_Account_Valid]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_AcctSub_PJ_Account_Account_Valid]
	@CpnyID	varchar(10),
	@Acct	varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	if (
	select	count(*)
	from	vs_AcctSub (NOLOCK)
	join	PJ_Account (NOLOCK) on vs_AcctSub.Acct = Pj_Account.gl_Acct
	where	vs_AcctSub.CpnyID = @CpnyID
	and	vs_AcctSub.Acct = @Acct
	and	vs_AcctSub.Active = 1
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
