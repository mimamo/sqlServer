USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDefGetList]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDefGetList]

	@ApprovalStepDefKey int


AS --Encrypt

		SELECT tApprovalStepUserDef.*,
			tUser.FirstName + ' ' + tUser.LastName as UserName
		FROM tApprovalStepUserDef (nolock)
			inner join tUser (nolock) on tApprovalStepUserDef.AssignedUserKey = tUser.UserKey
		WHERE
			ApprovalStepDefKey = @ApprovalStepDefKey
		Order By 
			DisplayOrder

	RETURN 1
GO
