USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractClientGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractClientGet]
	@CompanyMediaContractKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/19/13 MFT 10.569  Created
*/

SELECT
	mc.CompanyMediaContractKey,
	c.CompanyKey,
	c.CompanyName,
	c.CustomerID AS ClientID
FROM
	tCompanyMediaContractClient mc (nolock)
	INNER JOIN tCompany c (nolock) ON mc.CompanyKey = c.CompanyKey
WHERE
	mc.CompanyMediaContractKey = @CompanyMediaContractKey
GO
