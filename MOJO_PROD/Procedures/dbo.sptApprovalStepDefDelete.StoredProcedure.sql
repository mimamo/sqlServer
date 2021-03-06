USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefDelete]
	@ApprovalStepDefKey int

AS --Encrypt

Declare @DisplayOrder int, @Entity varchar(50), @EntityKey int

	Select @DisplayOrder = DisplayOrder,
			@Entity = Entity,
			@EntityKey = EntityKey
	from tApprovalStepDef (nolock) Where ApprovalStepDefKey = @ApprovalStepDefKey 
	
	DELETE
	FROM tApprovalStepUserDef
	WHERE
		ApprovalStepDefKey = @ApprovalStepDefKey 

	DELETE
	FROM tApprovalStepDef
	WHERE
		ApprovalStepDefKey = @ApprovalStepDefKey
		
	Update tApprovalStepDef
	Set DisplayOrder = DisplayOrder - 1
	Where
		DisplayOrder > @DisplayOrder and
		Entity = @Entity and
		EntityKey = @EntityKey

	RETURN 1
GO
