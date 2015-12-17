USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RcptAddlCost_all]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RcptAddlCost_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM RcptAddlCost
	WHERE RcptNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	ORDER BY RcptNbr,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
