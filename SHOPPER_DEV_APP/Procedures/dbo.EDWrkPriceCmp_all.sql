USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPriceCmp_all]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDWrkPriceCmp_all]
	@parm1 varchar( 21 ),
	@parm2min smallint, @parm2max smallint,
	@parm3 varchar( 10 ),
	@parm4min smallint, @parm4max smallint
AS
	SELECT *
	FROM EDWrkPriceCmp
	WHERE ComputerID LIKE @parm1
	   AND RI_ID BETWEEN @parm2min AND @parm2max
	   AND EDIPOID LIKE @parm3
	   AND LineNbr BETWEEN @parm4min AND @parm4max
	ORDER BY ComputerID,
	   RI_ID,
	   EDIPOID,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
