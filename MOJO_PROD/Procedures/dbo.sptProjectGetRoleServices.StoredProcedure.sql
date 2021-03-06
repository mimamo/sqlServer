USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetRoleServices]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetRoleServices]
	(
		@CompanyKey int
		,@ProjectKey int
		,@ShowAllServices tinyint
		,@IncludeProjectServices tinyint = 1  
	)
AS --Encrypt
	
	SET NOCOUNT ON
	
  /*
  || When     Who Rel     What
  || 09/27/10 GHL 10.536  Added @IncludeProjectServices parameter because on some screens 
  ||                      where project services are updated, the info in the db server is obsolete      
  ||                      they need to be merged in on the client side
  || 09/30/10 GHL 10.536  Added IconID column to enable balloons
  */

	DECLARE @EstimateServices AS INT
			,@ProjectTypeServices AS INT

	-- Take Union of Services already assigned and Services from the estimates
	-- If none from the estimates, get from the project types
	-- If none from the project types, take all active services

	SELECT @EstimateServices = 0
		  ,@ProjectTypeServices = 0
		  ,@ShowAllServices = isnull(@ShowAllServices, 0)
		  	
	IF EXISTS (
			SELECT 1
			FROM   tEstimate e (NOLOCK)
				INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
			Where e.ProjectKey = @ProjectKey
			And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			And ISNULL(ServiceKey, 0) > 0
			)
		SELECT @EstimateServices = 1
	ELSE
		IF EXISTS (
			SELECT 1
			FROM   tProject p (NOLOCK) 
				INNER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
				INNER JOIN tProjectTypeService pts (NOLOCK) ON pt.ProjectTypeKey = pts.ProjectTypeKey
			Where p.ProjectKey = @ProjectKey
			)
			SELECT @ProjectTypeServices = 1
			
	IF @EstimateServices = 0 AND @ProjectTypeServices = 0
		SELECT @ShowAllServices = 1 
		

	SELECT s.ServiceKey
			,s.ServiceCode
			,s.Description
			,'edit' as IconID
	FROM   tService s (NOLOCK)
	INNER JOIN
		(
		SELECT DISTINCT c.ServiceKey
		FROM    (
				SELECT ServiceKey
				FROM   tProjectUserServices (NOLOCK)
				WHERE  ProjectKey = @ProjectKey
				AND    @IncludeProjectServices = 1

				UNION
				
				SELECT etl.ServiceKey
				FROM   tEstimate e (NOLOCK)
					INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
				Where e.ProjectKey = @ProjectKey
				And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
				And @EstimateServices = 1
				
				UNION 
				
				SELECT pts.ServiceKey
				FROM   tProject p (NOLOCK) 
					INNER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
					INNER JOIN tProjectTypeService pts (NOLOCK) ON pt.ProjectTypeKey = pts.ProjectTypeKey
				Where p.ProjectKey = @ProjectKey
				And @ProjectTypeServices = 1

				UNION
				
				SELECT ServiceKey
				FROM   tService (NOLOCK)
				WHERE  CompanyKey = @CompanyKey
				AND    Active = 1
				AND    @ShowAllServices = 1
										
				) As c
		) As b on s.ServiceKey = b.ServiceKey
	
	WHERE  CompanyKey = @CompanyKey

			
		
	
	
	RETURN 1
GO
