USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_Log_Prog]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_Log_Prog]
	@parm1 varchar( 8 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE Log_Prog LIKE @parm1
	ORDER BY Log_Prog
GO
