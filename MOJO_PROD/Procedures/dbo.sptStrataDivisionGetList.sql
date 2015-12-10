USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataDivisionGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataDivisionGetList]

	@CompanyKey int

AS --Encrypt

	SELECT 
		cd.ClientDivisionKey,
		cd.DivisionName,
		cd.Active,
		ISNULL(cd.LinkID, '0') as LinkID,
		ISNULL(c.CustomerID, '') as ClientID
	FROM 
		tClientDivision cd (nolock)
		left outer join tCompany c (nolock) on cd.ClientKey = c.CompanyKey
	WHERE
		cd.CompanyKey = @CompanyKey

	RETURN 1
GO
