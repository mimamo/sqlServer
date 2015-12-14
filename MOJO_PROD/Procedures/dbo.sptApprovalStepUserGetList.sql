USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserGetList]

	@ApprovalStepKey int


AS --Encrypt

		SELECT tApprovalStepUser.*,
			tUser.FirstName + ' ' + tUser.LastName as UserName,
			tUser.Email
		FROM tApprovalStepUser (nolock)
			inner join tUser (nolock) on tApprovalStepUser.AssignedUserKey = tUser.UserKey
		WHERE
			ApprovalStepKey = @ApprovalStepKey
		Order By 
			DisplayOrder

	RETURN 1
GO
