USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalUpdateListInsert]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalUpdateListInsert]
	(
		@ApprovalKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	INSERT tApprovalUpdateList (ApprovalKey, UserKey)
	VALUES (@ApprovalKey, @UserKey)	
	
	RETURN 1
GO
