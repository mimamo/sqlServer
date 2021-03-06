USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskPredecessorGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskPredecessorGetList]

	@TaskKey int


AS --Encrypt

		SELECT tp.*, t.ProjectKey, t.TaskID, t.TaskName, t.TaskID + ' ' + t.TaskName as TaskFullName
		FROM 
			tTaskPredecessor tp (nolock),
			tTask t (nolock)
		WHERE
			tp.PredecessorKey = t.TaskKey and
			tp.TaskKey = @TaskKey

	RETURN 1
GO
