USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetByID]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetByID]
	@ReportID varchar(50),
	@UserKey int

AS 

/*
|| When      Who Rel      What

*/

	DECLARE	@SecurityGroupKey int
	DECLARE @CompanyKey int
	
	
	SELECT	@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
		   ,@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (NOLOCK) 
	WHERE	UserKey = @UserKey

	SELECT	r.ReportKey, r.Name, r.ReportFilter, Deleted, DefaultReportKey, Private, UserKey, 
		CASE WHEN Private = 1 AND UserKey = @UserKey THEN 1
		ELSE ISNULL((SELECT 1 FROM tRptSecurityGroup rsg (NOLOCK) WHERE  rsg.SecurityGroupKey = @SecurityGroupKey and ReportKey = r.ReportKey), 0) END as HasAccess
	FROM	tReport r (NOLOCK) 
	WHERE	r.CompanyKey = @CompanyKey
	and ReportID = @ReportID 
	and ISNULL(ApplicationVersion, 2) = 2
GO
