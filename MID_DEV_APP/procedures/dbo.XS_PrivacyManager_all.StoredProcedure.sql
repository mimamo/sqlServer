USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyManager_all]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyManager_all]
	@parm1 varchar( 47 ),
	@parm2 varchar( 7 )
AS
	SELECT *
	FROM XS_PrivacyManager
	WHERE UserID LIKE @parm1
	   AND ScreenID LIKE @parm2
	ORDER BY UserID,
	   ScreenID
GO
