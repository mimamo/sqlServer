USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTimeDetail]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTimeDetail]
AS

/*
  || When     Who Rel     What
  || 08/22/07 GHL 8.5     Added TimeSheetKey for drill downs
  || 12/01/08 GHL 10.013  Added NOLOCKS
  || 10/10/12 MFT 10.561  (156524) Changed the Comments field to BilledComment (was Comments) with blank override
  || 08/05/14 MFT 10.582  (224681) Trimed the Comments so a space will override the tTime.Comments, but not hold space on a report
  || 01/27/15 WDF 10.588  (Abelson Taylor) Added Division and Product
  || 01/28/15 GHL 10.588  Added title info for Abelson
*/

SELECT
	tTime.TimeKey, 
	tTimeSheet.CompanyKey, 
	tTimeSheet.TimeSheetKey, 
	tUser.FirstName, 
	tUser.LastName, 
	tUser.HourlyRate AS UserRate,
	tUser.Title AS UserTitle, 
	tCompany.CompanyName AS ClientName, 
	tProject.ProjectName, 
	LEFT(tProject.ProjectName, 25) AS ProjectShortName, 
	tProject.ProjectNumber, 
	tTask.TaskID, 
	tTask.TaskID + ' - ' + tTask.TaskName AS FullTaskName, 
	tService.ServiceCode, 
	Case tTime.RateLevel 
		When 1 then ISNULL(tService.Description1, tService.Description)
		When 2 then ISNULL(tService.Description2, tService.Description)
		When 3 then ISNULL(tService.Description3, tService.Description)
		When 4 then ISNULL(tService.Description4, tService.Description)
		When 5 then ISNULL(tService.Description5, tService.Description)
		Else tService.Description
	END as ServiceDescription, 
	Case tTime.RateLevel 
		When 1 then ISNULL(bService.Description1, bService.Description)
		When 2 then ISNULL(bService.Description2, bService.Description)
		When 3 then ISNULL(bService.Description3, bService.Description)
		When 4 then ISNULL(bService.Description4, bService.Description)
		When 5 then ISNULL(bService.Description5, bService.Description)
		Else bService.Description
	END as BilledServiceDescription, 
	tTime.WorkDate, 
	tTime.ActualHours, 
	tTime.ActualRate, 
	ROUND(tTime.ActualHours * tTime.ActualRate, 2) AS ActualTotal, 
	tTime.BilledHours, tTime.BilledRate, 
	ROUND(tTime.BilledHours * tTime.BilledRate, 2) AS BilledTotal,
	tTime.InvoiceLineKey,
	LTRIM(ISNULL(tTime.BilledComment, tTime.Comments)) AS Comments,
	tTitle.TitleName,
	tTitle.TitleID,
	cd.DivisionID,
    cd.DivisionName,
    cp.ProductID,
    cp.ProductName
FROM tTimeSheet (NOLOCK)
INNER JOIN tTime (NOLOCK) ON  tTimeSheet.TimeSheetKey = tTime.TimeSheetKey 
INNER JOIN tUser (NOLOCK) ON tTime.UserKey = tUser.UserKey 
LEFT OUTER JOIN tService (NOLOCK) ON tTime.ServiceKey = tService.ServiceKey 
LEFT OUTER JOIN tService bService (NOLOCK) ON tTime.BilledService = bService.ServiceKey 
LEFT OUTER JOIN tProject (NOLOCK) ON tTime.ProjectKey = tProject.ProjectKey 
LEFT OUTER JOIN tCompany (NOLOCK) ON tProject.ClientKey = tCompany.CompanyKey 
LEFT OUTER JOIN tTask (NOLOCK) ON tTime.TaskKey = tTask.TaskKey
LEFT OUTER JOIN tTitle (NOLOCK) ON tTime.TitleKey = tTitle.TitleKey
LEFT OUTER JOIN tClientDivision cd (nolock) on tProject.ClientDivisionKey = cd.ClientDivisionKey
LEFT OUTER JOIN tClientProduct  cp (nolock) on tProject.ClientProductKey  = cp.ClientProductKey
GO
