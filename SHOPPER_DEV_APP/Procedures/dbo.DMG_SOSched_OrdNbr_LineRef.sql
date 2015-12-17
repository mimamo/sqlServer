USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_OrdNbr_LineRef]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_SOSched_OrdNbr_LineRef]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@LineRef varchar(5),
	@SchedRef varchar(5)
as

	select 	*
	from 	vp_SOSchedPO
		where	CpnyID = @CpnyID
	And		OrdNbr = @OrdNbr
	And		LineRef = @LineRef
	And		SchedRef like @SchedRef
	Order by CpnyID, OrdNbr, LineRef, SchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
