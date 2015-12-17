USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ProjectTasks]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_ProjectTasks]
AS

/*
|| When     Who Rel   What
|| 04/26/07 GHL 8.4   Added task description for project assignments report          
|| 09/12/07 GHL 8.436 Added Schedule Task flag to hide unscheduled tasks on some reports
|| 10/11/07 CRG 8.5   Added GLCompany, Class, and Office
|| 03/07/12 GHL 10.554 (103259) Added [Opportunity Name]
|| 04/18/12 GHL 10.555  Added p.GLCompanyKey for filtering in reports
|| 12/28/12 KMC 10.563 (141843) Added the HideFromClient column
|| 12/4/14  GWG 10.587 Added indented task name
*/

SELECT	p.CompanyKey
        ,p.GLCompanyKey
		,p.ProjectKey
		,p.ProjectStatusKey
		,p.ClientKey
		,p.AccountManager
		,p.StartDate
		,p.CompleteDate
		,p.ProjectNumber
		,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectNameNumber
		,p.Active
		,c.CustomerID
		,c.CompanyName
		,t.TaskKey
		,t.ProjectOrder as [Line Number]
		,CASE
			WHEN LEN(ISNULL(t.TaskID, '')) > 0 AND LEN(ISNULL(t.TaskName, '')) > 0 THEN
				ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '')
			WHEN LEN(ISNULL(t.TaskID, '')) > 0 THEN t.TaskID
			ELSE t.TaskName
		END AS TaskIDName
		,STUFF(t.TaskName, 1, 0, REPLICATE ( '     ' ,t.TaskLevel )) as [Indented Task Name]
		,t.SummaryTaskKey
		,CASE
			WHEN ISNULL(t.SummaryTaskKey, 0) = 0 THEN ''
			ELSE ISNULL(st.TaskID, '') + '-' + ISNULL(st.TaskName, '')
		END AS SummaryTaskIDName
		,t.ProjectOrder
		,t.PredecessorsComplete
		,t.ScheduleTask
		,tu.UserKey
		,UPPER(LEFT(ISNULL(u.FirstName, ''), 1) 
			     + LEFT(ISNULL(u.MiddleName, ''), 1)
			     + LEFT(ISNULL(u.LastName, ''), 1)) AS Initials
		,ISNULL(tu.ActStart, ISNULL(t.ActStart, t.PlanStart)) AS TaskStart
		,ISNULL(tu.ActComplete, ISNULL(t.ActComplete, t.PlanComplete)) AS TaskComplete
		,ISNULL(tu.PercComp, t.PercComp) AS PercComp
		,tu.Hours
		,t.Comments
		,t.Description
		,glc.GLCompanyID as [Company ID]
		,glc.GLCompanyName as [Company Name]
		,cl.ClassID as [Class ID]
		,cl.ClassName as [Class Name]
		,o.OfficeID as [Office ID]
		,o.OfficeName as [Office Name]
		,l.Subject as [Opportunity Name]
		,t.HideFromClient 
FROM	tTask t (NOLOCK)
INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
LEFT JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
LEFT JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
LEFT JOIN tTask st (NOLOCK) ON t.SummaryTaskKey = st.TaskKey
LEFT JOIN tClass cl (nolock) on p.ClassKey = cl.ClassKey
LEFT JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
LEFT JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
left outer join tLead l (nolock) on p.LeadKey = l.LeadKey

WHERE 	t.TaskType = 2
GO
