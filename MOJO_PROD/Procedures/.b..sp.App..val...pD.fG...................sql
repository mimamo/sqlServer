USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefGet]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefGet]
	@ApprovalStepDefKey int

AS --Encrypt

		SELECT *
		FROM tApprovalStepDef (nolock)
		WHERE
			ApprovalStepDefKey = @ApprovalStepDefKey

	RETURN 1
GO
