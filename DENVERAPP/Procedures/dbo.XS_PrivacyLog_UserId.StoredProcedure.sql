USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_UserId]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_UserId]
	@parm1 varchar( 47 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE UserId LIKE @parm1
	ORDER BY UserId
GO
