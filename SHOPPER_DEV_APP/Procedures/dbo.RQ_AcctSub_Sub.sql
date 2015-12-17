USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_AcctSub_Sub]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQ_AcctSub_Sub]

	@CpnyID varchar(10),
	@Acct varchar(10),
	@Userid varchar(47),
	@Sub varchar(24)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctSub
	where	CpnyID = @CpnyID
	and	Acct like @Acct
	and	Sub like @Sub
	and	Sub in (Select Sub from RQUserSubAct where Userid = @Userid)
	and	Active = 1
	order by Sub
GO
