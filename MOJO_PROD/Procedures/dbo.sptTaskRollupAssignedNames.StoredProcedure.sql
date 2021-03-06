USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskRollupAssignedNames]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskRollupAssignedNames]
	@TaskKey int
AS

/*
|| When      Who Rel      What
|| 11/18/10  CRG 10.5.3.8 Created to cetralize the rollup of assignment initials
*/

	DECLARE @TaskUserKey int, 
			@Names varchar(2000),
			@UserName varchar(100), 
			@UserKey int, 
			@ServiceKey int

	SELECT	@TaskUserKey = -1, 
			@Names = NULL

	WHILE (1=1)
	BEGIN
		SELECT	@TaskUserKey = MIN(TaskUserKey) 
		FROM	tTaskUser (nolock) 
		WHERE	TaskKey = @TaskKey 
		AND		TaskUserKey > @TaskUserKey
		
		IF @TaskUserKey IS NULL
			BREAK

		SELECT	@UserKey = UserKey, 
				@ServiceKey = ServiceKey
		FROM	tTaskUser (nolock) 
		WHERE	TaskUserKey = @TaskUserKey

		IF @UserKey IS NOT NULL
			SELECT @UserName = Initials FROM vUserName (nolock) WHERE UserKey = @UserKey
		ELSE
			SELECT @UserName = Description FROM tService (nolock) WHERE ServiceKey = @ServiceKey

		IF @Names IS NULL
			SELECT @Names = @UserName
		Else
			SELECT @Names = @Names + ',' + @UserName
	END

	IF @Names IS NOT NULL
		UPDATE tTask SET AssignedNames = @Names WHERE TaskKey = @TaskKey
GO
