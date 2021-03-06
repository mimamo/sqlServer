USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctSub]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctSub]

	@CpnyID varchar(10),
	@UserID varchar(47),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	vs_AcctSub.Acct, vs_AcctSub.Active
	from	vs_AcctSub
	where	CpnyID = @CpnyID
	and  	Acct in (Select Acct from RQUserAcct where UserID = @UserID)
	and	Acct like @Acct
	and	Active = 1
	order by Acct, Sub
GO
