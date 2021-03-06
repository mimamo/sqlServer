USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetVendorLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetVendorLookup]

	(
		@CompanyKey int,
		@VendorID varchar(50)
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 03/28/07 RTC 8.4.1 (8721) Corrected VendorName, VendorFullName erors in listings (9)
*/

if @VendorID is null
	SELECT 
		CompanyKey,
		VendorID,
		CompanyName,
		CompanyName as VendorName,
		VendorID + ' - ' + CompanyName as VendorFullName
	FROM
		tCompany (nolock)
	WHERE
		OwnerCompanyKey = @CompanyKey AND
		Vendor = 1 AND
		Active = 1
	ORDER BY
		CompanyName
else
	SELECT 
		CompanyKey,
		VendorID,
		CompanyName,
		CompanyName as VendorName,
		VendorID + ' - ' + CompanyName as VendorFullName
	FROM
		tCompany (nolock)
	WHERE
		OwnerCompanyKey = @CompanyKey AND
		Vendor = 1 AND
		Active = 1 AND
		VendorID Like @VendorID+'%'
	ORDER BY
		CompanyName
GO
