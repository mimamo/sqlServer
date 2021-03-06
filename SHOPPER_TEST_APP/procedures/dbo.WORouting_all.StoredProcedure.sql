USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WORouting_all]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORouting_all]
	@parm1 varchar( 16 ),
	@parm2 varchar( 32 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM WORouting
	WHERE WONbr LIKE @parm1
	   AND Task LIKE @parm2
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY WONbr,
	   Task,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
