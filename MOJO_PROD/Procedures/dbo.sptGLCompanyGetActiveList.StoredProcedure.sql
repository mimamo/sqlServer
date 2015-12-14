USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyGetActiveList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyGetActiveList]

	@CompanyKey int,
	@GLCompanyKey int = NULL


AS --Encrypt

		SELECT *
		FROM tGLCompany
		WHERE
		CompanyKey = @CompanyKey and (Active = 1 or GLCompanyKey = @GLCompanyKey)

	RETURN 1
GO
