USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefGetList]

	@Entity varchar(50),
	@EntityKey int


AS --Encrypt

		SELECT asd.*,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			(Case asd.Action When 1 then 'Edit' when 2 then 'Approve' when 3 then 'Notify' end) as ActionText
		FROM tApprovalStepDef asd (nolock)
			Left outer join tApprovalStepUserDef asud on asd.ApprovalStepDefKey = asud.ApprovalStepDefKey
			Left outer join tUser u on asud.AssignedUserKey = u.UserKey
		WHERE
		asd.Entity = @Entity and
		asd.EntityKey = @EntityKey
		Order By
			asd.DisplayOrder, asud.DisplayOrder

	RETURN 1
GO
