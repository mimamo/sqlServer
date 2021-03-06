USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGetList]
	@CompanyKey int
	,@RetainerKey int = null		-- To handle cases when retainer is no longer active
	,@ClientKey int = null
	,@GLCompanyKey int = null

AS -- Encrypt

/*
|| When      Who Rel     What
|| 4/15/08   CRG 1.0.0.0 Added ClientKey and GLCompanyKey optional parameters
*/
		
	SELECT	*
	FROM	tRetainer (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		(
			(@RetainerKey IS NULL AND Active = 1)
			OR
			(RetainerKey = @RetainerKey OR Active = 1 )
			)
	AND		(ClientKey = @ClientKey OR @ClientKey IS NULL)
	AND		(GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
	
	RETURN 1
GO
