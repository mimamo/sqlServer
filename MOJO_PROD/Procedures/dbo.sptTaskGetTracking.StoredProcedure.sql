USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetTracking]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetTracking]

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
			TaskType = 2 and
			ScheduleTask = 1
			
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
			TaskType = 2 and
			TaskKey <> @TaskKey and
			ScheduleTask = 1
			
		ORDER BY
			ProjectOrder
GO
