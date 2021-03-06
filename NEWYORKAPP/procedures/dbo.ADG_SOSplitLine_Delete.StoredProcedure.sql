USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSplitLine_Delete]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOSplitLine_Delete]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@LineRef varchar(5),
	@SlsPerID varchar(10)
AS
	DELETE FROM SOSplitLine
	WHERE CpnyID LIKE @CpnyID AND
		OrdNbr LIKE @OrdNbr AND
		LineRef LIKE @LineRef AND
		SlsPerID LIKE @SlsPerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
