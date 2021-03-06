USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupUpdate]
	(
		@ProjectKey INT
		,@TranType INT		-- -1 All, 1 Labor, 2 Misc Cost, 3 Exp Receipt, 4 Voucher, 5 PO, 6 Billed, 7 Unbilled, 8 WriteOff, 9 Estimate
		,@BaseRollup INT	-- Includes Unbilled also
		,@Approved INT		-- Used when changing status on transaction header
		,@Unbilled INT		
		,@WriteOff INT
	)
AS --Encrypt

	-- This variable controls the use and the delay in the project rollup queue 
	-- If @kProcessingDelay <= 0, there is no delay, the queue is not used
	declare @kProcessingDelay int		select @kProcessingDelay = 0 -- 3 minutes by default on hosted, 0 on installed sites

  /*
  || When     Who Rel   What
  || 02/14/07 GHL 8.4   Creation to solve performance problems in listing and reports    
  || 06/06/07 GHL 8.4.3 Recalculating now AmountBilled as Fixed Fee Amounts + Transactions     
  || 06/07/07 GHL 8.431 (9415) Reviewed AmountBilled because Advance Bill can be billed against transactions
  || 07/09/07 GHL 8.5   Added restriction on ERs
  || 08/07/07 GHL 8.5   Use now tInvoiceSummary for amount billed
  || 10/05/07 GHL 8.5   Corrected OpenOrdersGross to make it similar to budget analysis 
  || 10/11/07 GHL 8.5   Calculating now write offs at gross for labor, at net for expenses
  || 11/07/07 GHL 8.5   Added OutsideCostsGross
  || 02/15/08 GHL 8.504 (21216) Added update times to monitor when the rollup is done  
  || 02/18/08 GHL 8.504 (21216) Calculating AdvBilledOpen by multiplying first then dividing to eliminate rounding erros 
  || 02/19/08 GHL 8.504 (21641) Calculating now write offs at gross for expenses
  || 08/14/08 GHL 10.007 (32434)(32026) MDS Advertising, duplicate tProjectRollup records. Added protection against dups
  || 10/15/08 GHL 10.010 (36763) take vouchers tied to closed or open pos
  || 07/09/09 GHL 10.504 (56867) Added Billed Amount without tax
  || 07/30/09 RLB 10.5.0.6 Added WriteOff's when pulling unbilled vouchers on OutsideCostsGross
  || 08/25/09 GWG 10.5.0.8 OpenOrdersNet should only include approved orders
  || 01/05/10 GHL 10.516 Added call to sptProjectItemRollupUpdate
  || 01/06/10 GHL 10.516 Added update of estimate data
  || 01/06/10 GHL 10.516 Added Billed and Invoiced data
  || 02/17/10 GHL 10.518 (73756) Added Billed Amount Approved
  || 05/21/10 GHL 10.530 (81186) Including now prebilled orders in OpenOrderGross 
  || 06/21/10 GHL 10.531 (83389) Added OpenOrderUnbilled 
  || 07/19/10 GHL 10.532 Added update of tTask.TotalActualHours
  || 08/09/10 GHL 10.533 Added ProjectKey in where clause when updating tTask.TotalActualHours with DetailTaskKey 
  || 01/20/12 GHL 10.552 Modified join with tTime when calc tTask.TotalActualHours (1 statement instead of 2)
  || 04/02/12 GHL 10.554 Using now the project rollup queue to increase perfo
  || 04/26/12 GHL 10.555 Added logic for delay so that rollup queue can be immediately processed  
  || 03/11/13 GHL 10.565 (171324) Added cast to Decimal(24,8) when calculating open order gross unbilled for better precision  
  || 08/26/13 GHL 10.571  Using now PTotalCost and PAppliedCost instead of TotalCost and AppliedCost for ERs, POs, and VDs
  ||                      Did not change labor and misc costs because they are expressed in Project Currency                         
                            
  */
	SET NOCOUNT ON
	
	IF ISNULL(@ProjectKey, 0) <= 0
		RETURN 1
		
	-- If more than 1 record, this creates problems in view	
	IF (SELECT COUNT(*) 
					FROM tProjectRollup (NOLOCK)
					WHERE ProjectKey = @ProjectKey) > 1
					DELETE tProjectRollup WHERE ProjectKey = @ProjectKey				
					
	-- If record is missing, add it				
	IF NOT EXISTS (SELECT 1
					FROM  tProjectRollup (NOLOCK)
					WHERE ProjectKey = @ProjectKey)
					INSERT tProjectRollup (ProjectKey) VALUES (@ProjectKey) 
	

	-- if labor
	if @TranType = 1 and @kProcessingDelay > 0
	begin
		if not exists (select 1 from tProjectRollupQueue (nolock) where ProjectKey = @ProjectKey and Updated= 0)
			insert tProjectRollupQueue (ProjectKey)
			values (@ProjectKey)

		exec sptProjectRollupQueueUpdate @kProcessingDelay

		return 1
	end

	-- For tracking update times
	DECLARE @UpdateString VARCHAR(250)
	
	SELECT @UpdateString = 'sptProjectRollupUpdate @ProjectKey=' + CAST(@ProjectKey AS VARCHAR(250))
			+ ' ,@TranType=' + CAST(@TranType AS VARCHAR(250))
			+ ' ,@BaseRollup=' + CAST(@BaseRollup AS VARCHAR(250))
			+ ' ,@Approved=' + CAST(@Approved AS VARCHAR(250))
			+ ' ,@Unbilled=' + CAST(@Unbilled AS VARCHAR(250))
			+ ' ,@WriteOff=' + CAST(@WriteOff AS VARCHAR(250))
			
	UPDATE tProjectRollup 
	SET UpdateStarted = GETDATE(), UpdateString = @UpdateString
	WHERE  ProjectKey = @ProjectKey		
			 
	DECLARE @CompanyKey INT
	SELECT @CompanyKey = CompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	DECLARE @ProjectItemRollupUpdate int	SELECT @ProjectItemRollupUpdate = 1
	DECLARE @ProjectItemRollupUse int		SELECT @ProjectItemRollupUse = 1
					
	DECLARE @Hours DECIMAL(24, 4)
		    ,@HoursApproved DECIMAL(24, 4)
			,@HoursBilled DECIMAL(24, 4) --
			,@HoursInvoiced DECIMAL(24, 4) --
			,@LaborNet MONEY
			,@LaborNetApproved MONEY
			,@LaborGross MONEY
			,@LaborGrossApproved MONEY
			,@LaborUnbilled MONEY
			,@LaborWriteOff MONEY
			,@LaborBilled MONEY --
			,@LaborInvoiced MONEY --
			
			,@MiscCostNet MONEY
			,@MiscCostGross MONEY
			,@MiscCostUnbilled MONEY
			,@MiscCostWriteOff MONEY
			,@MiscCostBilled MONEY --
			,@MiscCostInvoiced MONEY --
			
			,@ExpReceiptNet MONEY
			,@ExpReceiptNetApproved MONEY
			,@ExpReceiptGross MONEY
			,@ExpReceiptGrossApproved MONEY
			,@ExpReceiptUnbilled MONEY
			,@ExpReceiptWriteOff MONEY
			,@ExpReceiptBilled MONEY --
			,@ExpReceiptInvoiced MONEY --
					
			,@VoucherNet MONEY
			,@VoucherNetApproved MONEY
			,@VoucherGross MONEY
			,@VoucherGrossApproved MONEY
			,@VoucherOutsideCostsGross MONEY
			,@VoucherOutsideCostsGrossApproved MONEY
			,@VoucherUnbilled MONEY
			,@VoucherWriteOff MONEY		
			,@VoucherBilled MONEY --
			,@VoucherInvoiced MONEY --
							
			,@OpenOrderNet MONEY
			,@OpenOrderNetApproved MONEY
			,@OpenOrderGross MONEY
			,@OpenOrderGrossApproved MONEY
			,@OpenOrderUnbilled MONEY
			,@OrderPrebilled MONEY
			
			,@BilledAmount MONEY
			,@BilledAmountApproved MONEY
			,@BilledAmountNoTax MONEY
			,@AdvanceBilled MONEY
			,@AdvanceBilledOpen MONEY
			
			,@EstQty DECIMAL(24,4)
			,@EstNet MONEY
			,@EstGross MONEY
			,@EstCOQty DECIMAL(24,4)
			,@EstCONet MONEY
			,@EstCOGross MONEY
					
	SELECT 	@Hours = Hours
		    ,@HoursApproved = HoursApproved
			,@HoursBilled = HoursBilled
			,@HoursInvoiced = HoursInvoiced
			,@LaborNet = LaborNet
			,@LaborNetApproved = LaborNetApproved
			,@LaborGross = LaborGross
			,@LaborGrossApproved = LaborGrossApproved
			,@LaborUnbilled = LaborUnbilled
			,@LaborWriteOff = LaborWriteOff
			,@LaborBilled = LaborBilled
			,@LaborInvoiced = LaborInvoiced
			
			,@MiscCostNet = MiscCostNet
			,@MiscCostGross = MiscCostGross
			,@MiscCostUnbilled = MiscCostUnbilled
			,@MiscCostWriteOff = MiscCostWriteOff
			,@MiscCostBilled = MiscCostBilled
			,@MiscCostInvoiced = MiscCostInvoiced
			
			,@ExpReceiptNet = ExpReceiptNet
			,@ExpReceiptNetApproved = ExpReceiptNetApproved
			,@ExpReceiptGross = ExpReceiptGross
			,@ExpReceiptGrossApproved = ExpReceiptGrossApproved
			,@ExpReceiptUnbilled =  ExpReceiptUnbilled
			,@ExpReceiptWriteOff =  ExpReceiptWriteOff
			,@ExpReceiptBilled =  ExpReceiptBilled
			,@ExpReceiptInvoiced =  ExpReceiptInvoiced
					
			,@VoucherNet = VoucherNet
			,@VoucherNetApproved = VoucherNetApproved
			,@VoucherGross = VoucherGross
			,@VoucherGrossApproved = VoucherGrossApproved
			,@VoucherOutsideCostsGross = VoucherOutsideCostsGross
			,@VoucherOutsideCostsGrossApproved = VoucherOutsideCostsGrossApproved

			,@VoucherUnbilled = VoucherUnbilled
			,@VoucherWriteOff = VoucherWriteOff		
			,@VoucherBilled = VoucherBilled
			,@VoucherInvoiced = VoucherInvoiced
							
			,@OpenOrderNet = OpenOrderNet
			,@OpenOrderNetApproved = OpenOrderNetApproved
			,@OpenOrderGross = OpenOrderGross
			,@OpenOrderGrossApproved = OpenOrderGrossApproved
			,@OpenOrderUnbilled = OpenOrderUnbilled
			,@OrderPrebilled = OrderPrebilled
			
			,@BilledAmount = BilledAmount
			,@BilledAmountApproved = BilledAmountApproved
			,@BilledAmountNoTax = BilledAmountNoTax
			,@AdvanceBilled = AdvanceBilled
			,@AdvanceBilledOpen = AdvanceBilledOpen
	
			,@EstQty = EstQty
			,@EstNet = EstNet
			,@EstGross = EstGross
			,@EstCOQty = EstCOQty
			,@EstCONet = EstCONet
			,@EstCOGross = EstCOGross
			
	FROM    tProjectRollup (NOLOCK)
	WHERE   ProjectKey = @ProjectKey
								
	DECLARE @Labor INT,@MiscCost INT,@ExpReceipt INT,@Voucher INT,@OpenOrder INT,@Billing INT, @Estimate INT
		
	SELECT	@Labor = 0,@MiscCost = 0,@ExpReceipt = 0,@Voucher = 0,@OpenOrder = 0,@Billing = 0, @Estimate = 0
					
	IF @TranType = -1	-- All
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 1, @Estimate = 1
	ELSE IF @TranType = 1 -- Labor
		SELECT @Labor = 1
	ELSE IF @TranType = 2 -- MiscCost
		SELECT @MiscCost = 1
	ELSE IF @TranType = 3 -- ExpReceipt
		SELECT @ExpReceipt = 1
	ELSE IF @TranType = 4 -- Voucher
		SELECT @Voucher = 1
		      ,@OpenOrder = 1
	ELSE IF @TranType = 5 -- PO
		SELECT @Voucher = 1
			  ,@OpenOrder = 1
	ELSE IF @TranType = 6 -- Billing
		SELECT @Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 1
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 0,@Unbilled = 1
	ELSE IF @TranType = 7 -- ALL Unbilled
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 0
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 0,@Unbilled = 1
	ELSE IF @TranType = 8 -- ALL WriteOff
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 0,@Billing = 0
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 1,@Unbilled = 0
	ELSE IF @TranType = 9 -- Estimates
		SELECT @Estimate = 1
		
	-- perform rollup by project/item, 1 indicates SingleMode 		
	IF @ProjectItemRollupUpdate = 1
		EXEC sptProjectItemRollupUpdate @ProjectKey, 1, @TranType, @BaseRollup, @Approved, @Unbilled, @WriteOff, @CompanyKey
	
IF @Labor = 1 AND @BaseRollup = 1
BEGIN
	-- Bring in the Actual hours tied to detail tasks
	Update tTask Set TotalActualHours = ISNULL(
		(
		select SUM(ti.ActualHours)
		from tTime ti (nolock)
		where ti.ProjectKey = @ProjectKey -- Added ProjectKey to restrict records 
		-- this will sum up to the Tracking task completely 
		-- + the detail task
		-- will not sum up to the immediate summary task (if not tracking)
		and   (ti.DetailTaskKey = tTask.TaskKey or ti.TaskKey = tTask.TaskKey)
		), 0)
	Where tTask.ProjectKey = @ProjectKey
END

-- Old calculations	
IF @ProjectItemRollupUse = 0
BEGIN												
	IF @Labor = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT @Hours =   
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
			
					,@HoursBilled =   
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0  
					), 0) 
			
					,@HoursInvoiced =   
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND InvoiceLineKey > 0  
					), 0)
					
			       ,@LaborNet =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
						
					,@LaborGross =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
					
					,@LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NULL
					), 0)
					
					,@LaborBilled =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0  
					), 0) 

					,@LaborInvoiced =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND InvoiceLineKey > 0  
					), 0) 
					
		 END
		       
		 IF @Approved = 1
		 BEGIN   
			SELECT @HoursApproved = 
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = @ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
				
					,@LaborNetApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = @ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
						
					,@LaborGrossApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = @ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
					
		END
			   		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT @LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NULL
					), 0) 

					,@HoursBilled =   
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0  
					), 0) 
			
					,@HoursInvoiced =   
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND InvoiceLineKey > 0  
					), 0)
					
					,@LaborBilled =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0  
					), 0) 

					,@LaborInvoiced =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND InvoiceLineKey > 0  
					), 0)
					
		END	 
		
		IF @WriteOff = 1
		BEGIN
			SELECT @LaborWriteOff =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND WriteOff = 1), 0) 
		END	
		
	END
	
	
	IF @MiscCost = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @MiscCostNet =
					ISNULL((SELECT SUM(TotalCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
						
					,@MiscCostGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
					
					,@MiscCostUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL
					), 0) 

					,@MiscCostBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0) 

					,@MiscCostInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					), 0) 
			
		 END
	
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@MiscCostUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL), 0) 

					,@MiscCostBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0) 

					,@MiscCostInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					), 0) 
			
		END
		
		IF @WriteOff = 1
		BEGIN
			SELECT	@MiscCostWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And WriteOff = 1), 0) 
			
		END
	END
	
	
	IF @ExpReceipt = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @ExpReceiptNet =
					--ISNULL((SELECT SUM(ActualCost) 
					ISNULL((SELECT SUM(PTotalCost) -- change for MC 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND   VoucherDetailKey IS NULL), 0) 
						
					,@ExpReceiptGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					AND   VoucherDetailKey IS NULL), 0) 
					
					,@ExpReceiptUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL
					AND   VoucherDetailKey IS NULL), 0)

					,@ExpReceiptBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					AND   VoucherDetailKey IS NULL), 0)

					,@ExpReceiptInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					AND   VoucherDetailKey IS NULL), 0)
					
		 END
	
		IF @Approved = 1
		 BEGIN   
			SELECT @ExpReceiptNetApproved =
					--ISNULL((SELECT SUM(ActualCost) 
					ISNULL((SELECT SUM(PTotalCost) 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = @ProjectKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
						
					,@ExpReceiptGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = @ProjectKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@ExpReceiptUnbilled =
					ISNULL((SELECT SUM(BillableCost)  
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL
					AND   VoucherDetailKey IS NULL), 0) 

					,@ExpReceiptBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					AND   VoucherDetailKey IS NULL), 0)

					,@ExpReceiptInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					AND   VoucherDetailKey IS NULL), 0)
			
		END
		
		IF @WriteOff = 1
		BEGIN
			SELECT	@ExpReceiptWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And WriteOff = 1
					AND   VoucherDetailKey IS NULL), 0) 
			
		END

	END
	
	IF @Voucher = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @VoucherNet =
					--ISNULL((SELECT SUM(TotalCost) 
					ISNULL((SELECT SUM(PTotalCost) -- change for MC 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
						
					,@VoucherGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
					
					,@VoucherUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL
					), 0)

					,@VoucherBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)

					,@VoucherInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					), 0)
					
		 END
	
		IF @Approved = 1
		 BEGIN   
			SELECT @VoucherNetApproved =
					--ISNULL((SELECT SUM(TotalCost) 
					ISNULL((SELECT SUM(PTotalCost) -- change for MC 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = @ProjectKey
					AND tVoucher.Status = 4), 0) 
						
					,@VoucherGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = @ProjectKey
					AND   tVoucher.Status = 4), 0) 
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@VoucherUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NULL
					), 0) 

					,@VoucherBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)

					,@VoucherInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And InvoiceLineKey > 0
					), 0)
			
		END
		
		IF @WriteOff = 1
		BEGIN
			SELECT	@VoucherWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					And WriteOff = 1), 0) 
			
		END
		
		-- Outside Costs Gross
		/* 
		1) The amount billed of all pre-billed orders
		2) The amount billed of all billed vouchers
		3) The gross amount of unbilled vouchers not tied to an order 
		4) The gross amount of unbilled vouchers tied to an order line from a non pre-billed order
		
		Note: In tProjectRollup 1 is calculated as OrderPrebilled, 2+3+4 as VoucherOutsideCostsGross
		*/

		--The amount billed of all pre-billed orders (ADD LATER IN REPORT)

		-- + The amount billed of all billed vouchers
		DECLARE @VoucherAmountBilled MONEY				
		SELECT @VoucherAmountBilled = ISNULL((
									SELECT SUM(vd.AmountBilled) 
									FROM tVoucherDetail vd (NOLOCK)
									WHERE vd.ProjectKey = @ProjectKey
									), 0)
		
		SELECT @VoucherOutsideCostsGross = ISNULL(@VoucherAmountBilled, 0)
		
		-- + The gross amount of unbilled vouchers not tied to an order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
									WHERE vd.ProjectKey = @ProjectKey
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									AND   vd.PurchaseOrderDetailKey IS NULL
									), 0)
		-- + The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									WHERE vd.ProjectKey = @ProjectKey
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									--AND   pod.Closed = 1
									AND   pod.DateBilled IS NULL 
									), 0)

		--The amount billed of all pre-billed orders (ADD LATER IN REPORT)
		-- + The amount billed of all billed vouchers
		SELECT @VoucherOutsideCostsGrossApproved = ISNULL(@VoucherAmountBilled, 0)
		
		-- + The gross amount of unbilled vouchers not tied to an order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									WHERE vd.ProjectKey = @ProjectKey
									AND   v.Status = 4
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									AND   vd.PurchaseOrderDetailKey IS NULL
									), 0)
		-- + The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									WHERE vd.ProjectKey = @ProjectKey
									AND   v.Status = 4
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									--AND   pod.Closed = 1
									AND   pod.DateBilled IS NULL 
									), 0)

		-- + The gross of any non pre-billed open orders that are open. (ADD LATER IN REPORT)
								--+ @OpenOrderGross
		
	END

	DECLARE @AppliedCost MONEY
	
	IF @OpenOrder = 1
	BEGIN
		SELECT @OpenOrderNet =
			--ISNULL((SELECT SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0) )
			ISNULL((SELECT SUM(pod.PTotalCost - ISNULL(pod.PAppliedCost, 0) ) -- change for MC
			FROM	tPurchaseOrderDetail pod (NOLOCK)
				INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			WHERE	pod.Closed = 0
			AND		pod.ProjectKey = @ProjectKey
			AND     po.Status = 4), 0)

		SELECT @OpenOrderNetApproved =
			--ISNULL((SELECT SUM(pod.TotalCost)
			ISNULL((SELECT SUM(pod.PTotalCost) -- change for MC
			FROM	tPurchaseOrderDetail pod (NOLOCK)
				INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			WHERE	pod.Closed = 0
			AND		pod.ProjectKey = @ProjectKey
			AND     po.Status = 4), 0)
		
		SELECT @AppliedCost = 
			--ISNULL((SELECT SUM(vd.TotalCost)
			ISNULL((SELECT SUM(vd.PTotalCost) -- change for MC
			FROM	tPurchaseOrderDetail pod (NOLOCK)
				INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				INNER JOIN tVoucherDetail vd (NOLOCK) ON pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
			WHERE	pod.Closed = 0
			AND		pod.ProjectKey = @ProjectKey
			AND     po.Status = 4
			AND     v.Status = 4), 0)
			
		-- Can this be negative?
		SELECT @OpenOrderNetApproved = ISNULL(@OpenOrderNetApproved, 0) - ISNULL(@AppliedCost, 0)
			
		SELECT @OpenOrderGross = ISNULL((
		
				SELECT SUM(
							CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8) ) )	
								ELSE NewBillableCost 
							END
						)
				FROM				
				(
				SELECT CASE po.BillAt 
						WHEN 0 THEN ISNULL(pod.BillableCost, 0)
						WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
						WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
						END AS NewBillableCost
						,pod.PTotalCost as TotalCost
						,pod.PAppliedCost as AppliedCost
						,pod.BillableCost
				FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE	pod.Closed = 0					-- still open
				AND		pod.ProjectKey = @ProjectKey
				--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
				) AS OpenOrders			
			
			), 0)
		
				
		SELECT @OpenOrderGrossApproved = ISNULL((
		
				SELECT SUM(
							CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8)))	
								ELSE NewBillableCost 
							END
						)
				FROM				
				(
				SELECT CASE po.BillAt 
						WHEN 0 THEN ISNULL(pod.BillableCost, 0)
						WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
						WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
						END AS NewBillableCost
						,pod.PTotalCost as TotalCost
						,pod.PAppliedCost as AppliedCost
						,pod.BillableCost
				FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE	pod.Closed = 0					-- still open
				AND		pod.ProjectKey = @ProjectKey
				--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
				AND     po.Status = 4
				) AS OpenOrders			
			
			), 0)
		    
			SELECT @OpenOrderUnbilled = ISNULL((
		
				SELECT SUM(
							CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8) ) )	
								ELSE NewBillableCost 
							END
						)
				FROM				
				(
				SELECT CASE po.BillAt 
						WHEN 0 THEN ISNULL(pod.BillableCost, 0)
						WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
    					WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
						END AS NewBillableCost
						,pod.PTotalCost as TotalCost
						,pod.PAppliedCost as AppliedCost
						,pod.BillableCost
				FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE	pod.Closed = 0					-- still open
				AND		pod.ProjectKey = @ProjectKey
				AND     pod.DateBilled IS NULL  -- Non Prebilled only
				) AS OpenOrders			
			
			), 0)

		SELECT @OrderPrebilled =
			ISNULL((SELECT SUM(pod.AmountBilled)
			FROM	tPurchaseOrderDetail pod (NOLOCK)
			WHERE	pod.ProjectKey = @ProjectKey
			AND     ISNULL(pod.InvoiceLineKey, 0) > 0 ), 0)
				
	END			  
	
	IF @Billing = 1
	BEGIN
		SELECT @BilledAmount = 
		ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 0
		AND   isum.ProjectKey = @ProjectKey
		), 0)
	
		SELECT @BilledAmountApproved = 
		ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 0
		AND   isum.ProjectKey = @ProjectKey
		AND   i.InvoiceStatus = 4
		), 0)
		
		SELECT @BilledAmountNoTax = 
		ISNULL((SELECT SUM(isum.Amount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 0
		AND   isum.ProjectKey = @ProjectKey
		), 0)
	
		SELECT @AdvanceBilled = 
		ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 1
		AND   isum.ProjectKey = @ProjectKey
		), 0)
		
		/*
		AdvanceBilledOpen = Invoice Line Amt - (Invoice Line Amt / Invoice Amt) * Amt Applied
		*/
					
		SELECT @AdvanceBilledOpen =
		ISNULL(
			--(SELECT SUM(adv.LineAmount - (adv.LineAmount / adv.InvoiceTotalAmount) * adv.AmountApplied)
			--(SELECT SUM(adv.LineAmount * (1 - adv.AmountApplied / adv.InvoiceTotalAmount)) -- creates rounding errors
			(SELECT SUM(adv.LineAmount - (adv.LineAmount * adv.AmountApplied) / adv.InvoiceTotalAmount)
			FROM (
				SELECT ISNULL(i.InvoiceTotalAmount, 0)		AS InvoiceTotalAmount
					,ISNULL(inv.LineAmount, 0)				AS LineAmount
					,ISNULL((SELECT SUM(iab.Amount)
						FROM tInvoiceAdvanceBill iab (NOLOCK)
						WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
					, 0)									AS AmountApplied 	
				FROM tInvoice i (NOLOCK)
				INNER JOIN	-- Starting Point: we need unique Adv Bill invoices with line for the project
					(SELECT isum.InvoiceKey
					, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
					FROM  tInvoiceSummary isum (NOLOCK)
						INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
					WHERE isum.ProjectKey = @ProjectKey
					AND   i2.CompanyKey = @CompanyKey
					AND   i2.AdvanceBill = 1
					GROUP BY isum.InvoiceKey 
					) AS inv ON i.InvoiceKey = inv.InvoiceKey
				WHERE i.CompanyKey = @CompanyKey
				AND   i.AdvanceBill = 1
				AND   i.InvoiceTotalAmount <> 0		-- Protection against division by 0 
				) AS adv
			)
		,0)

		
		SELECT @AdvanceBilledOpen = ROUND(@AdvanceBilledOpen, 2)
		
	END
	
	IF @Estimate = 1
	BEGIN              
         
        SELECT @EstQty = SUM(Qty)
               ,@EstNet = SUM(Net)
               ,@EstGross = SUM(Gross)               
               ,@EstCOQty = SUM(COQty)
               ,@EstCONet = SUM(CONet)
               ,@EstCOGross = SUM(COGross)               
        FROM   tProjectEstByItem (NOLOCK)
        WHERE  ProjectKey = @ProjectKey
        
	END
	
END

-- New calculations
IF @ProjectItemRollupUse = 1
BEGIN												
	IF @Labor = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT @Hours =   
					ISNULL((SELECT SUM(Hours) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 

					,@HoursBilled =
					ISNULL((SELECT SUM(HoursBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
					,@HoursInvoiced =
					ISNULL((SELECT SUM(HoursInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
			
			       ,@LaborNet =
					ISNULL((SELECT SUM(LaborNet) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
						
					,@LaborGross =
					ISNULL((SELECT SUM(LaborGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey), 0) 
					
					,@LaborUnbilled =
					ISNULL((SELECT SUM(LaborUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 

					,@LaborBilled =
					ISNULL((SELECT SUM(LaborBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
					,@LaborInvoiced =
					ISNULL((SELECT SUM(LaborInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		 END
		       
		 IF @Approved = 1
		 BEGIN   
			SELECT @HoursApproved = 
					ISNULL((SELECT SUM(HoursApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
				
					,@LaborNetApproved =
					ISNULL((SELECT SUM(LaborNetApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)  
						
					,@LaborGrossApproved =
					ISNULL((SELECT SUM(LaborGrossApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
		END
			   		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT @LaborUnbilled =
					ISNULL((SELECT SUM(LaborUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 

					,@HoursBilled =
					ISNULL((SELECT SUM(HoursBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
					,@HoursInvoiced =
					ISNULL((SELECT SUM(HoursInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

					,@LaborBilled =
					ISNULL((SELECT SUM(LaborBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
					,@LaborInvoiced =
					ISNULL((SELECT SUM(LaborInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		END	 
		
		IF @WriteOff = 1
		BEGIN
			SELECT @LaborWriteOff =
					ISNULL((SELECT SUM(LaborWriteOff) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
		END	
		
	END
	
	
	IF @MiscCost = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @MiscCostNet =
					ISNULL((SELECT SUM(MiscCostNet) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
						
					,@MiscCostGross =
					ISNULL((SELECT SUM(MiscCostGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
					,@MiscCostUnbilled =
					ISNULL((SELECT SUM(MiscCostUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 

					,@MiscCostBilled =
					ISNULL((SELECT SUM(MiscCostBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
			
					,@MiscCostInvoiced =
					ISNULL((SELECT SUM(MiscCostInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
			
		 END
	
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@MiscCostUnbilled =
					ISNULL((SELECT SUM(MiscCostUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 

					,@MiscCostBilled =
					ISNULL((SELECT SUM(MiscCostBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
			
					,@MiscCostInvoiced =
					ISNULL((SELECT SUM(MiscCostInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
			
		END
		
		IF @WriteOff = 1
		BEGIN
			SELECT	@MiscCostWriteOff =
					ISNULL((SELECT SUM(MiscCostWriteOff) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
			
		END
	END

	
	IF @ExpReceipt = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @ExpReceiptNet =
					ISNULL((SELECT SUM(ExpReceiptNet) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
						
					,@ExpReceiptGross =
					ISNULL((SELECT SUM(ExpReceiptGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@ExpReceiptUnbilled =
					ISNULL((SELECT SUM(ExpReceiptUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

					,@ExpReceiptBilled =
					ISNULL((SELECT SUM(ExpReceiptBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@ExpReceiptInvoiced =
					ISNULL((SELECT SUM(ExpReceiptInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

		 END
		 
		IF @Approved = 1
		 BEGIN   
			SELECT @ExpReceiptNetApproved =
					ISNULL((SELECT SUM(ExpReceiptNetApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
						
					,@ExpReceiptGrossApproved =
					ISNULL((SELECT SUM(ExpReceiptGrossApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0) 
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@ExpReceiptUnbilled =
					ISNULL((SELECT SUM(ExpReceiptUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
	
					,@ExpReceiptBilled =
					ISNULL((SELECT SUM(ExpReceiptBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@ExpReceiptInvoiced =
					ISNULL((SELECT SUM(ExpReceiptInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)		
		END

		IF @WriteOff = 1
		BEGIN
			SELECT	@ExpReceiptWriteOff =
					ISNULL((SELECT SUM(ExpReceiptWriteOff) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
			
		END

	END

	
	IF @Voucher = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			SELECT  @VoucherNet =
					ISNULL((SELECT SUM(VoucherNet) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					,@VoucherGross =
					ISNULL((SELECT SUM(VoucherGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@VoucherUnbilled =
					ISNULL((SELECT SUM(VoucherUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

					,@VoucherBilled =
					ISNULL((SELECT SUM(VoucherBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@VoucherInvoiced =
					ISNULL((SELECT SUM(VoucherInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		 END
	
		IF @Approved = 1
		 BEGIN   
			SELECT @VoucherNetApproved =
					ISNULL((SELECT SUM(VoucherNetApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
						
					,@VoucherGrossApproved =
					ISNULL((SELECT SUM(VoucherGrossApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			SELECT	@VoucherUnbilled =
					ISNULL((SELECT SUM(VoucherUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

					,@VoucherBilled =
					ISNULL((SELECT SUM(VoucherBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
					,@VoucherInvoiced =
					ISNULL((SELECT SUM(VoucherInvoiced) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
			
		END
		
		IF @WriteOff = 1
		BEGIN
			SELECT	@VoucherWriteOff =
					ISNULL((SELECT SUM(VoucherWriteOff) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
			
		END
		
		-- Outside Costs Gross
		/* 
		1) The amount billed of all pre-billed orders
		2) The amount billed of all billed vouchers
		3) The gross amount of unbilled vouchers not tied to an order 
		4) The gross amount of unbilled vouchers tied to an order line from a non pre-billed order
		
		Note: In tProjectRollup 1 is calculated as OrderPrebilled, 2+3+4 as VoucherOutsideCostsGross
		*/

		
		SELECT @VoucherOutsideCostsGross = 
					ISNULL((SELECT SUM(VoucherOutsideCostsGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		
		SELECT @VoucherOutsideCostsGrossApproved = 
					ISNULL((SELECT SUM(VoucherOutsideCostsGrossApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
	END

	IF @OpenOrder = 1
	BEGIN
		SELECT @OpenOrderNet =
					ISNULL((SELECT SUM(OpenOrderNet) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

		SELECT @OpenOrderNetApproved =
					ISNULL((SELECT SUM(OpenOrderNetApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
		
			
		SELECT @OpenOrderGross = 
					ISNULL((SELECT SUM(OpenOrderGross) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
				
		SELECT @OpenOrderGrossApproved = 
					ISNULL((SELECT SUM(OpenOrderGrossApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
		    
       SELECT @OpenOrderUnbilled = 
					ISNULL((SELECT SUM(OpenOrderUnbilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

		SELECT @OrderPrebilled =
					ISNULL((SELECT SUM(OrderPrebilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)				
	END			  
	
	IF @Billing = 1
	BEGIN
		SELECT @BilledAmount = 
					ISNULL((SELECT SUM(BilledAmount) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)

		SELECT @BilledAmountApproved = 
					ISNULL((SELECT SUM(BilledAmountApproved) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
	
		SELECT @BilledAmountNoTax = 
					ISNULL((SELECT SUM(BilledAmountNoTax) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		SELECT @AdvanceBilled = 
					ISNULL((SELECT SUM(AdvanceBilled) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
					
		
		/*
		AdvanceBilledOpen = Invoice Line Amt - (Invoice Line Amt / Invoice Amt) * Amt Applied
		*/
					
		SELECT @AdvanceBilledOpen =
					ISNULL((SELECT SUM(AdvanceBilledOpen) 
					FROM tProjectItemRollup (NOLOCK) 
					WHERE ProjectKey = @ProjectKey
					), 0)
				
	END
	
	IF @Estimate = 1
	BEGIN              
         
        SELECT @EstQty = SUM(EstQty)
               ,@EstNet = SUM(EstNet)
               ,@EstGross = SUM(EstGross)               
               ,@EstCOQty = SUM(EstCOQty)
               ,@EstCONet = SUM(EstCONet)
               ,@EstCOGross = SUM(EstCOGross)               
        FROM   tProjectItemRollup (NOLOCK)
        WHERE  ProjectKey = @ProjectKey
        
	END

END
		
	UPDATE tProjectRollup
		SET Hours = ISNULL(@Hours, 0)
		    ,HoursApproved = ISNULL(@HoursApproved, 0)
			,HoursBilled = ISNULL(@HoursBilled, 0)
			,HoursInvoiced = ISNULL(@HoursInvoiced, 0)
			,LaborNet = ISNULL(@LaborNet, 0)
			,LaborNetApproved = ISNULL(@LaborNetApproved, 0)
			,LaborGross = ISNULL(@LaborGross, 0)
			,LaborGrossApproved = ISNULL(@LaborGrossApproved, 0)
			,LaborUnbilled = ISNULL(@LaborUnbilled, 0)
			,LaborWriteOff = ISNULL(@LaborWriteOff, 0)
			,LaborBilled = ISNULL(@LaborBilled, 0)
			,LaborInvoiced = ISNULL(@LaborInvoiced, 0)
			
			,MiscCostNet = ISNULL(@MiscCostNet, 0)
			,MiscCostGross = ISNULL(@MiscCostGross, 0)
			,MiscCostUnbilled = ISNULL(@MiscCostUnbilled, 0)
			,MiscCostWriteOff = ISNULL(@MiscCostWriteOff, 0)
			,MiscCostBilled = ISNULL(@MiscCostBilled, 0)
			,MiscCostInvoiced = ISNULL(@MiscCostInvoiced, 0)
			
			,ExpReceiptNet = ISNULL(@ExpReceiptNet, 0)
			,ExpReceiptNetApproved = ISNULL(@ExpReceiptNetApproved, 0)
			,ExpReceiptGross = ISNULL(@ExpReceiptGross, 0)
			,ExpReceiptGrossApproved = ISNULL(@ExpReceiptGrossApproved, 0)
			,ExpReceiptUnbilled =  ISNULL(@ExpReceiptUnbilled, 0)
			,ExpReceiptWriteOff =  ISNULL(@ExpReceiptWriteOff, 0)
			,ExpReceiptBilled =  ISNULL(@ExpReceiptBilled, 0)
			,ExpReceiptInvoiced =  ISNULL(@ExpReceiptInvoiced, 0)
					
			,VoucherNet = ISNULL(@VoucherNet, 0)
			,VoucherNetApproved = ISNULL(@VoucherNetApproved, 0)
			,VoucherGross = ISNULL(@VoucherGross, 0)
			,VoucherGrossApproved = ISNULL(@VoucherGrossApproved, 0)
			,VoucherOutsideCostsGross = ISNULL(@VoucherOutsideCostsGross, 0)
			,VoucherOutsideCostsGrossApproved = ISNULL(@VoucherOutsideCostsGrossApproved, 0)
			
			,VoucherUnbilled = ISNULL(@VoucherUnbilled, 0)
			,VoucherWriteOff = ISNULL(@VoucherWriteOff, 0)		
			,VoucherBilled = ISNULL(@VoucherBilled, 0)
			,VoucherInvoiced = ISNULL(@VoucherInvoiced, 0)
							
			,OpenOrderNet = ISNULL(@OpenOrderNet, 0)
			,OpenOrderNetApproved = ISNULL(@OpenOrderNetApproved, 0)
			,OpenOrderGross = ISNULL(@OpenOrderGross, 0)
			,OpenOrderGrossApproved = ISNULL(@OpenOrderGrossApproved, 0)
			,OpenOrderUnbilled = ISNULL(@OpenOrderUnbilled, 0)
			,OrderPrebilled = ISNULL(@OrderPrebilled, 0)
			
			,BilledAmount = ISNULL(@BilledAmount, 0)
			,BilledAmountApproved = ISNULL(@BilledAmountApproved, 0)
			,BilledAmountNoTax = ISNULL(@BilledAmountNoTax, 0)
			,AdvanceBilled = ISNULL(@AdvanceBilled, 0)
			,AdvanceBilledOpen = ISNULL(@AdvanceBilledOpen, 0)
			
			,EstQty = ISNULL(@EstQty, 0)
			,EstNet = ISNULL(@EstNet, 0)
			,EstGross = ISNULL(@EstGross, 0)
			,EstCOQty = ISNULL(@EstCOQty, 0)
			,EstCONet = ISNULL(@EstCONet, 0)
			,EstCOGross = ISNULL(@EstCOGross, 0)
			
			,UpdateEnded = GETDATE()
	WHERE   ProjectKey = @ProjectKey
	
	RETURN 1
GO
