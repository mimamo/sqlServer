USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserGetRejected]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserGetRejected]

	(
		@ApprovalStepKey int
	)

AS --Encrypt

/*
|| When     Who Rel			What
|| 07/02/12 QMD 10.5.5.7    Added the action to the sptApprovalStep update
*/

SELECT * FROM tApprovalStepUser (NOLOCK) WHERE ApprovalStepKey = @ApprovalStepKey AND Action = 2 AND CompletedUser = 1
GO
