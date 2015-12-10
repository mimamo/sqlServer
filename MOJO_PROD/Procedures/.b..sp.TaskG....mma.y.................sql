USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetSummary]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetSummary]

	(
		@ProjectKey int
	   ,@TaskKey int	
	)

AS --Encrypt

	if @TaskKey is null
		SELECT 
			TaskKey,
			TaskID,
			TaskName,
			TaskID + ' - ' + TaskName as TaskFullName
		FROM
			tTask (nolock)
		WHERE
			ProjectKey = @ProjectKey AND
			TaskType = 1
			
		ORDER BY
			ProjectOrder

	else
		SELECT 
			TaskKey,
			TaskID,
			TaskName,
			TaskID + ' - ' + TaskName as TaskFullName
		FROM
			tTask (nolock)
		WHERE
			ProjectKey = @ProjectKey AND
			TaskType = 1 and
			TaskKey <> @TaskKey
			
		ORDER BY
			ProjectOrder
GO
