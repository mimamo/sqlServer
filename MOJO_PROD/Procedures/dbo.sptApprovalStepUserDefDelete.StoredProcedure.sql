USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDefDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDefDelete]
	@ApprovalStepDefKey int

AS --Encrypt
	
	DELETE
	FROM tApprovalStepUserDef
	WHERE
		ApprovalStepDefKey = @ApprovalStepDefKey 


	RETURN 1
GO
