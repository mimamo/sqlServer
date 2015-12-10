USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceInsert]
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
	@Taxable2 tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt


  /*
  || When     Who Rel   What
  || 06/14/07 GWG 8.5   Added the departmentKey
  || 01/15/10 GWG 10.517 Add the service into any rate sheets that exists
  */
  
if exists(select 1 from tService (NOLOCK) Where CompanyKey = @CompanyKey and ServiceCode = @ServiceCode)
	Return -1

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
 
 SELECT @oIdentity = @@IDENTITY
 
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
  @oIdentity,
  @HourlyRate1,
  @HourlyRate2,
  @HourlyRate3,
  @HourlyRate4,
  @HourlyRate5
 From tTimeRateSheet Where CompanyKey = @CompanyKey
 
 
 RETURN 1
GO
