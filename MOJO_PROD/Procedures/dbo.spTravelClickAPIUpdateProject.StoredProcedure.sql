USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTravelClickAPIUpdateProject]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTravelClickAPIUpdateProject]
	@UserKey int,
	@CompanyKey int,
	@CopyProjectKey int,
	@CopyEstimate tinyint,
	@ProjectName varchar(100),
	@ProjectNumber varchar(50),
	@ProjectStatus varchar(100),
	@StartDate smalldatetime,
	@ClientKey int,
	@ProjectColor varchar(10),
	@ProjectKey int OUTPUT

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/24/07  CRG 8.5     (13411) Created for TravelClick API enhancement.  Uses Insert and Update SPs from the page to maintain the business rules.
|| 06/18/13 GHL 10.569   (181721) Added campaign when calling sptProjectCopy because of new project numbers by campaign
|| 12/19/14 WDF 10.5.8.7 (237583) Add @DefaultRetainerKey for sptProjectCopy
*/

	DECLARE	@RetVal int,
			@ProjectStatusKey int,
			@ClientDivisionKey int,
			@ClientProductKey int,
			@CampaignKey int,
			@ClientProjectNumber varchar(200),
			@RequestKey int,
			@BillingContact int, 
			@CustomFieldKey int,
			@OfficeKey int,
			@GLCompanyKey int,
			@ClassKey int,
			@AccountManager int,
			@Closed tinyint,
			@ProjectBillingStatusKey int,
			@StatusNotes varchar(100),
			@DetailedNotes varchar(4000),
			@ClientNotes varchar(4000),
			@ImageFolderKey int,
			@KeyPeople1 int,
			@KeyPeople2 int,
			@KeyPeople3 int,
			@KeyPeople4 int,
			@KeyPeople5 int,
			@KeyPeople6 int,
			@UserDefined1 varchar(250),
			@UserDefined2 varchar(250),
			@UserDefined3 varchar(250),
			@UserDefined4 varchar(250),
			@UserDefined5 varchar(250),
			@UserDefined6 varchar(250),
			@UserDefined7 varchar(250),
			@UserDefined8 varchar(250),
			@UserDefined9 varchar(250),
			@UserDefined10 varchar(250),
			@CompleteDate smalldatetime,
			@WorkMon tinyint,
			@WorkTue tinyint,
			@WorkWed tinyint,
			@WorkThur tinyint,
			@WorkFri tinyint,
			@WorkSat tinyint,
			@WorkSun tinyint,
			@ScheduleDirection smallint,
			@FlightStartDate smalldatetime,
			@FlightEndDate smalldatetime,
			@FlightInterval tinyint,
			@CampaignBudgetKey int,
			@ProjectTypeKey int,
			@Added tinyint,
			@CurProjectColor varchar(10)

	IF Object_Id('tempdb..#Description') IS NOT NULL
		DROP TABLE #GLTran
	
	CREATE TABLE #Description (Description text NULL)

	SELECT	@ProjectStatusKey = ProjectStatusKey
	FROM	tProjectStatus (nolock)
	WHERE	ProjectStatus = @ProjectStatus
	AND		CompanyKey = @CompanyKey
	
	IF @ProjectStatusKey IS NULL
		RETURN -1
				
	SELECT @Added = 0
	
	IF @ProjectNumber IS NOT NULL
		SELECT	@ProjectKey = ProjectKey,
				@ClientDivisionKey = ClientDivisionKey,
				@ClientProductKey = ClientProductKey,
				@ProjectTypeKey = ProjectTypeKey,
				@CampaignKey = CampaignKey,
				@ClientProjectNumber = ClientProjectNumber,
				@RequestKey = RequestKey,
				@BillingContact = BillingContact, 
				@CustomFieldKey = CustomFieldKey,
				@OfficeKey = OfficeKey,
				@GLCompanyKey = GLCompanyKey,
				@ClassKey = ClassKey,
				@AccountManager = AccountManager,
				@Closed = Closed,
				@ProjectBillingStatusKey = ProjectBillingStatusKey,
				@StatusNotes = StatusNotes,
				@DetailedNotes = DetailedNotes,
				@ClientNotes = ClientNotes,
				@ImageFolderKey = ImageFolderKey,
				@KeyPeople1 = KeyPeople1,
				@KeyPeople2 = KeyPeople2,
				@KeyPeople3 = KeyPeople3,
				@KeyPeople4 = KeyPeople4,
				@KeyPeople5 = KeyPeople5,
				@KeyPeople6 = KeyPeople6,
				@UserDefined1 = UserDefined1,
				@UserDefined2 = UserDefined2,
				@UserDefined3 = UserDefined3,
				@UserDefined4 = UserDefined4,
				@UserDefined5 = UserDefined5,
				@UserDefined6 = UserDefined6,
				@UserDefined7 = UserDefined7,
				@UserDefined8 = UserDefined8,
				@UserDefined9 = UserDefined9,
				@UserDefined10 = UserDefined10,
				@CompleteDate = CompleteDate,
				@WorkMon = WorkMon,
				@WorkTue = WorkTue,
				@WorkWed = WorkWed,
				@WorkThur = WorkThur,
				@WorkFri = WorkFri,
				@WorkSat = WorkSat,
				@WorkSun = WorkSun,
				@ScheduleDirection =@ScheduleDirection,
				@FlightStartDate = FlightStartDate,
				@FlightEndDate = FlightEndDate,
				@FlightInterval = FlightInterval,
				@CurProjectColor = ProjectColor,  --If updating, get the existing color and ignore the one passed in
				@CampaignBudgetKey = CampaignBudgetKey		
		FROM	tProject (nolock)
		WHERE	ProjectNumber = @ProjectNumber
		AND		CompanyKey = @CompanyKey
		AND		Deleted = 0
		
	IF ISNULL(@ProjectKey, 0) = 0
	BEGIN
		EXEC @RetVal = sptProjectCopy
				@UserKey,
				@ProjectName,
				@ProjectNumber,
				@CompanyKey,
				@ProjectStatusKey,
				NULL, --@ProjectTypeKey
				NULL, --@ClientDivisionKey
				NULL, --@ClientProductKey
				NULL, --@OfficeKey
				NULL, --@GLCompanyKey
				NULL, --@ClassKey
				NULL, --@ClientKey
				NULL, --@RequestKey
				@CopyProjectKey,
				@CopyEstimate,
				0, --@CopyFrom
				NULL, --@EstimateInternalApprover
				NULL, --@TeamKey
				NULL, --@LeadKey
				@ProjectColor,  
				NULL, -- @ModelYear
				NULL, -- @CampaignKey
				NULL, -- @DefaultRetainerKey
				@ProjectKey OUTPUT
			
		IF @RetVal <= 0
			RETURN -2 --Error inserting Project
			
		UPDATE	tProject
		SET		Closed = 0
		WHERE	ProjectKey = @ProjectKey
		
		SELECT	@ProjectNumber = ProjectNumber
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey
		
		SELECT	@Closed = 0,
				@WorkMon = 1,
				@WorkTue = 1,
				@WorkWed = 1,
				@WorkThur = 1,
				@WorkFri = 1,
				@WorkSat = 0,
				@WorkSun = 0,
				@ScheduleDirection = 1 --From Project Start
		
		SELECT @Added = 1
		
	END
	ELSE
	BEGIN
		--Save off the Description into a Temp Table (can't use a variable because it's a Text type)
		INSERT	#Description
		SELECT	Description
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey
		
		SELECT	@ProjectColor = @CurProjectColor
	END
	
	--Call the Update SP whether you're adding or updating
	EXEC @RetVal = sptProjectUpdate
			@ProjectKey,
			@CompanyKey,
			@ProjectName,
			@ProjectNumber,
			@ProjectTypeKey,
			@ClientDivisionKey,
			@ClientProductKey,
			@ClientKey,
			@CampaignKey,
			@ClientProjectNumber,
			@RequestKey,
			@BillingContact, 
			@CustomFieldKey,
			@OfficeKey,
			@GLCompanyKey,
			@ClassKey,
			@AccountManager,
			@Closed,
			@ProjectStatusKey,
			@ProjectBillingStatusKey,
			@StatusNotes,
			@DetailedNotes,
			@ClientNotes,
			NULL, --@Description (updated below)
			@ImageFolderKey,
			@KeyPeople1,
			@KeyPeople2,
			@KeyPeople3,
			@KeyPeople4,
			@KeyPeople5,
			@KeyPeople6,
			@UserDefined1,
			@UserDefined2,
			@UserDefined3,
			@UserDefined4,
			@UserDefined5,
			@UserDefined6,
			@UserDefined7,
			@UserDefined8,
			@UserDefined9,
			@UserDefined10,
			@StartDate,
			@CompleteDate,
			@WorkMon,
			@WorkTue,
			@WorkWed,
			@WorkThur,
			@WorkFri,
			@WorkSat,
			@WorkSun,
			@ScheduleDirection,
			@FlightStartDate,
			@FlightEndDate,
			@FlightInterval,
			@ProjectColor,
			@CampaignBudgetKey
		
		IF @RetVal <= 0
			RETURN -3

	IF @Added = 1
		RETURN 1 --Project Added (VB will copy the Specs)
	ELSE
	BEGIN
		--Update the Description
		UPDATE	tProject
		SET		Description = tmp.Description
		FROM	#Description tmp
		
		RETURN 2 --Project Updated (VB will not copy the Specs)
	END
GO
