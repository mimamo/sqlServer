USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetDashDetails]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec sptLeadGetDashDetails 'byStage', 0, 16, 100, 0
exec sptLeadGetDashDetails 'byStage', 62, 16, 100, 1
exec sptLeadGetDashDetails 'byLevel', 0, 16, 100, 0
exec sptLeadGetDashDetails 'byLevel', 3, 16, 100, 1
exec sptLeadGetDashDetails 'byNeglected', 1, 16, 100, 0
exec sptLeadGetDashDetails 'byNeglected', 2, 16, 100, 1

Select SaleAmount, Subject, CMFolderKey, LeadStageKey, LeadStatusKey, WWPCurrentLevel, DateUpdated, AccountManagerKey from tLead Where CompanyKey = 100 and AccountManagerKey = 16 and LeadStageKey = 62

Update tLead set LeadStatusKey = 7 Where LeadStatusKey IS NULL and CompanyKey = 100
*/
CREATE Procedure [dbo].[sptLeadGetDashDetails]
(
	@Type varchar(50),
	@Key int,
	@UserKey int,
	@CompanyKey int,
	@Detailed tinyint = 1
)

as


Declare @UseFolders tinyint, @RestrictToGLCompany int, @SecurityGroupKey int, @Admin tinyint

Select @SecurityGroupKey = SecurityGroupKey, @Admin = ISNULL(Administrator, 0) from tUser (NOLOCK) Where UserKey = @UserKey

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0), @UseFolders = ISNULL(UseLeadFolders, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey



--Select @RestrictToGLCompany, @UseFolders

Create table #keys (FolderKey int)

Insert #keys Values ( 0 )

INSERT	#keys (FolderKey)
		SELECT 	f.CMFolderKey
		FROM	tCMFolder f (nolock)
		INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
		WHERE	f.CompanyKey = @CompanyKey
		AND		f.Entity = 'tLead'
		AND		f.UserKey = 0
		AND		((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
				OR
				(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
		AND		(fs.CanView = 1)

--select * from #keys

if @Type = 'byStage'
BEGIN
	if @Detailed = 1
	BEGIN
		Select l.* 
			,st.LeadStatusName
			,stg.LeadStageName
			,c.CompanyName
			,cu.UserName as ContactName
			,a.Subject as ActivitySubject
			,f.FolderName
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		INNER JOIN tCompany c (NOLOCK) on l.ContactCompanyKey = c.CompanyKey
		LEFT OUTER JOIN vUserName cu (NOLOCK) on l.ContactKey = cu.UserKey
		LEFT OUTER JOIN tActivity a (NOLOCK) on l.NextActivityKey = a.ActivityKey
		LEFT OUTER JOIN tCMFolder f (NOLOCK) on l.CMFolderKey = f.CMFolderKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.CompanyKey = @CompanyKey
			and l.LeadStageKey = @Key
			AND st.Active = 1
			AND (@UseFolders = 0 OR ISNULL(l.CMFolderKey, 0) in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
		
	END
	ELSE
	BEGIN
		Select stg.LeadStageKey, stg.LeadStageName, Sum(SaleAmount) as Amount
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.CompanyKey = @CompanyKey
			AND st.Active = 1
			and stg.DisplayOnDashboard = 1
			AND (@UseFolders = 0 OR ISNULL(l.CMFolderKey, 0) in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
		Group By stg.DisplayOrder, stg.LeadStageKey, stg.LeadStageName
		Order By stg.DisplayOrder, stg.LeadStageName
	END
END

if @Type = 'byLevel'
BEGIN
	if @Detailed = 1
	BEGIN
		Select l.* 
			,st.LeadStatusName
			,stg.LeadStageName
			,c.CompanyName
			,cu.UserName as ContactName
			,a.Subject as ActivitySubject
			,f.FolderName
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		INNER JOIN tCompany c (NOLOCK) on l.ContactCompanyKey = c.CompanyKey
		LEFT OUTER JOIN vUserName cu (NOLOCK) on l.ContactKey = cu.UserKey
		LEFT OUTER JOIN tActivity a (NOLOCK) on l.NextActivityKey = a.ActivityKey
		LEFT OUTER JOIN tCMFolder f (NOLOCK) on l.CMFolderKey = f.CMFolderKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.CompanyKey = @CompanyKey
			and ISNULL(l.WWPCurrentLevel, 1) = @Key
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
	END
	ELSE
	BEGIN
		Select ISNULL(l.WWPCurrentLevel, 1) as Level, Sum(SaleAmount) as Amount 

		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.CompanyKey = @CompanyKey
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
		Group By l.WWPCurrentLevel
		Order By l.WWPCurrentLevel
	END
END


if @Type = 'byNeglected'
BEGIN

	DECLARE @LastWeek DATETIME, @LastMonth DATETIME, @Older DATETIME, @CurrentStart DATETIME, @CurrentDate DATETIME, @Start DATETIME, @End DATETIME
	DECLARE @Last7Amt money, @LastMonthAmt money, @OlderAmt money
	
	SELECT @CurrentDate = Cast(Cast(MONTH(GETDATE()) as varchar) + '/' + Cast(DAY(GETDATE()) as varchar) + '/' + Cast(YEAR(GETDATE()) as varchar) as smalldatetime)
	SELECT @CurrentStart = DATEADD(DAY, -1, @CurrentDate)
	SELECT @LastWeek = DATEADD(DAY, -7, @CurrentDate)
	SELECT @LastMonth = DATEADD(MONTH, -1, @CurrentDate)
	SELECT @Older = DATEADD(YEAR, -10, @CurrentDate)
	if @Detailed = 1
	BEGIN
		if @Key = 1
		BEGIN
			Select @Start = @LastWeek, @End = @CurrentStart
		END
		if @Key = 2
		BEGIN
			Select @Start = @LastMonth, @End = @LastWeek
		END
		if @Key = 3
		BEGIN
			Select @Start = @Older, @End = @LastMonth
		END

		
		Select l.* 
			,st.LeadStatusName
			,stg.LeadStageName
			,c.CompanyName
			,cu.UserName as ContactName
			,a.Subject as ActivitySubject
			,f.FolderName
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		INNER JOIN tCompany c (NOLOCK) on l.ContactCompanyKey = c.CompanyKey
		LEFT OUTER JOIN vUserName cu (NOLOCK) on l.ContactKey = cu.UserKey
		LEFT OUTER JOIN tActivity a (NOLOCK) on l.NextActivityKey = a.ActivityKey
		LEFT OUTER JOIN tCMFolder f (NOLOCK) on l.CMFolderKey = f.CMFolderKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.DateUpdated >= @Start
			AND l.DateUpdated < @End
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
			ORDER BY l.DateUpdated 
	END
	ELSE
	BEGIN
		Select @Last7Amt = Count(*)
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.DateUpdated >= @LastWeek
			AND l.DateUpdated < @CurrentStart
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
			
		Select @LastMonthAmt = Count(*)
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.DateUpdated >= @LastMonth
			AND l.DateUpdated < @LastWeek
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
			
		Select @OlderAmt = Count(*)
		FROM tLead l (NOLOCK) 
		INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
		INNER JOIN tLeadStage stg (NOLOCK) ON l.LeadStageKey = stg.LeadStageKey
		WHERE 
			l.AccountManagerKey = @UserKey
			AND l.DateUpdated >= @Older
			AND l.DateUpdated < @LastMonth
			AND st.Active = 1
			AND (@UseFolders = 0 OR l.CMFolderKey in (Select FolderKey from #keys))
			AND (@RestrictToGLCompany = 0 OR l.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) ) 
			
		Select @Last7Amt as LastWeek, @LastMonthAmt as LastMonth, @OlderAmt as Older
		
	END
END
GO
