USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepInit]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepInit]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt


  /*
  || When		Who Rel			What
  || 09/25/12   GWG 10.5.6.0    Added in a call to rollup status label
  || 07/25/13   QMD 10.5.7.0    Added the tReviewRound logic
  || 10/28/13   QMD 10.5.7.3    Used IsNull(@Stepduedate, @ActualDate) instead of @ActualDate for the duedate of the step.
  */

Declare @CurKey int
Declare @EnableRouting as tinyint


Update tApprovalStep
Set
	ActiveStep = 0, Completed = 0
Where
	Entity = @Entity and EntityKey = @EntityKey
	
Update tApprovalStepUser
Set
	Comments = LastComments
from
	tApprovalStep (nolock)
Where
	tApprovalStepUser.ApprovalStepKey = tApprovalStep.ApprovalStepKey and
	Entity = @Entity and 
	EntityKey = @EntityKey


Update tApprovalStepUser
Set
	ActiveUser = 0, CompletedUser = 0, Comments = NULL, DateActivated = NULL, DueDate = NULL, DateCompleted = NULL
from
	tApprovalStep (nolock)
Where
	tApprovalStepUser.ApprovalStepKey = tApprovalStep.ApprovalStepKey and
	Entity = @Entity and 
	EntityKey = @EntityKey


Update tApprovalStep 
Set ActiveStep = 1
Where Entity = @Entity and EntityKey = @EntityKey and DisplayOrder = 1

Select @CurKey = ApprovalStepKey, @EnableRouting = EnableRouting from tApprovalStep (nolock) Where
	Entity = @Entity and EntityKey = @EntityKey and DisplayOrder = 1

Declare @DaysToApprove int, @DateActivated smalldatetime, @DueDate datetime, @StepDueDate datetime
Select @DaysToApprove = DaysToApprove, @StepDueDate = DueDate from tApprovalStep (nolock) Where ApprovalStepKey = @CurKey
Select @DateActivated = Cast(Convert(varchar, GETDATE(), 101) as smalldatetime)
Select @DueDate = DATEADD(d, @DaysToApprove, ISNULL(@StepDueDate, @DateActivated))

-- do this only for the deliverable ui
--if @Entity = 'tReviewRound' 
    --Begin   
		--Select @DueDate = DateAdd(Hour, DATEPART(Hour, @StepDueDate), @DueDate)
		--Select @DueDate = DateAdd(Minute, DATEPART(Minute, @StepDueDate), @DueDate)
	--End

if @EnableRouting = 1
	Update tApprovalStepUser
	Set ActiveUser = 1, DateActivated = @DateActivated, DueDate = @DueDate 
	Where ApprovalStepKey = @CurKey and DisplayOrder = 1
else
	Update tApprovalStepUser
	Set ActiveUser = 1, DateActivated = @DateActivated, DueDate = @DueDate 
	Where ApprovalStepKey = @CurKey
	
	exec sptApprovalStepUpdateStatusNames @CurKey

return ISNULL(@CurKey, 0)
GO
