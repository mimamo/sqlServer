USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctSub_PJ_Account_Acct]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctSub_PJ_Account_Acct]

	@CpnyID varchar(10),
	@UserID varchar(47),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctSub
	join	PJ_Account on vs_AcctSub.Acct = Pj_Account.gl_Acct
	where	vs_AcctSub.CpnyID = @CpnyID
	and  	vs_AcctSub.Acct in (Select Acct from RQUserAcct where UserID = @UserID)
	and	vs_AcctSub.Acct like @Acct
	and	vs_AcctSub.Active = 1
	order by vs_AcctSub.Acct
GO
