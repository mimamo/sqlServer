USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportDelete]
	@ReportKey int

AS --Encrypt

	DELETE
	FROM tRptSecurityGroup
	WHERE
		ReportKey = @ReportKey 

	DELETE
	FROM tReport
	WHERE
		ReportKey = @ReportKey 

	RETURN 1
GO
