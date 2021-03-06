USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDelete]
	@ApprovalStepKey int

AS --Encrypt

Declare @DisplayOrder int, @Entity varchar(50), @EntityKey int

if exists(Select 1 from tApprovalStep (nolock) Where ActiveStep = 1 and ApprovalStepKey = @ApprovalStepKey)
	return -2
	
if exists(Select 1 from tApprovalStep (nolock) Where Completed = 1 and ApprovalStepKey = @ApprovalStepKey)
	return -3
	
	Select @DisplayOrder = DisplayOrder,
			@Entity = Entity,
			@EntityKey = EntityKey
	from tApprovalStep (nolock) Where ApprovalStepKey = @ApprovalStepKey 
	
	DELETE
	FROM tApprovalStepUser
	WHERE
		ApprovalStepKey = @ApprovalStepKey 

	DELETE
	FROM tApprovalStep
	WHERE
		ApprovalStepKey = @ApprovalStepKey
		
	Update tApprovalStep
	Set DisplayOrder = DisplayOrder - 1
	Where
		DisplayOrder > @DisplayOrder and
		Entity = @Entity and
		EntityKey = @EntityKey

	RETURN 1
GO
