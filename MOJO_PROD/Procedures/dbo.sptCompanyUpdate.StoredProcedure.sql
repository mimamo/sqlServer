USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdate]
	@CompanyKey int,
	@CompanyName varchar(200),
	@SourceKey int,
	@CompanyTypeKey int,
	@PrimaryContact int,
	@OwnerCompanyKey int,
	@Phone varchar(20),
	@Fax varchar(20),
	@WebSite varchar(100),
	@Active tinyint,
	@CMFolderKey int,
	@ContactOwnerKey int,
	@AccountManagerKey int,
	@SalesPersonKey int,
	@Comments text,
	@UserKey int,
	@DateConverted smalldatetime

AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/05/09 MAS 10.5  Added CustomFieldKey
  || 09/09/09 GWG 10.509 Removed CustomFieldKey
  || 11/24/09 GWG 10.514 Added an update to UserCompanyName 
  || 03/19/10 RLB 10.520 Getting Company Defaults
  || 07/09/12 GHL 10.558 If we restrict by gl company, get default from user and add to tGLCompanyAccess
  || 10/8/12  CRG 10.5.6.1 Added call to sptCompanyWebDavSafeFolders for new Companies. It'll be called from VB for existing Companies.
  */

  Declare
 @GetRateFrom int,
 @TimeRateSheetKey int,
 @HourlyRate money,
 @GetMarkupFrom int,
 @ItemRateSheetKey int, 
 @ItemMarkup decimal(24,4),
 @IOCommission decimal(24,4),
 @BCCommission decimal(24,4),
 @RestrictToGLCompany int,
 @GLCompanyKey int



if @CompanyKey = 0
BEGIN
		select @GetRateFrom = isnull(GetRateFrom, 1) 
			,@TimeRateSheetKey = isnull(TimeRateSheetKey, 0) 
			, @HourlyRate = isnull(HourlyRate, 0) 
			, @GetMarkupFrom = isnull(GetMarkupFrom, 1) 
			, @ItemRateSheetKey = isnull(ItemRateSheetKey, 0)
			, @ItemMarkup = isnull(ItemMarkup, 0) 
			, @IOCommission = isnull(IOCommission, 0) 
			, @BCCommission = isnull(BCCommission, 0) 
			, @RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
		from tPreference (nolock) where CompanyKey = @OwnerCompanyKey

		INSERT tCompany
		(
			CompanyName,
			SourceKey,
			CompanyTypeKey,
			PrimaryContact,
			OwnerCompanyKey,
			Phone,
			Fax,
			WebSite,
			Active,
			CMFolderKey,
			ContactOwnerKey,
			AccountManagerKey,
			SalesPersonKey,
			Comments,
			DateAdded,
			DateUpdated,
			CreatedBy,
			ModifiedBy,
			DateConverted,
			GetRateFrom,
			TimeRateSheetKey,
			HourlyRate,
			GetMarkupFrom,
			ItemRateSheetKey,
			ItemMarkup,
			IOCommission,
			BCCommission
		)
		VALUES
		(
			@CompanyName,
			@SourceKey,
			@CompanyTypeKey,
			@PrimaryContact,
			@OwnerCompanyKey,
			@Phone,
			@Fax,
			@WebSite,
			@Active,
			@CMFolderKey,
			@ContactOwnerKey,
			@AccountManagerKey,
			@SalesPersonKey,
			@Comments,
			GETUTCDATE(),
			GETUTCDATE(),
			@UserKey,
			@UserKey,
			@DateConverted,
			@GetRateFrom,
			@TimeRateSheetKey,
			@HourlyRate,
			@GetMarkupFrom,
			@ItemRateSheetKey,
			@ItemMarkup,
			@IOCommission,
			@BCCommission
		)

		Select @CompanyKey = @@IDENTITY

		--Set the WebDav safe folder names
		EXEC sptCompanyWebDavSafeFolders @CompanyKey

		if @RestrictToGLCompany = 1
		begin
			select @GLCompanyKey = GLCompanyKey
			from   tUser (nolock)
			where  UserKey = @UserKey

			if isnull(@GLCompanyKey, 0) > 0
			begin
				insert tGLCompanyAccess (Entity, EntityKey, GLCompanyKey, CompanyKey)
				values ('tCompany', @CompanyKey, @GLCompanyKey, @OwnerCompanyKey)
			end

		end
END
ELSE
BEGIN

		UPDATE
		tCompany
		SET
			CompanyName = @CompanyName,
			SourceKey = @SourceKey,
			CompanyTypeKey = @CompanyTypeKey,
			PrimaryContact = @PrimaryContact,
			Phone = @Phone,
			Fax = @Fax,
			WebSite = @WebSite,
			Active = @Active,
			CMFolderKey = @CMFolderKey,
			ContactOwnerKey = @ContactOwnerKey,
			AccountManagerKey = @AccountManagerKey,
			SalesPersonKey = @SalesPersonKey,
			Comments = @Comments,
			DateUpdated = GETUTCDATE(),
			ModifiedBy = @UserKey,
			DateConverted = @DateConverted
		WHERE
		CompanyKey = @CompanyKey 


END

	Update tUser Set UserCompanyName = @CompanyName Where CompanyKey = @CompanyKey


 RETURN @CompanyKey
GO
