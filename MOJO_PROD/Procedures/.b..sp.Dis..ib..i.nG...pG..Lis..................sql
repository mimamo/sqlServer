USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupGetList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupGetList]
	(
		@CompanyKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT *
	FROM   tDistributionGroup (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    (UserKey IS NULL OR UserKey = @UserKey)

	RETURN
GO
