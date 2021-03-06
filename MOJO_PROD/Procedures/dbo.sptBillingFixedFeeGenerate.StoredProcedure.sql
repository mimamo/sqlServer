USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeGenerate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeGenerate] 
	(
	@CompanyKey int
	,@BillingKey INT
	,@ClientKey INT
    ,@ProjectKey INT
	,@ThruDate smalldatetime
	)
AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 04/27/15 GHL 10.591  (239471) Creation to insert tBillingFixedFee records at the time of the generation of the billing worksheet 
  ||                      Merged code fragments from sptBillingFixedFeeGetTaskList, sptBillingFixedFeeGetServiceList, sptBillingFixedFeeGetItemList
  ||                      ,sptBillingFixedFeeGetBillingItemList
  ||                      Also taking in account the billing schedule, like in sptBillingInsert
  */


  CREATE TABLE #ff_item (Entity VARCHAR(50) NULL, EntityKey INT NULL, BudgetAmount MONEY null, BilledAmount MONEY, RemainingAmount MONEY null
	,Amount MONEY NULL, Percentage DECIMAL(24,4) NULL, Taxable INT NULL, Taxable2 INT NULL, DepartmentKey INT NULL)

	DECLARE @OneLinePer SMALLINT
	DECLARE @Entity VARCHAR(50)
	DECLARE @NextBillDate SMALLDATETIME
	DECLARE @PercentBudget decimal(24,4) 
	DECLARE @FFTotal MONEY

	-- we need to map the line format from the client to what is possible to achieve on the FF Worksheet screen
	SELECT @OneLinePer = DefaultARLineFormat FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey
	SELECT @OneLinePer = ISNULL(@OneLinePer, 0)

	IF @OneLinePer = 1 -- Task
		SELECT @Entity = 'tTask'
	ELSE IF @OneLinePer IN (2, 14) --Service or Service/Item
		SELECT @Entity = 'tService'
	ELSE IF @OneLinePer IN (3,8,9) --BI or Project then BI and Item or BI and Item
		SELECT @Entity = 'tWorkType'
	ELSE
        SELECT @Entity = 'tEstimate' -- just a one line FF rec


IF @Entity = 'tTask'
BEGIN
	INSERT #ff_item(Entity, EntityKey, BudgetAmount, BilledAmount, Taxable,Taxable2)
	SELECT 'tTask', ta.TaskKey, ISNULL(ta.EstLabor, 0) + ISNULL(ta.EstExpenses, 0) + ISNULL(ta.ApprovedCOLabor, 0) + ISNULL(ta.ApprovedCOExpense, 0)
	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.TaskKey = ta.TaskKey
				AND   inv.AdvanceBill = 0), 0)
	,ta.Taxable, ta.Taxable2
	FROM   tTask ta (NOLOCK)
	WHERE  ta.ProjectKey = @ProjectKey
	AND    ta.TrackBudget = 1

	INSERT #ff_item (Entity, EntityKey, BudgetAmount, BilledAmount)
	SELECT 'tTask', 0
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and isnull(et.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and isnull(et.TaskKey, 0) = 0), 0)
	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   ISNULL(isum.TaskKey, 0) = 0
				AND   inv.AdvanceBill = 0), 0)

END

	

IF @Entity = 'tWorkType'
BEGIN
	INSERT #ff_item(Entity, EntityKey, BudgetAmount, BilledAmount)
	SELECT 'tWorkType', wt.WorkTypeKey
	, ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			
		+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)

		+ ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1  
			and isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
					
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1  
			and isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
	
	,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = wt.WorkTypeKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1				-- Fixed Fee Only
	     ), 0)
	     
	    + ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		inner join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tService'
		AND   ISNULL(s.WorkTypeKey, 0) = wt.WorkTypeKey 
		), 0)
		 
		+ ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		inner join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tItem'
		AND   ISNULL(i.WorkTypeKey, 0) = wt.WorkTypeKey 
		), 0)
	FROM    tWorkType wt (NOLOCK)
	WHERE   wt.CompanyKey = @CompanyKey

	INSERT #ff_item(Entity, EntityKey, BudgetAmount, BilledAmount)
	SELECT 'tWorkType',0
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				left outer join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and (isnull(etl.ServiceKey, 0) = 0 OR isnull(s.WorkTypeKey, 0) = 0)), 0)
			
		+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = 0), 0)

	+ ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				left outer join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1  
			and isnull(i.WorkTypeKey, 0) = 0), 0)
		
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1  
			and isnull(t.WorkTypeKey, 0) = 0), 0)

	,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = 0 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1				-- Fixed Fee Only
	     ), 0)
	     
	    + ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		left outer join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tService'
		AND   ISNULL(s.WorkTypeKey, 0) = 0 
		), 0)
		 
		+ ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		left outer join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   ISNULL(isum.Entity, '') in ('', 'tItem')
		AND   ISNULL(i.WorkTypeKey, 0) = 0 
		), 0)


	UPDATE #ff_item
	SET    #ff_item.Taxable = wt.Taxable
		  ,#ff_item.Taxable2 = wt.Taxable2
		  ,#ff_item.DepartmentKey = wt.DepartmentKey
	FROM   tWorkType wt (NOLOCK)
	WHERE  wt.CompanyKey = @CompanyKey
	AND    wt.WorkTypeKey = #ff_item.EntityKey
END


IF @Entity = 'tService' -- Service or Item
BEGIN
	INSERT #ff_item (Entity, EntityKey, BudgetAmount, BilledAmount)

	SELECT 'tService', s.ServiceKey
	,ISNULL((SELECT pe.Gross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) 

	+ ISNULL((SELECT pe.COGross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) 

	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.Entity = 'tService'
				AND   ISNULL(isum.EntityKey, 0) = s.ServiceKey
				AND   inv.AdvanceBill = 0), 0)
	FROM		
		(
		select ServiceKey
		from tService (nolock)
		where CompanyKey = @CompanyKey
		UNION
		select	0 AS ServiceKey
		) AS s    
    
	INSERT #ff_item (Entity, EntityKey, BudgetAmount, BilledAmount)

	SELECT 'tItem', i.ItemKey
	,ISNULL((SELECT pe.Gross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = i.ItemKey
				AND pe.Entity = 'tItem'  
				), 0) 

	+ ISNULL((SELECT pe.COGross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = i.ItemKey
				AND pe.Entity = 'tItem'  
				), 0) 

	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   ISNULL(isum.Entity, '') IN ('','tItem')
				AND   ISNULL(isum.EntityKey, 0) = i.ItemKey
				AND   inv.AdvanceBill = 0), 0)
	FROM		
		(
		select ItemKey
		from tItem (nolock)
		where CompanyKey = @CompanyKey
		UNION
		select	0 AS ItemKey
		) AS i    
    

	UPDATE #ff_item
	SET    #ff_item.Taxable = s.Taxable
		  ,#ff_item.Taxable2 = s.Taxable2
		  ,#ff_item.DepartmentKey = s.DepartmentKey
	FROM   tService s (NOLOCK)
	WHERE  s.CompanyKey = @CompanyKey
	AND    s.ServiceKey = #ff_item.EntityKey
	AND    #ff_item.Entity = 'tService'

	UPDATE #ff_item
	SET    #ff_item.Taxable = i.Taxable
		  ,#ff_item.Taxable2 = i.Taxable2
		  ,#ff_item.DepartmentKey = i.DepartmentKey
	FROM   tItem i (NOLOCK)
	WHERE  i.CompanyKey = @CompanyKey
	AND    i.ItemKey = #ff_item.EntityKey
	AND    #ff_item.Entity = 'tItem'

end


UPDATE #ff_item
SET    BudgetAmount = ROUND(BudgetAmount, 2)
      ,BilledAmount = ROUND(BilledAmount, 2)

UPDATE #ff_item
SET    RemainingAmount = ISNULL(BudgetAmount, 0) - ISNULL(BilledAmount, 0)

-- take in account the billing schedule
select @NextBillDate = min(NextBillDate)
	from   tBillingSchedule (nolock)
	where  ProjectKey = @ProjectKey
	and    BillingKey is null
	and    NextBillDate is not null
	and    NextBillDate <= @ThruDate
	and    isnull(PercentBudget, 0) > 0

if @NextBillDate is not null
	select @PercentBudget = PercentBudget 
	from tBillingSchedule (nolock)
	where  ProjectKey = @ProjectKey
	and    BillingKey is null
	and    NextBillDate = @NextBillDate 



if isnull(@PercentBudget, 0) > 0
BEGIN
	UPDATE #ff_item
	SET    Amount = round((BudgetAmount * @PercentBudget) / 100.00, 2)

	INSERT tBillingFixedFee (BillingKey, Entity, EntityKey, Percentage, Amount
					, Taxable1, Taxable2, OfficeKey, DepartmentKey)
	SELECT @BillingKey, Entity, EntityKey, @PercentBudget, ISNULL(Amount, 0), ISNULL(Taxable,0), ISNULL(Taxable2,0), NULL, DepartmentKey
	FROM   #ff_item
	WHERE  ISNULL(Amount, 0) <> 0

	SELECT @FFTotal = SUM(Amount) FROM #ff_item 

	UPDATE tBilling 
		SET FixedFeeDisplay = CASE @Entity
			WHEN 'tTask' THEN 2
			WHEN 'tService' THEN 3 -- in fact Service/Item
			WHEN 'tWorkType' THEN 4
			ELSE 1
			end
			,FixedFeeCalcMethod = 1		-- Percentage of Total (vs Estimate Remaining)
			,FFTotal = @FFTotal 
	WHERE BillingKey = @BillingKey

END        
ELSE
BEGIN
	INSERT tBillingFixedFee (BillingKey, Entity, EntityKey, Percentage, Amount
				, Taxable1, Taxable2, OfficeKey, DepartmentKey)
	SELECT @BillingKey, Entity, EntityKey, 100, ISNULL(RemainingAmount, 0), ISNULL(Taxable,0), ISNULL(Taxable2,0), NULL, DepartmentKey
	FROM   #ff_item
	WHERE  ISNULL(RemainingAmount, 0) > 0 -- do not show negative amount
		
	SELECT @FFTotal = SUM(RemainingAmount) FROM #ff_item WHERE ISNULL(RemainingAmount, 0) > 0

	UPDATE tBilling 
		SET FixedFeeDisplay = CASE @Entity
			WHEN 'tTask' THEN 2
			WHEN 'tService' THEN 3  -- in fact Service/Item
			WHEN 'tWorkType' THEN 4
			ELSE 1
			end
			,FixedFeeCalcMethod = 0		-- Percentage of Remaining (vs Estimate Total)
			,FFTotal = @FFTotal 
	WHERE BillingKey = @BillingKey

END
GO
