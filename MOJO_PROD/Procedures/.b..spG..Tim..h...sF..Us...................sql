USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetTimeSheetsForUser]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetTimeSheetsForUser]
 @UserKey int
 
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

 SELECT ts.TimeSheetKey, ts.StartDate, ts.EndDate, SUM(t.ActualHours) AS TotalHours, ts.Status
 FROM tTimeSheet ts (nolock)
   LEFT OUTER JOIN tTime t ON ts.TimeSheetKey = t.TimeSheetKey
 WHERE ts.UserKey = @UserKey
 AND  (ts.Status = 1 OR ts.Status = 3)
 GROUP BY ts.TimeSheetKey, ts.StartDate, ts.EndDate, t.TimeSheetKey, ts.Status 
 ORDER BY ts.StartDate
 RETURN 1
GO
