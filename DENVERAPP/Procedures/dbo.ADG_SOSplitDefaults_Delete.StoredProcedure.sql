USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSplitDefaults_Delete]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOSplitDefaults_Delete]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@SlsPerID varchar(10)
AS
	DELETE FROM SOSplitDefaults
	WHERE CpnyID LIKE @CpnyID AND
		OrdNbr LIKE @OrdNbr AND
		SlsPerID LIKE @SlsPerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
