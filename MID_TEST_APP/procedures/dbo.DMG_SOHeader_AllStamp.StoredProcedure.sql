USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_AllStamp]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_AllStamp]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
AS
	SELECT	*,
		convert(int, tstamp)
	FROM	SOHeader
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
