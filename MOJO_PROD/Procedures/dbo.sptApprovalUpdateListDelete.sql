USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalUpdateListDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalUpdateListDelete]
	(
		@ApprovalKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	DELETE tApprovalUpdateList WHERE ApprovalKey = @ApprovalKey
		
	RETURN 1
GO
