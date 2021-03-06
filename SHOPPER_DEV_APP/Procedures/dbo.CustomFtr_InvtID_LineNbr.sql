USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_InvtID_LineNbr]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustomFtr_InvtID_LineNbr]
	@parm1 varchar( 30 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM CustomFtr
	WHERE InvtID LIKE @parm1
	   AND LineNbr BETWEEN @parm2min AND @parm2max
	ORDER BY InvtID,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
