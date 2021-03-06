USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskPredecessorGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskPredecessorGet]
	@TaskPredecessorKey int

AS --Encrypt

		SELECT tTaskPredecessor.*, tTask.TaskID
		FROM 
			tTaskPredecessor (nolock),
			tTask (nolock)
		WHERE
			tTaskPredecessor.PredecessorKey = tTask.TaskKey and
			TaskPredecessorKey = @TaskPredecessorKey

	RETURN 1
GO
