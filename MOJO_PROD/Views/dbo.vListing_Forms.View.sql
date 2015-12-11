USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Forms]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         VIEW [dbo].[vListing_Forms]
AS
SELECT     
	 f.CompanyKey 
	,f.FormDefKey
	,f.CustomFieldKey
	,f.AssignedTo [AssignedUserKey]
	,f.Author [AuthorKey]	
	,f.FormKey
	,c.CompanyKey as [ClientCompanyKey]
	,fd.FormName [Form Name]
	,fd.FormPrefix [Form Prefix] 
	,p.ProjectName [Project Name]
	,p.ProjectNumber [Project Number]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,t.TaskID as [Task ID]            
	,t.TaskName as [Task Name]
	,t.TaskID + ' - ' + t.TaskName as [Task Full Name] 
	,fd.FormPrefix + '-' + Cast(f.FormNumber as varchar) as [Form Number] 
	,u.FirstName + ' ' + u.LastName AS [Author Name]
	,CAST( CAST(MONTH(f.DateCreated) as varchar) + '/' + CAST(DAY(f.DateCreated) as varchar) + '/' + CAST(YEAR(f.DateCreated) as varchar) as smalldatetime) as [Date Created]
	,CAST( CAST(MONTH(f.DateClosed) as varchar) + '/' + CAST(DAY(f.DateClosed) as varchar) + '/' + CAST(YEAR(f.DateClosed) as varchar) as smalldatetime) as [Date Closed]
	,u2.FirstName + ' ' + u2.LastName AS [Assigned To]
	,f.Subject [Form Subject]
	,f.DueDate [Form Due Date]
	,Case f.Priority When 1 then '1-High' When 2 then '2-Medium' when 3 then '3-Low' end as [Priority] 
	,c.CompanyName as [Company Name]
    ,us.UserKey as AccessUserKey
FROM         
	tForm f (nolock) 
	INNER JOIN tFormDef fd (nolock) ON f.FormDefKey = fd.FormDefKey 
	INNER JOIN tUser u (nolock) ON f.Author = u.UserKey 
    INNER JOIN tSecurityAccess sa (nolock) on fd.FormDefKey = sa.EntityKey
    INNER JOIN tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey 
	LEFT OUTER JOIN tCompany c (nolock) ON f.ContactCompanyKey = c.CompanyKey 
	LEFT OUTER JOIN tUser u2 (nolock) ON f.AssignedTo = u2.UserKey 
	LEFT OUTER JOIN tTask t (nolock) ON f.TaskKey = t.TaskKey 
	LEFT OUTER JOIN tProject p (nolock) ON f.ProjectKey = p.ProjectKey
WHERE sa.Entity = 'tFormDef'
GO
