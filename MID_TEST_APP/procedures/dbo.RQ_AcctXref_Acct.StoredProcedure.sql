USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctXref_Acct]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctXref_Acct]

	@CpnyID varchar(10),
	@UserID varchar(47),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctXRef
	where	CpnyID = @CpnyID
	and	Acct like @Acct
	and	Active = 1
	and  	Acct in (Select Acct from RQUserAcct where UserID = @UserID)
	order by Acct
GO
