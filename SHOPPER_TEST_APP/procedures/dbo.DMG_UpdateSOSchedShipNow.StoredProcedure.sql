USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateSOSchedShipNow]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_UpdateSOSchedShipNow]
	@CpnyID 	varchar(10),
	@OrdNbr 	varchar(15),
	@LineRef 	varchar(5),
	@SchedRef 	varchar(5),
	@LUpd_Prog 	varchar(8),
	@LUpd_User 	varchar(10)
	AS

	update	SOSched
	set	S4Future09 = 1,
		LUpd_DateTime = GETDATE(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and 	LineRef = @LineRef
	  and	SchedRef = @SchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
