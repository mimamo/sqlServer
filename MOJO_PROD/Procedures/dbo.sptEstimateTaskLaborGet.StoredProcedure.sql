USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborGet]
	(
		@EstimateKey int,
		@TaskKey int
	)
AS  -- Encrypt

	SET NOCOUNT ON 

	SELECT etl.*
		,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
		,d.DepartmentName 
		,s.Description AS ServiceName	
	FROM    tEstimateTaskLabor etl (NOLOCK)
		LEFT OUTER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
		LEFT OUTER JOIN tUser u (NOLOCK) ON etl.UserKey = u.UserKey
		LEFT OUTER JOIN tDepartment d (NOLOCK) ON u.DepartmentKey = d.DepartmentKey
	WHERE   etl.EstimateKey = @EstimateKey
	AND     etl.TaskKey = @TaskKey

	RETURN 1
GO
