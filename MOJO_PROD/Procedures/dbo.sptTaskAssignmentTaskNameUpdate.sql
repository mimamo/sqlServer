USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTaskNameUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTaskNameUpdate]
	@TaskKey int,
	@TaskName varchar(300)
	
as --Encrypt

	/*
	|| When     Who Rel     What
	|| 09/05/13 RLB 105.7.2 (187728) Added update for task name for kohls
	*/
	
	UPDATE
		tTask
	SET
		TaskName = @TaskName      	  	
	WHERE
		TaskKey = @TaskKey
GO
