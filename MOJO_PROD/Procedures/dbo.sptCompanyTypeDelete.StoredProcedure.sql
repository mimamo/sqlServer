USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeDelete]
	@CompanyTypeKey int

AS --Encrypt

	if exists(select 1 from tCompany (nolock) Where CompanyTypeKey = @CompanyTypeKey)
		return -1

	DELETE
	FROM tCompanyType
	WHERE
		CompanyTypeKey = @CompanyTypeKey 

	RETURN 1
GO
