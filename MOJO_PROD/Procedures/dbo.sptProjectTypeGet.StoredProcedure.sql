USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeGet]
	@ProjectTypeKey int = null,
	@ProjectTypeName varchar(100) = null,
	@CompanyKey int = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/26/11   RLB 10544   Needed to change  SP to work with updates to Project Types when importing them.
*/



IF ISNULL(@ProjectTypeKey, 0) = 0
	SELECT *
	FROM tProjectType (NOLOCK)
	WHERE 
		CompanyKey = @CompanyKey AND ProjectTypeName = @ProjectTypeName
ELSE	
	SELECT *
	FROM tProjectType (NOLOCK) 
	WHERE
		ProjectTypeKey = @ProjectTypeKey

	RETURN 1
GO
