USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptTaskOrder]    Script Date: 04/29/2016 16:42:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




alter Procedure [dbo].[sptTaskOrder]
(
	@ProjectKey int,
	@ParentTaskKey int,
	@CurrentOrder int,
	@TaskLevel int,
	@AutoIDTask tinyint = 0
)

/*
|| When      Who Rel      What
|| 11/13/15  CRG 10.5.9.8 Added optional AutoIDTask parm to reset the TaskIDs
|| 11/16/15  CRG 10.5.9.8 Added logic to ensure that DisplayOrders are contiguous within levels
*/

AS --Encrypt

Declare @CurrentTaskKey int
Declare @ChildCount int
Declare @CurrentTreeOrder int
Declare @ChildTaskLevel int

Select @CurrentTaskKey = -1
Select @CurrentTreeOrder = 0
Select @ChildTaskLevel = @TaskLevel + 1

DECLARE	@SummaryTaskKey int
DECLARE	@DisplayOrder int
DECLARE	@TaskID varchar(30)

DECLARE	@LoopDisplayOrder int  SELECT @LoopDisplayOrder = 1
DECLARE	@NextDisplayOrder int

--Ensure that the DisplayOrder is contiguous
WHILE (1=1)
BEGIN
	--See if there is a gap in the Display Orders before just exiting the loop
	IF NOT EXISTS(SELECT 1
			FROM	tTask (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		SummaryTaskKey = @ParentTaskKey
			AND		DisplayOrder = @LoopDisplayOrder)
	BEGIN
		IF (SELECT COUNT(*)
				FROM	tTask (nolock)
				WHERE	ProjectKey = @ProjectKey
				AND		SummaryTaskKey = @ParentTaskKey
				AND		DisplayOrder > @LoopDisplayOrder) > 0
		BEGIN
			--Update the next one(s) to equal the LoopDisplayOrder, if there are duplicates, they'll be taken care of below
			SELECT	@NextDisplayOrder = MIN(DisplayOrder)
			FROM	tTask (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		SummaryTaskKey = @ParentTaskKey
			AND		DisplayOrder > @LoopDisplayOrder
			
			IF @NextDisplayOrder IS NULL
				BREAK --Just in case there's a problem and it couldn't find one
			
			UPDATE	tTask
			SET		DisplayOrder = @LoopDisplayOrder
			WHERE	ProjectKey = @ProjectKey
			AND		SummaryTaskKey = @ParentTaskKey
			AND		DisplayOrder = @NextDisplayOrder
		END
		ELSE
			BREAK --There are no more tasks at this level, we can exit the loop
	END
	
	--See if there is more than one task with this DisplayOrder
	IF (SELECT COUNT(*)
			FROM	tTask (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		SummaryTaskKey = @ParentTaskKey
			AND		DisplayOrder = @LoopDisplayOrder) > 1
	BEGIN
		--Set the Min TaskKey to this DisplayOrder, and push the other Tasks down one
		SELECT	@CurrentTaskKey = MIN(TaskKey)
		FROM	tTask (nolock)
		WHERE	ProjectKey = @ProjectKey
		AND		SummaryTaskKey = @ParentTaskKey
		AND		DisplayOrder = @LoopDisplayOrder
		
		UPDATE	tTask
		SET		DisplayOrder = DisplayOrder + 1
		WHERE	ProjectKey = @ProjectKey
		AND		TaskKey <> @CurrentTaskKey
		AND		SummaryTaskKey = @ParentTaskKey
		AND		DisplayOrder >= @LoopDisplayOrder
	END
		
	SELECT	@LoopDisplayOrder = @LoopDisplayOrder + 1
END


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
			
			IF @AutoIDTask = 1
			BEGIN
				SELECT	@SummaryTaskKey = ISNULL(SummaryTaskKey, 0),
						@DisplayOrder = DisplayOrder
				FROM	tTask (nolock)
				WHERE	TaskKey = @CurrentTaskKey
				
				IF @SummaryTaskKey = 0
					SELECT	@TaskID = CAST(@DisplayOrder as varchar)
				ELSE
				BEGIN
					SELECT	@TaskID = TaskID
					FROM	tTask (nolock)
					WHERE	TaskKey = @SummaryTaskKey
					
					SELECT	@TaskID = ISNULL(@TaskID, '') + '.' + CAST(@DisplayOrder as varchar)
				END
				
				UPDATE	tTask SET TaskID = @TaskID WHERE TaskKey = @CurrentTaskKey
			END

			Select @ChildCount = Count(*) from tTask t1 (nolock) Where t1.SummaryTaskKey = @CurrentTaskKey
			if @ChildCount > 0
			BEGIN
				Exec @CurrentOrder = sptTaskOrder @ProjectKey, @CurrentTaskKey, @CurrentOrder, @ChildTaskLevel, @AutoIDTask
			END
		END
END

Return @CurrentOrder








GO
