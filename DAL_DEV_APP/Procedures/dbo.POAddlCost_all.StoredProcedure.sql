USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAddlCost_all]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POAddlCost_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM POAddlCost
	WHERE PONbr LIKE @parm1
	   AND LineRef LIKE @parm2
	ORDER BY PONbr,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
