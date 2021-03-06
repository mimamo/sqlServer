USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_Log_Date_Log_Tim]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_Log_Date_Log_Tim]
	@parm1min smalldatetime, @parm1max smalldatetime,
	@parm2 varchar( 6 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE Log_Date BETWEEN @parm1min AND @parm1max
	   AND Log_Time LIKE @parm2
	ORDER BY Log_Date,
	   Log_Time
GO
