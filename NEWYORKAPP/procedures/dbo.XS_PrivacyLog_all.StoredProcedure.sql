USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_all]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE LogId LIKE @parm1
	ORDER BY LogId
GO
