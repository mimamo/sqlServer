USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdateSOSchedPriority]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_UpdateSOSchedPriority]
	@CpnyID 	varchar(10),
	@OrdNbr 	varchar(15),
	@LineRef 	varchar(5),
	@SchedRef 	varchar(5),
 	@PrioritySeq 	int,
	@LUpd_Prog 	varchar(8),
	@LUpd_User 	varchar(10)
	AS

	update	SOSched
	set	PrioritySeq = @PrioritySeq,
		LUpd_DateTime = GETDATE(),
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and 	LineRef = @LineRef
	  and	SchedRef = @SchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
