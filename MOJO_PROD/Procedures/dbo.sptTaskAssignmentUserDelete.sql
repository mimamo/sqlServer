USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUserDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUserDelete]
	@TaskAssignmentKey int
	
AS --Encrypt

	DELETE
	FROM tTaskAssignmentUser
	WHERE
		TaskAssignmentKey = @TaskAssignmentKey 

	RETURN 1
GO
