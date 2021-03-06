USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyValidVendorRow]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyValidVendorRow]
	@CompanyKey int,
	@VendorID varchar(50),
	@ActiveOnly tinyint
AS

 /*
 || When    Who Rel      What
 || 3/6/10  CRG 10.5.1.9 Created for the ItemRateManager vendor validation
 */
  
	SELECT	*
	FROM	tCompany  (nolock)
	WHERE	OwnerCompanyKey = @CompanyKey
	AND		UPPER(VendorID) = UPPER(@VendorID)
	AND		Vendor = 1
	AND		Active >= @ActiveOnly
GO
