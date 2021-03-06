USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditCheck_HoldOrder]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditCheck_HoldOrder]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@CreditHold	smallint,
	@CreditHoldDate	smalldatetime,
	@ProgID		varchar(8),
	@UserID		varchar(10)
as
	update		SOHeader
	set		CreditHold = @CreditHold,
			CreditHoldDate = @CreditHoldDate,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @ProgID,
			LUpd_User = @UserID,
			ReleaseValue = 0
	where		CpnyID = @CpnyID
	and		OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
