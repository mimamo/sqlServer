USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_all]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4min smallint, @parm4max smallint,
	@parm5 varchar( 30 )
AS
	SELECT *
	FROM Component
	WHERE KitID LIKE @parm1
	   AND KitSiteID LIKE @parm2
	   AND KitStatus LIKE @parm3
	   AND LineNbr BETWEEN @parm4min AND @parm4max
	   AND CmpnentID LIKE @parm5
	ORDER BY KitID,
	   KitSiteID,
	   KitStatus,
	   LineNbr,
	   CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
