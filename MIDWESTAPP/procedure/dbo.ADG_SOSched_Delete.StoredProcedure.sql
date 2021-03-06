USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSched_Delete]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOSched_Delete]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@LineRef varchar(5),
	@SchedRef varchar(5)
AS
	DELETE FROM SOSched
	WHERE CpnyID LIKE @CpnyID AND
		OrdNbr LIKE @OrdNbr AND
		LineRef LIKE @LineRef AND
		SchedRef LIKE @SchedRef

	DELETE FROM SOSchedMark
	WHERE CpnyID LIKE @CpnyID AND
		OrdNbr LIKE @OrdNbr AND
		LineRef LIKE @LineRef AND
		SchedRef LIKE @SchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
