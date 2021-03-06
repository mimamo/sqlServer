USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCreateProjectInvoiceLines]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCreateProjectInvoiceLines]
	(
	@InvoiceKey int
	)
	
AS --Encrypt

	/*
    || When     Who Rel   What
    || 03/25/13 GHL 10.5 Creation for flex project FF billing
	||                   This sp splits a FF invoice detail line with a task so that the line
	||                   can be converted to a summary line and underlying detail invoice lines
	||                   are created proportionally to the estimate amounts
	*/

	SET NOCOUNT ON

	create table #currlines (
		InvoiceLineKey int null
		,ProjectKey int null
		,TaskKey int null
		,EstimateKey int null
		,TotalAmount money null
		,EstTotal money null
		,Percentage decimal(24,4) null
		,RoundingError money null

		-- various update flags
		,UpdateID int null
		,UpdateAmount money null
		,UpdateFlag int null -- this will be the flag indicating that the line is split
		)

	/* Assume done in calling sp 
	create table #newlines (
	    NewLineID int identity(1,1)
		,CurrInvoiceLineKey int null
		,TaskKey int null
		,Entity varchar(50) null
		,EntityKey int null
		,EstTotal money null
		,NewTotalAmount money null

		,UpdateFlag int null
	)
	*/

	-- capture current lines, the No Task case should have a project
	insert #currlines (InvoiceLineKey, ProjectKey, TaskKey, EstimateKey, TotalAmount,UpdateFlag)
	select InvoiceLineKey, ProjectKey, isnull(TaskKey, 0), isnull(EstimateKey, 0), TotalAmount, 0
	from   tInvoiceLine (nolock)
	where  InvoiceKey = @InvoiceKey
	and    LineType = 2 --Detail
	and    BillFrom = 1  --FF
	
	-- capture new lines from the estimates, labor should have a TaskKey
	-- if no estimate, take all approved
	insert #newlines (CurrInvoiceLineKey, TaskKey, Entity, EntityKey, EstTotal)
	select b.InvoiceLineKey, etl.TaskKey, 'tService', etl.ServiceKey,  Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
	from   tEstimateTaskLabor etl (nolock)	
		inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
		inner join #currlines b on etl.TaskKey = b.TaskKey and b.EstimateKey = 0
		inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey  
	Where e.ProjectKey = b.ProjectKey
	and e.Approved = 1
	and e.EstType = 2 -- Task/Service only
	group by b.InvoiceLineKey, etl.TaskKey, etl.ServiceKey
	order by s.Description

	-- if there is an estimate, link thru estimate key
	insert #newlines (CurrInvoiceLineKey, TaskKey, Entity, EntityKey, EstTotal)
	select b.InvoiceLineKey, etl.TaskKey, 'tService', etl.ServiceKey,  Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
	from   tEstimateTaskLabor etl (nolock)	
		inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
		inner join #currlines b on etl.TaskKey = b.TaskKey and etl.EstimateKey = b.EstimateKey
		inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey  
	Where e.EstType = 2 -- Task/Service only
	group by b.InvoiceLineKey, etl.TaskKey, etl.ServiceKey
	order by s.Description

	-- Expenses
	insert #newlines (CurrInvoiceLineKey, TaskKey, Entity, EntityKey, EstTotal)
	select b.InvoiceLineKey, isnull(ete.TaskKey,0), 'tItem', ete.ItemKey, ISNULL((
				 Sum(case 
						when e.ApprovedQty = 1 Then ete.BillableCost
						when e.ApprovedQty = 2 Then ete.BillableCost2
						when e.ApprovedQty = 3 Then ete.BillableCost3
						when e.ApprovedQty = 4 Then ete.BillableCost4
						when e.ApprovedQty = 5 Then ete.BillableCost5
						when e.ApprovedQty = 6 Then ete.BillableCost6											 
						end )
						),0)
	from   tEstimateTaskExpense ete (nolock)	
	inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
	inner join #currlines b on isnull(ete.TaskKey, 0) = isnull(b.TaskKey, 0) and b.EstimateKey = 0  
	inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
	Where e.ProjectKey = b.ProjectKey
	and e.Approved = 1
	and e.EstType = 2 -- Task/Service only
	group by b.InvoiceLineKey, isnull(ete.TaskKey,0), ete.ItemKey
	order by i.ItemName

	insert #newlines (CurrInvoiceLineKey, TaskKey, Entity, EntityKey, EstTotal)
	select b.InvoiceLineKey, isnull(ete.TaskKey,0), 'tItem', ete.ItemKey, ISNULL((
				Sum(case 
						when e.ApprovedQty = 1 Then ete.BillableCost
						when e.ApprovedQty = 2 Then ete.BillableCost2
						when e.ApprovedQty = 3 Then ete.BillableCost3
						when e.ApprovedQty = 4 Then ete.BillableCost4
						when e.ApprovedQty = 5 Then ete.BillableCost5
						when e.ApprovedQty = 6 Then ete.BillableCost6											 
						end )
						),0)
	from   tEstimateTaskExpense ete (nolock)	
	inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
	inner join #currlines b on isnull(ete.TaskKey, 0) = isnull(b.TaskKey, 0) and b.EstimateKey = ete.EstimateKey  
	inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
	Where e.ProjectKey = b.ProjectKey
	and e.EstType = 2 -- Task/Service only
	group by b.InvoiceLineKey, isnull(ete.TaskKey,0), ete.ItemKey
	order by i.ItemName

	update #currlines
	set    #currlines.EstTotal = isnull((
		select sum(b.EstTotal) from #newlines b where b.CurrInvoiceLineKey = #currlines.InvoiceLineKey 
	),0)
	
	-- Use the UpdateFlag to determine which lines we will split
	update #currlines
	set    #currlines.UpdateFlag = 1 
	from   #newlines b
	where  #currlines.InvoiceLineKey =  b.CurrInvoiceLineKey 
	-- however do not split if the line amount is 0, no div by 0
	and    #currlines.TotalAmount <> 0

	-- also if different signs, do not split
	update #currlines
	set    #currlines.UpdateFlag = 0
	where  EstTotal * TotalAmount < 0

	-- calc percent
	update #currlines
	set    #currlines.Percentage =  TotalAmount / EstTotal 
	where  #currlines.UpdateFlag = 1

	-- then calc the amount on the new lines
	update #newlines
	set    #newlines.NewTotalAmount =  ROUND(#newlines.EstTotal * b.Percentage, 2) 
	from   #currlines b
	where  #newlines.CurrInvoiceLineKey = b.InvoiceLineKey
	and    b.UpdateFlag = 1

	-- calc the rounding error
	update #currlines
	set    #currlines.RoundingError = isnull(#currlines.TotalAmount, 0) - isnull((
		select sum(b.NewTotalAmount) from #newlines b where b.CurrInvoiceLineKey = #currlines.InvoiceLineKey 
	),0)

	-- capture the max amount/key to apply the rounding error to
	update #currlines
	set    #currlines.UpdateAmount = isnull((
		select max(abs(EstTotal)) from #newlines b where b.CurrInvoiceLineKey = #currlines.InvoiceLineKey  
	),0)
	
	update #currlines
	set    #currlines.UpdateID = b.NewLineID 
	from   #newlines b
	where  #currlines.InvoiceLineKey = b.CurrInvoiceLineKey   
	and    abs(#currlines.UpdateAmount) = abs(b.EstTotal)
	and    #currlines.UpdateFlag = 1

	update #newlines
	set    #newlines.NewTotalAmount = isnull(#newlines.NewTotalAmount, 0) + isnull(b.RoundingError, 0)
	from   #currlines b
	where  b.InvoiceLineKey = #newlines.CurrInvoiceLineKey
	and    b.UpdateFlag = 1
	and    b.UpdateID = #newlines.NewLineID   

	--select * from #currlines
	--select * from #newlines

	delete #newlines where CurrInvoiceLineKey not in (select InvoiceLineKey from #currlines where UpdateFlag = 1)

	 
	RETURN 1
GO
