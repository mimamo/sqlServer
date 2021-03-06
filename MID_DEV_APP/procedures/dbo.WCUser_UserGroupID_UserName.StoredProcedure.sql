USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WCUser_UserGroupID_UserName]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WCUser_UserGroupID_UserName]
	@parm1 varchar( 40 ),
	@parm2 varchar(60)
AS
	SELECT *
	FROM WCUser
	WHERE UserName LIKE @parm2
	and UserGroupID LIKE @parm1
	ORDER BY UserName, UserGroupID
GO
