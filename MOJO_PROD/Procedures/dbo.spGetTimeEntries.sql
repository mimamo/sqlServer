USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetTimeEntries]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetTimeEntries]
 @InvoiceLineKey int,
 @FromDate smalldatetime,
 @ToDate smalldatetime
 
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

 DECLARE @ProjectKey int
 
 SELECT @ProjectKey = ProjectKey
 FROM tInvoiceLine (NOLOCK)
 WHERE InvoiceLineKey = @InvoiceLineKey
 SELECT DISTINCT 
	t.*, 
	ROUND(t.ActualHours * t.ActualRate, 2) as ActualAmount,
	Case t.RateLevel 
		When 1 then ISNULL(s.Description1, s.Description)
		When 2 then ISNULL(s.Description2, s.Description)
		When 3 then ISNULL(s.Description3, s.Description)
		When 4 then ISNULL(s.Description4, s.Description)
		When 5 then ISNULL(s.Description5, s.Description)
		Else s.Description
	END as Service,
	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS Person
 FROM tTime t (NOLOCK)
	INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey 
    INNER JOIN tUser u (NOLOCK) ON t.UserKey = u.UserKey
    LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
 WHERE t.ProjectKey = @ProjectKey
 and     ts.Status = 4
 AND  t.InvoiceLineKey IS NULL
 AND  t.WriteOff = 0
 AND  ((t.WorkDate BETWEEN @FromDate AND @ToDate)
   OR ((@FromDate IS NULL) AND (t.WorkDate <= @ToDate))
   OR ((@ToDate IS NULL) AND (t.WorkDate >= @FromDate))
   OR ((@FromDate IS NULL) AND (@ToDate IS NULL)))
 ORDER BY t.WorkDate
GO
