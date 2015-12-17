USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOLine_All0]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOLine_All0]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
AS
	SELECT	*
	FROM	SOLine
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr
	  AND	LineRef = @LineRef

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
