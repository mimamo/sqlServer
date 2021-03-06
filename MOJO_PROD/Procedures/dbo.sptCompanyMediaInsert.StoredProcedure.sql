USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaInsert]
	@VendorKey int,
	@CompanyKey int,
	@MediaKind smallint,
	@Name varchar(250),
	@StationID varchar(50),
	@Date1Days int,
	@Date2Days int,
	@Date3Days int,
	@Date4Days int,
	@Date5Days int,
	@Date6Days int,
	@MediaMarketKey int,
	@ItemKey int,
	@Active tinyint,
	@Contact varchar(200),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@Phone varchar(50),
	@Fax varchar(50),
	@MAddress1 varchar(100),
	@MAddress2 varchar(100),
	@MAddress3 varchar(100),
	@MCity varchar(100),
	@MState varchar(50),
	@MPostalCode varchar(20),
	@MCountry varchar(50),
	@MPhone varchar(50),
	@MFax varchar(50),
	@MEmail varchar(200),
	@MMaterials varchar(4000),
	@PrintMaterialsInfo tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/14/12 MFT 10.554  (135183) Added Contact
*/


if exists(Select 1 from tCompanyMedia (nolock) Where CompanyKey = @CompanyKey and StationID = @StationID and MediaKind = @MediaKind)
	Return -1

	INSERT tCompanyMedia
		(
		VendorKey,
		CompanyKey,
		MediaKind,
		Name,
		StationID,
		Date1Days,
		Date2Days,
		Date3Days,
		Date4Days,
		Date5Days,
		Date6Days,
		MediaMarketKey,
		ItemKey,
		Active,
		Contact,
		Address1,
		Address2,
		Address3,
		City,
		State,
		PostalCode,
		Country,
		Phone,
		Fax,
		MAddress1,
		MAddress2,
		MAddress3,
		MCity,
		MState,
		MPostalCode,
		MCountry,
		MPhone,
		MFax,
		MEmail,
		MMaterials,
		PrintMaterialsInfo
		)

	VALUES
		(
		@VendorKey,
		@CompanyKey,
		@MediaKind,
		@Name,
		@StationID,
		@Date1Days,
		@Date2Days,
		@Date3Days,
		@Date4Days,
		@Date5Days,
		@Date6Days,
		@MediaMarketKey,
		@ItemKey,
		@Active,
		@Contact,
		@Address1,
		@Address2,
		@Address3,
		@City,
		@State,
		@PostalCode,
		@Country,
		@Phone,
		@Fax,
		@MAddress1,
		@MAddress2,
		@MAddress3,
		@MCity,
		@MState,
		@MPostalCode,
		@MCountry,
		@MPhone,
		@MFax,
		@MEmail,
		@MMaterials,
		@PrintMaterialsInfo
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
