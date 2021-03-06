USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUserGetUserList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUserGetUserList]
	@TaskKey int

AS --Encrypt


	SELECT	tau.TaskAssignmentKey
			,u.UserKey
			,u.FirstName + ' ' + u.LastName AS UserName
			,UPPER(LEFT(ISNULL(u.FirstName, ''), 1) 
			     + LEFT(ISNULL(u.MiddleName, ''), 1)
			     + LEFT(ISNULL(u.LastName, ''), 1)) AS Initials
	FROM	tTaskAssignmentUser  tau (nolock)
			INNER JOIN tUser u (NOLOCK) ON tau.UserKey = u.UserKey
	WHERE	tau.TaskKey = @TaskKey
	
		
RETURN 1
GO
