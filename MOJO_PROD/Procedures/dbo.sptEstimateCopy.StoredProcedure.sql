USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateCopy]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateCopy]
	@EstimateKey int,
	@ToProjectKey int = null,
	@ToCampaignKey int = null,
	@ToLeadKey int = null,
	@CopyApproval int = 0,
	@UserKey int = null,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 06/06/08  GHL 8.512  (27493) Creating now estimate expenses by order of EstimateTaskExpenseKey so that the expenses
||                       are in the same order than the original estimate.
|| 02/11/10  GHL 10.518  Added Campaign, Lead, Segment
|| 03/04/10  RLB 10.519  Added CompanyKey when copying Estimates
|| 03/19/10  GHL 10.520  Added AddressKey and LayoutKey. Added UnitRate, Height, Width, CM.
||                       Added params @ToProjectKey, @ToCampaignKey, @ToLeadKey so that we can copy from tLead to tCampaign
|| 11/11/10  GHL 10.537  (94144) Added UserKey param to modify tEstimate.EnteredBy
|| 09/07/11  RLB 10.548  (120593) Copying service comments
|| 09/23/11  GHL 10.548  (120964) Added copying of tEstimateTaskLaborLevel
|| 11/07/12  MFT 10.561  (159052) Added copying of LineFormat
|| 06/12/13  WDF 10.569  (181055) Added copying of VendorKey
|| 03/05/15  GHL 10.590  Added new fields and tables for Abelson/Taylor
*/

	DECLARE @CompanyKey INT
			,@ProjectKey INT
			,@CampaignKey INT
			,@LeadKey INT
			,@EstimateNumber VARCHAR(50)
			,@RetVal INT
			,@DeliveryDate smalldatetime
			,@CopyOf varchar(20)
			
	SELECT @CopyOf = 'Copy Of '
			
	SELECT  @CompanyKey = isnull(p.CompanyKey, e.CompanyKey)
			,@ProjectKey = e.ProjectKey
			,@CampaignKey = e.CampaignKey
			,@LeadKey = e.LeadKey
			,@DeliveryDate = e.DeliveryDate
	FROM    tEstimate e (NOLOCK)
		LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
	WHERE   e.EstimateKey =	@EstimateKey
	
	
	-- prevent infinite loops in calling sps if we by mistake we have same projects/campaigns/opps
	IF ISNULL(@ToProjectKey, 0) >0 AND ISNULL(@ToProjectKey, 0) = ISNULL(@ProjectKey, 0)
		SELECT @ToProjectKey = NULL
	IF ISNULL(@ToCampaignKey, 0) >0 AND ISNULL(@ToCampaignKey, 0) = ISNULL(@CampaignKey, 0)
		SELECT @ToCampaignKey = NULL
	IF ISNULL(@ToLeadKey, 0) >0 AND ISNULL(@ToLeadKey, 0) = ISNULL(@LeadKey, 0)
		SELECT @ToLeadKey = NULL
		 
				
	IF ISNULL(@ToProjectKey, 0) >0
		SELECT @ProjectKey = @ToProjectKey
		      ,@CampaignKey = NULL
		      ,@LeadKey = NULL
		      ,@CopyOf = ''
		      
	IF ISNULL(@ToCampaignKey, 0) >0
		SELECT @ProjectKey = NULL
		      ,@CampaignKey = @ToCampaignKey
		      ,@LeadKey = NULL
		      ,@CopyOf = ''
		      
	IF ISNULL(@ToLeadKey, 0) >0
		SELECT @ProjectKey = NULL
		      ,@CampaignKey = NULL
		      ,@LeadKey = @ToLeadKey
		      ,@CopyOf = ''
		 		
	EXEC sptEstimateGetNextEstimateNum
		@CompanyKey,
		@ProjectKey,
		@CampaignKey,
	    @LeadKey,
		@RetVal OUTPUT,
		@EstimateNumber OUTPUT

	IF @RetVal <> 1
		RETURN -1	
		
	 insert tEstimate
		   (
		    CompanyKey
		   ,ProjectKey
		   ,CampaignKey
		   ,LeadKey
		   ,EstimateName
		   ,EstimateNumber
		   ,EstimateDate
		   ,Revision
		   ,EstType
		   ,PrimaryContactKey --08.15.2006
		   ,EstDescription
		   ,EstimateTemplateKey
		   ,ChangeOrder			-- Added after change orders use the same table
		 
		   ,InternalApprover	-- Since it is required on the UI
		   ,InternalApproval
		   ,InternalStatus
		   ,InternalDueDate
		   ,InternalComments
		   ,ExternalApprover
		   ,ExternalApproval
		   ,ExternalStatus
		   ,ExternalDueDate
		   ,ExternalComments
		 
		   ,MultipleQty
		   ,ApprovedQty
		   ,Expense1
		   ,Expense2
		   ,Expense3
		   ,Expense4
		   ,Expense5
		   ,Expense6
		   ,SalesTaxKey			-- Below Added in 7.9 					
		   ,SalesTaxAmount
		   ,SalesTax2Key
		   ,SalesTax2Amount
		   ,LaborTaxable
		   ,Contingency
		   ,EnteredBy
		   ,DateAdded
		   ,EstimateTotal
		   ,LaborGross
		   ,ExpenseGross
		   ,TaxableTotal
		   ,ContingencyTotal
		   ,LaborNet
		   ,ExpenseNet
		   ,Hours
		   ,DeliveryDate
		   ,AddressKey
		   ,LayoutKey
		   ,UseRateLevel
		   ,LineFormat
		   ,HideZeroAmountServices
		   ,IncludeInForecast
		   ,UseTitle
		   )
     select CompanyKey
		   ,@ProjectKey	
		   ,@CampaignKey
		   ,@LeadKey
           ,@CopyOf + SUBSTRING(EstimateName, 1, 90) -- Must be limited to 100
           ,@EstimateNumber
           ,CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETUTCDATE(), 101))
           ,1
		   ,EstType
		   ,PrimaryContactKey --08.15.2006
		   ,EstDescription
		   ,EstimateTemplateKey
		   ,ChangeOrder
		
		   ,InternalApprover	-- Since it is required on the UI
		   ,case when @CopyApproval = 1 then InternalApproval else null end
		   ,case when @CopyApproval = 1 then InternalStatus else 1 end
		   ,case when @CopyApproval = 1 then InternalDueDate else null end
		   ,case when @CopyApproval = 1 then InternalComments else null end
		   ,ExternalApprover
		   ,case when @CopyApproval = 1 then ExternalApproval else null end
		   ,case when @CopyApproval = 1 then ExternalStatus else 1 end
		   ,case when @CopyApproval = 1 then ExternalDueDate else null end
		   ,case when @CopyApproval = 1 then ExternalComments else null end
		   
		   ,MultipleQty
		   ,ApprovedQty
		   ,Expense1
		   ,Expense2
		   ,Expense3
		   ,Expense4
		   ,Expense5
		   ,Expense6
		   ,SalesTaxKey						
		   ,SalesTaxAmount
		   ,SalesTax2Key
		   ,SalesTax2Amount
		   ,LaborTaxable
		   ,Contingency
		   ,case when isnull(@UserKey, 0) > 0 then @UserKey else EnteredBy end
		   ,GETUTCDATE()
		   ,EstimateTotal
		   ,LaborGross
		   ,ExpenseGross
		   ,TaxableTotal
		   ,ContingencyTotal
		   ,LaborNet
		   ,ExpenseNet
		   ,Hours
		   ,@DeliveryDate
		   ,AddressKey
		   ,LayoutKey
		   ,UseRateLevel
		   ,LineFormat
		   ,HideZeroAmountServices
		   ,IncludeInForecast
		   ,UseTitle
	   from tEstimate (nolock)
      where EstimateKey = @EstimateKey
      
	 select @oIdentity = @@IDENTITY
	
	insert tEstimateTask
			(
			EstimateKey,
			TaskKey,
			Hours,
			Rate,
			EstLabor,
			BudgetExpenses,
			Markup,
			EstExpenses,
			Cost		 -- Added 7.9
			)
    select  @oIdentity,
			TaskKey,
			Hours,
			Rate,
			EstLabor,
			BudgetExpenses,
			Markup,
			EstExpenses,
			Cost
       from tEstimateTask (nolock)
      where EstimateKey = @EstimateKey

INSERT tEstimateTaskAssignmentLabor		-- Added in 7.9
		(
		EstimateKey,
		TaskKey,
		TaskAssignmentKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate
		)

	Select
		@oIdentity,
		TaskKey,
		TaskAssignmentKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate
	from tEstimateTaskAssignmentLabor (nolock)
      	where EstimateKey = @EstimateKey
      	

	INSERT tEstimateUser
		(
		EstimateKey,
		UserKey,
		BillingRate,
		Cost
		)

	Select
		@oIdentity,
		UserKey,
		BillingRate,
		Cost
	from tEstimateUser (nolock)
      	where EstimateKey = @EstimateKey

	INSERT tEstimateNotify		-- Added in 7.9 
		(EstimateKey
		, UserKey)
	Select
		@oIdentity,
		UserKey
	from tEstimateNotify (nolock)
      	where EstimateKey = @EstimateKey


	INSERT tEstimateTaskLabor
		(
		EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate,
		Cost, -- Added 7.9
		CampaignSegmentKey,
		Comments,
		TitleKey		
		)

	Select
		@oIdentity,
		TaskKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate,
		Cost,
		CampaignSegmentKey,
		Comments,
		TitleKey		
	from tEstimateTaskLabor (nolock)
      	where EstimateKey = @EstimateKey

	INSERT tEstimateTaskLaborTitle
		(
		EstimateKey,
		TaskKey,
		ServiceKey,
		Hours,
		Rate,
		Gross,
		Cost, 
		CampaignSegmentKey,
		TitleKey		
		)

	Select
		@oIdentity,
		TaskKey,
		ServiceKey,
		Hours,
		Rate,
		Gross,
		Cost, 
		CampaignSegmentKey,
		TitleKey		
	from tEstimateTaskLaborTitle (nolock)
      	where EstimateKey = @EstimateKey

	INSERT tEstimateTaskLaborLevel
		(
		EstimateKey,
		TaskKey,
		ServiceKey,
		RateLevel,
		Hours,
		Rate		
		)

	Select
		@oIdentity,
		TaskKey,
		ServiceKey,
		RateLevel,
		Hours,
		Rate		
	from tEstimateTaskLaborLevel (nolock)
      	where EstimateKey = @EstimateKey
      	
	Insert tEstimateService
		( EstimateKey, ServiceKey, Rate, Cost )
	Select @oIdentity, ServiceKey, Rate, Cost
		from tEstimateService (nolock) Where EstimateKey = @EstimateKey

	INSERT tEstimateTaskExpense
		(
		EstimateKey,
		TaskKey,
		ItemKey,
		VendorKey,
		ShortDescription,
		LongDescription,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		Billable,
		Markup,
		BillableCost,
		Taxable,
		Taxable2,
		
		Quantity2,
		UnitCost2,
		UnitDescription2,
		TotalCost2,
		Markup2,
		BillableCost2,
		
		Quantity3,
		UnitCost3,
		UnitDescription3,
		TotalCost3,
		Markup3,
		BillableCost3,

		Quantity4,
		UnitCost4,
		UnitDescription4,
		TotalCost4,
		Markup4,
		BillableCost4,

		Quantity5,
		UnitCost5,
		UnitDescription5,
		TotalCost5,
		Markup5,
		BillableCost5,

		Quantity6,
		UnitCost6,
		UnitDescription6,
		TotalCost6,
		Markup6,
		BillableCost6,
		
		DisplayOrder,
		CampaignSegmentKey,		

		UnitRate,
		UnitRate2,
		UnitRate3,
		UnitRate4,
		UnitRate5,
		UnitRate6,
		
		Height,
		Height2,
		Height3,
		Height4,
		Height5,
		Height6,
		 	
		Width,
		Width2,
		Width3,
		Width4,
		Width5,
		Width6,
		 
		ConversionMultiplier,
		ConversionMultiplier2,
		ConversionMultiplier3,
		ConversionMultiplier4,
		ConversionMultiplier5,
		ConversionMultiplier6 		

		)

	Select
		@oIdentity,
		TaskKey,
		ItemKey,
		VendorKey,
		ShortDescription,
		LongDescription,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		Billable,
		Markup,
		BillableCost,
		Taxable,
		Taxable2,
		
		Quantity2,
		UnitCost2,
		UnitDescription2,
		TotalCost2,
		Markup2,
		BillableCost2,
		
		Quantity3,
		UnitCost3,
		UnitDescription3,
		TotalCost3,
		Markup3,
		BillableCost3,

		Quantity4,
		UnitCost4,
		UnitDescription4,
		TotalCost4,
		Markup4,
		BillableCost4,

		Quantity5,
		UnitCost5,
		UnitDescription5,
		TotalCost5,
		Markup5,
		BillableCost5,

		Quantity6,
		UnitCost6,
		UnitDescription6,
		TotalCost6,
		Markup6,
		BillableCost6,
		
		DisplayOrder,
		CampaignSegmentKey,
		
		UnitRate,
		UnitRate2,
		UnitRate3,
		UnitRate4,
		UnitRate5,
		UnitRate6,
		
		Height,
		Height2,
		Height3,
		Height4,
		Height5,
		Height6,
		 	
		Width,
		Width2,
		Width3,
		Width4,
		Width5,
		Width6,
		 
		ConversionMultiplier,
		ConversionMultiplier2,
		ConversionMultiplier3,
		ConversionMultiplier4,
		ConversionMultiplier5,
		ConversionMultiplier6 		
				
	from tEstimateTaskExpense (nolock)
      	where EstimateKey = @EstimateKey
  	Order By EstimateTaskExpenseKey
  	
    return 1
GO
