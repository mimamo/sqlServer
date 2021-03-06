USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaValidID]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaValidID]

	(
		@CompanyKey int,
		@MediaKind smallint,
		@VendorID varchar(50),
		@StationID varchar(50)
	)

AS --Encrypt

Declare @Key int

if @VendorID is null
	Select @Key = CompanyMediaKey
	From tCompanyMedia (nolock)
	inner join tCompany on tCompanyMedia.VendorKey = tCompany.CompanyKey
	Where
		tCompanyMedia.CompanyKey = @CompanyKey and
		MediaKind = @MediaKind and
		StationID = @StationID
else
	Select @Key = CompanyMediaKey
	From tCompanyMedia (nolock)
	inner join tCompany on tCompanyMedia.VendorKey = tCompany.CompanyKey
	Where
		tCompanyMedia.CompanyKey = @CompanyKey and
		tCompany.VendorID = @VendorID and
		MediaKind = @MediaKind and
		StationID = @StationID
	
	
Return ISNULL(@Key, 0)
GO
