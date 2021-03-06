USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskOrder]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskOrder]
(
	@ProjectKey int,
	@ParentTaskKey int,
	@CurrentOrder int,
	@TaskLevel int
)

AS --Encrypt

Declare @CurrentTaskKey int
Declare @ChildCount int
Declare @CurrentTreeOrder int
Declare @ChildTaskLevel int

Select @CurrentTaskKey = -1
Select @CurrentTreeOrder = 0
Select @ChildTaskLevel = @TaskLevel + 1

while 1 = 1
BEGIN
		Select @CurrentTreeOrder = @CurrentTreeOrder + 1

		Select @CurrentTaskKey = MIN(TaskKey)
			from tTask t (nolock) 
			Where t.ProjectKey = @ProjectKey and 
				t.SummaryTaskKey = @ParentTaskKey and 
				t.DisplayOrder = @CurrentTreeOrder

		if @CurrentTaskKey is null
		BEGIN
			Break
		END
		Else
		BEGIN
			Select @CurrentOrder = @CurrentOrder + 1

			Update tTask Set ProjectOrder = @CurrentOrder, TaskLevel = @TaskLevel Where TaskKey = @CurrentTaskKey

			Select @ChildCount = Count(*) from tTask t1 (nolock) Where t1.SummaryTaskKey = @CurrentTaskKey
			if @ChildCount > 0
			BEGIN
				Exec @CurrentOrder = sptTaskOrder @ProjectKey, @CurrentTaskKey, @CurrentOrder, @ChildTaskLevel
			END
		END
END

Return @CurrentOrder
GO
