USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStringCompanyDeleteAll]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptStringCompanyDeleteAll]
	@CompanyKey int
	
AS --Encrypt

	delete tStringCompany
	 where CompanyKey = @CompanyKey
	 
	return 1
GO
