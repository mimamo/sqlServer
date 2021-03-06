USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvWIP_TimeGetProject]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvWIP_TimeGetProject]

	(
		@ProjectKey int,
		@OnlyUnbilled tinyint = 0
	)

AS --Encrypt


if @OnlyUnbilled = 1
SELECT 
	tTime.TimeKey, 
	tTime.UserKey,
	tTime.TaskKey,
	tTime.ServiceKey,
	tProject.ClientKey, 
	tProject.ProjectKey, 
	tProject.ProjectNumber, 
	tProject.ProjectName, 
	tUser.FirstName + ' ' + tUser.LastName AS UserName, 
	tTask.TaskID, 
	Case tTime.RateLevel 
		When 1 then ISNULL(tService.Description1, tService.Description)
		When 2 then ISNULL(tService.Description2, tService.Description)
		When 3 then ISNULL(tService.Description3, tService.Description)
		When 4 then ISNULL(tService.Description4, tService.Description)
		When 5 then ISNULL(tService.Description5, tService.Description)
		Else tService.Description
	END as Service,
	tTime.RateLevel, 
	tTimeSheet.Status, 
	tTime.WorkDate, 
	tTime.ActualHours, 
	tTime.ActualRate, 
	tTime.CostRate, 
	tTime.BilledHours, 
	tTime.BilledRate, 
	ROUND(tTime.ActualHours * tTime.ActualRate, 2) AS ActualBillableTotal,
	ROUND(tTime.ActualHours * tTime.CostRate, 2) AS ActualCostTotal,
	ROUND(tTime.BilledHours * tTime.BilledRate, 2) AS BilledTotal, 
	tTime.InvoiceLineKey, 
	tTime.WriteOff,
	tTime.WIPPostingInKey,
	tTime.WIPPostingOutKey
FROM tTime (NOLOCK) INNER JOIN
    tTimeSheet (NOLOCK) ON 
    tTime.TimeSheetKey = tTimeSheet.TimeSheetKey INNER
     JOIN
    tProject (NOLOCK) ON 
    tTime.ProjectKey = tProject.ProjectKey INNER JOIN
    tUser (NOLOCK) ON 
    tTime.UserKey = tUser.UserKey LEFT OUTER JOIN
    tService (NOLOCK) ON 
    tTime.ServiceKey = tService.ServiceKey LEFT OUTER JOIN
    tTask (NOLOCK) ON 
    tTime.TaskKey = tTask.TaskKey
	WHERE
		tTime.ProjectKey = @ProjectKey and
		tTime.InvoiceLineKey is null and 
		tTime.WriteOff <> 1
	ORDER BY
		tTime.WorkDate
else
SELECT 
	tTime.TimeKey, 
	tTime.UserKey,
	tTime.TaskKey,
	tTime.ServiceKey,
	tProject.ClientKey, 
	tProject.ProjectKey, 
	tProject.ProjectNumber, 
	tProject.ProjectName, 
	tUser.FirstName + ' ' + tUser.LastName AS UserName, 
	tTask.TaskID, 
	Case tTime.RateLevel 
		When 1 then ISNULL(tService.Description1, tService.Description)
		When 2 then ISNULL(tService.Description2, tService.Description)
		When 3 then ISNULL(tService.Description3, tService.Description)
		When 4 then ISNULL(tService.Description4, tService.Description)
		When 5 then ISNULL(tService.Description5, tService.Description)
		Else tService.Description
	END as Service,
	tTime.RateLevel, 
	tTimeSheet.Status, 
	tTime.WorkDate, 
	tTime.ActualHours, 
	tTime.ActualRate, 
	tTime.CostRate, 
	tTime.BilledHours, 
	tTime.BilledRate, 
	ROUND(tTime.ActualHours * tTime.ActualRate, 2) AS ActualBillableTotal,
	ROUND(tTime.ActualHours * tTime.CostRate, 2) AS ActualCostTotal,
	ROUND(tTime.BilledHours * tTime.BilledRate, 2) AS BilledTotal, 
	tTime.InvoiceLineKey, 
	tTime.WriteOff,
	tTime.WIPPostingInKey,
	tTime.WIPPostingOutKey
FROM tTime (NOLOCK) INNER JOIN
    tTimeSheet (NOLOCK) ON 
    tTime.TimeSheetKey = tTimeSheet.TimeSheetKey INNER
     JOIN
    tProject (NOLOCK) ON 
    tTime.ProjectKey = tProject.ProjectKey INNER JOIN
    tUser (NOLOCK) ON 
    tTime.UserKey = tUser.UserKey LEFT OUTER JOIN
    tService (NOLOCK) ON 
    tTime.ServiceKey = tService.ServiceKey LEFT OUTER JOIN
    tTask (NOLOCK) ON 
    tTime.TaskKey = tTask.TaskKey
	WHERE
		tTime.ProjectKey = @ProjectKey
	ORDER BY
		tTime.WorkDate
GO
