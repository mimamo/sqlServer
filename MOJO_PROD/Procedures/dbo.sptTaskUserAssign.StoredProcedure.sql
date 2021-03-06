USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserAssign]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserAssign]
	(
	@TaskKey int,
	@TaskUserKey int,
	@UserKey int
	)
AS

/*
|| When      Who Rel      What
|| 7/31/14   QMD 10.5.8.2 Changed User.Today.MyTasks to today.creative.myTasks
*/

Declare @ProjectKey int, @CompanyKey int, @TaskType int, @ServiceKey int, @Hours decimal(24,4)
Select @ProjectKey = ProjectKey, @TaskType = TaskType from tTask (nolock) Where TaskKey = @TaskKey
Select @ServiceKey = DefaultServiceKey, @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) From tUser (nolock) Where UserKey = @UserKey

if @TaskType = 1
	return 1
	
	
if @TaskUserKey is null
BEGIN
	Update tTaskUser Set UserKey = @UserKey, ServiceKey = ISNULL(ServiceKey, @ServiceKey) Where TaskUserKey = @TaskUserKey
END
ELSE
BEGIN
	Insert tTaskUser(TaskKey, UserKey, ServiceKey, Hours)
	Values(@TaskKey, @UserKey, @ServiceKey, 0)
	Select @TaskUserKey = @@Identity
	
END

exec sptAppFavoriteInsert @CompanyKey, @UserKey, 'today.creative.myTasks', @TaskUserKey
exec sptAssignmentInsertFromTask @ProjectKey, @UserKey
GO
