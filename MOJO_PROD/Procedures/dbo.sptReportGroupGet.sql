USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGroupGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGroupGet]
	@ReportGroupKey int

AS --Encrypt

		SELECT *
		FROM tReportGroup (NOLOCK) 
		WHERE
			ReportGroupKey = @ReportGroupKey

	RETURN 1
GO
