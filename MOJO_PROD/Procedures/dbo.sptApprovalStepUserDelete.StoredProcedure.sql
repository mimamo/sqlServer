USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDelete]
	@ApprovalStepKey int

AS --Encrypt
	
	DELETE
	FROM tApprovalStepUser
	WHERE
		ApprovalStepKey = @ApprovalStepKey 


	RETURN 1
GO
