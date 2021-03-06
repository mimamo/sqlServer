USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyGetAllDetails]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyGetAllDetails]
	@CompanyKey int

AS --Encrypt

/*
|| When     Who Rel       What
|| 03/03/09 RLB 10.5.1.9  Created
|| 06/03/11 GHL 10.5.4.5  Added Account Name/Number
|| 06/01/12 MFT 10.5.5.6  Added GLCompanyAccess
|| 06/20/12 MFT 10.5.5.7 Added AddressName to tGLCompany for export/import
*/

-- Gl Companies 
SELECT glc.*
	,CASE WHEN glc.AddressKey IS NOT NULL THEN glad.AddressName ELSE ad.AddressName END AS AddressName
	,gla.AccountNumber
	,gla.AccountName
FROM  tGLCompany glc (nolock)
	INNER JOIN tCompany c (nolock) ON glc.CompanyKey = c.CompanyKey
	LEFT OUTER JOIN tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	LEFT OUTER JOIN tAddress glad (nolock) on glc.AddressKey = glad.AddressKey
	LEFT OUTER JOIN tGLAccount gla (nolock) on glc.BankAccountKey = gla.GLAccountKey
WHERE glc.CompanyKey = @CompanyKey

--  Addresses
SELECT tAddress.*
FROM tAddress (nolock)
WHERE CompanyKey = @CompanyKey

-- GL Company Access
SELECT *
FROM tGLCompanyAccess
WHERE CompanyKey = @CompanyKey
GO
