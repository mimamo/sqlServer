USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepNotifyInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepNotifyInsert]
	@ApprovalStepKey int,
	@AssignedUserKey int
	
AS --Encrypt
  /*
  || When		Who Rel			What
  || 09/15/11	MAS 10.5.4.7	Created for new ArtReview
  */

	INSERT tApprovalStepNotify
		(
		ApprovalStepKey,
		AssignedUserKey
		)

	VALUES
		(
		@ApprovalStepKey,
		@AssignedUserKey
		)

	RETURN 1
GO
