USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_AcctXref_Acct]    Script Date: 12/21/2015 16:00:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_AcctXref_Acct]

	@CpnyID varchar(10),
	@Acct varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_AcctXRef
	where	CpnyID = @CpnyID
	and	Acct like @Acct
	and	Active = 1
	order by Acct
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
