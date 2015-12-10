USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaVendorGet]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaVendorGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/07/13 MFT 10.569  Created
*/

SELECT
	mv.CompanyMediaKey,
	v.CompanyKey,
	v.CompanyName,
	v.VendorID
FROM
	tCompanyMediaVendor mv (nolock)
	INNER JOIN tCompany v (nolock) ON mv.CompanyKey = v.CompanyKey 
WHERE
	mv.CompanyMediaKey = @CompanyMediaKey
GO
