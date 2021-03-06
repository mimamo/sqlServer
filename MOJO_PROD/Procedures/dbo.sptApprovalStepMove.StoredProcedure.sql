USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepMove]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepMove]

	(
		@ApprovalStepKey int,
		@Direction varchar(10)
	)

AS --Encrypt

Declare @DisplayOrder int
Declare @MoveKey int, @Entity varchar(50), @EntityKey int

Select @DisplayOrder = DisplayOrder, @Entity = Entity, @EntityKey = EntityKey from tApprovalStep (nolock) Where ApprovalStepKey = @ApprovalStepKey

If @Direction = 'Up'
BEGIN

Select @MoveKey = ApprovalStepKey from tApprovalStep (nolock) Where DisplayOrder = @DisplayOrder - 1 and Entity = @Entity and EntityKey = @EntityKey

if @MoveKey is null
	return -1
	
if exists(Select 1 from tApprovalStep (nolock) Where ActiveStep = 1 and (ApprovalStepKey = @ApprovalStepKey or ApprovalStepKey = @MoveKey))
	return -2
	
if exists(Select 1 from tApprovalStep (nolock) Where Completed = 1 and (ApprovalStepKey = @ApprovalStepKey or ApprovalStepKey = @MoveKey))
	return -3

Update tApprovalStep Set DisplayOrder = @DisplayOrder - 1 Where ApprovalStepKey = @ApprovalStepKey
Update tApprovalStep Set DisplayOrder = @DisplayOrder Where ApprovalStepKey = @MoveKey

END


If @Direction = 'Down'
BEGIN

Select @MoveKey = ApprovalStepKey from tApprovalStep (nolock) Where DisplayOrder = @DisplayOrder + 1 and Entity = @Entity and EntityKey = @EntityKey

if @MoveKey is null
	return -1
	
if exists(Select 1 from tApprovalStep (nolock) Where ActiveStep = 1 and (ApprovalStepKey = @ApprovalStepKey or ApprovalStepKey = @MoveKey))
	return -2
	
if exists(Select 1 from tApprovalStep (nolock) Where Completed = 1 and (ApprovalStepKey = @ApprovalStepKey or ApprovalStepKey = @MoveKey))
	return -3
	
Update tApprovalStep Set DisplayOrder = @DisplayOrder + 1 Where ApprovalStepKey = @ApprovalStepKey
Update tApprovalStep Set DisplayOrder = @DisplayOrder Where ApprovalStepKey = @MoveKey

END
GO
