USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTaskAssignmentUser]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportTaskAssignmentUser]
	(
		@CompanyKey INT,
		@TaskAssignmentKey INT,
		@UserID VARCHAR(50)
	)
AS
	SET NOCOUNT ON
	
	DECLARE @UserKey INT
			,@TaskKey INT
			,@ProjectKey INT
			,@UserRate money
						
	SELECT @UserKey = UserKey
	FROM   tUser (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    UserID = @UserID
	
	IF @@ROWCOUNT = 0
		RETURN -1
		
	SELECT @TaskKey = tTask.TaskKey
		   ,@ProjectKey = tTask.ProjectKey
	FROM   tTaskAssignment (NOLOCK)
		INNER JOIN tTask (NOLOCK) ON tTask.TaskKey = tTaskAssignment.TaskKey
	WHERE  tTaskAssignment.TaskAssignmentKey = @TaskAssignmentKey
	
	IF @ProjectKey IS NULL
		RETURN -2
		
	if not exists(Select 1 from tAssignment (nolock) Where ProjectKey = @ProjectKey and UserKey = @UserKey)
	begin
		Select @UserRate = HourlyRate from tUser (nolock) Where UserKey = @UserKey
		Insert tAssignment (ProjectKey, UserKey, HourlyRate)
		Values (@ProjectKey, @UserKey, @UserRate)	
	end

	IF NOT EXISTS (SELECT 1 FROM tTaskAssignmentUser (NOLOCK)
					WHERE TaskAssignmentKey = @TaskAssignmentKey
					AND   UserKey = @UserKey
					AND   TaskKey = @TaskKey)
		INSERT tTaskAssignmentUser (TaskAssignmentKey, UserKey, TaskKey)
		VALUES (@TaskAssignmentKey, @UserKey, @TaskKey)		 
	
	RETURN 1
GO
