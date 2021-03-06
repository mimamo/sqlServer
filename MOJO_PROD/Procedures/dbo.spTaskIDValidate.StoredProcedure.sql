USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskIDValidate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTaskIDValidate]
 @TaskID varchar(30),
 @ProjectKey int,
 @Restrict smallint
 
AS --Encrypt
 DECLARE @TaskKey int
 
 
 if @Restrict = 0  -- No Restrictions
	SELECT @TaskKey = TaskKey 
	FROM tTask (NOLOCK) 
	WHERE ProjectKey = @ProjectKey
	AND  UPPER(TaskID) = UPPER(@TaskID)

if @Restrict = 1  -- Schedule Only
	SELECT @TaskKey = TaskKey 
	FROM tTask (NOLOCK) 
	WHERE ProjectKey = @ProjectKey
	AND  UPPER(TaskID) = UPPER(@TaskID)
	AND tTask.ScheduleTask = 1

if @Restrict = 2  -- Money Only
	SELECT @TaskKey = TaskKey 
	FROM tTask (NOLOCK) 
	WHERE ProjectKey = @ProjectKey
	AND  UPPER(TaskID) = UPPER(@TaskID)
	AND tTask.TrackBudget = 1
	
if @Restrict = 3  -- Summary Only
	SELECT @TaskKey = TaskKey 
	FROM tTask (NOLOCK) 
	WHERE ProjectKey = @ProjectKey
	AND  UPPER(TaskID) = UPPER(@TaskID)
	AND tTask.TaskType = 1
	
 if @TaskKey is null
	return -1
	
   
 return @TaskKey
GO
