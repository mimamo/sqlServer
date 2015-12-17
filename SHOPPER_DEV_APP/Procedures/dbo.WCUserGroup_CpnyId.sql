USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WCUserGroup_CpnyId]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WCUserGroup_CpnyId]
	@parm1 varchar( 10 ),
	@parm2 varchar(15)
AS
	SELECT *
	FROM WCUserGroup
	WHERE CpnyId LIKE @parm1
	AND  UserGroupID LIKE @parm2
	ORDER BY UserGroupID
GO
