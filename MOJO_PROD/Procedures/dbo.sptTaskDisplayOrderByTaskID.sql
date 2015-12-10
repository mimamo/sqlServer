USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDisplayOrderByTaskID]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskDisplayOrderByTaskID]
(
	@ProjectKey int,
	@ParentTaskKey int
)

AS --Encrypt

Declare @CurrentDisplayOrder int
Declare @CurrentTaskKey int
Declare @CurrentTaskID varchar(50)
Declare @ChildCount int

Select @CurrentTaskKey = -1
Select @CurrentTaskID = ''
Select @CurrentDisplayOrder = 0

-- Place the tasks without ID at top
while 1 = 1
BEGIN
					
		Select @CurrentTaskKey = MIN(TaskKey)
		from   tTask t (nolock) 
		Where  t.ProjectKey = @ProjectKey  
		And    t.SummaryTaskKey = @ParentTaskKey 
		And    t.TaskKey > @CurrentTaskKey
		And    t.TaskID IS NULL
				
		if @CurrentTaskKey is null
			Break
		
		Select @CurrentDisplayOrder = @CurrentDisplayOrder + 1
		
		Update tTask 
		Set DisplayOrder = @CurrentDisplayOrder
		Where TaskKey = @CurrentTaskKey

		Select @ChildCount = Count(*) from tTask t1 (nolock) Where t1.SummaryTaskKey = @CurrentTaskKey
		if @ChildCount > 0
		BEGIN
			Exec sptTaskDisplayOrderByTaskID @ProjectKey, @CurrentTaskKey
		END

END

while 1 = 1
BEGIN
					
		Select @CurrentTaskID = MIN(TaskID)
		from   tTask t (nolock) 
		Where  t.ProjectKey = @ProjectKey  
		And    t.SummaryTaskKey = @ParentTaskKey 
		And    t.TaskID > @CurrentTaskID
		And    t.TaskID IS NOT NULL
				
		if @CurrentTaskID is null
			Break
		
		Select @CurrentDisplayOrder = @CurrentDisplayOrder + 1

		Select @CurrentTaskKey = TaskKey 
		from tTask (nolock) 
		where ProjectKey = @ProjectKey And TaskID = @CurrentTaskID
		
		Update tTask 
		Set DisplayOrder = @CurrentDisplayOrder
		Where TaskKey = @CurrentTaskKey

		Select @ChildCount = Count(*) from tTask t1 (nolock) Where t1.SummaryTaskKey = @CurrentTaskKey
		if @ChildCount > 0
		BEGIN
			Exec sptTaskDisplayOrderByTaskID @ProjectKey, @CurrentTaskKey
		END

END

Return 1
GO
