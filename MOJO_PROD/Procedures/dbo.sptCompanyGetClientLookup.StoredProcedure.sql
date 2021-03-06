USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetClientLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetClientLookup]

	(
		@CompanyKey int,
		@CustomerID varchar(50)
	)

AS --Encrypt

if @CustomerID is null
	SELECT 
		CompanyKey,
		CustomerID,
		CompanyName
	FROM
		tCompany (nolock)
	WHERE
		OwnerCompanyKey = @CompanyKey AND
		BillableClient = 1 AND
		Active = 1
	ORDER BY
		CompanyName
else
	SELECT 
		CompanyKey,
		CustomerID,
		CompanyName
	FROM
		tCompany (nolock)
	WHERE
		OwnerCompanyKey = @CompanyKey AND
		BillableClient = 1 AND
		Active = 1 AND
		CustomerID Like @CustomerID+'%'
	ORDER BY
		CompanyName
GO
