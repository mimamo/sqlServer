USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_CpnyID_InvcNbr]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_CpnyID_InvcNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE CpnyID LIKE @parm1
	   AND InvcNbr LIKE @parm2
	ORDER BY CpnyID,
	   InvcNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
