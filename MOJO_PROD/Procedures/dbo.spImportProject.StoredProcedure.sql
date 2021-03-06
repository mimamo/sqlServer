USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportProject]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportProject]
	(
		@CompanyKey int,
		@UserKey int,
		@ProjectName varchar(100),
		@ProjectShortName varchar(25),
		@ProjectNumber varchar(50),
		@ProjectType varchar(100),
		@ClientID varchar(50),
		@ClientProjectNumber varchar(20),
		@GetRateFrom smallint,
		@HourlyRate money,
		@RateSheet varchar(100),
		@OverrideRate tinyint,
		@NonBillable tinyint,
		@StartDate smalldatetime,
		@CompleteDate smalldatetime,
		@WorkMon tinyint,
		@WorkTue tinyint,
		@WorkWed tinyint,
		@WorkThur tinyint,
		@WorkFri tinyint,
		@WorkSat tinyint,
		@WorkSun tinyint,
		@Office varchar(200),
		@AccountManagerID varchar(50),
		@Closed tinyint,
		@ProjectStatusID varchar(30),
		@ProjectBillingStatusID varchar(30),
		@StatusNotes varchar(100),
		@DetailedNotes varchar(4000),
		@TeamName varchar(200) = NULL --Optional because of CMP90
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 1/20/09   CRG 10.0.1.7 (43409) Added Team to the import
*/

Declare @ClientKey int, @BillingContact int, @TimeRateSheetKey int, @OfficeKey int, @AccountManager int, @Template tinyint,
	@ProjectStatusKey int, @ProjectBillingStatusKey int, @ProjectKey int, @Active tinyint, @ProjectTypeKey int, @TeamKey int


if exists(Select 1 from tProject (nolock) Where ProjectNumber = @ProjectNumber and CompanyKey = @CompanyKey)
	Return -1
Select @ProjectStatusKey = ProjectStatusKey, @Active = IsActive from tProjectStatus (nolock) Where ProjectStatusID = @ProjectStatusID and CompanyKey = @CompanyKey
if @ProjectStatusKey is null
	Return -2

if @ClientID is not null
BEGIN
	Select @ClientKey = CompanyKey from tCompany (nolock) Where CustomerID = @ClientID and OwnerCompanyKey = @CompanyKey
	if @ClientKey is null
		return -3
END
if @RateSheet is not null
BEGIN
	Select @TimeRateSheetKey = TimeRateSheetKey From tTimeRateSheet (nolock) Where RateSheetName = @RateSheet and CompanyKey = @CompanyKey
	if @TimeRateSheetKey is null
		return -4
END
if @Office is not null
BEGIN
	Select @OfficeKey = OfficeKey From tOffice (nolock) Where OfficeName = @Office and CompanyKey = @CompanyKey
	if @OfficeKey is null
		return -5
END
if @AccountManagerID is not null
BEGIN
	Select @AccountManager = UserKey from tUser (nolock) Where CompanyKey = @CompanyKey and SystemID = @AccountManagerID
	if @AccountManager is null
		return -6
END
if @ProjectBillingStatusID is not null
BEGIN
	Select @ProjectBillingStatusKey = ProjectBillingStatusKey from tProjectBillingStatus (nolock) Where ProjectBillingStatusID = @ProjectBillingStatusID and CompanyKey = @CompanyKey
	if @ProjectBillingStatusKey is null
		return -7
END
if @ProjectType is not null
BEGIN
	Select @ProjectTypeKey = ProjectTypeKey from tProjectType (nolock) Where ProjectTypeName = @ProjectType and CompanyKey = @CompanyKey
	if @ProjectTypeKey is null
		return -8
END
IF @TeamName IS NOT NULL
BEGIN
	SELECT @TeamKey = TeamKey FROM tTeam (nolock) WHERE TeamName = @TeamName AND CompanyKey = @CompanyKey
	IF @TeamKey IS NULL
		RETURN -10
END

if @Active = 1 and @Closed = 1
	Return -9
	
if UPPER(@ProjectStatusID) = 'TEMPLATE'
	select @Template = 1
else
	Select @Template = 0
	
	INSERT tProject
		(
		ProjectName,
		ProjectNumber,
		CompanyKey,
		ClientKey,
		ClientProjectNumber,
		BillingContact,
		GetRateFrom,
		TimeRateSheetKey,
		HourlyRate,
		OverrideRate,
		NonBillable,
		Closed,
		StartDate,
		CompleteDate,
		ProjectStatusKey,
		ProjectBillingStatusKey,
		ProjectTypeKey,
		StatusNotes,
		DetailedNotes,
		Active,
		CreatedDate,
		CreatedByKey,
		AccountManager,
		Template,
		WorkMon,
		WorkTue,
		WorkWed,
		WorkThur,
		WorkFri,
		WorkSat,
		WorkSun,
		OfficeKey,
		TeamKey
		)

	VALUES
		(
		@ProjectName,
		@ProjectNumber,
		@CompanyKey,
		@ClientKey,
		@ClientProjectNumber,
		@BillingContact,
		@GetRateFrom,
		@TimeRateSheetKey,
		@HourlyRate,
		@OverrideRate,
		@NonBillable,
		@Closed,
		ISNULL(@StartDate, CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)),
		@CompleteDate,
		@ProjectStatusKey,
		@ProjectBillingStatusKey,
		@ProjectTypeKey,
		@StatusNotes,
		@DetailedNotes,
		@Active,
		CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
		@UserKey,
		@AccountManager,
		@Template,
		@WorkMon,
		@WorkTue,
		@WorkWed,
		@WorkThur,
		@WorkFri,
		@WorkSat,
		@WorkSun,
		@OfficeKey,
		@TeamKey
		)
	
	SELECT @ProjectKey = @@IDENTITY

	INSERT	tAssignment (ProjectKey, UserKey, HourlyRate)
	SELECT	@ProjectKey  -- new ProjectKey
			,UserKey
			,HourlyRate
	FROM	tUser (NOLOCK)
	WHERE  (OwnerCompanyKey = @CompanyKey OR CompanyKey = @CompanyKey)
	AND    AutoAssign = 1

	IF ISNULL(@TeamKey, 0) > 0
		INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
		SELECT DISTINCT @ProjectKey,
				tu.UserKey, 
				u.HourlyRate
		FROM	tTeamUser tu (NOLOCK)
		INNER JOIN tUser u (nolock) ON tu.UserKey = u.UserKey
		WHERE	tu.TeamKey = @TeamKey
		AND		u.Active = 1
		AND		tu.UserKey not in (Select UserKey from tAssignment (nolock) Where ProjectKey = @ProjectKey)
 
	RETURN @ProjectKey
GO
