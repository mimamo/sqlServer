USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGetListWithUsers]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGetListWithUsers]

	@Entity varchar(50),
	@EntityKey int


AS --Encrypt

		SELECT asd.*,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			u.Email,
			asud.ApprovalStepUserKey,
			asud.DisplayOrder as UserDisplayOrder,
			asud.AssignedUserKey,
			asud.DateActivated,
			asud.DueDate,
			asud.DateCompleted,
			asud.Comments,
			asud.LastComments,
			asud.ActiveUser,
			asud.CompletedUser,
			(Case asd.Action When 1 then 'Edit' when 2 then 'Approve' when 3 then 'Notify' end) as ActionText
		FROM tApprovalStep asd (nolock)
			Left outer join tApprovalStepUser asud on asd.ApprovalStepKey = asud.ApprovalStepKey
			Left outer join tUser u on asud.AssignedUserKey = u.UserKey
		WHERE
		asd.Entity = @Entity and
		asd.EntityKey = @EntityKey
		Order By
			asd.DisplayOrder, asud.DisplayOrder

	RETURN 1
GO
