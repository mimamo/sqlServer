USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUpdate]
	@EstimateKey int,
	@EstimateName varchar(100),
	@EstimateNumber varchar(50),
	@EstimateDate smalldatetime,
	@DeliveryDate smalldatetime,
	@Revision int,
	@EstDescription text,
	@EstimateTemplateKey int,
	@PrimaryContactKey int,
	@AddressKey int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@LaborTaxable tinyint,
	@Contingency decimal(24, 4),
	@ChangeOrder tinyint,
	@InternalApprover int,
	@InternalDueDate smalldatetime,
	@ExternalApprover int,
	@ExternalDueDate smalldatetime,
	@MultipleQty tinyint,
	@ApprovedQty smallint,
	@Expense1 varchar(100),
	@Expense2 varchar(100),
	@Expense3 varchar(100),
	@Expense4 varchar(100),
	@Expense5 varchar(100),
	@Expense6 varchar(100),
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250)
	

AS --Encrypt

 /*
  || When     Who Rel   What
  || 06/25/08 GHL 8.515 (29365) Added check of budget tasks   
  ||                    When saving the project, we check for tasks on approved estimate
  ||                    When saving and approving the estimate, we must check the tasks
  || 07/15/08 GWG 10.005Removed the deletion of estimate task and task assignment rows if track budget = 1
  ||					This was deleting rows if hours were entered at detail level
  */
  
Declare @EstType smallint, @ProjectKey int, @OldApprovedQty int, @CompanyKey int

Select	@EstType = e.EstType
		,@ProjectKey = e.ProjectKey
		,@OldApprovedQty = e.ApprovedQty 
		,@CompanyKey = e.CompanyKey
from tEstimate e (nolock)
Where e.EstimateKey = @EstimateKey

	-- Check for a duplicate project number
	SELECT @EstimateNumber = REPLACE(REPLACE(REPLACE(REPLACE(@EstimateNumber, '&', ''), ',', ''), '"', ''), '''', '')

	IF EXISTS(
			SELECT 1 FROM tEstimate e (NOLOCK)
			WHERE  e.EstimateKey <> @EstimateKey
			AND    e.EstimateNumber = @EstimateNumber 
			AND    e.CompanyKey = @CompanyKey
			)
		RETURN -1

	UPDATE
		tEstimate
	SET
		EstimateName = @EstimateName,
		EstimateNumber = @EstimateNumber,
		EstimateDate = @EstimateDate,
		DeliveryDate = @DeliveryDate,
		Revision = @Revision,
		EstDescription = @EstDescription,
		EstimateTemplateKey = @EstimateTemplateKey,
		PrimaryContactKey = @PrimaryContactKey,
		AddressKey = @AddressKey,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		LaborTaxable = @LaborTaxable,
		Contingency = @Contingency,
		ChangeOrder = @ChangeOrder,
		InternalApprover = @InternalApprover,
		InternalDueDate = @InternalDueDate,
		ExternalApprover = @ExternalApprover,
		ExternalDueDate = @ExternalDueDate,
		MultipleQty = @MultipleQty,
		ApprovedQty = @ApprovedQty,
		Expense1 = @Expense1,
		Expense2 = @Expense2,
		Expense3 = @Expense3,
		Expense4 = @Expense4,
		Expense5 = @Expense5,
		Expense6 = @Expense6,
		UserDefined1 = @UserDefined1,
		UserDefined2 = @UserDefined2,
		UserDefined3 = @UserDefined3,
		UserDefined4 = @UserDefined4,
		UserDefined5 = @UserDefined5,
		UserDefined6 = @UserDefined6,
		UserDefined7 = @UserDefined7,
		UserDefined8 = @UserDefined8,
		UserDefined9 = @UserDefined9,
		UserDefined10 = @UserDefined10
	WHERE
		EstimateKey = @EstimateKey 
		

-- By task/service or service

if @EstType = 2 Or @EstType = 4
Begin
	Delete tEstimateTaskLabor
	Where
		EstimateKey = @EstimateKey and
		ServiceKey not in (Select ServiceKey from tEstimateService (nolock) Where EstimateKey = @EstimateKey)

	Delete tEstimateTaskAssignmentLabor
	Where
		EstimateKey = @EstimateKey and
		ServiceKey not in (Select ServiceKey from tEstimateService (nolock) Where EstimateKey = @EstimateKey)
End

-- By task only
If @EstType = 1
Begin
	Delete tEstimateTask
	Where 
		EstimateKey = @EstimateKey and
		TaskKey not in (Select TaskKey from tTask (nolock) Where ProjectKey = @ProjectKey and TrackBudget = 1)
End


-- Make sure that the internal approver is assigned to the project
-- This SP will do the job
exec sptAssignmentInsertFromTask @ProjectKey, @InternalApprover


-- Rollup the expenses to tEstimateTask if EstType = 1 (by task) if the ApprovedQty has changed
if @EstType = 1 And @ApprovedQty <> @OldApprovedQty
	exec sptEstimateTaskExpenseRollupDetail @EstimateKey


Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey


	RETURN 1
GO
