USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefMove]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefMove]

	(
		@ApprovalStepDefKey int,
		@Direction varchar(10)
	)

AS --Encrypt

Declare @DisplayOrder int
Declare @MoveKey int, @Entity varchar(50), @EntityKey int

Select @DisplayOrder = DisplayOrder, @Entity = Entity, @EntityKey = EntityKey from tApprovalStepDef (nolock) Where ApprovalStepDefKey = @ApprovalStepDefKey

If @Direction = 'Up'
BEGIN

Select @MoveKey = ApprovalStepDefKey from tApprovalStepDef (nolock) Where DisplayOrder = @DisplayOrder - 1 and Entity = @Entity and EntityKey = @EntityKey

if @MoveKey is null
	return -1

Update tApprovalStepDef Set DisplayOrder = @DisplayOrder - 1 Where ApprovalStepDefKey = @ApprovalStepDefKey
Update tApprovalStepDef Set DisplayOrder = @DisplayOrder Where ApprovalStepDefKey = @MoveKey

END


If @Direction = 'Down'
BEGIN

Select @MoveKey = ApprovalStepDefKey from tApprovalStepDef (nolock) Where DisplayOrder = @DisplayOrder + 1 and Entity = @Entity and EntityKey = @EntityKey

if @MoveKey is null
	return -1
	
Update tApprovalStepDef Set DisplayOrder = @DisplayOrder + 1 Where ApprovalStepDefKey = @ApprovalStepDefKey
Update tApprovalStepDef Set DisplayOrder = @DisplayOrder Where ApprovalStepDefKey = @MoveKey

END
GO
