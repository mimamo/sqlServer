USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTaskPredecessor]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportTaskPredecessor]
	@TaskKey int,
	@PredecessorTaskID varchar(50)
	
AS --Encrypt

Declare @ProjectKey int, @PredecessorTaskKey int

Select @ProjectKey = ProjectKey from tTask (nolock) Where TaskKey = @TaskKey
if @TaskKey is null
	return -1
	
Select @PredecessorTaskKey = TaskKey from tTask (nolock) Where TaskID = @PredecessorTaskID and ProjectKey = @ProjectKey
	
	IF @PredecessorTaskKey IS NULL
		RETURN -1
		
	INSERT	tTaskPredecessor
			(TaskKey,
			PredecessorKey,
			Type,
			Lag)
	VALUES	(@TaskKey,
			@PredecessorTaskKey,
			'FS',
			0)
			
	RETURN 1
GO
