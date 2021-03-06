USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Time]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vExport_Time]
AS
SELECT 
	tUser.SystemID, 
	tTimeSheet.Status, 
	tTime.WorkDate, 
	tTime.TimeSheetKey, 
	tService.ServiceCode, 
	tTime.ActualHours, 
	tTime.ActualRate, 
	tTime.CostRate, 
	tTime.Downloaded, 
	tTime.Comments, 
	tUser.CompanyKey, 
	tCompany.CustomerID

FROM 
	tProject (NOLOCK) LEFT OUTER JOIN tCompany (NOLOCK) ON 
	tProject.ClientKey = tCompany.CompanyKey RIGHT OUTER JOIN
	tTime (NOLOCK) INNER JOIN tTimeSheet (NOLOCK) ON 
	tTime.TimeSheetKey = tTimeSheet.TimeSheetKey INNER JOIN
	tUser (NOLOCK) ON 
	tTime.UserKey = tUser.UserKey LEFT OUTER JOIN
	tService (NOLOCK) ON 
	tTime.ServiceKey = tService.ServiceKey ON 
	tProject.ProjectKey = tTime.ProjectKey

WHERE 
	tTimeSheet.Status = 4
GO
