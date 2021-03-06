USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepNotifyUserGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepNotifyUserGetList]

	@ApprovalStepKey int


AS --Encrypt

/*
|| When      Who Rel		What
|| 01/09/12  MAS 10.5.5.2	Created
*/

SELECT tApprovalStepNotify.*,
	LTRIM(RTRIM(ISNULL(tUser.FirstName,'') + ' ' + ISNULL(tUser.LastName,''))) as UserName,
	tUser.Email
FROM tApprovalStepNotify (nolock)
	inner join tUser (nolock) on tApprovalStepNotify.AssignedUserKey = tUser.UserKey
WHERE
	ApprovalStepKey = @ApprovalStepKey

RETURN 1
GO
