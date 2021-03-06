USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetDaySummary]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptTimeSheetDaySummary]

	(
		@TimeSheetKey int
	)

AS --Encrypt

Select
	t.WorkDate,
	ISNULL(Sum(t.ActualHours), 0) as TotalHours
from
	tTime t (nolock)
Where
	t.TimeSheetKey = @TimeSheetKey
Group By
	t.WorkDate
Order By 
	t.WorkDate
GO
