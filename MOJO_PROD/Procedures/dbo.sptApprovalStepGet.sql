USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGet]
	@ApprovalStepKey int

AS --Encrypt

	/*
	|| When     Who		Rel			What
	|| 05/07/14 QMD		10.5.7.9	Added TimeZoneDescription
	*/
		
		SELECT tApprovalStep.*, TimeZoneDescription = ''
		FROM tApprovalStep (nolock)
		WHERE
			ApprovalStepKey = @ApprovalStepKey

	RETURN 1
GO
