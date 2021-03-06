USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvTimeSheetReportGetWeek]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvTimeSheetReportGetWeek]
 (
  @TimeSheetKey int
 )
AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/15/12 RLB 10556  (143248) Added transfer out filter to the actual hours
  || 06/20/13 WDF 10.569 (181720) Add Campaign ID/Name
  */


DECLARE @StartDate As DATETIME

SELECT @StartDate = ts.StartDate
FROM   tTimeSheet ts (NOLOCK)
WHERE  ts.TimeSheetKey = @TimeSheetKey
		
 SELECT b.*
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 0, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)  
		  AND    t.TransferredOut = 0 		       
		  ) AS FirstHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 1, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)	
		  AND    t.TransferredOut = 0 	       
		  ) AS SecondHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 2, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)
		  AND    t.TransferredOut = 0 		       
		  ) AS ThirdHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 3, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)	
		  AND    t.TransferredOut = 0 	       
		  ) AS FourthHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 4, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)
		  AND    t.TransferredOut = 0 		       
		  ) AS FifthHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 5, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)	
		  AND    t.TransferredOut = 0 	       
		  ) AS SixthHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    t.WorkDate = DATEADD(day, 6, @StartDate)
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)
		  AND    t.TransferredOut = 0 		       
		  ) AS SeventhHours
		,(SELECT SUM(t.ActualHours)
		  FROM   vTimeSheet t (NOLOCK)
		  WHERE  t.TimeSheetKey = @TimeSheetKey
		  AND    ISNULL(t.ProjectNumber, 0) = ISNULL(b.ProjectNumber, 0)
		  AND    ISNULL(t.TaskID, 0) = ISNULL(b.TaskID, 0)
		  AND    ISNULL(t.ServiceCode, 0) = ISNULL(b.ServiceCode, 0)
		  AND    t.TransferredOut = 0 		       
		  ) AS WeekHours
 FROM
	(
 SELECT DISTINCT ProjectNumber
				,ProjectName
				,ProjectShortName
				,CampaignID
				,CampaignName
				,ISNULL(CampaignID, '') + '-' + ISNULL(CampaignName, '') AS CampaignFullName
				,TaskID
				,TaskName
				,ServiceCode
				,ServiceDescription 
				,StartDate
				,EndDate
				,FirstName
				,LastName
				,SystemID
				,ApprFirstName
				,ApprLastName				
 FROM	vTimeSheet (NOLOCK)
 WHERE  TimeSheetKey = @TimeSheetKey AND TransferredOut = 0
	) AS b
GO
