USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDefGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDefGet]
	@ApprovalStepUserDefKey int

AS --Encrypt

		SELECT *
		FROM tApprovalStepUserDef (nolock)
		WHERE
			ApprovalStepUserDefKey = @ApprovalStepUserDefKey

	RETURN 1
GO
