USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetVendorsList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherGetVendorsList]

	(
		@CompanyKey int
	)

AS --Encrypt

SELECT 
	tCompany.VendorID + ' - ' + tCompany.CompanyName AS VendorFullName,
    tCompany.CompanyKey
FROM 
	tCompany (NOLOCK) INNER JOIN tVoucher (NOLOCK) ON 
    tCompany.CompanyKey = tVoucher.VendorKey
WHERE 
	tVoucher.CompanyKey = @CompanyKey
GROUP BY
	tCompany.VendorID + ' - ' + tCompany.CompanyName, tCompany.CompanyKey
GO
