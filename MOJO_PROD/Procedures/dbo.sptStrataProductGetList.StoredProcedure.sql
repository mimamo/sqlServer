USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataProductGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataProductGetList]

	@CompanyKey int

AS --Encrypt

	SELECT 
		cp.ClientProductKey,
		cp.ProductName,
		cp.Active,
		ISNULL(cp.LinkID, '0') as LinkID,
		ISNULL(c.CustomerID, '0') as ClientID,
		ISNULL(d.LinkID, '0') as ClientDivisionLinkID
	FROM 
		tClientProduct cp (nolock)
		left outer join tCompany c (nolock) on cp.ClientKey = c.CompanyKey
		left outer join tClientDivision d (nolock) on d.ClientDivisionKey = cp.ClientDivisionKey 
	WHERE
		cp.CompanyKey = @CompanyKey

	RETURN 1
GO
