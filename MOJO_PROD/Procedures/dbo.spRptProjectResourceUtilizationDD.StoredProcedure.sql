USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectResourceUtilizationDD]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectResourceUtilizationDD]
	@StartDate datetime,
	@EndDate datetime,
	@ResourceUserKey int
AS

/*
|| When      Who Rel     What
|| 09/20/12  MFT 10.560  Created
*/


SELECT
	p.ProjectKey,
	p.ProjectName,
	p.ProjectNumber,
	p.UtilizationType,
	SUM(t.ActualHours) AS TotalHours
FROM
	tTime t (nolock)
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
WHERE
	t.UserKey = @ResourceUserKey AND
	t.WorkDate >= @StartDate AND
	t.WorkDate <= @EndDate
GROUP BY
	p.ProjectKey,
	p.ProjectName,
	p.ProjectNumber,
	p.UtilizationType
GO
