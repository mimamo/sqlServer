USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGet]
	@ReportKey int

AS --Encrypt

/*
|| When     Who Rel     What

*/


		
		SELECT	r.*, u.UserName
		FROM tReport r (NOLOCK)
		LEFT OUTER JOIN vUserName u (NOLOCK) on r.UserKey = u.UserKey
		WHERE
			r.ReportKey = @ReportKey or r.DefaultReportKey = @ReportKey

	RETURN 1
GO
