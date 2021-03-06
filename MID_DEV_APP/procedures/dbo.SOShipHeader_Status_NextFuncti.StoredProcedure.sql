USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_Status_NextFuncti]    Script Date: 12/21/2015 14:18:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_Status_NextFuncti]
	@parm1 varchar( 1 ),
	@parm2 varchar( 8 ),
	@parm3 varchar( 4 ),
	@parm4 varchar( 15 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE Status LIKE @parm1
	   AND NextFunctionID LIKE @parm2
	   AND NextFunctionClass LIKE @parm3
	   AND OrdNbr LIKE @parm4
	ORDER BY Status,
	   NextFunctionID,
	   NextFunctionClass,
	   OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
