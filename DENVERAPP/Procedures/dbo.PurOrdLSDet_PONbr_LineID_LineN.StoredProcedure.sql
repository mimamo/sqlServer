USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineID_LineN]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdLSDet_PONbr_LineID_LineN]
	@parm1 varchar( 10 ),
	@parm2min int, @parm2max int,
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM PurOrdLSDet
	WHERE PONbr LIKE @parm1
	   AND LineID BETWEEN @parm2min AND @parm2max
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY PONbr,
	   LineID,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
