USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetList]
	(
		@BillingKey int
	)
AS
  /*
  || When     Who Rel    What
  || 08/26/13 WDF 10.571 (182241) Added CampaignID
  */

Select
	 b.*
	,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
	,cp.CampaignID
	,Case b.Status
		When 1 then 'In Review'
		When 2 then 'Sent for Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved'
		When 5 then 'Billed' end as WorksheetStatus
	,u.FirstName + ' ' + u.LastName as AccountManager
From
	tBilling b (NOLOCK) 
	left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
    left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
Where
	b.ParentWorksheetKey = @BillingKey
Order By b.Status, p.ProjectNumber
GO
