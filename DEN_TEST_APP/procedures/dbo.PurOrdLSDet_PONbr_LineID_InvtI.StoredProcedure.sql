USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineID_InvtI]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdLSDet_PONbr_LineID_InvtI]
	@parm1 varchar( 10 ),
	@parm2min int, @parm2max int,
	@parm3 varchar( 30 ),
	@parm4 varchar( 25 )
AS
	SELECT *
	FROM PurOrdLSDet
	WHERE PONbr LIKE @parm1
	   AND LineID BETWEEN @parm2min AND @parm2max
	   AND InvtID LIKE @parm3
	   AND LotSerNbr LIKE @parm4
	ORDER BY PONbr,
	   LineID,
	   InvtID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
