USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPAdjustment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPAdjustment]
	(
		@Entity VARCHAR(50)
		,@EntityKey INT
		,@UIDEntityKey UNIQUEIDENTIFIER
		,@OldProjectKey INT
		,@NewProjectKey INT	
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/13/07 GHL 8.5   Creation to do transfers from projects
  ||                    We should reverse 2 transactions for the old project 
  ||                    And create 2 new ones if the new project is billable or link thru media
  ||                    Returns: 1 Success, -1 Error
  || 03/05/08 GHL 8.505 (22352) Added protection against NULL PostingDate
  || 04/08/08 GHL 8.508 Added multiple protections after I realized that WIPPostingDetail with 0 TransactionKey 
  ||                    were inserted at Media Logic
  || 04/21/08 GHL 8.509 (25205) Do not allow a transfer if we go from a billable project to a non billable project
  || 06/17/08 GHL 8.513 Added update of tWIPPostingDetail.Amount like spGLPostWIP
  || 12/22/08 GHL 10.015 Corrected the way the 2 last transactions (out of 4) are created
  || 02/20/08 GHL 10.019 (47204) Added checking of OpeningTransaction before erroring out
  ||                     If OpeningTransaction = 1, there was no impact on GL
  || 07/02/09 GHL 10.502 (56020) If OpeningTransaction = 1, assume people will make appropriate Journal Entries  
  ||                     so continue with the adjustment
  */  

	SET NOCOUNT ON

	-- No need to continue if same projects
	IF @OldProjectKey = @NewProjectKey
		RETURN 1
		
Declare @OldTransactionKey int
Declare @TransactionKey int
Declare @CompanyKey int
Declare @GLAccountKey int
Declare @ClassKey int
Declare @ClientKey int
Declare @ProjectKey int
Declare @GLCompanyKey int
Declare @OfficeKey int
Declare @DepartmentKey int
Declare @Reference varchar(50)
Declare @PostingDate datetime
Declare @Memo varchar(500)
Declare @PostSide char(1)
Declare @ReversalPostSide char(1)
Declare @Amount money
Declare @WIPPostingInKey int
Declare @WIPPostingOutKey int
Declare @ItemType int
Declare @MaxTransactionKey int
Declare @LoopCounter int

Declare @PostToGL int
Declare @TrackWIP int
Declare @WIPLaborAssetAccountKey int
Declare @WIPLaborIncomeAccountKey int
Declare @WIPLaborWOAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare @WIPExpenseIncomeAccountKey int
Declare @WIPExpenseWOAccountKey int
Declare @WIPMediaAssetAccountKey int
Declare @WIPMediaIncomeAccountKey int
Declare @WIPMediaWOAccountKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPVoucherWOAccountKey int
Declare @WIPClassFromDetail int
Declare @IOClientLink int
Declare @BCClientLink int

Declare @NewGLCompanyKey int
	   ,@NewOfficeKey int
       ,@NewNonBillable int
       ,@NewClassKey int
       ,@NewClientKey int
       ,@NewDepartmentKey int
       ,@NewDebitGLAccountKey int
       ,@NewCreditGLAccountKey int
       ,@NewReference varchar(50)
       ,@NewMemo varchar(500)
	   ,@CreateNewTransactions int
	   ,@OldNonBillable int
	   ,@OldClientKey int
	   ,@OldGLCompanyKey int
	   ,@OldOfficeKey int
	   ,@OpeningTransaction int
	   ,@WIPPostingDate smalldatetime	
	   	
SELECT @CompanyKey = CompanyKey
       ,@NewGLCompanyKey  = GLCompanyKey
	   ,@NewOfficeKey = OfficeKey
       ,@NewNonBillable	= ISNULL(NonBillable, 0)
       ,@NewClientKey = ClientKey   
FROM   tProject (NOLOCK)
WHERE  ProjectKey = @NewProjectKey

-- Error out if we cannot find the new project
IF @@ROWCOUNT = 0
	RETURN -2

SELECT @OldGLCompanyKey  = GLCompanyKey
	   ,@OldOfficeKey = OfficeKey
       ,@OldNonBillable	= ISNULL(NonBillable, 0)
       ,@OldClientKey = ClientKey
FROM   tProject (NOLOCK)
WHERE  ProjectKey = @OldProjectKey
	
-- Cannot transfer from Billable to NonBillable	
IF @OldNonBillable = 0 AND @NewNonBillable = 1
	RETURN -3
	
-- Get the Preference Settings, cloned from spGLPostWIP
Select	
	-- Labor accounts
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),

	-- Misc Costs and ERs accounts
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),

	-- Media Voucher accounts
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0),

	-- Production Voucher accounts
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0),
	@WIPVoucherWOAccountKey = ISNULL(WIPVoucherWOAccountKey, 0),

	-- Flags
	@PostToGL = ISNULL(PostToGL, 0),
	@TrackWIP = ISNULL(TrackWIP, 0),
	@WIPClassFromDetail = ISNULL(WIPClassFromDetail, 0),
	@IOClientLink = ISNULL(IOClientLink, 1),
	@BCClientLink = ISNULL(BCClientLink, 1)	
from tPreference  (nolock)
Where CompanyKey = @CompanyKey

IF @PostToGL = 0
	RETURN 1
IF @TrackWIP = 0
	RETURN 1


	-- Should work with entities in transactions.aspx or billing worksheet
	-- Convert now
	IF @Entity = 'LABOR'
		SELECT @Entity = 'tTime' 
	IF @Entity = 'MISCCOST'
		SELECT @Entity = 'tMiscCost'
	IF @Entity = 'EXPRPT'
		SELECT @Entity = 'tExpenseReceipt'
	IF @Entity = 'VOUCHER'
		SELECT @Entity = 'tVoucherDetail'

	IF @Entity = 'tTime'
	BEGIN
		SELECT  @NewReference = 'WIP LABOR IN - ADJUSTMENT/TRANSFER'
				,@NewDebitGLAccountKey = @WIPLaborAssetAccountKey
				,@NewCreditGLAccountKey = @WIPLaborIncomeAccountKey

		SELECT @Amount = ROUND(t.ActualHours * t.ActualRate, 2)
				,@WIPPostingInKey = t.WIPPostingInKey
				,@WIPPostingOutKey = t.WIPPostingOutKey
				,@NewDepartmentKey = s.DepartmentKey
				,@NewClassKey = CASE WHEN @WIPClassFromDetail = 1 THEN u.ClassKey ELSE s.ClassKey END  
		FROM   tTime t (NOLOCK)
			LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON t.UserKey = u.UserKey
		WHERE  t.TimeKey = @UIDEntityKey

	END
	IF @Entity = 'tMiscCost'
	BEGIN
		SELECT @NewReference = 'WIP MISC COST IN - ADJUSTMENT/TRANSFER'
				,@NewDebitGLAccountKey = @WIPExpenseAssetAccountKey
				,@NewCreditGLAccountKey = @WIPExpenseIncomeAccountKey

		SELECT @Amount = mc.TotalCost
				,@WIPPostingInKey = mc.WIPPostingInKey
				,@WIPPostingOutKey = mc.WIPPostingOutKey
				,@NewDepartmentKey = i.DepartmentKey
			    ,@NewClassKey = CASE WHEN @WIPClassFromDetail = 1 THEN mc.ClassKey ELSE i.ClassKey END	
		FROM   tMiscCost mc (NOLOCK)
			LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey
		WHERE  mc.MiscCostKey = @EntityKey

	END
	IF @Entity = 'tExpenseReceipt'
	BEGIN
		-- What to do here, expense receipts are no longer put in
		-- We reverse but do not put in for the new project?
		SELECT @Amount = ActualCost,@WIPPostingInKey = WIPPostingInKey,@WIPPostingOutKey = WIPPostingOutKey
		FROM   tExpenseReceipt (NOLOCK)
		WHERE  ExpenseReceiptKey = @EntityKey
	END
	IF @Entity = 'tVoucherDetail'
	BEGIN

		SELECT @Amount = vd.TotalCost
				,@WIPPostingInKey = vd.WIPPostingInKey
				,@WIPPostingOutKey = vd.WIPPostingOutKey
				,@NewClassKey = vd.ClassKey
				,@NewDepartmentKey = vd.DepartmentKey	
				,@ItemType = ISNULL(i.ItemType, 0)
			    ,@NewClientKey = vd.ClientKey -- NOT from Project but from the line
			    ,@NewOfficeKey = vd.OfficeKey -- NOT from Project but from the line
			    ,@NewGLCompanyKey = v.GLCompanyKey -- NOT from Project but from the line
				,@NewCreditGLAccountKey = vd.ExpenseAccountKey -- by default get it from the line
		FROM   tVoucherDetail vd (NOLOCK)
			INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
 			LEFT OUTER JOIN tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
 			LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		WHERE  vd.VoucherDetailKey = @EntityKey	

		IF @ItemType IN (0, 3)
			SELECT @NewReference = 'WIP VENDOR INVOICE IN - ADJUSTMENT/TRANSFER'
		ELSE
			SELECT @NewReference = 'WIP MEDIA INVOICE IN - ADJUSTMENT/TRANSFER'	

		IF @ItemType = 0
			SELECT @NewDebitGLAccountKey = @WIPVoucherAssetAccountKey
		IF @ItemType IN (1,2) 
			SELECT @NewDebitGLAccountKey = @WIPMediaAssetAccountKey
		IF @ItemType = 3
			SELECT @NewDebitGLAccountKey = @WIPExpenseAssetAccountKey


	END
	IF @Entity = 'ORDER'
		SELECT @Entity = 'tPurchaseOrderDetail' 

	IF NOT (@WIPPostingInKey > 0 AND @WIPPostingOutKey = 0)
		RETURN 1

	IF @Amount = 0
		RETURN 1

	IF @Entity = 'tPurchaseOrderDetail'
		RETURN 1
	
	/*
	-- nothing to adjust in GL if OpeningTransaction = 1
	IF EXISTS (SELECT 1 FROM tWIPPosting (NOLOCK) 
		WHERE WIPPostingKey = @WIPPostingInKey AND ISNULL(OpeningTransaction, 0) = 1)
		RETURN 1
	*/
	
	-- We assume now that they made appropriate JEs if OpeningTransaction = 1, so continue	
	SELECT @OpeningTransaction = ISNULL(OpeningTransaction, 0)
	      ,@NewMemo = Comment
	      ,@WIPPostingDate = PostingDate
	FROM tWIPPosting (NOLOCK) 
	WHERE WIPPostingKey = @WIPPostingInKey
		
	-- Loop goes thru TransactionKey desc to find a maximum of 2 transactions (Debit + Credit)
	
	SELECT @MaxTransactionKey = MAX(TransactionKey) FROM tTransaction (NOLOCK)
	SELECT @OldTransactionKey = @MaxTransactionKey + 1
	SELECT @LoopCounter = 0
	WHILE (1=1)
	BEGIN
		IF @Entity <> 'tTime'
			SELECT @OldTransactionKey = MAX(wpd.TransactionKey)
			FROM   tWIPPostingDetail wpd (NOLOCK)
				INNER JOIN tTransaction t (NOLOCK) ON wpd.TransactionKey = t.TransactionKey 
			WHERE  wpd.WIPPostingKey = @WIPPostingInKey
			AND    wpd.Entity = @Entity
			AND    wpd.EntityKey = @EntityKey
			AND    wpd.TransactionKey < @OldTransactionKey
			AND    t.ProjectKey = @OldProjectKey
			AND    wpd.TransactionKey > 0
		ELSE
			SELECT @OldTransactionKey = MAX(wpd.TransactionKey)
			FROM   tWIPPostingDetail wpd (NOLOCK)
				INNER JOIN tTransaction t (NOLOCK) ON wpd.TransactionKey = t.TransactionKey 
			WHERE  wpd.WIPPostingKey = @WIPPostingInKey
			AND    wpd.Entity = @Entity
			AND    wpd.UIDEntityKey = @UIDEntityKey
			AND    wpd.TransactionKey < @OldTransactionKey
			AND    t.ProjectKey = @OldProjectKey
			AND    wpd.TransactionKey > 0

		IF @OldTransactionKey IS NULL
			BREAK

		SELECT @CompanyKey = CompanyKey, @Reference = Reference, @GLAccountKey = GLAccountKey
				, @ClassKey = ClassKey, @ClientKey = ClientKey, @ProjectKey = ProjectKey
				, @GLCompanyKey = GLCompanyKey, @OfficeKey = OfficeKey, @DepartmentKey = DepartmentKey
				, @PostingDate = TransactionDate, @Memo = Memo, @PostSide = PostSide
		FROM  tTransaction (NOLOCK) WHERE TransactionKey = @OldTransactionKey

		-- reversal of old project 
		IF @PostSide = 'C'
			SELECT @ReversalPostSide = 'D'
		ELSE
			SELECT @ReversalPostSide = 'C'

		exec @TransactionKey = spGLInsertTran @CompanyKey, @ReversalPostSide, @PostingDate, 'WIP', 
			@WIPPostingInKey, @NewReference, @GLAccountKey, @Amount, @ClassKey,
			@Memo, @ClientKey, @ProjectKey, NULL, NULL, @GLCompanyKey, @OfficeKey, @DepartmentKey, NULL, 6
		
		IF @@ERROR <> 0
			RETURN -1	

		-- If spGLInsertTran fails, it will return 0, so test NULL or 0
		If ISNULL(@TransactionKey, 0) = 0
			RETURN -1	

		IF @Entity <> 'tTime'
		BEGIN					
			insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
			select @WIPPostingInKey, @Entity, @EntityKey, NULL, @TransactionKey, @Amount
			
			IF @@ERROR <> 0
				RETURN -1	
				
		END
		ELSE
		BEGIN
			insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
			select @WIPPostingInKey, @Entity, NULL, @UIDEntityKey, @TransactionKey, @Amount

			IF @@ERROR <> 0
				RETURN -1	

		END
		
		SELECT @LoopCounter = @LoopCounter + 1
		IF @LoopCounter >= 2
			BREAK
	END	
	
	-- If we could not find them, abort only if OpeningTransaction = 1, continue
	IF @LoopCounter <> 2
	BEGIN
		IF @OpeningTransaction = 0 	
			RETURN -3 
		ELSE
		BEGIN	
			-- IF @OpeningTransaction = 1, there was no GL transactions, but assume they made JEs
			-- Add 2 reversals here
		    
			IF @PostingDate IS NULL
				SELECT @PostingDate = @WIPPostingDate 
				
			IF @PostingDate IS NULL
				SELECT @PostingDate = CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)	
			
			exec @TransactionKey = spGLInsertTran @CompanyKey, 'D', @PostingDate, 'WIP', 
				@WIPPostingInKey, @NewReference, @NewCreditGLAccountKey, @Amount, @NewClassKey,
				@NewMemo, @OldClientKey, @OldProjectKey, NULL, NULL, @OldGLCompanyKey, @OldOfficeKey, @NewDepartmentKey, NULL, 6

			IF @@ERROR <> 0
				RETURN -1	

			If ISNULL(@TransactionKey, 0) = 0
				RETURN -1	

			IF @Entity <> 'tTime'					
			BEGIN
				insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
				select @WIPPostingInKey, @Entity, @EntityKey, NULL, @TransactionKey, @Amount

				IF @@ERROR <> 0
					RETURN -1	

			END
			ELSE
			BEGIN
				insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
				select @WIPPostingInKey, @Entity, NULL, @UIDEntityKey, @TransactionKey, @Amount

				IF @@ERROR <> 0
					RETURN -1	

			END

			exec @TransactionKey = spGLInsertTran @CompanyKey, 'C', @PostingDate, 'WIP', 
				@WIPPostingInKey, @NewReference, @NewDebitGLAccountKey, @Amount, @NewClassKey,
				@NewMemo, @OldClientKey, @OldProjectKey, NULL, NULL, @OldGLCompanyKey, @OldOfficeKey, @NewDepartmentKey, NULL, 6

			IF @@ERROR <> 0
				RETURN -1	

			If ISNULL(@TransactionKey, 0) = 0
				RETURN -1	

			IF @Entity <> 'tTime'					
			BEGIN
				insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
				select @WIPPostingInKey, @Entity, @EntityKey, NULL, @TransactionKey, @Amount
				
				IF @@ERROR <> 0
					RETURN -1	

			END
			ELSE
			BEGIN
				insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
				select @WIPPostingInKey, @Entity, NULL, @UIDEntityKey, @TransactionKey, @Amount

				IF @@ERROR <> 0
					RETURN -1	

			END
		END
	END
		
	-- we no longer put ERs in 
	IF @Entity = 'tExpenseReceipt'
		RETURN 1

	-- Now try to create new transactions for the new project
	SELECT @ItemType = ISNULL(@ItemType, 0), @CreateNewTransactions = 1

	IF @ItemType IN (0, 3) 
	BEGIN
		IF @NewNonBillable = 1
			SELECT @CreateNewTransactions = 0
	END 
	ELSE
	BEGIN
		IF @ItemType = 1 AND @IOClientLink = 1 AND @NewNonBillable = 1
			SELECT @CreateNewTransactions = 0

		IF @ItemType = 2 AND @BCClientLink = 1 AND @NewNonBillable = 1
			SELECT @CreateNewTransactions = 0 
	END	

	IF @CreateNewTransactions = 0
		RETURN 1


	IF @PostingDate IS NULL
		SELECT @PostingDate = @WIPPostingDate
		
	IF @PostingDate IS NULL
		SELECT @PostingDate = CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)	
	
	exec @TransactionKey = spGLInsertTran @CompanyKey, 'D', @PostingDate, 'WIP', 
		@WIPPostingInKey, @NewReference, @NewDebitGLAccountKey, @Amount, @NewClassKey,
		@NewMemo, @NewClientKey, @NewProjectKey, NULL, NULL, @NewGLCompanyKey, @NewOfficeKey, @NewDepartmentKey, NULL, 6

	IF @@ERROR <> 0
		RETURN -1	

	If ISNULL(@TransactionKey, 0) = 0
		RETURN -1	

	IF @Entity <> 'tTime'					
	BEGIN
		insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
		select @WIPPostingInKey, @Entity, @EntityKey, NULL, @TransactionKey, @Amount

		IF @@ERROR <> 0
			RETURN -1	

	END
	ELSE
	BEGIN
		insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
		select @WIPPostingInKey, @Entity, NULL, @UIDEntityKey, @TransactionKey, @Amount

		IF @@ERROR <> 0
			RETURN -1	

	END

	exec @TransactionKey = spGLInsertTran @CompanyKey, 'C', @PostingDate, 'WIP', 
		@WIPPostingInKey, @NewReference, @NewCreditGLAccountKey, @Amount, @NewClassKey,
		@NewMemo, @NewClientKey, @NewProjectKey, NULL, NULL, @NewGLCompanyKey, @NewOfficeKey, @NewDepartmentKey, NULL, 6

	IF @@ERROR <> 0
		RETURN -1	

	If ISNULL(@TransactionKey, 0) = 0
		RETURN -1	

	IF @Entity <> 'tTime'					
	BEGIN
		insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
		select @WIPPostingInKey, @Entity, @EntityKey, NULL, @TransactionKey, @Amount

		IF @@ERROR <> 0
			RETURN -1	

	END
	ELSE
	BEGIN
		insert tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
		select @WIPPostingInKey, @Entity, NULL, @UIDEntityKey, @TransactionKey, @Amount

		IF @@ERROR <> 0
			RETURN -1	

	END
	
	RETURN 1
GO
