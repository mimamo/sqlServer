USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDisplayOrderByPlanStartLoop]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskDisplayOrderByPlanStartLoop]
(
	@ProjectKey int,
	@ParentTaskKey int
)

AS --Encrypt

Declare @CurrentDisplayOrder int
Declare @CurrentTaskKey int
Declare @CurrentMyID varchar(50)
Declare @ChildCount int

Select @CurrentTaskKey = -1
Select @CurrentMyID = -1
Select @CurrentDisplayOrder = 0

/* Assume
CREATE TABLE #tTask (TaskKey INT NULL, TaskLevel INT NULL, 
					 SummaryTaskKey INT NULL, PlanStart DATETIME NULL, MyID INT NULL)
					 
*/

while 1 = 1
BEGIN
					
		Select @CurrentMyID = MIN(MyID)
		from   #tTask t (nolock) 
		Where  t.SummaryTaskKey = @ParentTaskKey 
		And    t.MyID > @CurrentMyID
		
		if @CurrentMyID is null
		BEGIN
			Break
		END
		Else
		BEGIN
			Select @CurrentDisplayOrder = @CurrentDisplayOrder + 1

			SELECT @CurrentTaskKey = TaskKey FROM #tTask (nolock) 
			where MyID = @CurrentMyID
			
			Update tTask Set DisplayOrder = @CurrentDisplayOrder
			Where TaskKey = @CurrentTaskKey

			Select @ChildCount = Count(*) from tTask t1 (nolock) Where t1.SummaryTaskKey = @CurrentTaskKey
			if @ChildCount > 0
			BEGIN
				Exec sptTaskDisplayOrderByPlanStartLoop @ProjectKey, @CurrentTaskKey
			END
		END
END

Return 1
GO
