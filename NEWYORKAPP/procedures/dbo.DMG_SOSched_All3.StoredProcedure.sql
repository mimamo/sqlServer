USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_All3]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOSched_All3]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
AS
	SELECT	*
	FROM	SOSched
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr
	  AND	LineRef = @LineRef

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
