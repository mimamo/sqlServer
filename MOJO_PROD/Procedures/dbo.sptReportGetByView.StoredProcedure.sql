USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetByView]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetByView]
	@ViewKey int,
	@UserKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 02/13/08  RTC 1.0.0.0  Added ApplicationVersion checking
|| 04/16/08  GHL 1.0.0.0  Added ISNULL() to ApplicationVersion to handle CMP+WMJ
|| 01/16/09  RTC 10.0.1.6 Added CompanyKey to tReport get where clause
*/

	DECLARE	@SecurityGroupKey int
	DECLARE @CompanyKey int
	
	SELECT	@CompanyKey = CompanyKey
		   ,@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (NOLOCK) 
	WHERE	UserKey = @UserKey

	SELECT	r.*
	FROM	tReport r (NOLOCK) 
	WHERE	r.CompanyKey = @CompanyKey
	and ViewKey = @ViewKey 
	and ISNULL(ApplicationVersion, 1) = 1
	and ((r.Private = 0 AND r.ReportKey IN 
				(SELECT rsg.ReportKey 
				FROM   tRptSecurityGroup rsg (NOLOCK)
				WHERE  rsg.SecurityGroupKey = @SecurityGroupKey))
			OR
			(r.UserKey = @UserKey))
GO
