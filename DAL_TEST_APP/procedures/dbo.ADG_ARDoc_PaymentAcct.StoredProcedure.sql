USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_PaymentAcct]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_PaymentAcct]
	@CpnyID		varchar(10),
	@PmtTypeID	varchar(4)
as
	select	CashAcct,
		CashSub

	from	PmtType

	where	CpnyID = @CpnyID
	  and	PmtTypeID = @PmtTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
