USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskValidID]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskValidID]

	(
		@CompanyKey int,
		@ProjectKey int,
		@TaskKey int,
		@TaskID varchar(50)
	)

AS --Encrypt

Declare @MasterTaskKey int
Declare @CountTaskID int
	
	
	Select @MasterTaskKey = MasterTaskKey
	From tMasterTask (nolock)
	Where
		CompanyKey = @CompanyKey and
		TaskID = @TaskID and
		Active = 1
	
	IF @MasterTaskKey IS NOT NULL
	BEGIN
		SELECT @CountTaskID = 0

		IF ISNULL(@TaskKey, 0) <> 0
			SELECT @CountTaskID = COUNT(*)
			FROM   tTask (NOLOCK)
			WHERE  ProjectKey = @ProjectKey
			AND    TaskKey <> @TaskKey
			AND    TaskID = @TaskID
		ELSE				
			SELECT @CountTaskID = COUNT(*)
			FROM   tTask (NOLOCK)
			WHERE  ProjectKey = @ProjectKey
			AND    TaskID = @TaskID
	
		IF @CountTaskID > 0
			RETURN -1
	END	
	
		
		
return isnull(@MasterTaskKey, 0)
GO
