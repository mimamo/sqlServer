USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PmtType_Account]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PmtType_Account]
	@CpnyID varchar(10),
	@CuryID varchar(4),
	@PmtTypeID varchar(4)
AS
	select	PmtType.*
	from	PmtType
	join	Account on Account.Acct = PmtType.CashAcct
	where	PmtType.CpnyID = @CpnyID
	and	(Account.CuryID = @CuryID or Account.CuryID = '')
	and	PmtTypeID like @PmtTypeID
	ORDER BY CpnyID, PmtTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
