use mojo_prod
go

alter PROCEDURE [dbo].[sptProjectCreate]
 (
 @UserKey int,
 @ProjectName varchar(100),
 @ProjectNumber varchar(50),
 @CompanyKey int,
 @ProjectStatusKey int,
 @ProjectTypeKey int,
 @ClientDivisionKey int,
 @ClientProductKey int,
 @OfficeKey int,
 @GLCompanyKey int,
 @ClientKey int,
 @CampaignKey int,
 @ProjectColor varchar(10), 
 @SparkCustomization int = 0,
 @SparkModelYear varchar(10) = null, 
 @oIdentity INT OUTPUT
 
 )
AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/21/06 GHL 8.4   Added logic to prevent duplicates in tAssignment
  || 03/01/07 GHL 8.4   Added project rollup creation
  || 04/10/07 QMD 8.4.2	Added ProjectColor field -- See Issue 8638 for more information
  || 10/22/08 CRG 10.0.1.1 (38462) Added protection from ProjectStatusKey = 0
  || 11/06/08 GHL 10.0.1.2 Added protection against missing client
  || 01/10/09 GWG 10.0.1.6 Forced custom field key to 0
  || 01/27/09 MFT 10.0.1.8 (45458) Trim leading and trailing spaces from ProjectNumber
  || 12/12/09 GWG 10.5.1.4 Added protection against creating a project if default bill method is retainer and no retainer.
  || 10/5/10  RLB 10.5.3.6 (91563) Get default layout key from client if there is a client key
  || 02/27/12 GHL 10.5.5.3 (135372) Error out if the retainer is inactive and billing method is by retainer
  || 05/08/12 GHL 10.5.5.6 Do not auto assign users if we restrict to gl companies
  ||                       because if we create a project in one gl company, users in other gl companies would be assigned also
  || 08/24/12 MFT 10.5.5.9 Insert into tAssignment based on GLCompany restrictions 
  || 02/12/13 GHL 10.5.6.5 (167857) Added ModelYear for a custom for Spark44
  || 06/18/13 GHL 10.5.6.9 (181721) Added campaign key for new project numbers by campaign
  || 03/25/14 WDF 10.5.7.8 (210499) Added BillingMethod check for RetainerKey
  || 10/22/14 GAR 10.5.8.5 (233507) Moving the code that gets next project number below all validations so we don't increment
  ||						the project number if the validation fails.
  || 02/06/15 GHL 10.5.8.8 When copying defaults from the client, do not forget the title info
  || 11/24/15 MMM		   (34633) Adding input for product description.
 */

DECLARE @Error int
DECLARE @Active tinyint
Declare @AccountManager int
DECLARE @RetVal	INTEGER
Declare @NextTranNo VARCHAR(100)
declare @customFieldKey int
declare @FieldDefKey int

 -- Get the active status of the project status
 SELECT @Active = IsActive
 FROM tProjectStatus (NOLOCK) 
 WHERE ProjectStatusKey = @ProjectStatusKey 
  
 --Determine Billing Defaults
 Declare @GetRateFrom smallint, 
	@TimeRateSheetKey int, 
	@TitleRateSheetKey int,
	@HourlyRate money, 
	@GetMarkupFrom smallint, 
	@ItemRateSheetKey int, 
	@ItemMarkup decimal(24,4), 
	@IOCommission decimal(24,4), 
	@BCCommission decimal(24,4), 
	@DefaultRetainerKey int



 Declare @BillingMethod smallint, 
 @ExpensesNotIncluded tinyint, 
 @LayoutKey int, 
 @RestrictToGLCompany int, 
 @UseGLCompany int
 
 if ISNULL(@ClientKey, 0) = 0
	Select
		@GetRateFrom = ISNULL(GetRateFrom, 2),
		@TimeRateSheetKey = TimeRateSheetKey,
		@TitleRateSheetKey = TitleRateSheetKey,
		@HourlyRate = ISNULL(HourlyRate, 0),
		@GetMarkupFrom = ISNULL(GetMarkupFrom, 2),
		@ItemRateSheetKey = ItemRateSheetKey,
		@ItemMarkup = ISNULL(ItemMarkup, 0),
		@IOCommission = ISNULL(IOCommission, 0),
		@BCCommission = ISNULL(BCCommission, 0),
		@BillingMethod = 1,
		@ExpensesNotIncluded = 0,
		@LayoutKey = NULL,
		@UseGLCompany = ISNULL(UseGLCompany, 0),
		@RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	From
		tPreference (nolock)
	Where CompanyKey = @CompanyKey
 else
 begin
 	Select
		@GetRateFrom = ISNULL(c.GetRateFrom, ISNULL(p.GetRateFrom, 2)),
		@TimeRateSheetKey = ISNULL(c.TimeRateSheetKey, p.TimeRateSheetKey),
		@TitleRateSheetKey = ISNULL(c.TitleRateSheetKey, p.TitleRateSheetKey),
		@HourlyRate = ISNULL(c.HourlyRate, ISNULL(p.HourlyRate, 0)),
		@GetMarkupFrom = ISNULL(c.GetMarkupFrom, ISNULL(p.GetMarkupFrom, 2)),
		@ItemRateSheetKey = ISNULL(c.ItemRateSheetKey, p.ItemRateSheetKey),
		@ItemMarkup = ISNULL(c.ItemMarkup, ISNULL(p.ItemMarkup, 0)),
		@IOCommission = ISNULL(c.IOCommission, ISNULL(p.IOCommission, 0)),
		@BCCommission = ISNULL(c.BCCommission, ISNULL(p.BCCommission, 0)),
		@AccountManager = c.AccountManagerKey,
		@DefaultRetainerKey = c.DefaultRetainerKey,
		@DefaultRetainerKey = CASE WHEN ISNULL(c.DefaultBillingMethod, 1) = 3 THEN c.DefaultRetainerKey ELSE NULL END,
		@BillingMethod = ISNULL(c.DefaultBillingMethod, 1),
		@ExpensesNotIncluded = ISNULL(c.DefaultExpensesNotIncluded, 0),
		@LayoutKey = c.LayoutKey,
		@UseGLCompany = ISNULL(p.UseGLCompany, 0),
		@RestrictToGLCompany = ISNULL(p.RestrictToGLCompany, 0)
	From
		tCompany c (nolock) 
		inner join tPreference p (nolock) on c.OwnerCompanyKey = p.CompanyKey
	Where c.CompanyKey = @ClientKey
 
	If @@ROWCOUNT = 0
		RETURN -3
 end
 
if @UseGLCompany = 0
	select @RestrictToGLCompany = 0

if @BillingMethod = 3 and ISNULL(@DefaultRetainerKey, 0) = 0
	return -5
	
-- make sure that the retainer is still active
if @BillingMethod = 3 
begin 
	if not exists (select 1 from tRetainer (nolock) 
				where RetainerKey = @DefaultRetainerKey
				and   Active = 1)
		return -5
end

 --Protect against ProjectStatusKey = 0
 IF ISNULL(@ProjectStatusKey, 0) = 0
	RETURN -1
 
 -- Last resort protection against null
 Select
		@GetRateFrom = ISNULL(@GetRateFrom, 2),
		@HourlyRate = ISNULL(@HourlyRate, 0),
		@GetMarkupFrom = ISNULL(@GetMarkupFrom, 2),
		@ItemMarkup = ISNULL(@ItemMarkup, 0),
		@IOCommission = ISNULL(@IOCommission, 0),
		@BCCommission = ISNULL(@BCCommission, 0)
	
 -- Get the next number - only called if all validations pass.
 IF @ProjectNumber IS NULL OR @ProjectNumber = ''
 BEGIN
	if @SparkCustomization = 0

		EXEC sptProjectGetNextProjectNum
			@CompanyKey,
			@ClientKey,
			@OfficeKey,
			@ProjectTypeKey,
			@ClientDivisionKey,
			@CampaignKey,
			@RetVal OUTPUT,
			@NextTranNo OUTPUT

	ELSE

		EXEC sptProjectGetNextProjectNumSpark
			@CompanyKey,
			@ClientKey,
			@ProjectTypeKey,
			@ClientProductKey,
			@SparkModelYear,
			@RetVal OUTPUT,
			@NextTranNo OUTPUT

	IF @RetVal <> 1
		RETURN -1
END
ELSE
BEGIN
	-- Check for a duplicate project number
	IF EXISTS(
		SELECT 1 FROM tProject (NOLOCK) 
		WHERE
			ProjectNumber = @ProjectNumber AND
			CompanyKey = @CompanyKey
			)
		RETURN -2
		
	SELECT @NextTranNo = @ProjectNumber
END

SELECT @NextTranNo = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@NextTranNo, '&', ''), ',', ''), '"', ''), '''', '')))
 	
 	
 -- Insert the project
 INSERT mojo_prod.dbo.tProject (
  ProjectName,
  ProjectNumber,
  CompanyKey,
  ProjectStatusKey,
  ProjectTypeKey,
  ClientDivisionKey,
  ClientProductKey,
  ClientKey,
  OfficeKey,
  GLCompanyKey,
  Active,
  CreatedDate,
  CreatedByKey,
  GetRateFrom,
  TimeRateSheetKey,
  TitleRateSheetKey,
  HourlyRate,
  GetMarkupFrom,
  ItemRateSheetKey,
  ItemMarkup,
  IOCommission,
  BCCommission,
  AccountManager,
  RetainerKey,
  BillingMethod,
  ExpensesNotIncluded,
  LayoutKey,
  ProjectColor,
  CampaignKey,
  CustomFieldKey
  ) 
 VALUES (
  @ProjectName,
  @NextTranNo, -- @ProjectNumber,
  @CompanyKey,
  @ProjectStatusKey,
  @ProjectTypeKey,
  @ClientDivisionKey,
  @ClientProductKey,
  @ClientKey,
  @OfficeKey,
  @GLCompanyKey,
  @Active,
  CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
  @UserKey,
  @GetRateFrom,
  @TimeRateSheetKey,
  @TitleRateSheetKey,
  @HourlyRate,
  @GetMarkupFrom,
  @ItemRateSheetKey,
  @ItemMarkup,
  @IOCommission,
  @BCCommission,
  @AccountManager,
  CASE WHEN @BillingMethod = 3 THEN @DefaultRetainerKey ELSE NULL END,
  @BillingMethod,
  @ExpensesNotIncluded,
  @LayoutKey,
  @ProjectColor,
  @CampaignKey,
  0--@customFieldKey
  )
  


 SELECT @oIdentity = @@IDENTITY  

 INSERT tProjectRollup (ProjectKey) VALUES (@oIdentity)
 
 --execute mojo_prod.dbo.spCF_UpdateFieldValue @FieldDefKey = @fieldDefKey, @ObjectFieldSetKey = @customFieldKey, @FieldValue = @description
------------------------------------------------------------
--GL Company restrictions
DECLARE @tGLCompanies table (UserKey int, GLCompanyKey int)
IF @RestrictToGLCompany = 0
	BEGIN --@RestrictToGLCompany = 0
		--All GLCompanyKeys + 0 to get NULLs
		INSERT INTO @tGLCompanies
		SELECT UserKey, 0
		FROM tUser (nolock)
		WHERE
			(OwnerCompanyKey = @CompanyKey OR CompanyKey = @CompanyKey) AND
			AutoAssign = 1
		INSERT INTO @tGLCompanies
			SELECT
				u.UserKey,
				glc.GLCompanyKey
			FROM
				tGLCompany glc (nolock),
				tUser u (nolock)
			WHERE
				glc.CompanyKey = @CompanyKey AND
				(u.OwnerCompanyKey = @CompanyKey OR u.CompanyKey = @CompanyKey) AND
				u.AutoAssign = 1
	END --@RestrictToGLCompany = 0
ELSE
	BEGIN --@RestrictToGLCompany = 1
		 --Only GLCompanyKeys @UserKey has access to
		INSERT INTO @tGLCompanies
			SELECT
				glca.UserKey,
				glca.GLCompanyKey
			FROM
				tUserGLCompanyAccess glca (nolock)
				INNER JOIN tUser u (nolock) ON glca.UserKey = u.UserKey
			WHERE
				(u.OwnerCompanyKey = @CompanyKey OR u.CompanyKey = @CompanyKey) AND
				u.AutoAssign = 1
	END --@RestrictToGLCompany = 1
--GL Company restrictions
------------------------------------------------------------
INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
SELECT
	@oIdentity, -- new ProjectKey
	UserKey,
	HourlyRate
FROM
	tUser u (nolock)
WHERE
	(OwnerCompanyKey = @CompanyKey OR CompanyKey = @CompanyKey) AND
	AutoAssign = 1 AND
	Active = 1 AND
	UserKey <> @UserKey AND -- Do not Assign the creator first
	UserKey NOT IN (Select UserKey from tAssignment (nolock) Where ProjectKey = @oIdentity) AND
	UserKey IN (SELECT UserKey FROM @tGLCompanies WHERE GLCompanyKey = ISNULL(@GLCompanyKey, 0))

IF @@Error <> 0
BEGIN
--ROLLBACK TRANSACTION   
RETURN -1
END

-- Assign the creator even if AutoAssign = 0
INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
SELECT @oIdentity  -- new ProjectKey
		 ,UserKey
		 ,HourlyRate
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey
AND    UserKey NOT IN (Select UserKey from tAssignment (nolock) Where ProjectKey = @oIdentity)


IF @@Error <> 0
BEGIN
--ROLLBACK TRANSACTION
RETURN -1
END 
 
 /* set nocount on */
 return 1