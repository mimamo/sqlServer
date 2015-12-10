USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskDelete]
	@MasterTaskKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/11/07 GHL 8.4   Added prevention of deletion when a task is associated to that master task key 
  */
  
	DECLARE @CompanyKey INT
	SELECT  @CompanyKey = CompanyKey FROM tMasterTask (NOLOCK) WHERE MasterTaskKey = @MasterTaskKey
	
	IF EXISTS (SELECT 1 
				FROM  tTask t (NOLOCK)
				INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
				WHERE p.CompanyKey = @CompanyKey
				AND   t.MasterTaskKey = @MasterTaskKey)
		RETURN -1				   

	IF EXISTS (SELECT 1
				FROM  tMasterTask (NOLOCK)
				WHERE SummaryMasterTaskKey = @MasterTaskKey)
		RETURN -2
				
	DELETE
	FROM tProjectTypeMasterTask
	WHERE
		MasterTaskKey = @MasterTaskKey 
		
	DELETE
	FROM tMasterTask
	WHERE
		MasterTaskKey = @MasterTaskKey 

	RETURN 1
GO
