USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDefInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDefInsert]
	@ApprovalStepDefKey int,
	@AssignedUserKey int,
	@DisplayOrder int
AS --Encrypt

	INSERT tApprovalStepUserDef
		(
		ApprovalStepDefKey,
		AssignedUserKey,
		DisplayOrder
		)

	VALUES
		(
		@ApprovalStepDefKey,
		@AssignedUserKey,
		@DisplayOrder
		)

	RETURN 1
GO
