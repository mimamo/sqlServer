USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectDetails]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProjectDetails]
AS

  /*
  || When     Who Rel		What
  || 01/24/14 QMD 10.5.7.6  Created detail view for wjapp
  */

SELECT 
	isnull(c.CustomerID + ' \ ','') + ISNULL(p.ProjectNumber + ' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject,
	isnull(c.CustomerID + ' - ','') +  + isnull(c.CompanyName,'') as CustomerFullName,
	isnull(rtrim(p.ProjectNumber)+' - ','') + isnull(p.ProjectName,'') as ProjectFullName,
	c.CompanyName,
	c.CustomerID,
	
	ps.ProjectStatus, 
	ps.DisplayOrder, 
	u.FirstName + ' ' + u.LastName AS AccountManagerName,
	LEFT(ISNULL(u.FirstName, ''), 1) + LEFT(ISNULL(u.MiddleName, ''), 1) + LEFT(ISNULL(u.LastName, ''), 1) AS AccountManagerInitials, 
	pt.ProjectTypeName,
	ca.CampaignName,
	ISNULL(p.TaskStatus, 1) as ProjectTaskStatus,	
	p.*,
	LEFT(ISNULL(u2.FirstName, ''), 1) + ' ' + LEFT(ISNULL(u2.LastName, ''), 1) AS PrimaryContactName, 
	u2.Email AS PrimaryContactEmail,
	u2.Phone1 AS PrimaryContactPhone,
	u2.Phone2 AS PrimaryContactPhone2,
	u2.Cell AS PrimaryContactCell
		
FROM 
	tProject p (nolock) 
	INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
    LEFT OUTER JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey 
	LEFT OUTER JOIN tCampaign ca (nolock) ON p.CampaignKey = ca.CampaignKey 
	LEFT OUTER JOIN tUser u (nolock) ON p.AccountManager = u.UserKey 
	LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser u2 on p.BillingContact = u2.UserKey
Where
	p.Deleted = 0
GO
