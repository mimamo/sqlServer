USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyInsertUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyInsertUpdate]
	(
	@CompanyKey int,
	@CompanyName varchar(200),
	@OwnerCompanyKey int,
	@ParentCompany tinyint,
	@ParentCompanyKey int,
	@PrimaryContact int,
	@Phone varchar(50),
	@Fax varchar(50),
	@WebSite varchar(100),
	@SourceKey int,
	@CompanyTypeKey int,
	@DefaultAddressKey int,
	@CMFolderKey int,
	@ContactOwnerKey int,
	@AccountManagerKey int,
	@SalesPersonKey int,
	@Comments text,
	@Active tinyint,
	@UserKey int
	)

AS --Encrypt
	
/*
|| When     Who Rel		What
|| 07/23/08 GHL 10.005  Creation for new flash screen
*/

	SET NOCOUNT ON

	Declare @Error int, @InsertCompanyKey int
	Declare @GetRateFrom smallint, @TimeRateSheetKey int, @HourlyRate money, @GetMarkupFrom smallint, 
		@ItemRateSheetKey int, @ItemMarkup decimal(24,4), @IOCommission decimal(24,4), 
		@BCCommission decimal(24,4), @PaymentTermsKey int, @DefaultARLineFormat smallint

	If @CompanyKey <= 0
	Begin
		-- Insert Mode
		
		-- Get defaults from owner company key
		Select
			@GetRateFrom = GetRateFrom,
			@TimeRateSheetKey = TimeRateSheetKey,
			@HourlyRate = HourlyRate,
			@GetMarkupFrom = GetMarkupFrom,
			@ItemRateSheetKey = ItemRateSheetKey,
			@ItemMarkup = ItemMarkup,
			@IOCommission = IOCommission,
			@BCCommission = BCCommission,
			@PaymentTermsKey = PaymentTermsKey,
			@DefaultARLineFormat = DefaultARLineFormat
		From 
			tPreference (nolock)
		Where CompanyKey = @OwnerCompanyKey

		INSERT tCompany
			(
			CompanyName,
			ParentCompany,
			ParentCompanyKey,
			OwnerCompanyKey,
			SourceKey,
			CompanyTypeKey,
			CMFolderKey,
			ContactOwnerKey,
			AccountManagerKey,
			SalesPersonKey,
			Phone,
			Fax,
			WebSite,
			Comments,
			Active,
			
			-- below are system or default fields 
			CreatedBy,
			DateAdded,
			GetRateFrom,
			TimeRateSheetKey,
			HourlyRate,
			GetMarkupFrom,
			ItemRateSheetKey,
			ItemMarkup,
			IOCommission,
			BCCommission,
			PaymentTermsKey,
			DefaultARLineFormat
			)

		VALUES
			(
			@CompanyName,
			@ParentCompany,
			@ParentCompanyKey,
			@OwnerCompanyKey,
			@SourceKey,
			@CompanyTypeKey,
			@CMFolderKey,
			@ContactOwnerKey,
			@AccountManagerKey,
			@SalesPersonKey,
			@Phone,
			@Fax,
			@WebSite,
			@Comments,
			1,
			
			-- below are system or default fields 
			@UserKey,
			GETUTCDATE(),
			@GetRateFrom,
			@TimeRateSheetKey,
			@HourlyRate,
			@GetMarkupFrom,
			@ItemRateSheetKey,
			@ItemMarkup,
			@IOCommission,
			@BCCommission,
			@PaymentTermsKey,
			@DefaultARLineFormat
			)
		
		SELECT @Error = @@ERROR, @InsertCompanyKey = @@IDENTITY
	
		IF @Error <> 0
			RETURN -1
		ELSE
			RETURN @InsertCompanyKey 
	End 
	
	Else 
	Begin
		-- Update Mode
		
		UPDATE tCompany
		SET    CompanyName = @CompanyName
			  ,ParentCompany = @ParentCompany
			  ,ParentCompanyKey = @ParentCompanyKey
			  ,PrimaryContact = @PrimaryContact
			  ,Phone = @Phone
			  ,Fax = @Fax
			  ,WebSite = @WebSite
			  ,SourceKey = @SourceKey
			  ,CompanyTypeKey = @CompanyTypeKey
			  ,DefaultAddressKey = @DefaultAddressKey
			  ,CMFolderKey = @CMFolderKey
			  ,ContactOwnerKey = @ContactOwnerKey
			  ,AccountManagerKey = @AccountManagerKey
			  ,SalesPersonKey = @SalesPersonKey
			  ,Comments = @Comments
			  ,Active = @Active
			  ,ModifiedBy = @UserKey
			  ,DateUpdated = GETUTCDATE()
		WHERE  CompanyKey = @CompanyKey

		IF @@ERROR <> 0
			RETURN -1
		ELSE
			RETURN @CompanyKey 	
	
	End
GO
