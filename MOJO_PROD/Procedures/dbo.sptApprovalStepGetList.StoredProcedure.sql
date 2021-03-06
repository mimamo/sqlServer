USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGetList]
	@ApprovalStepKey int = NULL,
	@Entity varchar(50) = NULL,
	@EntityKey int = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 04/26/13  MFT 10.5.5.7 Moved Entity/EntityKey to input parameters to support more standardized use
*/
	
	IF ISNULL(@ApprovalStepKey, 0) > 0
		SELECT @Entity = Entity, @EntityKey = EntityKey
		FROM tApprovalStep (nolock)
		WHERE ApprovalStepKey = @ApprovalStepKey
	
	SELECT *
	FROM tApprovalStep asd (nolock)
	WHERE
		asd.Entity = @Entity AND
		asd.EntityKey = @EntityKey
	ORDER BY asd.DisplayOrder

	RETURN 1
GO
