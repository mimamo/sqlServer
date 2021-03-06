USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGetActive]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGetActive]
	@Entity varchar(50),
	@EntityKey int

AS --Encrypt

		SELECT *
		FROM tApprovalStep (nolock)
		WHERE
			Entity = @Entity and 
			EntityKey = @EntityKey and
			(ISNULL(Completed, 0) = 0 OR ActiveStep = 1)
		Order By DisplayOrder

	RETURN 1
GO
