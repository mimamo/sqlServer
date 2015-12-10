USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCopyEntity]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectCopyEntity]
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
 @CopyFrom int, -- 0: from project,  1: from project type
 @EstimateInternalApprover int,
 @TeamKey int,
 @LeadKey int,
 @Entity varchar(50),  -- 'tLead' for now
 @EntityKey int,       -- LeadKey
 @ProjectColor varchar(10),  
 @ModelYear varchar(10) = null,
 @CampaignKey int = null,
 @oIdentity INT OUTPUT
 )
AS --Encrypt

  /*
  || When     Who Rel      What
  || 03/22/10 GHL 10.520   Cloned sptProjectCopy for opportunity  
  || 04/02/10 GHL 10.521   Updating now tLead.ConvertEntity,tLead.ConvertEntityKey
  || 04/08/10 GHL 10.522   (78512) Checking existence of template project before executing sp
  ||                        if does not exist, bounce back to sptProjectCopy
  || 04/22/10 GHL 10.522   Moved patch of 04/08/10 to the VB section. Added LeadKey
  || 08/19/10 GHL 10.534   (87237 + 87571) Always copy of the estimates for the entity (not dependent on @CopyEstimate = 1)
  ||                       copying estimates from the copyProjectKey still depend on @CopyEstimate = 1 
  || 11/11/10 GHL 10.538   (94144) Added param UserKey when calling sptProjectCopyEstimates
  || 12/1/10  RLB 10.5.3.9 (94833) just adding Default User Service instead of all users services
  || 07/19/11 RLB 10.5.4.6 (116508) set project Billing Method from copied project
  || 09/09/11 RLB 10.5.4.8 (120913) Set Date Converted on Opportunity
  || 11/22/11 RLB 10.5.5.1 (124338) If client has a Default EstimateTemplate or layout set that on the Estimates
  || 02/12/13 GHL 10.5.6.5 (167857) Added ModelYear for a customization for Spark44
  || 06/18/13 GHL 10.5.6.9 (181721) Added campaign key for new project numbers by campaign
  || 08/26/13 RLB 10.5.7.1 (170225) Set BillingManagerKey from Client Default
  || 11/25/13 RLB 10.5.7.4 (197740) Adding some validation for client and selected gl company 
  || 11/05/14 RLB 10.5.8.6 Copy AnyoneChargeTime over to new project from template
  || 02/06/15 GHL 10.5.8.8 When copying defaults from the client, do not forget the title info
  */

	DECLARE @RetVal INT
	       ,@ProjectKey INT
	       ,@SpecCustomFieldKey INT
 

declare @kCopyFromProject int		select @kCopyFromProject = 0
declare @kCopyFromProjectType int	select @kCopyFromProjectType = 1
  
declare @kByTaskOnly int            select @kByTaskOnly = 1
declare @kByTaskService int         select @kByTaskService = 2
declare @kByTaskPerson int          select @kByTaskPerson = 3
declare @kByServiceOnly int         select @kByServiceOnly = 4
declare @kBySegmentService int      select @kBySegmentService = 5  -- Unlikely here since it is only for campaigns 


  DECLARE @RequireMasterTask INT
  declare @Customizations varchar(1000)
  declare @SparkCustomization int
  declare @RestrictToGLCompany int
 
  SELECT @RequireMasterTask = ISNULL(RequireMasterTask, 0)
        ,@Customizations = UPPER(ISNULL(Customizations, ''))
		,@RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
  FROM   tPreference (NOLOCK)
  WHERE  CompanyKey = @CompanyKey 
  
  IF @RequireMasterTask = 1 and @CopyFrom = @kCopyFromProject
  BEGIN
	IF EXISTS (SELECT 1
			   FROM   tTask (NOLOCK)
			   WHERE  tTask.ProjectKey = @CopyProjectKey
			   AND    tTask.TrackBudget = 1
			   AND    ISNULL(tTask.MasterTaskKey, 0) = 0)
			   RETURN -10

  END

   IF @RestrictToGLCompany = 1
  BEGIN
	IF NOT EXISTS (SELECT 1
				   FROM  tGLCompanyAccess (NOLOCK)
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
			select @ModelYear = ModelYear from tProject (nolock) where ProjectKey = @CopyProjectKey

		if @ModelYear is null
			select @ModelYear = DATEPART("YEAR",GETDATE()) - 2000

		if len(@ModelYear) = 1
			select @ModelYear = '0' + @ModelYear

	end

end
else
	select @SparkCustomization = 0

	        	
	-- First call sptProjectCreate
	EXEC @RetVal = sptProjectCreate
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
				@ProjectKey OUTPUT
	
	IF @RetVal <> 1 
	BEGIN
		SELECT @oIdentity = 0
		RETURN @RetVal
	END
	 
	SELECT @oIdentity = @ProjectKey
	
	IF @RequestKey > 0
	begin
		
		Update	tProject
		Set		RequestKey = @RequestKey
		Where	ProjectKey = @ProjectKey
		
	end

	DECLARE @GetRateFrom SMALLINT
	       ,@GetMarkupFrom SMALLINT
	
	IF (ISNULL(@CopyProjectKey, 0) = 0) AND (@CopyFrom = @kCopyFromProject)
	BEGIN
		-- copy from project but there is no project to copy
		
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
			FROM	tCompany cl (NOLOCK)
			WHERE	cl.CompanyKey = @ClientKey
			AND		tProject.ProjectKey = @ProjectKey
		END
		
		-- If a team was specified, add the people in it
		IF ISNULL(@TeamKey, 0) > 0
			INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
			SELECT DISTINCT @ProjectKey  -- new ProjectKey
					,tTeamUser.UserKey, 0
			FROM	tTeamUser (NOLOCK)
			INNER JOIN tUser u (nolock) ON tTeamUser.UserKey = u.UserKey
			WHERE	tTeamUser.TeamKey = @TeamKey
			AND		u.Active = 1
			AND		tTeamUser.UserKey not in (Select UserKey from tAssignment (nolock) Where ProjectKey = @ProjectKey)

		UPDATE tAssignment 
		SET    tAssignment.HourlyRate = u.HourlyRate
		FROM   tUser u (NOLOCK)
		WHERE  tAssignment.UserKey = u.UserKey
		AND    tAssignment.ProjectKey = @ProjectKey
	END	
	ELSE
	BEGIN
		-- there could be a valid project to copy OR we copy from a project type 
		
		IF @CopyProjectKey > 0
		UPDATE
			tProject
		SET
			tProject.GetRateFrom = p2.GetRateFrom,
			tProject.TimeRateSheetKey = p2.TimeRateSheetKey,
			tProject.TitleRateSheetKey = p2.TitleRateSheetKey,
			tProject.HourlyRate = p2.HourlyRate,
			tProject.GetMarkupFrom = p2.GetMarkupFrom,
			tProject.ItemRateSheetKey = p2.ItemRateSheetKey,
			tProject.ItemMarkup = p2.ItemMarkup,
			tProject.IOCommission = p2.IOCommission,
			tProject.BCCommission = p2.BCCommission,
			tProject.ScheduleDirection = p2.ScheduleDirection,
			tProject.ClassKey = ISNULL(p2.ClassKey, @ClassKey),
			tProject.BillingMethod = p2.BillingMethod,
			tProject.ExpensesNotIncluded = p2.ExpensesNotIncluded
		FROM tProject
			,tProject p2 (NOLOCK)
		WHERE
			tProject.ProjectKey = @ProjectKey 
		AND  
			p2.ProjectKey = @CopyProjectKey
			
		-- Check if we need to get defaults from the client
		If ISNULL(@ClientKey, 0) > 0
		BEGIN
			SELECT @GetRateFrom = GetRateFrom
				   ,@GetMarkupFrom = GetMarkupFrom
			FROM   tProject (NOLOCK)
			WHERE  ProjectKey = @ProjectKey
			
			-- If Get Rate from Client
			IF @GetRateFrom = 1
			BEGIN
				UPDATE tProject 
				SET    tProject.GetRateFrom = ISNULL(cl.GetRateFrom, 2)
					  ,tProject.TimeRateSheetKey = ISNULL(cl.TimeRateSheetKey, 0)
					  ,tProject.TitleRateSheetKey = ISNULL(cl.TitleRateSheetKey, 0)
					  ,tProject.HourlyRate = ISNULL(cl.HourlyRate, 0)
				FROM   tCompany cl (NOLOCK)
				WHERE  cl.CompanyKey = @ClientKey
				AND    cl.GetRateFrom IS NOT NULL
				AND    tProject.ProjectKey = @ProjectKey
			END	

			-- If Get Markup  from Client
			IF @GetMarkupFrom = 1
			BEGIN
				UPDATE tProject 
				SET    tProject.GetMarkupFrom = ISNULL(cl.GetMarkupFrom, 2)
					  ,tProject.ItemRateSheetKey = ISNULL(cl.ItemRateSheetKey, 0)
					  ,tProject.ItemMarkup = ISNULL(cl.ItemMarkup, 0)
				FROM   tCompany cl (NOLOCK)
				WHERE  cl.CompanyKey = @ClientKey
				AND    cl.GetMarkupFrom IS NOT NULL
				AND  tProject.ProjectKey = @ProjectKey
			END	
		END
			
		-- Now copy detail from CopyProjectKey to ProjectKey
		IF @CopyProjectKey > 0
		BEGIN
		
			UPDATE
				tProject
			SET
				tProject.BillingContact = CASE 
					WHEN tProject.ClientKey = p2.ClientKey THEN p2.BillingContact
					ELSE NULL
					END,
				tProject.OverrideRate = p2.OverrideRate,
				tProject.NonBillable = p2.NonBillable,
				tProject.ScheduleDirection = p2.ScheduleDirection,
				tProject.AnyoneChargeTime = p2.AnyoneChargeTime
			FROM tProject (NOLOCK) 
				 ,tProject p2 (NOLOCK)
			WHERE
				tProject.ProjectKey = @ProjectKey 
			AND  
				p2.ProjectKey = @CopyProjectKey

			 -- sptProjectCreate assigns people with AutoAssign = 0 and the creator even if AutoAssign = 0
			 -- Copy now people from the old project
			INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
			SELECT DISTINCT @ProjectKey  -- new ProjectKey
					,tAssignment.UserKey, 0
			FROM	tAssignment (NOLOCK)
			INNER JOIN tUser u (nolock) ON tAssignment.UserKey = u.UserKey
			WHERE	ProjectKey = @CopyProjectKey 
			AND		u.Active = 1
			AND		tAssignment.UserKey not in (Select UserKey from tAssignment (nolock) Where ProjectKey = @ProjectKey)

		END
		
		-- If a team was specified, add the people in it
		IF ISNULL(@TeamKey, 0) > 0
			INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
			SELECT DISTINCT @ProjectKey  -- new ProjectKey
					,tTeamUser.UserKey, 0
			FROM	tTeamUser (NOLOCK)
			INNER JOIN tUser u (nolock) ON tTeamUser.UserKey = u.UserKey
			WHERE	tTeamUser.TeamKey = @TeamKey
			AND		u.Active = 1
			AND		tTeamUser.UserKey not in (Select UserKey from tAssignment (nolock) Where ProjectKey = @ProjectKey)

		UPDATE tAssignment 
		SET    tAssignment.HourlyRate = u.HourlyRate
		FROM   tUser u (NOLOCK)
		WHERE  tAssignment.UserKey = u.UserKey
		AND    tAssignment.ProjectKey = @ProjectKey
		
		if @CopyFrom = @kCopyFromProject
		BEGIN			
			-- cannot use sptProjectCopyTasks because it copies tasks from tTask
			--exec sptProjectCopyTasks @ProjectKey, @CopyProjectKey, @CopyEstimate, @UserKey

			-- copy tasks from tEstimateTaskTemp
			-- this will also copy estimates of type task only (1), task/service (2), task/user (3)
			exec sptProjectCopyTasksEntity @ProjectKey, @CopyProjectKey, @CopyEstimate, @Entity, @EntityKey, @UserKey
		END
		
		if @CopyFrom = @kCopyFromProjectType
		BEGIN
			
			Declare @MaxOrder int, @NewTaskKey int, @CurOrder int, @CurMTID varchar(100)
			Select @MaxOrder = Max(DisplayOrder), @CurOrder = 0 from tProjectTypeMasterTask (NOLOCK) Where ProjectTypeKey = @ProjectTypeKey
			
			While @CurOrder < @MaxOrder
			BEGIN
				Select @CurOrder = @CurOrder + 1
				Select @CurMTID = TaskID from tProjectTypeMasterTask (NOLOCK) 
					inner join tMasterTask (NOLOCK) on tProjectTypeMasterTask.MasterTaskKey = tMasterTask.MasterTaskKey
				Where ProjectTypeKey = @ProjectTypeKey and DisplayOrder = @CurOrder
				if @CurMTID is not null
				BEGIN
					exec sptTaskQuickInsert @ProjectKey, @CurMTID, NULL, 0, 1, @NewTaskKey OUTPUT
				END
			END
			
			exec sptTaskOrder @ProjectKey, 0, 0, 0
		END
		
		
		If isnull(@EstimateInternalApprover, 0) <> 0
			UPDATE tEstimate
			SET    InternalApprover = @EstimateInternalApprover
			WHERE  ProjectKey = @ProjectKey
			AND    InternalStatus = 1
			
	END
		
	-- this will copy estimates of type service only (4), segment/service (5), also copy the approval status
	exec sptProjectCopyEstimates @Entity, @EntityKey,@ProjectKey, 1, @UserKey

	-- Defaulting Layout, Estimate Template and Billing Manager from client onto Estimate
	DECLARE @DefaultLayoutKey int, @DefaultEstimateTemplateKey int, @DefaultBillingManagerKey int
	If ISNULL(@ClientKey, 0) > 0
		Select @DefaultLayoutKey = ISNULL(LayoutKey, 0), @DefaultEstimateTemplateKey = ISNULL(EstimateTemplateKey, 0) , @DefaultBillingManagerKey = ISNULL(BillingManagerKey, 0 ) from tCompany (NOLOCK) Where CompanyKey = @ClientKey

	if ISNULL(@DefaultEstimateTemplateKey, 0) <> 0
		UPDATE tEstimate
		SET EstimateTemplateKey = @DefaultEstimateTemplateKey
		WHERE ProjectKey = @ProjectKey

	if ISNULL(@DefaultLayoutKey, 0) <> 0
		UPDATE tEstimate
		SET LayoutKey = @DefaultLayoutKey
		WHERE ProjectKey = @ProjectKey

	if ISNULL(@DefaultBillingManagerKey, 0) <> 0
			UPDATE tProject
			SET BillingManagerKey = @DefaultBillingManagerKey
			WHERE ProjectKey = @ProjectKey
	
	Delete tProjectUserServices Where ProjectKey = @ProjectKey
	
	Insert tProjectUserServices (ProjectKey, UserKey, ServiceKey)
		Select DISTINCT @ProjectKey, u.UserKey, u.DefaultServiceKey
		from tUser u (nolock) 
		inner join tAssignment a (nolock) on u.UserKey = a.UserKey  
		Where ISNULL(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey
		And   a.ProjectKey = @ProjectKey And u.DefaultServiceKey IS NOT NULL

	UPDATE	tProject
	SET		TeamKey = @TeamKey
	       ,ModelYear = @ModelYear
	WHERE	ProjectKey = @ProjectKey

	IF @Entity = 'tLead'
	BEGIN
		UPDATE	tProject
		SET		LeadKey = @EntityKey
		WHERE	ProjectKey = @ProjectKey
		
		UPDATE tLead
		SET    ConvertEntity = 'tProject'
		      ,ConvertEntityKey = @ProjectKey
		      ,ConvertedByKey = @UserKey
			  ,DateConverted = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
		WHERE  LeadKey = @EntityKey
		      
	END
	ELSE
		UPDATE	tProject
		SET		LeadKey = @LeadKey
		WHERE	ProjectKey = @ProjectKey
			
			
  -- also since we copy now the approval status, rollup the estimates data
  exec sptEstimateRollupDetail @ProjectKey
  			
 /* set nocount on */
 return 1
GO
