USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_All0]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_All0]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
AS
	SELECT	*
	FROM	SOHeader
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
