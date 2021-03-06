USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctXref]    Script Date: 12/21/2015 14:34:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctXref]

	@CpnyID varchar(10),
	@UserID varchar(47),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	vs_AcctXRef.Acct, vs_AcctXref.Active
	from	vs_AcctXRef
	where	CpnyID = @CpnyID
	and	Acct like @Acct
	and	Active = 1
	and  	Acct in (Select Acct from RQUserAcct where UserID = @UserID)
	order by Acct
GO
