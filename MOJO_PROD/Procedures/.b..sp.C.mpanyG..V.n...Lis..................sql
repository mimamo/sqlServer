USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetVendorList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetVendorList]

	(
		@CompanyKey int
	)

AS --Encrypt

	SELECT 
		CompanyKey,
		CompanyName as VendorFullName
	FROM
		tCompany (nolock)
	WHERE
		OwnerCompanyKey = @CompanyKey AND
		Vendor = 1 AND
		Active = 1
	ORDER BY
		CompanyName
GO
