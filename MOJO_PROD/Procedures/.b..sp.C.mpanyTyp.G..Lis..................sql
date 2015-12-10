USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCompanyType (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By CompanyTypeName

	RETURN 1
GO
