USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POAlloc_ScheduleAssigned]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POAlloc_ScheduleAssigned]
	@CpnyID varchar(10),
	@SOOrdNbr varchar(15),
	@SOLineRef varchar(5),
	@SOSchedRef varchar(5)
AS
		-- Select a PONbr that is NOT Cancelled.
	select	A.PONbr
	from	POAlloc A
	where	CpnyID = @CpnyID
	and	SOOrdNbr = @SOOrdNbr
	and	SOLineRef = @SOLineRef
	and	SOSchedRef = @SOSchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
