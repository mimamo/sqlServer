USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepNotifyDelete]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepNotifyDelete]
	@ApprovalStepKey int

AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/15/11	MAS 10.5.4.7	Created for new ArtReview
  */
	
	DELETE
	FROM tApprovalStepNotify
	WHERE
		ApprovalStepKey = @ApprovalStepKey 


	RETURN 1
GO
