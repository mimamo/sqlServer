USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_ScreenId]    Script Date: 12/21/2015 15:49:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_ScreenId]
	@parm1 varchar( 7 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE ScreenId LIKE @parm1
	ORDER BY ScreenId
GO
