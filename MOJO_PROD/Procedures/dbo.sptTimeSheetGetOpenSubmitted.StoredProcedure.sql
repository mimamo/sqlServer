USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetOpenSubmitted]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeSheetGetOpenSubmitted]

	(
		@CompanyKey int
	)

AS --Encrypt

  /*
  || 11/27/07 GHL 8.5 removed *= join for SQL 2005
  */

Select
	u.FirstName + ' ' + u.LastName as UserName,
	ts.TimeSheetKey,
	ts.StartDate,
	ts.EndDate,
	ts.DateSubmitted,
	u2.FirstName + ' ' + u2.LastName as ApproverName,
	(Select sum(ActualHours) from tTime (NOLOCK) Where tTime.TimeSheetKey = ts.TimeSheetKey) as TotalHours
From
	tTimeSheet ts (nolock)
	INNER JOIN tUser u (nolock) ON ts.UserKey = u.UserKey
	LEFT OUTER JOIN tUser u2 (nolock) ON u.TimeApprover = u2.UserKey 
Where
	ts.CompanyKey = @CompanyKey and
	ts.Status = 2
GO
