USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_KitID_CmpnentID_KitSite_KitStatus]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_KitID_CmpnentID_KitSite_KitStatus]
	@parm1 varchar( 30 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 1 )

AS
	SELECT *
	FROM Component
	WHERE KitID LIKE @parm1
	   AND CmpnentID LIKE @parm2
	   AND KitSiteID LIKE @parm3
	   AND KitStatus LIKE @parm4

	ORDER BY KitID,
	   CmpnentID,
	   KitSiteID,
	   KitStatus
GO
