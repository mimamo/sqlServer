USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOLine_All2]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOLine_All2]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
AS
	SELECT	*
	FROM	SOLine
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
