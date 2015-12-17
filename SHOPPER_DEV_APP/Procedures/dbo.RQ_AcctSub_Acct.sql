USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctSub_Acct]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctSub_Acct]

	@CpnyID varchar(10),
	@UserID varchar(47),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctSub
	where	CpnyID = @CpnyID
	and  	Acct in (Select Acct from RQUserAcct where UserID = @UserID)
	and	Acct like @Acct
	and	Active = 1
	order by Acct, Sub
GO
