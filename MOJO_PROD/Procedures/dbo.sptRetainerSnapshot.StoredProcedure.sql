USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerSnapshot]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerSnapshot]
	(
		@RetainerKey INT
	   ,@ParmStartDate  smalldatetime
	   ,@ParmEndDate  smalldatetime 

	)
AS --Encrypt

	/*
	Who		Rel		When		What
	GHL		82		12/26/2005	Removed reading of AmountReceived and OpenAmt since we moved
								tInvoice.RetainerKey to tInvoiceLine.RetainerKey
	GHL     85      07/09/2007  Added restriction on ER		
	GHL     8519    09/04/2008  (34200) Replaced some queries by project rollup
	                            to speed up stored proc
	GHL     8519    09/04/2008  (34245) Removed Advance Bills	
	GWG		10519   02/23/2010	(75073) Modified the Total cost to not include orders that are closed and reduced by the total applied cost
	GWG     10519   02/25/2010  (75073) Using the rollup tables for order amounts
	WDF     10560   09/11/2012  (117179)Added Date Criteria for Status tab of Billing.Retainer screen
	GHL     10560   09/13/2012  Taking now tVoucher.InvoiceDate instead of tVoucher.PostingDate
	                            Removed join between tPurchaseOrderDetail and tInvoiceLine
	GHL     10573   10/08/13    Changes for multi currency. Take PTotalCost and PAppliedCost for Net
	*/
	
	SET NOCOUNT ON 
	
	-- Local vars
	DECLARE @CompanyKey INT
			,@IncludeLabor INT
			,@IncludeExpense INT
	
	-- Vars that we will output
	DECLARE @AmountBilled MONEY
		   ,@AmountBilledRetainer MONEY
		   ,@AmountBilledExtra MONEY		   
	       ,@LaborGross MONEY
	       ,@LaborNet MONEY
	       ,@ExpenseGrossMC MONEY
	       ,@ExpenseNetMC MONEY
	       ,@ExpenseGrossER MONEY
	       ,@ExpenseNetER MONEY
	       ,@ExpenseGrossVO MONEY
	       ,@ExpenseNetVO MONEY
	       ,@ExpenseGrossPO MONEY
	       ,@ExpenseNetPO MONEY
	       ,@ExpenseGross MONEY
	       ,@ExpenseNet MONEY

      
	SELECT @CompanyKey = CompanyKey
	FROM	tRetainer (NOLOCK)
	WHERE	RetainerKey = @RetainerKey
	
	-- Retainer period amount will have BillFrom = 1 (No transaction detail)
	-- Extras lines will have BillFrom = 2 (Transaction detail)

	SELECT @AmountBilledExtra = SUM(il.TotalAmount)
	FROM   tInvoice i (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
	WHERE  i.CompanyKey = @CompanyKey
	AND    i.AdvanceBill = 0
    AND   (i.InvoiceDate >= @ParmStartDate AND i.InvoiceDate <= @ParmEndDate)
	AND	   il.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK)
							WHERE CompanyKey = @CompanyKey 
							AND RetainerKey =  @RetainerKey)
	AND	   il.BillFrom = 2  -- May not be necessary now that RetainerKey moved to line level and used for retainer amount only 
	
	SELECT @AmountBilledRetainer = SUM(il.TotalAmount)
	FROM   tInvoice i (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
	WHERE  i.CompanyKey = @CompanyKey
	AND    i.AdvanceBill = 0
    AND   (i.InvoiceDate >= @ParmStartDate AND i.InvoiceDate <= @ParmEndDate)
	AND	   il.RetainerKey = @RetainerKey
	AND	   il.BillFrom = 1
	
	SELECT @AmountBilled = ISNULL(@AmountBilledRetainer, 0) + ISNULL(@AmountBilledExtra, 0)
	
	--
	--  'ALL' selected.  Use Rollup table
	--
	IF ((CAST(DATEPART(year, @ParmStartDate) AS CHAR(4)) = '1900') AND (CAST(DATEPART(year, @ParmEndDate) AS CHAR(4)) = '2079'))
	BEGIN

		SELECT @LaborGross		= SUM(roll.LaborGross)
			  ,@LaborNet		= SUM(roll.LaborNet)
			  ,@ExpenseGrossMC	= SUM(roll.MiscCostGross)
			  ,@ExpenseNetMC	= SUM(roll.MiscCostNet)
			  ,@ExpenseGrossER	= SUM(roll.ExpReceiptGross)
			  ,@ExpenseNetER	= SUM(roll.ExpReceiptNet)
			  ,@ExpenseGrossVO	= SUM(roll.VoucherGross)
			  ,@ExpenseNetVO	= SUM(roll.VoucherNet)
			  ,@ExpenseGrossPO  = SUM(roll.OpenOrderGross)
			  ,@ExpenseNetPO  = SUM(roll.OpenOrderNet)
		FROM   tProjectRollup roll (NOLOCK)	
			INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey
		WHERE p.CompanyKey = @CompanyKey 
		AND   p.RetainerKey = @RetainerKey 
		AND  ISNULL(p.NonBillable, 0) = 0

	END
	ELSE
	BEGIN
	--
	--  Specific Date selected...manually Rollup using the dates
	--
		-- Labor	
		SELECT @LaborGross = SUM(ROUND(ActualHours * ActualRate, 2)) 
			   ,@LaborNet = SUM(ROUND(ActualHours * ISNULL(CostRate, ActualRate), 2)) -- Both CostRate/ActualRate in P Currency 
		FROM   tTime (NOLOCK) 
		WHERE  tTime.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey AND ISNULL(NonBillable, 0) = 0 )								
          AND  (WorkDate >= @ParmStartDate AND WorkDate <= @ParmEndDate)
		
		-- Expense MC
		SELECT @ExpenseGrossMC = SUM(BillableCost)
			   ,@ExpenseNetMC = SUM(TotalCost)   -- Misc Costs are expressed in Project Currency, so need of PTotalCost
		FROM   tMiscCost (NOLOCK) 
		WHERE  tMiscCost.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey AND ISNULL(NonBillable, 0) = 0 )															
          AND  (ExpenseDate >= @ParmStartDate AND ExpenseDate <= @ParmEndDate)
		
		-- Expense ER
		SELECT @ExpenseGrossER = SUM(BillableCost)
			   ,@ExpenseNetER = SUM(PTotalCost) 
		FROM   tExpenseReceipt (NOLOCK) 
		WHERE  tExpenseReceipt.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey AND ISNULL(NonBillable, 0) = 0 )															
		  AND  tExpenseReceipt.VoucherDetailKey IS NULL 
          AND  (ExpenseDate >= @ParmStartDate AND ExpenseDate <= @ParmEndDate)
		
		-- Expense VO
		SELECT @ExpenseGrossVO = SUM(vd.BillableCost)
			   ,@ExpenseNetVO = SUM(vd.PTotalCost) 
		FROM   tVoucherDetail vd (NOLOCK) 
		INNER JOIN tVoucher v (NOLOCK) ON v.VoucherKey = vd.VoucherKey
		WHERE  vd.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey AND ISNULL(NonBillable, 0) = 0 )															
          AND  (v.InvoiceDate >= @ParmStartDate AND v.InvoiceDate <= @ParmEndDate)
   		
		-- Expense PO
		SELECT @ExpenseGrossPO = ISNULL(SUM(CASE 
											   WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
											   WHEN AppliedCost > 0 AND AppliedCost < TotalCost THEN NewBillableCost * (1 - AppliedCost / TotalCost)	
											   ELSE NewBillableCost 
											 END
										), 0)
			  ,@ExpenseNetPO = ISNULL(SUM(TotalCost - AppliedCost), 0)
		  FROM (SELECT CASE po.BillAt 
				          WHEN 0 THEN ISNULL(pod.BillableCost, 0)
				          WHEN 1 THEN ISNULL(pod.PTotalCost,0)
				          WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
				        END AS NewBillableCost
				        ,pod.PTotalCost As TotalCost
				        ,pod.PAppliedCost As AppliedCost
		          FROM	tPurchaseOrderDetail pod (NOLOCK) 
				  INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				  WHERE	pod.Closed = 0					-- still open
                  AND (po.PODate >= @ParmStartDate AND po.PODate <= @ParmEndDate)
		          AND	pod.ProjectKey IN (SELECT ProjectKey 
		                                     FROM tProject (NOLOCK) 
		                                    WHERE CompanyKey  = @CompanyKey
		                                      AND RetainerKey = @RetainerKey
		                                      AND ISNULL(NonBillable, 0) = 0 ))
		AS ExpensePO   	
    END


	SELECT @ExpenseGross = ISNULL(@ExpenseGrossMC, 0) + ISNULL(@ExpenseGrossER, 0) + ISNULL(@ExpenseGrossVO, 0) + ISNULL(@ExpenseGrossPO, 0)
		  ,@ExpenseNet = ISNULL(@ExpenseNetMC, 0) + ISNULL(@ExpenseNetER, 0) + ISNULL(@ExpenseNetVO, 0) + ISNULL(@ExpenseNetPO, 0)
		  
	SELECT ISNULL(@ExpenseGross, 0)		    AS ExpenseGross
		  ,ISNULL(@ExpenseNet, 0) 			AS ExpenseNet
		  ,ISNULL(@LaborGross, 0)			AS LaborGross
		  ,ISNULL(@LaborNet, 0)			    AS LaborNet
		  ,ISNULL(@AmountBilled, 0)		 AS AmountBilled
		  ,ISNULL(@AmountBilledRetainer, 0) AS AmountBilledRetainer
		  ,ISNULL(@AmountBilledExtra, 0)	AS AmountBilledExtra
		  				
	RETURN 1
GO
