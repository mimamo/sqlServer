USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarGetMilestones]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarGetMilestones]
	(
		@StartDate DATETIME,
		@EndDate DATETIME,
		@UserKey INT,
		@ProjectKey INT
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN
*/

	/*
	CREATE TABLE #tMilestone(
		ProjectKey INT NULL
		,MilestoneLabel VARCHAR(100) NULL
		,MilestoneNumber INT NULL
		,DateChar VARCHAR(100) NULL
		,Date VARCHAR(100) NULL)
		
	*/
		
	/*CREATE TABLE #tProject(ProjectKey INT NULL
		 ,ProjectTypeKey INT NULL	
		 ,ProjectNumber VARCHAR(100) NULL
		 )
	*/
	SELECT 1 AS ProjectKey, ProjectTypeKey, ProjectNumber INTO #tProject FROM tProject (NOLOCK) WHERE 1=2

	IF @ProjectKey IS NOT NULL
		INSERT #tProject 
		SELECT ProjectKey
					,ProjectTypeKey
		      ,ProjectNumber
		FROM  tProject (NOLOCK)
		WHERE ProjectKey = @ProjectKey
	ELSE
		INSERT #tProject
		SELECT a.ProjectKey, p.ProjectTypeKey, p.ProjectNumber 
		FROM   tAssignment a (NOLOCK) 
					,tProject    p (NOLOCK)
		WHERE  a.UserKey = @UserKey
		AND    a.ProjectKey = p.ProjectKey
		AND    p.Active  = 1


	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone1Label, '') 
				 ,1,p.MileStone1, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '3'	
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone2Label, '') 
				 ,2,p.MileStone2, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '4'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone3Label, '') 
				 ,3,p.MileStone3, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '5'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone4Label, '') 
				 ,4,p.MileStone4, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '6'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone5Label, '') 
				 ,5,p.MileStone5, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '7'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone6Label, '') 
				 ,6,p.MileStone6, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '8'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone7Label, '') 
				 ,7,p.MileStone7, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '9'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone8Label, '') 
				 ,8,p.MileStone8, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '10'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone9Label, '') 
				 ,9,p.MileStone9, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '11'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone10Label, '') 
				 ,10,p.MileStone10, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '12'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone11Label, '') 
				 ,11,p.MileStone11, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
print '13'
	INSERT #tMilestone	
	SELECT p.ProjectKey 
				 ,ISNULL(LTRIM(RTRIM(a.ProjectNumber))+'-', '')+ISNULL(pt.MileStone12Label, '') 
				 ,12,p.MileStone12, NULL 
	FROM   #tProject      a
	      INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
	      LEFT OUTER JOIN tProjectType pt (NOLOCK) ON a.ProjectTypeKey = pt.ProjectTypeKey
	     	
	DELETE #tMilestone
	WHERE  ISDATE(DateChar) = 0
	
	UPDATE #tMilestone
	SET    Date = CONVERT(DATETIME, DateChar)
	
	DELETE #tMilestone
	WHERE  DATEDIFF(day, @StartDate, Date) < 0
	
	DELETE #tMilestone
	WHERE  DATEDIFF(day, Date ,@EndDate) < 0

	--select * from #tMilestone
			 
	/* set nocount on */
	return 1
GO
