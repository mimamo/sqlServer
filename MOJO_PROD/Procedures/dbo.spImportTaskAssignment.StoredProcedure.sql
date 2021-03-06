USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTaskAssignment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportTaskAssignment]
	@CompanyKey INT,
	@ProjectNumber VARCHAR(50),
	@TaskID VARCHAR(30),
	@Title varchar(500),
	@DueBy varchar(200),
	@WorkDescription varchar(4000),
	@MustStartOn smalldatetime,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@Priority smallint,
	@WorkOrder int,
	@Duration int, 
	@Comments varchar(4000),
	@oIdentity INT OUTPUT
AS --Encrypt

	DECLARE @ProjectKey INT
			,@TaskKey INT
			
	SELECT @ProjectKey = ProjectKey
	FROM   tProject (NOLOCK) 
	WHERE  CompanyKey = @CompanyKey
	AND    ProjectNumber =  @ProjectNumber
	
	IF @@ROWCOUNT = 0
		RETURN -1
		
	SELECT @TaskKey = TaskKey
	FROM   tTask (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	AND    TaskID =  @TaskID
		
	IF @@ROWCOUNT = 0
		RETURN -2
		 		
		 		
	IF @Priority < 1 
		SELECT @Priority = 1
		
	IF @Priority > 3 
		SELECT @Priority = 3
		
	IF @PercComp < 0
		SELECT 	@PercComp = 0
		
	IF @PercComp > 100
		SELECT 	@PercComp = 100
	
	INSERT tTaskAssignment
		(
		TaskKey,
		Title,
		DueBy,
		WorkDescription,
		MustStartOn,
		PlanStart,
		PlanComplete,
		ActStart,
		ActComplete,
		PercComp,
		Priority,
		WorkOrder,
		Duration,
		Comments
		)

	VALUES
		(
		@TaskKey,
		@Title,
		@DueBy,
		@WorkDescription,
		@MustStartOn,
		@ActStart,
		@ActComplete,
		@ActStart,
		@ActComplete,
		@PercComp,
		@Priority,
		@WorkOrder,
		@Duration,
		@Comments   
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptTaskUpdatePercComp @TaskKey
		
	RETURN 1
GO
