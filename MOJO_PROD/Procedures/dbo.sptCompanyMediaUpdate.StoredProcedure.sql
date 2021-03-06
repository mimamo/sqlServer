USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaUpdate]
	@CompanyMediaKey int = NULL,
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
	@Frequency varchar(50),
	@MediaCategoryKey int,
	@Commission decimal(24,4),
	@MediaUnitTypeKey int,
	@Circulation int,
	@URL varchar(200),
	@CallLetters varchar(50) = null,
	@Channel varchar(50) = null,
	@MediaAffiliateKey int = null,
	@SalesTaxKey int = null,
	@SalesTax2Key int = null
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/14/12 MFT 10.554  (135183) Added Contact
|| 06/05/13 MFT 10.569  Added INSERT logic
|| 06/19/13 MFT 10.569  Added Frequency
|| 01/21/14 PLC 10.575  Added Call Letters Channel and Media Affilate
|| 02/18/14 PLC 10.576  Made the Call Letters Channel and Media Affilate optional
|| 02/18/14 CRG 10.576  Added a "dummy" parm called @CallLeters due to a typo in the VB code. This should be removed for 10.5.7.7
|| 10/02/14 GHL 10.584  Added sales taxes
*/

IF EXISTS(
	SELECT *
	FROM tCompanyMedia (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		StationID = @StationID AND
		MediaKind = @MediaKind AND
		(
			ISNULL(@CompanyMediaKey, 0) = 0 OR
			CompanyMediaKey <> ISNULL(@CompanyMediaKey, 0)
		)
	) RETURN -1

IF ISNULL(@CompanyMediaKey, 0) > 0
	UPDATE
		tCompanyMedia
	SET
		VendorKey = @VendorKey,
		MediaKind = @MediaKind,
		Name = @Name,
		StationID = @StationID,
		Date1Days = @Date1Days,
		Date2Days = @Date2Days,
		Date3Days = @Date3Days,
		Date4Days = @Date4Days,
		Date5Days = @Date5Days,
		Date6Days = @Date6Days,
		MediaMarketKey = @MediaMarketKey,
		ItemKey = @ItemKey,
		Active = @Active,
		Contact = @Contact,
		Address1 = @Address1,
		Address2 = @Address2,
		Address3 = @Address3,
		City = @City,
		State = @State,
		PostalCode = @PostalCode,
		Country = @Country,
		Phone = @Phone,
		Fax = @Fax,
		MAddress1 = @MAddress1,
		MAddress2 = @MAddress2,
		MAddress3 = @MAddress3,
		MCity = @MCity,
		MState = @MState,
		MPostalCode = @MPostalCode,
		MCountry = @MCountry,
		MPhone = @MPhone,
		MFax = @MFax,
		MEmail = @MEmail,
		MMaterials = @MMaterials,
		PrintMaterialsInfo = @PrintMaterialsInfo,
		Frequency = @Frequency,
		MediaCategoryKey = @MediaCategoryKey,
		Commission = @Commission,
		DefaultMediaUnitTypeKey = @MediaUnitTypeKey,
		Circulation = @Circulation,
		URL = @URL,
		CallLetters = @CallLetters,
		Channel = @Channel,
		MediaAffiliateKey = @MediaAffiliateKey,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key
	WHERE
		CompanyMediaKey = @CompanyMediaKey 
ELSE
	BEGIN
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
			PrintMaterialsInfo,
			Frequency,
			MediaCategoryKey,
			Commission,
			DefaultMediaUnitTypeKey,
			Circulation,
			URL,
			CallLetters,
			Channel,
			MediaAffiliateKey,
			SalesTaxKey,
			SalesTax2Key
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
			@PrintMaterialsInfo,
			@Frequency,
			@MediaCategoryKey,
			@Commission,
			@MediaUnitTypeKey,
			@Circulation,
			@URL,
			@CallLetters,
			@Channel,
			@MediaAffiliateKey,
			@SalesTaxKey,
			@SalesTax2Key
		)
		
		SELECT @CompanyMediaKey = SCOPE_IDENTITY()
	END

RETURN @CompanyMediaKey
GO
