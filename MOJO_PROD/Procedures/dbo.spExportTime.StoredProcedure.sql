USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spExportTime]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spExportTime]
 (
  @CompanyKey int,
  @Status int,
  @StartDate smalldatetime,
  @EndDate smalldatetime,
  @IncludeDownloaded tinyint,
  @MarkDownloaded tinyint
 )
AS --Encrypt
IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()
 
SELECT 
 tUser.SystemID AS EmpID, 
 tTime.TimeKey AS TicketNumber, 
    tTime.WorkDate, 
    tService.ServiceCode, 
    tCompany.CustomerID, 
    tTime.ActualHours, 
    tTime.ActualRate, 
    tService.Description, 
    tTime.Comments, 
    tTime.Downloaded
FROM tTimeSheet (NOLOCK) INNER JOIN tTime (NOLOCK) INNER JOIN
    tUser (NOLOCK) ON tTime.UserKey = tUser.UserKey INNER JOIN
    tService (NOLOCK) ON tTime.ServiceKey = tService.ServiceKey ON 
    tTimeSheet.TimeSheetKey = tTime.TimeSheetKey LEFT OUTER JOIN
    tCompany (NOLOCK) RIGHT OUTER JOIN
    tProject (NOLOCK) ON tCompany.CompanyKey = tProject.ClientKey ON 
    tTime.ProjectKey = tProject.ProjectKey
WHERE 
 tTimeSheet.Status >= @Status AND
 tUser.CompanyKey = @CompanyKey AND 
 tTime.WorkDate >= @StartDate AND
 tTime.WorkDate <= @EndDate AND
    tTime.Downloaded <= @IncludeDownloaded
GO
