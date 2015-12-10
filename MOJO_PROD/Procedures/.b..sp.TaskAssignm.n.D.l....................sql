USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentDelete]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentDelete]
	@TaskAssignmentKey int

AS --Encrypt

	DELETE tTaskAssignmentUser
	WHERE
		TaskAssignmentKey = @TaskAssignmentKey 
	
	DELETE
	FROM tTaskAssignment
	WHERE
		TaskAssignmentKey = @TaskAssignmentKey 

	RETURN 1
GO
