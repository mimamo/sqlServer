USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetDailySubmitList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptTimeGetDailySubmitList]
	@TimeSheetKey int
AS

/*
|| When      Who Rel      What
|| 01/09/15  CRG 10.5.8.8 Created
*/

	CREATE TABLE #Time
		(ProjectKey int NULL,
		ActualHours decimal(24,4) NULL)

	DECLARE	@Status int
	
	SELECT	@Status = Status
	FROM	tTimeSheet (nolock)
	WHERE	TimeSheetKey = @TimeSheetKey

	--If Status is not Approved show all project hour details
	IF @Status <> 4
		INSERT	#Time
				(ActualHours,
				ProjectKey)
		SELECT	SUM(ActualHours),
				ProjectKey
		FROM	tTime  (nolock)
		WHERE	TimeSheetKey = @TimeSheetKey
		GROUP BY WorkDate, ProjectKey
	ELSE	
		INSERT	#Time
				(ActualHours)
		SELECT	SUM(ActualHours) --Approved hours are not separated by Project but instead grouped for the entire day
		FROM	tTime (nolock)
		WHERE	TimeSheetKey = @TimeSheetKey
		GROUP BY WorkDate
		
	SELECT	t.ActualHours,
			t.ProjectKey,
			p.ProjectNumber, 
			p.ProjectName
	FROM	#Time t (nolock)
	LEFT JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
GO
