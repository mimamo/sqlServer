USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyGet]
	@GLCompanyKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 10/27/08 GHL 10.011  (34982) Added address info for 1099 reporting
|| 06/06/11 GHL 10.545  Added bank account info
|| 03/27/13 MFT 10.566  Added second block of address aliases to mimic Company get
*/
		SELECT glc.*,

		-- for reporting and 1099 purposes 

		glc.PrintedName AS CompanyName, -- PrintedName on GLCompany will be used in lieu of CompanyName
		
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address1 ELSE ad.Address1 END as DAddress1,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address2 ELSE ad.Address2 END as DAddress2,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address3 ELSE ad.Address3 END as DAddress3,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.City ELSE ad.City END as DCity,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.State ELSE ad.State END as DState,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.PostalCode ELSE ad.PostalCode END as DPostalCode,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Country ELSE ad.Country END as DCountry,
		
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address1 ELSE ad.Address1 END as Address1,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address2 ELSE ad.Address2 END as Address2,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Address3 ELSE ad.Address3 END as Address3,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.City ELSE ad.City END as City,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.State ELSE ad.State END as State,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.PostalCode ELSE ad.PostalCode END as PostalCode,
		CASE WHEN glc.AddressKey IS NOT NULL THEN glad.Country ELSE ad.Country END as Country,
		
		gla.AccountNumber,
		gla.AccountName
		
		FROM tGLCompany glc (nolock)
			INNER JOIN tCompany c (nolock) ON glc.CompanyKey = c.CompanyKey
			LEFT OUTER JOIN tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
			LEFT OUTER JOIN tAddress glad (nolock) on glc.AddressKey = glad.AddressKey
		    LEFT OUTER JOIN tGLAccount gla (nolock) on glc.BankAccountKey = gla.GLAccountKey

		WHERE
			glc.GLCompanyKey = @GLCompanyKey

	RETURN 1
GO
