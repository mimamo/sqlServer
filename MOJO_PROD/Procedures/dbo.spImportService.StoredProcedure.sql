USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportService]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportService]
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
	@WorkTypeID varchar(100),
	@GLAccountNumber varchar(100),
	@ClassID varchar(50)
	
AS --Encrypt

Declare @WorkTypeKey int
		,@ClassKey int
		,@GLAccountKey int
		
if exists(select 1 from tService (nolock) Where CompanyKey = @CompanyKey and ServiceCode = @ServiceCode)
	Return -1

Select @WorkTypeKey = WorkTypeKey from tWorkType (nolock) Where WorkTypeID = @WorkTypeID and CompanyKey = @CompanyKey

if @ClassID is not null
begin
	Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey
	if @ClassKey is null
		return -2

end

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -2

if @GLAccountNumber is not null
begin
	Select @GLAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @GLAccountNumber and CompanyKey = @CompanyKey
	if @GLAccountKey is null
		return -3

end


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
		GLAccountKey,
		ClassKey
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
		ISNULL(@Active, 1),
		@Description1,
		@Description2,
		@Description3,
		@Description4,
		@Description5,
		@WorkTypeKey,
		@GLAccountKey,
		@ClassKey
  )
 
 RETURN 1
GO
