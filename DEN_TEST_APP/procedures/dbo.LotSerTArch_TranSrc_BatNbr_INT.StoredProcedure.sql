USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerTArch_TranSrc_BatNbr_INT]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerTArch_TranSrc_BatNbr_INT]
	@parm1 varchar( 2 ),
	@parm2 varchar( 10 ),
	@parm3min int, @parm3max int
AS
	SELECT *
	FROM LotSerTArch
	WHERE TranSrc LIKE @parm1
	   AND BatNbr LIKE @parm2
	   AND INTranLineID BETWEEN @parm3min AND @parm3max
	ORDER BY TranSrc,
	   BatNbr,
	   INTranLineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
