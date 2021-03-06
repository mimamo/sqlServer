USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_AllStamp]    Script Date: 12/16/2015 15:55:18 ******/
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
