USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyLog_ReportNbr_Report]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_PrivacyLog_ReportNbr_Report]
	@parm1 varchar( 5 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM XS_PrivacyLog
	WHERE ReportNbr LIKE @parm1
	   AND ReportFormat LIKE @parm2
	ORDER BY ReportNbr,
	   ReportFormat
GO
