USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskGetEstimatedHours]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskGetEstimatedHours]
	(
		@TaskKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT  SUM(ISNULL(et.Hours, 0))	AS Hours
	       ,'A-By Task'					AS Type
	       ,e.EstimateName				AS Description 
	       ,NULL						AS DepartmentName
	FROM    tEstimateTask et (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON et.EstimateKey = e.EstimateKey
		INNER JOIN tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
	WHERE et.TaskKey = @TaskKey  
	AND  ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	GROUP BY e.EstimateName
	
	UNION
	
	SELECT  SUM(ISNULL(etl.Hours, 0))	AS Hours
	       ,'B-By Service'				AS Type
	       ,s.Description				AS Description
	       ,NULL						AS DepartmentName
	FROM    tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
		INNER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
	WHERE etl.TaskKey = @TaskKey  
	AND  ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	GROUP BY s.Description

	UNION
	
	SELECT  SUM(ISNULL(etl.Hours, 0))		AS Hours
	       ,'C-By Person'					AS Type
	       ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')	AS Description
	       ,d.DepartmentName				AS DepartmentName	
	FROM    tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
		INNER JOIN tUser u (NOLOCK) ON etl.UserKey = u.UserKey
		LEFT OUTER JOIN tDepartment d (NOLOCK) ON u.DepartmentKey = d.DepartmentKey
	WHERE etl.TaskKey = @TaskKey  
	AND  ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	GROUP BY d.DepartmentName, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
	
			
	RETURN 1
GO
