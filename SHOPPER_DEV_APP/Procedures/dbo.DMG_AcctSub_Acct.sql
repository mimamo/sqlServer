USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_AcctSub_Acct]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_AcctSub_Acct]

	@CpnyID varchar(10),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctSub
	where	CpnyID = @CpnyID
	and	Acct like @Acct
	and	Active = 1
	order by Acct, Sub

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
