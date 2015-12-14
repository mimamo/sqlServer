USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_VendorsMarkDownloaded]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spvExport_VendorsMarkDownloaded]

	(
		@CompanyKey int
	)

AS --Encrypt


Update tCompany
Set VendorDownloaded = 1
Where
	OwnerCompanyKey = @CompanyKey and
	Vendor = 1 and
	(VendorDownloaded = 0 or VendorDownloaded is null)
GO
