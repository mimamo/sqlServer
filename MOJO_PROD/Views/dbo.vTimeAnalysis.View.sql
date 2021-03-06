USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTimeAnalysis]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[vTimeAnalysis]
AS

/*
|| When     Who Rel     What
|| 10/12/10 RLB 105.3.6 (73251) added for enhancement
|| 04/18/12 GHL 10.555  Added GLCompanyKey from tProject for filtering in reports
|| 05/15/12 GWG 10.556  Modified join to company for contacts with no company
|| 08/22/13 WDF 10.571  (179596) Added ProjectTypeName for grouping
|| 01/22/14 GHL 10.576  Added CurrencyID
|| 08/26/14 WDF 10.583  Added Campaign
|| 01/26/15 GHL 10.588  Added Billing Title for Abelson Taylor
*/
SELECT 
	tTimeSheet.CompanyKey, 
	tCompany.CompanyName, 
	tCompany.CustomerID,
	tCompany.CompanyKey as ClientKey,
	tProject.ProjectName,  
	tProject.ProjectNumber, 
	tProject.ProjectNumber + ' \ ' + tProject.ProjectName AS ProjectFullName,
	tProject.ProjectStatusKey,
	tProject.Active,
	tProject.AccountManager,
	tProjectType.ProjectTypeName,
	tCampaign.CampaignID,
	tCampaign.CampaignName,
	tCampaign.CampaignID + ' \ ' + tCampaign.CampaignName AS CampaignFullName,
	tUserAM.FirstName + ' ' + tUserAM.LastName AS AccountManagerName,
	tUser.FirstName + ' ' + tUser.LastName AS UserName, 
	tDepartment.DepartmentName,
	tUser.DepartmentKey,
	tOffice.OfficeName,
	tUser.OfficeKey,
	tTask.TaskID, 
	tService.ServiceCode, 
	tTime.RateLevel,
	tTime.UserKey,
	Case tTime.RateLevel 
		When 1 then ISNULL(tService.Description1, tService.Description)
		When 2 then ISNULL(tService.Description2, tService.Description)
		When 3 then ISNULL(tService.Description3, tService.Description)
		When 4 then ISNULL(tService.Description4, tService.Description)
		When 5 then ISNULL(tService.Description5, tService.Description)
		Else tService.Description
	END as [ServiceDescription],
	tTime.WorkDate, 
	DATEPART(Year, tTime.WorkDate) AS WorkYear,
	DATENAME(Month, tTime.WorkDate) AS WorkMonth,
	MONTH(tTime.WorkDate) as WorkMonthNumber,
	tTime.ActualHours, 
	CASE WHEN (tProject.NonBillable = 0) AND tTime.ActualRate > 0 THEN tTime.ActualHours
		ELSE 0 END AS ActualBillableHours,
	CASE WHEN (tProject.NonBillable = 0) AND tTime.ActualRate > 0 AND tTime.WriteOff = 0 THEN tTime.ActualHours
		ELSE 0 END AS ActualBillableHoursNoWriteOffs,
	CASE WHEN (tProject.NonBillable = 0) AND tTime.ActualRate > 0 AND tTime.WriteOff = 1 THEN tTime.ActualHours
	    ELSE 0 END AS ActualBillableHoursWrittenOff,
	CASE WHEN tProject.NonBillable = 1 OR tTime.ProjectKey IS NULL OR tTime.ActualRate = 0 
		THEN tTime.ActualHours ELSE 0 END AS ActualNonBillableHours,
	CASE WHEN (tProject.NonBillable = 0 OR tProject.NonBillable IS NULL) AND tTime.ActualRate > 0 
		THEN ROUND(tTime.ActualHours * tTime.ActualRate, 2)
		ELSE 0 END AS ActualBillableAmount,
	tTime.ActualRate, 
	ISNULL(tTime.CostRate, 0) as CostRate,
	ROUND(ISNULL(tTime.CostRate, 0) * ISNULL(tTime.ActualHours, 0), 2) AS ActualTotalCost,
	tClientDivision.ClientDivisionKey,
	ISNULL(tClientDivision.DivisionName, ' No Division') as DivisionName,
	tClientProduct.ClientProductKey,
	ISNULL(tClientProduct.ProductName, ' No Product') as ProductName,
	tProject.GLCompanyKey,
	tTime.CurrencyID,
	tTitle.TitleName,
	tTitle.TitleID
FROM 
	tTimeSheet (nolock)
	INNER JOIN tTime (nolock) ON tTimeSheet.TimeSheetKey = tTime.TimeSheetKey 
	INNER JOIN tUser (nolock) ON tTime.UserKey = tUser.UserKey 
	LEFT OUTER JOIN tCompany tCompany1 (nolock) ON tUser.CompanyKey = tCompany1.CompanyKey 
	LEFT OUTER JOIN tDepartment (nolock) ON tUser.DepartmentKey = tDepartment.DepartmentKey
	LEFT OUTER JOIN tOffice (nolock) ON tUser.OfficeKey = tOffice.OfficeKey 
	LEFT OUTER JOIN tService (nolock) ON tTime.ServiceKey = tService.ServiceKey  
	LEFT OUTER JOIN tProject (nolock)  ON tTime.ProjectKey = tProject.ProjectKey 
	LEFT OUTER JOIN tCampaign (nolock) on tProject.CampaignKey = tCampaign.CampaignKey 
	LEFT OUTER JOIN tProjectType (nolock) on tProjectType.ProjectTypeKey = tProject.ProjectTypeKey
	LEFT OUTER JOIN tCompany (nolock) ON tProject.ClientKey = tCompany.CompanyKey
	LEFT OUTER JOIN tUser tUserAM (nolock) ON tProject.AccountManager = tUserAM.UserKey
	LEFT OUTER JOIN tTask (nolock) ON tTime.TaskKey = tTask.TaskKey
	LEFT OUTER JOIN tClientDivision (nolock) on tProject.ClientDivisionKey = tClientDivision.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct (nolock) on tProject.ClientProductKey = tClientProduct.ClientProductKey
	LEFT OUTER JOIN tTitle (nolock) on tTime.TitleKey = tTitle.TitleKey
GO
