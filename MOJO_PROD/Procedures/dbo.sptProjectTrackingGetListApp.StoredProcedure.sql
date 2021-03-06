USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTrackingGetListApp]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTrackingGetListApp]
 (  
 @CompanyKey int  
 ,@UserKey int  
 ,@ProjectStatusKey int   -- -1 All Active Projects or valid ProjectStatusKey   
 ,@ProjectBillingStatusKey int -- -1 All Billing Status or valid Billing Status  
 ,@BudgetWarning int = 0
 ,@CheckAssignment tinyint = 1
 ,@RestrictToGLCompany tinyint = 0
 ,@GLCompanyKey int = null
 )  
AS -- Encrypt  
  
/*
|| 12/17/13 MAS 10.5.7.5	Copied sptProjectTrackingGetList for the NEW APP - commented out CF until we know how we want to handle things
|| 09/03/14 MAS 10.5.8.3	Changed Projects.Production.MyProjects to projects.production.myProjects
|| 12/11/14 WDF 10.5.8.7	Added Description
*/  
 
 
SELECT	p.ProjectKey  
		,ISNULL(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,'') AS ProjectFullName  
		,CASE ISNULL(c.CustomerID,'')
			WHEN '' THEN ISNULL(ISNULL(c.CompanyName,''), '')
			ELSE 
				CASE ISNULL(c.CompanyName,'')
					WHEN '' THEN ISNULL(c.CustomerID,'')
					ELSE c.CustomerID + ' - ' + c.CompanyName
				END
			END AS CustomerFullName 	
		,ISNULL(ps.ProjectStatus, '') AS ProjectStatus
		,ISNULL(pbs.ProjectBillingStatus, '') AS ProjectBillingStatus
		,ISNULL(p.PercComp, 0) as ProjectPercComp
		,ISNULL(ca.CampaignName, '') AS CampaignName
		,LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,''))) AS PrimaryContact
		,ISNULL(u.Phone1, ISNULL(u.Phone2,'')) AS PrimaryContactPhone
		,u.Phone1 
		,u.Email 
		,ISNULL(c.CompanyName, '') AS CompanyName
		,c.Phone
		,ISNULL(p.TaskStatus, 1) AS ProjectTaskStatus
		,(	SELECT	COUNT(*)   
			FROM	tTask t (NOLOCK) INNER JOIN tTaskUser tu (NOLOCK) ON tu.TaskKey = t.TaskKey   
			WHERE	t.ProjectKey = p.ProjectKey  
					AND tu.UserKey = @UserKey  
					AND (t.PercCompSeparate = 1 and tu.ActComplete IS NULL Or  t.PercCompSeparate = 0 and t.ActComplete IS NULL)
				        
			) AS OpenAssignments

		-- Budgeted data  
		,p.EstHours AS OriginalBudgetHours -- [Estimate Hours]  
		,p.EstLabor AS  OriginalBudgetLaborGross -- [Estimate Labor]  
		,p.BudgetExpenses AS OriginalBudgetExpenseNet -- [Estimate Expense Net]  
		,p.EstExpenses AS OriginalBudgetExpenseGross -- [Estimate Expense Gross]  
		,p.StatusNotes AS ProjectStatusNote  
		,p.DetailedNotes AS ProjectStatusDescription  
		,p.StartDate AS ProjectStartDate 
		,p.CompleteDate AS ProjectDueDate  
		,p.CreatedDate AS CreatedDate  
		,p.ProjectNumber
		,p.ProjectName
		,p.ProjectColor
		,p.Description
		,LTRIM(RTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName,''))) as AccountManagerName
		,p.ClientProjectNumber
		--- ,cf.*
FROM	tProject p (NOLOCK)  
		INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey 
		LEFT  JOIN tCampaign ca (nolock)  ON p.CampaignKey = ca.CampaignKey   
		LEFT  JOIN tCompany c (nolock)   ON p.ClientKey = c.CompanyKey  
		LEFT  JOIN tUser u (nolock)   ON p.BillingContact = u.UserKey  
		LEFT  JOIN tUser am (nolock)   ON p.AccountManager = am.UserKey  
		LEFT  JOIN tProjectBillingStatus pbs (nolock) ON p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
		--- LEFT JOIN #tCustomFields cf (nolock) ON p.CustomFieldKey = cf.CustomFieldKey
WHERE	p.CompanyKey = @CompanyKey  
		AND p.Deleted = 0  
		AND ( 
				(@ProjectStatusKey = -1 AND p.Active = 1)  
				OR  
				(p.ProjectStatusKey = @ProjectStatusKey)  
			)  
		AND (@ProjectBillingStatusKey = -1 OR p.ProjectBillingStatusKey = @ProjectBillingStatusKey)
		AND (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)
		AND (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 OR isnull(p.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)))
		AND p.ProjectKey NOT IN (Select ActionKey From tAppFavorite (nolock) Where UserKey = @UserKey AND ActionID = 'projects.production.myProjects')

 RETURN 1
GO
