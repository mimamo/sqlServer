USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetTimeSheetForApproval]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetTimeSheetForApproval]
 @UserKey int
 
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

 SELECT ts.TimeSheetKey, ts.StartDate, ts.EndDate, 
   SUM(t.ActualHours) AS TotalHours, ts.Status, u.FirstName, u.LastName, u.Email, ts.ApprovalComments
 FROM tTimeSheet ts (NOLOCK)
   LEFT OUTER JOIN tTime t (NOLOCK) ON ts.TimeSheetKey = t.TimeSheetKey
   INNER JOIN tUser u (NOLOCK) ON ts.UserKey = u.UserKey
 WHERE ts.UserKey IN 
    (SELECT UserKey
    FROM tUser (NOLOCK)
    WHERE TimeApprover = @UserKey)
 AND  ts.Status = 2
 GROUP BY ts.TimeSheetKey, ts.StartDate, ts.EndDate, t.TimeSheetKey, ts.Status,
   u.FirstName, u.LastName, ts.ApprovalComments, u.Email
 ORDER BY u.LastName, ts.StartDate
GO
