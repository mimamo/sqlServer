USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUserInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUserInsert]
	@TaskAssignmentKey int,
	@UserKey int,
	@TaskKey int,
	@Hours decimal(24, 4) = 0
	
AS --Encrypt

	IF NOT EXISTS (SELECT 1
					FROM tTaskAssignmentUser (NOLOCK)
					WHERE TaskAssignmentKey = @TaskAssignmentKey
					AND   UserKey = @UserKey
					AND   TaskKey = @TaskKey)
					 
	INSERT tTaskAssignmentUser
		(
		TaskAssignmentKey,
		UserKey,
		TaskKey,
		Hours
		)

	VALUES
		(
		@TaskAssignmentKey,
		@UserKey,
		@TaskKey,
		@Hours
		)
	

	RETURN 1
GO
