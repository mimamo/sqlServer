USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserAddUser]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserAddUser]
	(
	@TaskKey int,
	@UserKey int,
	@Hours decimal(24,4) = 0
	)
AS


Declare @ProjectKey int, @TaskType int, @ServiceKey int

Select @ProjectKey = ProjectKey, @TaskType = TaskType from tTask (nolock) Where TaskKey = @TaskKey

if @TaskType = 1
	return 1

if not exists(Select 1 from tTaskUser (nolock) Where TaskKey = @TaskKey and UserKey = @UserKey)
BEGIN
	exec sptAssignmentInsertFromTask @ProjectKey, @UserKey

	Select @ServiceKey = DefaultServiceKey From tUser (nolock) Where UserKey = @UserKey

	Insert tTaskUser(TaskKey, UserKey, ServiceKey, Hours)
	Values(@TaskKey, @UserKey, @ServiceKey, @Hours)


END
GO
