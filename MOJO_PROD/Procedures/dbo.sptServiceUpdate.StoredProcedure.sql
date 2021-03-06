USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceUpdate]
	@ServiceKey int = 0,
	@CompanyKey int,
	@ServiceCode varchar(50),
	@Description varchar(100),
	@HourlyRate1 money,
	@HourlyRate2 money,
	@HourlyRate3 money,
	@HourlyRate4 money,
	@HourlyRate5 money,
	@Active tinyint,
	@Description1 varchar(100),
	@Description2 varchar(100),
	@Description3 varchar(100),
	@Description4 varchar(100),
	@Description5 varchar(100),
	@WorkTypeKey int,
	@DepartmentKey int,
	@GLAccountKey int,
	@ClassKey int,
	@HourlyCost money,
	@Taxable tinyint,
	@Taxable2 tinyint
	
AS --Encrypt

  /*
  || When     Who Rel      What
  || 06/14/07 GWG 8.5      Added the departmentKey
  || 07/29/09 MFT 10.5.0.5 Added insert logic
  || 01/15/10 GWG 10.517   Add the service into any rate sheets that exists
  || 9/19/11  CRG 10.5.4.8 (121294) Added call to sptLayoutBillingInsertNewItem
  || 04/07/14 GHL 10.5.7.9 (212198) Added blanking of services for users
  ||                       when the service is made inactive
  */

if exists(select 1 from tService (NOLOCK) 
		Where CompanyKey = @CompanyKey 
		and ServiceCode = @ServiceCode
		and ServiceKey <> @ServiceKey)
	Return -1

declare @CurrActive int

IF @ServiceKey > 0
	BEGIN
		select @CurrActive = Active from tService (nolock) where ServiceKey = @ServiceKey

		UPDATE
			tService
		SET
			CompanyKey = @CompanyKey,
			ServiceCode = @ServiceCode,
			Description = @Description,
			HourlyRate1 = @HourlyRate1,
			HourlyRate2 = @HourlyRate2,
			HourlyRate3 = @HourlyRate3,
			HourlyRate4 = @HourlyRate4,
			HourlyRate5 = @HourlyRate5,
			Active = @Active,
			Description1 = @Description1,
			Description2 = @Description2,
			Description3 = @Description3,
			Description4 = @Description4,
			Description5 = @Description5,
			WorkTypeKey = @WorkTypeKey,
			DepartmentKey = @DepartmentKey,
			GLAccountKey = @GLAccountKey,
			ClassKey = @ClassKey,
			HourlyCost = @HourlyCost,
			Taxable = @Taxable,
			Taxable2 = @Taxable2
		WHERE
			ServiceKey = @ServiceKey
		
		if isnull(@CurrActive, 0) = 1 and isnull(@Active, 0) = 0
		begin
			delete tUserService where ServiceKey = @ServiceKey
			
			update tUser set DefaultServiceKey = null 
			where isnull(OwnerCompanyKey, CompanyKey) = @CompanyKey and  DefaultServiceKey = @ServiceKey
		end 

		RETURN @ServiceKey
	END
ELSE
	BEGIN
		IF @Active IS NULL
			SELECT @Active = 1
		
		INSERT tService
		(
			CompanyKey,
			ServiceCode,
			Description,
			HourlyRate1,
			HourlyRate2,
			HourlyRate3,
			HourlyRate4,
			HourlyRate5,
			Active,
			Description1,
			Description2,
			Description3,
			Description4,
			Description5,
			WorkTypeKey,
			DepartmentKey,
			GLAccountKey,
			ClassKey,
			HourlyCost,
			Taxable,
			Taxable2
		  )
		VALUES
		(
			@CompanyKey,
			@ServiceCode,
			@Description,
			@HourlyRate1,
			@HourlyRate2,
			@HourlyRate3,
			@HourlyRate4,
			@HourlyRate5,
			@Active,
			@Description1,
			@Description2,
			@Description3,
			@Description4,
			@Description5,
			@WorkTypeKey,
			@DepartmentKey,
			@GLAccountKey,
			@ClassKey,
			@HourlyCost,
			@Taxable,
			@Taxable2
  		)
  		
  		Select @ServiceKey = @@Identity
  		
		-- insert the service into all rate sheets
		INSERT tTimeRateSheetDetail
		(
			TimeRateSheetKey,
			ServiceKey,
			HourlyRate1,
			HourlyRate2,
			HourlyRate3,
			HourlyRate4,
			HourlyRate5
		)
		Select 
			TimeRateSheetKey,
			@ServiceKey,
			@HourlyRate1,
			@HourlyRate2,
			@HourlyRate3,
			@HourlyRate4,
			@HourlyRate5
		From tTimeRateSheet Where CompanyKey = @CompanyKey
  		
		DECLARE @RetVal int
		EXEC @RetVal = sptLayoutBillingInsertNewItem 'tService', @ServiceKey

		IF @RetVal <= 0
			RETURN @RetVal
		ELSE
			RETURN @ServiceKey
	END
GO
