USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_All0]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOSched_All0]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
AS
	SELECT	*
	FROM	SOSched
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr
	  AND	LineRef = @LineRef
	  AND	SchedRef = @SchedRef

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
