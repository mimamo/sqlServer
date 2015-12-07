use mojo_prod
go

alter Procedure [dbo].[sptProjectCopy]
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
 @ClassKey int,
 @ClientKey int,
 @RequestKey int,
 @CopyProjectKey int,
 @CopyEstimate tinyint,
 @CopyFrom int, -- 0 from project, 1 from project type, 2 from project template on UI
 @EstimateInternalApprover int,
 @TeamKey int,  
 @LeadKey int,
 @ProjectColor varchar(10),  
 @ModelYear varchar(10) = null, 
 @CampaignKey int = null,
 @DefaultRetainerKey int = null, 
 -- NOTE:If you add a parameter, modify intProjectCreate.sql ( modif for the Integer group)
 -- Also send an email to Mark Campbell with the new stored proc, markcampbell@integer.com
 @oIdentity INT OUTPUT
 
 
 )
AS --Encrypt

  /*
  || When     Who Rel      What
  || 10/16/06 GHL 8.4      Removed SummaryTaskKey parm when calling sptTaskQuickInsert 
  ||                       Added CanTrackBudget parm when calling sptTaskQuickInsert
  || 12/13/06 GHL 8.4      Added validation of master tasks
  || 12/21/06 GHL 8.4      Added logic to prevent duplicates in tAssignment
  || 04/10/07 QMD 8.4.2	   Added ProjectColor field -- See Issue 8638 for more information
  || 06/15/07 GWG 8.5      Added GL Company Key
  || 11/07/07 CRG 8.5      (9503) Modified to only pull over Active users from the copied project
  || 8/6/08   CRG 10.1.0.0 (31724) Modified to default the Labor and Purchasing rate sheet info from the Client if they're not copying from another project.
  ||                       (31632) Fixed logic problem where it was not executing the copy master tasks functionality if they were copying from the project type.
  || 8/29/08  CRG 10.1.0.0 (32709) Modified so that team memebers are added when not copying a project
  || 9/10/08  CRG 10.0.0.8 (the release formerly known as 10.1.0.0) Removed If statement that was doing nothing.
  || 11/4/08  CRG 10.0.1.2 (39543) Moved the insert into tProjectUserServices outside of the CopyProject If block so that it'll default the services whether
  ||                       you are copying the projects or not.
  || 12/29/08 CRG 10.0.1.5 (39387) Now updating new tProject column: TeamKey
  || 12/1/10  RLB 10.5.3.9 (94833) just adding Default User Service instead of all users services
  || 07/19/11 RLB 10.5.4.6 (116508) set project Billing Method from copied project
  || 09/27/11 GWG 10.5.4.8 (122426) Reversed the last change for billing method
  || 10/27/11 GWG 10.5.4.9 Added the copy of the client budget columns from the template
  || 11/08/11 GWG 10.5.5.1 Moved the update of hourly rate to the bottom and removed a duplicate reference since it should always happen
  || 11/22/11 RLB 10.5.5.1 (124338) If client has a Default EstimateTemplate or layout set that on the Estimates
  || 03/28/12 GWG 10.5.5.4 Added in the defaulting of GLCompanySource and copying of deliverables
  || 10/5/12  CRG 10.5.6.0 Added call to sptProjectWebDavSafeFolders
  || 02/12/13 GHL 10.5.6.5 (167857) Added ModelYear for a customization for Spark44
  || 06/18/13 GHL 10.5.6.9 (181721) Added campaign key for new project numbers by campaign
  || 08/26/13 RLB 10.5.7.1 (170225) Set BillingManagerKey from Client Default
  || 09/12/13 GHL 10.5.7.2 Copying now currency ID from client to project
  || 11/25/13 RLB 10.5.7.4 (197740) Adding some validation for client and selected gl company
  || 08/27/14 GHL 10.5.8.3 (227654) Only validate client and GL company if client key > 0
  || 11/05/14 RLB 10.5.8.6 Copy AnyoneChargeTime over to new project from template
  || 12/19/14 WDF 10.5.8.7 (237583) Add @DefaultRetainerKey
  || 02/06/15 GHL 10.5.8.8 When copying defaults from the client, do not forget the title info
  || 03/27/15 GHL 10.5.9.1 Added constants for CopyFrom
  || 11/24/15 MMM		   (34633) Adding input for product description.
  */
  
DECLARE @RequireMasterTask INT
declare @Customizations varchar(1000)
declare @SparkCustomization int
declare @MultiCurrency int
declare @RestrictToGLCompany int
 
  -- copy from template is converted to copy from project in ProjectSetup.vb, so only use 2 constants 
  declare @kCopyFromProject int						select @kCopyFromProject = 0
  declare @kCopyFromProjectType int					select @kCopyFromProjectType = 1
 
  IF isnull(@ClientKey, 0) > 0 and isnull(@DefaultRetainerKey, 0) > 0
  BEGIN 
	IF EXISTS (SELECT 1
			     FROM mojo_prod.dbo.tCompany (NOLOCK)
			    WHERE CompanyKey = @ClientKey
			      AND DefaultBillingMethod = 3)
			UPDATE mojo_prod.dbo.tCompany 
			  set DefaultRetainerKey = @DefaultRetainerKey
			WHERE  CompanyKey = @ClientKey 
  END
 
  SELECT @RequireMasterTask = ISNULL(RequireMasterTask, 0)
        ,@Customizations = UPPER(ISNULL(Customizations, ''))
		,@MultiCurrency = isnull(MultiCurrency, 0)
		,@RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
  FROM   mojo_prod.dbo.tPreference (NOLOCK)
  WHERE  CompanyKey = @CompanyKey 
  
  IF @RequireMasterTask = 1 and @CopyFrom = @kCopyFromProject  -- Copy from project
  BEGIN
	IF EXISTS (SELECT 1
			   FROM   mojo_prod.dbo.tTask (NOLOCK)
			   WHERE  tTask.ProjectKey = @CopyProjectKey
				   AND    tTask.TrackBudget = 1
				   AND    ISNULL(tTask.MasterTaskKey, 0) = 0)
				   RETURN -10

  END

  IF @RestrictToGLCompany = 1 And isnull(@ClientKey, 0) > 0
  BEGIN
	IF NOT EXISTS (SELECT 1
				   FROM  mojo_prod.dbo.tGLCompanyAccess (NOLOCK)
				   WHERE CompanyKey = @CompanyKey
						AND Entity = 'tCompany'
						AND EntityKey = @ClientKey
						AND GLCompanyKey = @GLCompanyKey)
						RETURN -15

  END
  
if charindex('SPARK44',@Customizations) > 0
begin
	select @SparkCustomization = 1

	if @ModelYear is null
	begin
		if @CopyProjectKey > 0
			select @ModelYear = ModelYear 
			from mojo_prod.dbo.tProject (nolock) 
			where ProjectKey = @CopyProjectKey

		if @ModelYear is null
			select @ModelYear = DATEPART("YEAR",GETDATE()) - 2000

		if len(@ModelYear) = 1
			select @ModelYear = '0' + @ModelYear

	end

end
else
	select @SparkCustomization = 0


	DECLARE @RetVal INT
	       ,@ProjectKey INT
	       ,@SpecCustomFieldKey INT
	        	
	-- First call sptProjectCreate
	EXEC @RetVal = mojo_prod.dbo.sptProjectCreate
				@UserKey,
				@ProjectName,
				@ProjectNumber,
				@CompanyKey,
				@ProjectStatusKey,
				@ProjectTypeKey,
				@ClientDivisionKey,
				@ClientProductKey,
				@OfficeKey,
				@GLCompanyKey,
				@ClientKey,
				@CampaignKey,
				@ProjectColor,
				@SparkCustomization,
				@ModelYear,
				@ProjectKey output
				
				
	
	IF @RetVal <> 1 
	BEGIN
		SELECT @oIdentity = 0
		RETURN @RetVal
	END
	 
	SELECT @oIdentity = @ProjectKey

	--Set the WebDav safe folder names
	EXEC mojo_prod.dbo.sptProjectWebDavSafeFolders @ProjectKey, 0
	
	IF @RequestKey > 0
	begin
		
		Update	mojo_prod.dbo.tProject
			Set		RequestKey = @RequestKey
		Where	ProjectKey = @ProjectKey
		
	end

	DECLARE @GetRateFrom SMALLINT
	       ,@GetMarkupFrom SMALLINT, @DefaultGLCompanySource SMALLINT

	Select @DefaultGLCompanySource = ISNULL(DefaultGLCompanySource, 0) 
	from mojo_prod.dbo.tPreference (nolock) 
	Where CompanyKey = @CompanyKey
	
	Update mojo_prod.dbo.tProject 
		Set GLCompanySource = @DefaultGLCompanySource 
	Where ProjectKey = @ProjectKey

	IF (ISNULL(@CopyProjectKey, 0) = 0) AND (@CopyFrom <> @kCopyFromProjectType )
	BEGIN
		IF ISNULL(@ClientKey, 0) > 0
		BEGIN
			UPDATE	tProject 
			SET		tProject.GetRateFrom = ISNULL(cl.GetRateFrom, 2)
					,tProject.TimeRateSheetKey = ISNULL(cl.TimeRateSheetKey, 0)
					,tProject.TitleRateSheetKey = ISNULL(cl.TitleRateSheetKey, 0)
					,tProject.HourlyRate = ISNULL(cl.HourlyRate, 0)
					,tProject.GetMarkupFrom = ISNULL(cl.GetMarkupFrom, 2)
					,tProject.ItemRateSheetKey = ISNULL(cl.ItemRateSheetKey, 0)
					,tProject.ItemMarkup = ISNULL(cl.ItemMarkup, 0)  
			FROM	mojo_prod.dbo.tCompany cl (NOLOCK)
			WHERE	cl.CompanyKey = @ClientKey
				AND		tProject.ProjectKey = @ProjectKey
		END
		
		-- If a team was specified, add the people in it
		IF ISNULL(@TeamKey, 0) > 0
			INSERT mojo_prod.dbo.tAssignment 
			(
				ProjectKey, 
				UserKey, 
				HourlyRate
			)
			SELECT DISTINCT @ProjectKey  -- new ProjectKey
					,tTeamUser.UserKey, 
					0
			FROM	mojo_prod.dbo.tTeamUser (NOLOCK)
			INNER JOIN mojo_prod.dbo.tUser u (nolock) 
				ON tTeamUser.UserKey = u.UserKey
			WHERE	tTeamUser.TeamKey = @TeamKey
				AND		u.Active = 1
				AND		tTeamUser.UserKey not in (Select UserKey 
													from tAssignment (nolock) 
													Where ProjectKey = @ProjectKey)

	END	
	ELSE
	BEGIN
		-- Copy these settings from the other project
		UPDATE
			mojo_prod.dbo.tProject
			SET	tProject.GetRateFrom = p2.GetRateFrom,
				tProject.TimeRateSheetKey = p2.TimeRateSheetKey,
				tProject.TitleRateSheetKey = p2.TitleRateSheetKey,
				tProject.HourlyRate = p2.HourlyRate,
				tProject.GetMarkupFrom = p2.GetMarkupFrom,
				tProject.ItemRateSheetKey = p2.ItemRateSheetKey,
				tProject.ItemMarkup = p2.ItemMarkup,
				tProject.IOCommission = p2.IOCommission,
				tProject.BCCommission = p2.BCCommission,
				tProject.ScheduleDirection = p2.ScheduleDirection,
				tProject.ClassKey = ISNULL(p2.ClassKey, @ClassKey)
		FROM mojo_prod.dbo.tProject
			,mojo_prod.dbo.tProject p2 (NOLOCK)
		WHERE tProject.ProjectKey = @ProjectKey 
			AND  p2.ProjectKey = @CopyProjectKey
			
		-- Check if we need to get defaults from the client
		       
		If ISNULL(@ClientKey, 0) > 0
		BEGIN
			SELECT @GetRateFrom = GetRateFrom
				   ,@GetMarkupFrom = GetMarkupFrom
			FROM   mojo_prod.dbo.tProject (NOLOCK)
			WHERE  ProjectKey = @ProjectKey
			
			-- If Get Rate from Client
			IF @GetRateFrom = 1
			BEGIN
				UPDATE tProject 
					SET    tProject.GetRateFrom = ISNULL(cl.GetRateFrom, 2)
						  ,tProject.TimeRateSheetKey = ISNULL(cl.TimeRateSheetKey, 0)
						  ,tProject.TitleRateSheetKey = ISNULL(cl.TitleRateSheetKey, 0)
						  ,tProject.HourlyRate = ISNULL(cl.HourlyRate, 0)
				FROM   mojo_prod.dbo.tCompany cl (NOLOCK)
				WHERE  cl.CompanyKey = @ClientKey
					AND    cl.GetRateFrom IS NOT NULL
					AND    tProject.ProjectKey = @ProjectKey
			END	

			-- If Get Markup  from Client
			IF @GetMarkupFrom = 1
			BEGIN
				UPDATE mojo_prod.dbo.tProject 
				SET    tProject.GetMarkupFrom = ISNULL(cl.GetMarkupFrom, 2)
					  ,tProject.ItemRateSheetKey = ISNULL(cl.ItemRateSheetKey, 0)
					  ,tProject.ItemMarkup = ISNULL(cl.ItemMarkup, 0)
				FROM   mojo_prod.dbo.tCompany cl (NOLOCK)
				WHERE  cl.CompanyKey = @ClientKey
					AND    cl.GetMarkupFrom IS NOT NULL
					AND  tProject.ProjectKey = @ProjectKey
			END	
		END
			
		-- Now copy detail from CopyProjectKey to ProjectKey
		UPDATE mojo_prod.dbo.tProject
			SET	tProject.BillingContact = CASE WHEN tProject.ClientKey = p2.ClientKey THEN p2.BillingContact
												ELSE NULL
											END,
				tProject.OverrideRate = p2.OverrideRate,
				tProject.NonBillable = p2.NonBillable,
				tProject.ScheduleDirection = p2.ScheduleDirection,
				tProject.ClientBHours = p2.ClientBHours,
				tProject.ClientBLabor = p2.ClientBLabor,
				tProject.ClientBCO = p2.ClientBCO,
				tProject.ClientBExpenses = p2.ClientBExpenses,
				tProject.ClientAHours = p2.ClientAHours,
				tProject.ClientALabor = p2.ClientALabor,
				tProject.ClientAPO = p2.ClientAPO,
				tProject.ClientAExpenses = p2.ClientAExpenses,
				tProject.GLCompanySource = ISNULL(p2.GLCompanySource, @DefaultGLCompanySource),
				tProject.AnyoneChargeTime = p2.AnyoneChargeTime
		FROM mojo_prod.dbo.tProject (NOLOCK) 
			 ,mojo_prod.dbo.tProject p2 (NOLOCK)
		WHERE tProject.ProjectKey = @ProjectKey 
			AND p2.ProjectKey = @CopyProjectKey

		 -- sptProjectCreate assigns people with AutoAssign = 0 and the creator even if AutoAssign = 0
		 -- Copy now people from the old project
		INSERT mojo_prod.dbo.tAssignment 
		(
			ProjectKey, 
			UserKey, 
			HourlyRate
		)
		SELECT DISTINCT @ProjectKey  -- new ProjectKey
				,tAssignment.UserKey, 0
		FROM	mojo_prod.dbo.tAssignment (NOLOCK)
		INNER JOIN mojo_prod.dbo.tUser u (nolock) 
			ON tAssignment.UserKey = u.UserKey
		WHERE	ProjectKey = @CopyProjectKey 
			AND		u.Active = 1
			AND		tAssignment.UserKey not in (Select UserKey 
												from mojo_prod.dbo.tAssignment (nolock) 
												Where ProjectKey = @ProjectKey)

		-- If a team was specified, add the people in it
		IF ISNULL(@TeamKey, 0) > 0
			INSERT tAssignment 
			(
				ProjectKey, 
				UserKey, 
				HourlyRate
			)
			SELECT DISTINCT @ProjectKey  -- new ProjectKey
					,tTeamUser.UserKey, 
					0
			FROM	mojo_prod.dbo.tTeamUser (NOLOCK)
			INNER JOIN mojo_prod.dbo.tUser u (nolock) 
				ON tTeamUser.UserKey = u.UserKey
			WHERE	tTeamUser.TeamKey = @TeamKey
				AND		u.Active = 1
				AND		tTeamUser.UserKey not in (Select UserKey 
													from tAssignment (nolock) 
													Where ProjectKey = @ProjectKey)
		
		if @CopyFrom = @kCopyFromProject 
		BEGIN
		
			exec sptProjectCopyTasks @ProjectKey, @CopyProjectKey, @CopyEstimate, @UserKey
			
		END
		ELSE
		BEGIN
			
			Declare @MaxOrder int, 
				@NewTaskKey int, 
				@CurOrder int, 
				@CurMTID varchar(100)
				
			Select @MaxOrder = Max(DisplayOrder), @CurOrder = 0 
								from tProjectTypeMasterTask (NOLOCK) 
								Where ProjectTypeKey = @ProjectTypeKey
			
			While @CurOrder < @MaxOrder
			BEGIN
			
				Select @CurOrder = @CurOrder + 1
				
				Select @CurMTID = TaskID 
				from mojo_prod.dbo.tProjectTypeMasterTask (NOLOCK) 
				inner join mojo_prod.dbo.tMasterTask (NOLOCK) 
					on tProjectTypeMasterTask.MasterTaskKey = tMasterTask.MasterTaskKey
				Where ProjectTypeKey = @ProjectTypeKey 
					and DisplayOrder = @CurOrder
					
				if @CurMTID is not null
				BEGIN
					exec mojo_prod.dbo.sptTaskQuickInsert @ProjectKey, @CurMTID, NULL, 0, 1, @NewTaskKey OUTPUT
				END
				
			END
			
			exec mojo_prod.dbo.sptTaskOrder @ProjectKey, 0, 0, 0
		END
		
		-- Defaulting Layout, Estimate Template and Billing Manager from client onto Estimate
		DECLARE @DefaultLayoutKey int, @DefaultEstimateTemplateKey int, @DefaultBillingManagerKey int
		If ISNULL(@ClientKey, 0) > 0
			Select @DefaultLayoutKey = ISNULL(LayoutKey, 0), 
				@DefaultEstimateTemplateKey = ISNULL(EstimateTemplateKey, 0), 
				@DefaultBillingManagerKey = ISNULL(BillingManagerKey, 0 ) 
			from tCompany (NOLOCK) 
			Where CompanyKey = @ClientKey

		if ISNULL(@DefaultEstimateTemplateKey, 0) <> 0
			UPDATE mojo_prod.dbo.tEstimate
				SET EstimateTemplateKey = @DefaultEstimateTemplateKey
			WHERE ProjectKey = @ProjectKey

		if ISNULL(@DefaultLayoutKey, 0) <> 0
			UPDATE mojo_prod.dbo.tEstimate
				SET LayoutKey = @DefaultLayoutKey
			WHERE ProjectKey = @ProjectKey

		If isnull(@EstimateInternalApprover, 0) <> 0
			UPDATE mojo_prod.dbo.tEstimate
				SET    InternalApprover = @EstimateInternalApprover
			WHERE  ProjectKey = @ProjectKey

		if ISNULL(@DefaultBillingManagerKey, 0) <> 0
			UPDATE mojo_prod.dbo.tProject
				SET BillingManagerKey = @DefaultBillingManagerKey
			WHERE ProjectKey = @ProjectKey
			
	END

	
	UPDATE mojo_prod.dbo.tAssignment 
		SET    tAssignment.HourlyRate = u.HourlyRate,
			   tAssignment.SubscribeDiary = ISNULL(u.SubscribeDiary, 0),
			   tAssignment.SubscribeToDo = ISNULL(u.SubscribeToDo, 0),
			   tAssignment.DeliverableReviewer = ISNULL(u.DeliverableReviewer, 0),
			   tAssignment.DeliverableNotify = ISNULL(u.DeliverableNotify, 0)

	FROM   mojo_prod.dbo.tUser u (NOLOCK)
	WHERE  tAssignment.UserKey = u.UserKey
		AND    tAssignment.ProjectKey = @ProjectKey
	
	Delete mojo_prod.dbo.tProjectUserServices 
	Where ProjectKey = @ProjectKey
	
	Insert mojo_prod.dbo.tProjectUserServices 
	(
		ProjectKey, 
		UserKey, 
		ServiceKey
	)
	Select DISTINCT @ProjectKey, 
		u.UserKey, 
		u.DefaultServiceKey
	from mojo_prod.dbo.tUser u (nolock) 
	inner join mojo_prod.dbo.tAssignment a (nolock) 
		on u.UserKey = a.UserKey  
	Where ISNULL(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
		And   a.ProjectKey = @ProjectKey 
		And u.DefaultServiceKey IS NOT NULL

	declare @CurrencyID varchar(10)  -- will be null by default
	
	if @MultiCurrency = 1 and isnull(@ClientKey, 0) > 0
		select @CurrencyID = CurrencyID 
							from mojo_prod.dbo.tCompany (nolock) 
							where CompanyKey = @ClientKey

	UPDATE	mojo_prod.dbo.tProject
		SET		TeamKey = @TeamKey
			   ,LeadKey = @LeadKey
			   ,ModelYear = @ModelYear
			   ,CurrencyID = @CurrencyID
	WHERE	ProjectKey = @ProjectKey


	-- copy all the deliverables over
	Insert mojo_prod.dbo.tReviewDeliverable 
	(
		CompanyKey, 
		DeliverableName, 
		[Description], 
		ProjectKey, 
		OwnerKey
	)
	Select @CompanyKey, 
		DeliverableName, 
		[Description], 
		@ProjectKey, 
		@UserKey
	From mojo_prod.dbo.tReviewDeliverable (nolock) 
	Where ProjectKey = @CopyProjectKey
				
 /* set nocount on */
 return 1