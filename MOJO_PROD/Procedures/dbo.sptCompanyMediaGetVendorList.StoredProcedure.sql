USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaGetVendorList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaGetVendorList]
	@CompanyKey int,
	@VendorID varchar(50),
	@MediaType smallint

AS

if @VendorID is null
	SELECT *
	FROM 	
		tCompanyMedia cm (nolock)
		INNER JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
	WHERE
		MediaKind = @MediaType and cm.CompanyKey = @CompanyKey
	Order By
		StationID
else

	SELECT *
	FROM 	
		tCompanyMedia cm (nolock)
		INNER JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
	WHERE
		MediaKind = @MediaType and cm.CompanyKey = @CompanyKey and c.VendorID LIKE @VendorID + '%'
	Order By
		StationID
	
	RETURN 1
GO
