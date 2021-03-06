USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTimeSheet]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vTimeSheet]
AS

/*
  || When     Who Rel     What
  || 03/22/10 RLB 10.520  (77260) Added Transferred Out
  || 06/20/13 WDF 10.569  (181720) Add Campaign ID/Name
  || 09/12/14 GHL 10.584  (229486) Added Start/End Times
*/


SELECT 
	tTimeSheet.TimeSheetKey, 
	tTimeSheet.StartDate, 
	tTimeSheet.EndDate, 
	tTimeSheet.Status, 
	tTimeSheet.ApprovalComments, 
	tTimeSheet.DateCreated, 
	tTimeSheet.DateSubmitted, 
	tTimeSheet.DateApproved, 
	tUser.FirstName, 
	tUser.LastName, 
	tUser.SystemID,
	tUser1.FirstName AS ApprFirstName, 
	tUser1.LastName AS ApprLastName, 
	tTime.ProjectKey, 
	LEFT(tProject.ProjectName, 25) AS ProjectShortName, 
	tCampaign.CampaignID,
	tCampaign.CampaignName,
	ISNULL(tCampaign.CampaignID, '') + '-' + ISNULL(tCampaign.CampaignName, '') AS CampaignFullName,
	tProject.ProjectName,
	tProject.ProjectNumber, 
	tTask.TaskID, 
	tTask.TaskName, 
	tService.ServiceCode, 
	Case tTime.RateLevel 
		When 1 then ISNULL(tService.Description1, tService.Description)
		When 2 then ISNULL(tService.Description2, tService.Description)
		When 3 then ISNULL(tService.Description3, tService.Description)
		When 4 then ISNULL(tService.Description4, tService.Description)
		When 5 then ISNULL(tService.Description5, tService.Description)
		Else tService.Description
	END as ServiceDescription,
	tTime.WorkDate, 
	tTime.ActualHours, 
	tTime.ActualRate, 
	tTime.RateLevel,
	ROUND(tTime.ActualHours * tTime.ActualRate, 2) AS TotalAmount,
	tTime.StartTime,
	tTime.EndTime, 
	tTime.Comments, 
	ISNULL(tCompany1.CompanyName, tCompany.CompanyName) AS CompanyName, 
	ISNULL(a_dc1.Address1, a_dc.Address1) AS Address1, 
	ISNULL(a_dc1.Address2, a_dc.Address2) AS Address2, 
	ISNULL(a_dc1.Address3, a_dc.Address3) AS Address3, 
	ISNULL(a_dc1.City, a_dc.City) AS City, 
	ISNULL(a_dc1.State, a_dc.State) AS State, 
	ISNULL(a_dc1.PostalCode, a_dc.PostalCode) AS PostalCode,
	Case When tTime.TransferToKey IS NULL Then 0 else 1 end as TransferredOut
FROM tTime 
INNER JOIN tTimeSheet (nolock) ON 
	tTime.TimeSheetKey = tTimeSheet.TimeSheetKey 
INNER JOIN tUser (nolock) ON 
    	tTimeSheet.UserKey = tUser.UserKey 
LEFT OUTER JOIN tCompany (nolock) ON 
    	tUser.CompanyKey = tCompany.CompanyKey 
LEFT OUTER JOIN tCompany tCompany1 (nolock) ON 
    	tUser.OwnerCompanyKey = tCompany1.CompanyKey 
LEFT OUTER JOIN tService (nolock) ON 
    	tTime.ServiceKey = tService.ServiceKey 
LEFT OUTER JOIN tUser tUser1 (nolock) ON 
    	tUser.TimeApprover = tUser1.UserKey 
LEFT OUTER JOIN tProject (nolock) ON 
    	tTime.ProjectKey = tProject.ProjectKey 
LEFT OUTER JOIN tCampaign (nolock) ON 
        tProject.CampaignKey = tCampaign.CampaignKey
LEFT OUTER JOIN tTask (nolock) ON 
    	tTime.TaskKey = tTask.TaskKey
LEFT OUTER JOIN tAddress a_dc (nolock) ON tCompany.DefaultAddressKey = a_dc.AddressKey
LEFT OUTER JOIN tAddress a_dc1 (nolock) ON tCompany1.DefaultAddressKey = a_dc1.AddressKey
GO
