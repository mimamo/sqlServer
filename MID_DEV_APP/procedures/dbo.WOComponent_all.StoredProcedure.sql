USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOComponent_all]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOComponent_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4min smallint, @parm4max smallint,
	@parm5 varchar( 30 )
AS
	SELECT *
	FROM Component
	WHERE KitId LIKE @parm1
	   AND KitSiteId LIKE @parm2
	   AND KitStatus LIKE @parm3
	   AND LineNbr BETWEEN @parm4min AND @parm4max
	   AND CmpnentId LIKE @parm5
	ORDER BY KitId,
	   KitSiteId,
	   KitStatus,
	   LineNbr,
	   CmpnentId
GO
