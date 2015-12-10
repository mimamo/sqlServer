USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUpdate]
	@LeadKey int,
	@CompanyKey int,
	@Subject varchar(200),
	@ContactCompanyKey int,
	@ContactKey int,
	@AccountManagerKey int,
	@ProjectTypeKey int,
	@Competitors varchar(1000),
	@LeadStatusKey int,
	@LeadStageKey int,
	@LeadOutcomeKey int,
	@CurrentStatus varchar(300),
	@OutcomeComment text,
	@Probability int,
	@SaleAmount money,
	@OutsideCostsGross money,
	@MediaGross money,
	@OutsideCostsPerc decimal(24,4),
	@MediaPerc decimal(24,4),
	@AGI money,
	@SubAmount money,
	@Margin int,
	@Bid tinyint,
	@BidDate smalldatetime,
	@StartDate smalldatetime,
	@EstCloseDate smalldatetime,
	@ActualCloseDate smalldatetime,
	@Comments text,
	@WWPCurrentLevel smallint,
	@WWPNeedSupply tinyint,
	@WWPNeedSupplyComment text,
	@WWPTimeline tinyint,
	@WWPTimelineComment text,
	@WWPDecisionMakers tinyint,
	@WWPDecisionMakersComment text,
	@WWPBudget tinyint,
	@WWPBudgetComment text,
	@UpdatedByKey int,
	@CMFolderKey int,
	@DateConverted smalldatetime,
	@EstimateType smallint = NULL,
	@TemplateProjectKey int = NULL,
	@MultipleSegments tinyint = NULL,
	@LayoutKey int = NULL,
	@ConvertEntity varchar(50) = NULL,
	@ConvertEntityKey int = NULL,
	@GLCompanyKey int = NULL,
	@Labor money = NULL,
	@Months int = NULL,
	@SpreadExpense smallint = NULL,
	@ClientDivisionKey int = NULL,
	@ClientProductKey int = NULL

AS --Encrypt 
/*
|| When     Who Rel      What
|| 5/6/09   GWG 10.500   Added isnull wrapping for maxlevel
|| 7/20/09  GWG 10.505   Added ability to save with a null stage key
|| 9/9/09   GWG 10.509   Removed custom field key
|| 3/10/10  CRG 10.5.2.0 Added EstimateType, TemplateProjectKey, MultipleSegments, LayoutKey (optional for backward compatability).
|| 3/23/10  GHL 10.5.2.1 Added saving of project snapshot by calling sptEstimateSaveProjectTemp
|| 04/01/10 MFT 10.5.2.1 Added ConvertEntity & ConvertEntityKey
|| 10/27/10 RLB 10.5.3.7 Fixed Date Converted not being saved on updates
|| 06/21/12 GHL 10.5.5.7 Added GL Company
|| 8/20/12  CRG 10.5.5.9 Added Labor
|| 8/27/12  CRG 10.5.5.9 Added Months and SpreadExpense
|| 10/02/13 MAS 10.5.7.3 (179034) Added ClientDivisionKey & ClientProductKey
|| 12/12/14 GHL 10.5.8.7 (239178) Update forecast detail when updating the opportunity
*/


Declare @Active tinyint, @CurStageKey int, @CurProb int, @CurSaleAmount money, @CurEstCloseDate smalldatetime
Declare @CurLevel int, @Level int, @NS tinyint, @Time tinyint, @Budget tinyint, @MaxLevel int, @RetVal int,
		@CurEstimateType smallint, @CurTemplateProjectKey int, @CurMultipleSegments tinyint, @CurLayoutKey int,
		@CurLabor money, @CurMonths int, @CurSpreadExpense smallint

if @LeadKey = 0
BEGIN
	IF @EstimateType IS NULL
		SELECT	@EstimateType = 1 --Default to Project

	INSERT tLead
		(
		CompanyKey,
		Subject,
		ContactCompanyKey,
		ContactKey,
		AccountManagerKey,
		ProjectTypeKey,
		Competitors,
		LeadStatusKey,
		LeadStageKey,
		LeadOutcomeKey,
		CurrentStatus,
		OutcomeComment,
		Probability,
		SaleAmount,
		OutsideCostsGross,
		MediaGross,
		OutsideCostsPerc,
		MediaPerc,
		AGI,
		SubAmount,
		Margin,
		Bid,
		BidDate,
		StartDate,
		EstCloseDate,
		ActualCloseDate,
		Comments,
		WWPCurrentLevel,
		WWPNeedSupply,
		WWPNeedSupplyComment,
		WWPTimeline,
		WWPTimelineComment,
		WWPDecisionMakers,
		WWPDecisionMakersComment,
		WWPBudget,
		WWPBudgetComment,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated,
		CMFolderKey,
		DateConverted,
		EstimateType,
		TemplateProjectKey,
		MultipleSegments,
		LayoutKey,
		ConvertEntity,
		ConvertEntityKey,
		GLCompanyKey,
		Labor,
		Months,
		SpreadExpense,
		ClientDivisionKey,
		ClientProductKey
		)

	VALUES
		(
		@CompanyKey,
		@Subject,
		@ContactCompanyKey,
		@ContactKey,
		@AccountManagerKey,
		@ProjectTypeKey,
		@Competitors,
		@LeadStatusKey,
		@LeadStageKey,
		@LeadOutcomeKey,
		@CurrentStatus,
		@OutcomeComment,
		@Probability,
		@SaleAmount,
		@OutsideCostsGross,
		@MediaGross,
		@OutsideCostsPerc,
		@MediaPerc,
		@AGI,
		@SubAmount,
		@Margin,
		@Bid,
		@BidDate,
		@StartDate,
		@EstCloseDate,
		@ActualCloseDate,
		@Comments,
		@WWPCurrentLevel,
		@WWPNeedSupply,
		@WWPNeedSupplyComment,
		@WWPTimeline,
		@WWPTimelineComment,
		@WWPDecisionMakers,
		@WWPDecisionMakersComment,
		@WWPBudget,
		@WWPBudgetComment,
		@UpdatedByKey,
		@UpdatedByKey,
		GETUTCDATE(),
		GETUTCDATE(),
		@CMFolderKey,
		@DateConverted,
		@EstimateType,
		@TemplateProjectKey,
		@MultipleSegments,
		@LayoutKey,
		@ConvertEntity,
		@ConvertEntityKey,
		@GLCompanyKey,
		@Labor,
		@Months,
		@SpreadExpense,
		@ClientDivisionKey,
		@ClientProductKey
		)
	
	
	
	SELECT @LeadKey = @@IDENTITY

	if @LeadStageKey is not null
		Insert tLeadStageHistory (LeadKey, LeadStageKey, HistoryDate, Comment, Probability, SaleAmount, EstCloseDate)
		values (@LeadKey, @LeadStageKey, GETUTCDATE(), @CurrentStatus, @Probability, @SaleAmount, @EstCloseDate)
	
	if @WWPNeedSupply = 1
		if @WWPTimeline = 1 
			if @WWPBudget = 1
				Select @Level = 4
			else
				Select @Level = 3
		else
			Select @Level = 2
	else
		Select @Level = 1
		
	Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
	Values ('tLead', @LeadKey, @Level, @CurrentStatus, GETUTCDATE())
	
	-- capture a snapshot of the project
	if @TemplateProjectKey > 0 
		exec @RetVal = sptEstimateSaveProjectTemp 'tLead', @LeadKey ,@TemplateProjectKey 
	
END
ELSE
BEGIN

	--Add a history item when one of the items changes
	Select @CurStageKey = LeadStageKey, 
		@CurProb = Probability,
		@CurSaleAmount = SaleAmount,
		@CurEstCloseDate = EstCloseDate,
		@CurLevel = WWPCurrentLevel,
		@CurEstimateType = ISNULL(EstimateType, 1),
		@CurTemplateProjectKey = TemplateProjectKey,
		@CurMultipleSegments = ISNULL(MultipleSegments, 0),
		@CurLayoutKey = LayoutKey,
		@CurLabor = Labor,
		@CurMonths = Months,
		@CurSpreadExpense = SpreadExpense
	from tLead (nolock) Where LeadKey = @LeadKey
	
	if @LeadStageKey is not null
	BEGIN
		if @CurStageKey <> @LeadStageKey OR @CurProb <> @Probability OR @CurSaleAmount <> @SaleAmount OR @CurEstCloseDate <> @EstCloseDate
			Insert tLeadStageHistory (LeadKey, LeadStageKey, HistoryDate, Comment, Probability, SaleAmount, EstCloseDate)
			values (@LeadKey, @LeadStageKey, GETUTCDATE(), @CurrentStatus, @Probability, @SaleAmount, @EstCloseDate)
	END
	
	if @WWPNeedSupply = 1
		if @WWPTimeline = 1 
			if @WWPBudget = 1
				Select @Level = 4
			else
				Select @Level = 3
		else
			Select @Level = 2
	else
		Select @Level = 1
	
	if ISNULL(@CurLevel, 0) <> ISNULL(@Level, 0)
		Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
		Values ('tLead', @LeadKey, @Level, @CurrentStatus, GETUTCDATE())
	
	
	UPDATE
		tLead
	SET
		Subject = @Subject,
		ContactCompanyKey = @ContactCompanyKey,
		ContactKey = @ContactKey,
		AccountManagerKey = @AccountManagerKey,
		ProjectTypeKey = @ProjectTypeKey,
		Competitors = @Competitors,
		LeadStatusKey = @LeadStatusKey,
		LeadStageKey = @LeadStageKey,
		LeadOutcomeKey = @LeadOutcomeKey,
		CurrentStatus = @CurrentStatus,
		OutcomeComment = @OutcomeComment,
		Probability = @Probability,
		SaleAmount = @SaleAmount,
		OutsideCostsGross = @OutsideCostsGross,
		MediaGross = @MediaGross,
		OutsideCostsPerc = @OutsideCostsPerc,
		MediaPerc = @MediaPerc,
		AGI = @AGI,
		SubAmount = @SubAmount,
		Margin = @Margin,
		Bid = @Bid,
		BidDate = @BidDate,
		StartDate = @StartDate,
		EstCloseDate = @EstCloseDate,
		ActualCloseDate = @ActualCloseDate,
		Comments = @Comments,
		WWPCurrentLevel = @WWPCurrentLevel,
		WWPNeedSupply = @WWPNeedSupply,
		WWPNeedSupplyComment = @WWPNeedSupplyComment,
		WWPTimeline = @WWPTimeline,
		WWPTimelineComment = @WWPTimelineComment,
		WWPDecisionMakers = @WWPDecisionMakers,
		WWPDecisionMakersComment = @WWPDecisionMakersComment,
		WWPBudget = @WWPBudget,
		WWPBudgetComment = @WWPBudgetComment,
		UpdatedByKey = @UpdatedByKey,
		DateUpdated = GETUTCDATE(),
		CMFolderKey = @CMFolderKey,
		DateConverted = @DateConverted,
		EstimateType = ISNULL(@EstimateType, @CurEstimateType),
		TemplateProjectKey = ISNULL(@TemplateProjectKey, @CurTemplateProjectKey),
		MultipleSegments = ISNULL(@MultipleSegments, @CurMultipleSegments),
		LayoutKey = ISNULL(@LayoutKey, @CurLayoutKey),
		ConvertEntity = @ConvertEntity,
		ConvertEntityKey = @ConvertEntityKey,
		GLCompanyKey = @GLCompanyKey,
		Labor = ISNULL(@Labor, @CurLabor),
		Months = ISNULL(@Months, @CurMonths),
		SpreadExpense = ISNULL(@SpreadExpense, @CurSpreadExpense),
		ClientDivisionKey = @ClientDivisionKey,
		ClientProductKey = @ClientProductKey
	WHERE
		LeadKey = @LeadKey 
		
		if (isnull(@TemplateProjectKey, 0) <> isnull(@CurTemplateProjectKey, 0)) 
		begin
			delete tEstimateTaskTemp where Entity = 'tLead' and EntityKey = @LeadKey
			delete tEstimateTaskTempPredecessor where Entity = 'tLead' and EntityKey = @LeadKey
			delete tEstimateTaskTempUser where Entity = 'tLead' and EntityKey = @LeadKey
		end 
		
		-- capture a snapshot of the project
		-- sptEstimateSaveProjectTemp will abort if records exist for LeadKey 
		if isnull(@TemplateProjectKey, 0) > 0
			exec @RetVal = sptEstimateSaveProjectTemp 'tLead', @LeadKey ,@TemplateProjectKey 

		update tForecastDetail
		set    RegenerateNeeded = 1
		where  Entity = 'tLead'
		and    EntityKey = @LeadKey

		 
END
		-- Company
		Select @CurLevel = ISNULL(WWPCurrentLevel, 0) from tCompany (nolock) Where CompanyKey = @ContactCompanyKey
		
		Select @MaxLevel = ISNULL(MAX(WWPCurrentLevel), 0) from tLead (nolock)
		Where ContactCompanyKey = @ContactCompanyKey and 
		(LeadOutcomeKey is null OR LeadOutcomeKey in (Select LeadOutcomeKey from tLeadOutcome (nolock) Where CompanyKey = @CompanyKey and PositiveOutcome = 1))
		
		if @CurLevel <> ISNULL(@MaxLevel, 0)
		BEGIN
			Update tCompany Set WWPCurrentLevel = @MaxLevel Where CompanyKey = @ContactCompanyKey
			
			Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
			Values ('tCompany', @ContactCompanyKey, @MaxLevel, NULL, GETUTCDATE())
		END
		
		
		-- anyone in the people tab
		declare @CurUserKey int
		select @CurUserKey = -1
		While 1=1
		BEGIN
			Select @CurUserKey = MIN(UserKey) from tLeadUser (nolock) Where LeadKey = @LeadKey and UserKey > @CurUserKey
				if @CurUserKey is null
					break
			
			Select @CurLevel = ISNULL(WWPCurrentLevel, 0) from tUser (nolock) Where UserKey = @CurUserKey
			
			Select @MaxLevel = ISNULL(MAX(WWPCurrentLevel), 0) from tLead l (nolock)
			inner join tLeadUser lu on l.LeadKey = lu.LeadKey
			Where lu.UserKey = @CurUserKey and 
			(LeadOutcomeKey is null OR LeadOutcomeKey in (Select LeadOutcomeKey from tLeadOutcome (nolock) Where CompanyKey = @CompanyKey and PositiveOutcome = 1))
		
			if @CurLevel <> ISNULL(@MaxLevel, 0)
			BEGIN
				Update tUser Set WWPCurrentLevel = @MaxLevel Where UserKey = @CurUserKey
				
				Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
				Values ('tUser', @CurUserKey, @MaxLevel, NULL, GETUTCDATE())
			END
		
		END
		
		
		
return @LeadKey
GO
