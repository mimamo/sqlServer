USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeGet]
	@CompanyTypeKey int

AS --Encrypt

		SELECT *
		FROM tCompanyType (nolock)
		WHERE
			CompanyTypeKey = @CompanyTypeKey

	RETURN 1
GO
