USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepCreateFromDef]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepCreateFromDef]

	(
		@DefEntity varchar(50),
		@DefEntityKey int,
		@Entity varchar(50),
		@EntityKey int,
		@UserKey int,
		@UpdateStatus int = 1
	)

AS
	/*
	|| When     Who		Rel			What
	|| 06/25/14 RLB		10.5.8.1	Added option parm for kohls enhancement (220664)
    || 03/25/15 WDF     10.5.9.0    (250961) Added @UserKey, UpdatedByKey and DateUpdated
	*/

Declare @CurDefKey int
Declare @CurKey int

/*
-- Do not recreate the process if approvals exists
Delete tApprovalStepUser 
	From tApprovalStep Where 
		tApprovalStepUser.ApprovalStepKey = tApprovalStep.ApprovalStepKey and
		Entity = @Entity and EntityKey = @EntityKey
		
Delete tApprovalStep Where Entity = @Entity and EntityKey = @EntityKey
*/

if not exists(select 1 from tApprovalStep (nolock) Where Entity = @Entity and EntityKey = @EntityKey)
BEGIN

	Select @CurDefKey = -1
	While 1 = 1
	BEGIN
		Select @CurDefKey = Min(ApprovalStepDefKey) from tApprovalStepDef (nolock) Where Entity = @DefEntity and EntityKey = @DefEntityKey and ApprovalStepDefKey > @CurDefKey
			if @CurDefKey is null
				Break
		
		Insert into tApprovalStep (	CompanyKey, Entity, EntityKey, Subject, DisplayOrder, Action, Instructions, EnableRouting, AllApprove, DaysToApprove)
		Select CompanyKey, @Entity, @EntityKey, Subject, DisplayOrder, Action, Instructions, EnableRouting, AllApprove, DaysToApprove
		from tApprovalStepDef (nolock) Where ApprovalStepDefKey = @CurDefKey
		
		Select @CurKey = @@IDENTITY
		
		Insert into tApprovalStepUser (ApprovalStepKey, AssignedUserKey, DisplayOrder)
		Select @CurKey, AssignedUserKey, DisplayOrder
		from tApprovalStepUserDef (nolock) Where ApprovalStepDefKey = @CurDefKey
		
	END

	If @Entity = 'ProjectRequest' and @UpdateStatus = 1
		Update tRequest Set Status = 2, UpdatedByKey = @UserKey, DateUpdated = GETUTCDATE() Where RequestKey = @EntityKey

END

IF @UpdateStatus = 1
	exec sptApprovalStepInit @Entity, @EntityKey

Declare @FirstKey int
Select @FirstKey = ApprovalStepKey from tApprovalStep (nolock) Where Entity = @Entity and EntityKey = @EntityKey and DisplayOrder = 1

return ISNULL(@FirstKey, 0)
GO
