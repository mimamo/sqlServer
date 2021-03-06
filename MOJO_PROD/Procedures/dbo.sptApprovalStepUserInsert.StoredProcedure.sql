USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserInsert]
	@ApprovalStepKey int,
	@AssignedUserKey int,
	@DisplayOrder int,
	@ActiveUser int = 0
AS --Encrypt

  /*
  || When		Who Rel			What
  || 01/13/12	QMD 10.5.5.2	Added the active input parm
  || 05/09/14	WDF 10.5.8.0	(215235) Added sptApprovalStepUpdateStatusNames
  */

	INSERT tApprovalStepUser
		(
		ApprovalStepKey,
		AssignedUserKey,
		DisplayOrder,
		ActiveUser
		)

	VALUES
		(
		@ApprovalStepKey,
		@AssignedUserKey,
		@DisplayOrder,
		@ActiveUser
		)

    exec sptApprovalStepUpdateStatusNames @ApprovalStepKey

	RETURN 1
GO
