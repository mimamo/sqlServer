USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignToTasks]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignToTasks]
	(
		@CompanyKey int,
		@MasterTaskKey int
	)
	
AS --Encrypt

declare @MasterTaskID varchar(100), @RecCount int

Select @MasterTaskID = TaskID from tMasterTask (nolock) Where MasterTaskKey = @MasterTaskKey


Update tTask
Set MasterTaskKey = @MasterTaskKey
From tProject (nolock)
Where
	tProject.ProjectKey = tTask.ProjectKey and
	tTask.TaskID = @MasterTaskID and
	tProject.CompanyKey = @CompanyKey
	
Select @RecCount = Count(*)
From tTask t (nolock)
Where
	t.MasterTaskKey = @MasterTaskKey

return ISNULL(@RecCount, 0)
GO
