USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetContactLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetContactLookup]

	(
		@CompanyKey int,
		@CustomerID varchar(50),
		@Type smallint = 0
	)

AS --Encrypt

if @Type = 0
	SELECT 
		u.FirstName,
		u.LastName,
		u.FirstName + ' ' + u.LastName as UserName
	FROM
		tCompany c (nolock) inner join tUser u (nolock) on c.CompanyKey = u.CompanyKey
	WHERE
		c.OwnerCompanyKey = @CompanyKey AND
		c.BillableClient = 1 AND
		c.Active = 1 AND
		u.Active = 1 AND
		c.CustomerID = @CustomerID
	ORDER BY
		u.LastName

else
	SELECT 
		u.FirstName,
		u.LastName,
		u.FirstName + ' ' + u.LastName as UserName
	FROM
		tCompany c (nolock) inner join tUser u (nolock) on c.CompanyKey = u.CompanyKey
	WHERE
		c.OwnerCompanyKey = @CompanyKey AND
		c.Vendor = 1 AND
		c.Active = 1 AND
		u.Active = 1 AND
		c.VendorID = @CustomerID
	ORDER BY
		u.LastName
GO
