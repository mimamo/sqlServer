USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadConvertToCampaign]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadConvertToCampaign]
	@LeadKey int,
	@CampaignID varchar(50),
	@CampaignName varchar(200),
	@CustomerID varchar(50),
	@UserKey int = null
AS

/*
|| When      Who Rel      What
|| 3/15/10   CRG 10.5.1.9 Created
|| 3/19/10   GHL 10.5.2.0 Added copying of estimates
|| 4/07/10   GWG 10.5.2.0 Added the hooks for updating tLead with the convert entity/key
|| 4/14/10   GHL 10.5.2.1 Fixed tLead update
|| 4/23/10   GHL 10.5.2.1 Copying now approval status of estimates. Added rollup to the campaign
|| 11/11/10  GHL 10.5.3.8 (94144) Modified call to sptEstimateCopy (new param UserKey)
|| 07/25/12  GHL 10.5.5.8 Propagate GLCompanyKey from the opportunity
|| 07/25/12  WDF 10.5.6.2 (157606) Modified call to sptCampaignUpdate (new params ClientDivisionKey & ClientProductKey)
|| 01/22/13  MAS 10.5.6.4  Modified call to sptCampaignUpdate (new param UserKey)
*/ 

	IF isnull(@LeadKey, 0) <= 0 
		RETURN -100 

	DECLARE	@CompanyKey int,
			@ContactCompanyKey int,
			@Description varchar(4000),
			@LayoutKey int,
			@MultipleSegments tinyint,
			@CompanyRetVal int,
			@CampaignKey int,
			@GLCompanyKey int,
			@RestrictToGLCompany int,
			@UseGLCompany int

	SELECT	@CompanyKey = CompanyKey,
			@ContactCompanyKey = ContactCompanyKey,
			@Description = SUBSTRING(Comments, 1, 4000),
			@LayoutKey = LayoutKey,
			@MultipleSegments = MultipleSegments,
			@GLCompanyKey = GLCompanyKey
	FROM	tLead (nolock)
	WHERE	LeadKey = @LeadKey
	
	select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) 
	      ,@UseGLCompany = isnull(UseGLCompany, 0)
	from tPreference (nolock) where CompanyKey = @CompanyKey
	
	-- if we restrict, gl company should already be set on the tLead record, do this only if it is not restricted 
	if @RestrictToGLCompany = 0
		select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @UserKey

	IF @CustomerID IS NOT NULL
	BEGIN
		--Turn @ContactCompanyKey into a Client
		EXEC @CompanyRetVal = sptCompanyConvertToClient
				@CompanyKey,
				@ContactCompanyKey,
				@CustomerID

		IF @CompanyRetVal < 0
			RETURN @CompanyRetVal - 100
	END

	DECLARE	@RetVal int
	
	EXEC @RetVal = sptCampaignUpdate
						0, --@CampaignKey
						@UserKey,
						@CompanyKey,
						@CampaignID,
						@CampaignName,
						@ContactCompanyKey,
						@Description, --varchar(4000)
						NULL, --@Objective
						NULL, --@StartDate
						NULL, --@EndDate
						NULL, --@AEKey
						1, --@Active
						NULL, --@CustomFieldKey
						NULL, --@GetActualsBy
						@LayoutKey,
						@MultipleSegments,
						NULL, --@BillBy
						NULL, --@OneLinePer
						NULL, --@ContactKey
						@GLCompanyKey,
						NULL,  -- @ClientDivisionKey
						NULL   -- @ClientProductKey
	
	IF @RetVal < 0
		RETURN @RetVal
		
	SELECT @CampaignKey = @RetVal
		
	UPDATE	tCampaign
	SET		LeadKey = @LeadKey
	WHERE	CampaignKey = @CampaignKey
		
	create table #segment(SegmentKey int null, NewSegmentKey int null) 
		
	IF @MultipleSegments = 1
	BEGIN
		DECLARE	@NewKey int
	
		DECLARE	@CampaignSegmentKey int
		SELECT	@CampaignSegmentKey = 0
		
		WHILE (1=1)
		BEGIN
			SELECT	@CampaignSegmentKey = MIN(CampaignSegmentKey)
			FROM	tCampaignSegment (nolock)
			WHERE	LeadKey = @LeadKey
			AND		CampaignSegmentKey > @CampaignSegmentKey
			
			IF @CampaignSegmentKey IS NULL
				BREAK
				
			INSERT	tCampaignSegment
					(CampaignKey,
					SegmentName,
					SegmentDescription,
					DisplayOrder,
					PlanStart,
					PlanComplete,
					ProjectTypeKey)
			SELECT	@CampaignKey,
					SegmentName,
					SegmentDescription,
					DisplayOrder,
					PlanStart,
					PlanComplete,
					ProjectTypeKey
			FROM	tCampaignSegment (nolock)
			WHERE	CampaignSegmentKey = @CampaignSegmentKey
			
			SELECT	@NewKey = @@IDENTITY

			INSERT  #segment (SegmentKey, NewSegmentKey)
			VALUES (@CampaignSegmentKey, @NewKey)
			
			INSERT	tWorkTypeCustom
					(Entity,
					EntityKey,
					WorkTypeKey,
					Subject,
					Description)
			SELECT	'tCampaignSegment',
					@NewKey,
					WorkTypeKey,
					Subject,
					Description
			FROM	tWorkTypeCustom (nolock)
			WHERE	Entity = 'tCampaignSegment'
			AND		EntityKey = @CampaignSegmentKey

		END
	END
	ELSE
	BEGIN
		INSERT	tWorkTypeCustom
				(Entity,
				EntityKey,
				WorkTypeKey,
				Subject,
				Description)
		SELECT	'tCampaign',
				@CampaignKey,
				WorkTypeKey,
				Subject,
				Description
		FROM	tWorkTypeCustom (nolock)
		WHERE	Entity = 'tLead'
		AND		EntityKey = @LeadKey
	END	
	
		
	DECLARE @EstimateKey int
	DECLARE @NewEstimateKey int
	DECLARE @CopyApproval int
		
	SELECT @CopyApproval = 1 -- copy approval status of the estimates
		
	SELECT @EstimateKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @EstimateKey = MIN(EstimateKey)
		FROM   tEstimate (NOLOCK)
		WHERE  LeadKey = @LeadKey
		AND    EstimateKey > @EstimateKey
		
		IF @EstimateKey IS NULL
			BREAK
					
		EXEC @RetVal = sptEstimateCopy @EstimateKey, NULL, @CampaignKey, NULL, @CopyApproval, @UserKey, @NewEstimateKey OUTPUT
		
	END
	
	UPDATE tEstimateTaskLabor
	SET    tEstimateTaskLabor.CampaignSegmentKey = #segment.NewSegmentKey
	FROM   tEstimate (NOLOCK)
	       ,#segment
	WHERE  tEstimate.CampaignKey = @CampaignKey
	AND    tEstimate.EstimateKey = tEstimateTaskLabor.EstimateKey 
	AND    tEstimateTaskLabor.CampaignSegmentKey = #segment.SegmentKey

	UPDATE tEstimateTaskExpense
	SET    tEstimateTaskExpense.CampaignSegmentKey = #segment.NewSegmentKey
	FROM   tEstimate (NOLOCK)
	       ,#segment
	WHERE  tEstimate.CampaignKey = @CampaignKey
	AND    tEstimate.EstimateKey = tEstimateTaskExpense.EstimateKey 
	AND    tEstimateTaskExpense.CampaignSegmentKey = #segment.SegmentKey
	
	Update tLead Set ConvertEntity = 'tCampaign', ConvertEntityKey = @CampaignKey
	Where  LeadKey = @LeadKey
 
	EXEC sptEstimateRollupCampaign @CampaignKey
	 
	RETURN @CampaignKey
GO
