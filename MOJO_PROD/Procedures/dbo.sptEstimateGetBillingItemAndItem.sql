USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetBillingItemAndItem]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetBillingItemAndItem]
	(
	@EstimateKey int
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 12/26/14 GHL 10.587 (238741) Enhancement for Giant Creative Strategy
  ||                     Get details by billing item then item/service
  ||                     Labor:
  ||                     - Estimate by Task: get billing items from task (tTask or tEstimateTempTask for opps), no service
  ||                     - Other estimates: get billing item from service
  ||                     Expenses:
  ||                     - Estimate by Task: get billing items from task (tTask or tEstimateTempTask for opps), no item
  ||                     - Other estimates: get billing item from item
  ||                     I calculate Taxable only for expenses to be consistent with other printouts
  ||                     Also we need the ability to compare to other budget data (already approved) 
  */

	SET NOCOUNT ON 

	-- Estimate Types
	declare @kByTaskOnly int					select @kByTaskOnly = 1
	declare @kByTaskService int					select @kByTaskService = 2
	declare @kByTaskPerson int					select @kByTaskPerson = 3
	declare @kByServiceOnly int					select @kByServiceOnly = 4
	declare @kBySegmentService int				select @kBySegmentService = 5
	declare @kByProject int						select @kByProject = 6 -- Handle later

	-- When there is no name, display these
	declare @kNoBillingItem varchar(100)		select @kNoBillingItem = 'Other Billing Item'
	declare @kNoItem varchar(100)				select @kNoItem = 'Other Item'
	declare @kNoService varchar(100)			select @kNoService = 'Other Service'

	declare @CompanyKey int
	declare @EstimateTemplateKey int
	declare @EntityKey int
	declare @Entity varchar(50)
	declare @EstType int
	
	select @EstimateTemplateKey = EstimateTemplateKey
	      ,@EntityKey = EntityKey
		  ,@Entity = Entity -- tProject/tLead/tCampaign
		  ,@EstType = EstType
		  ,@CompanyKey = CompanyKey
	from   vEstimateApproved (nolock)
	where  EstimateKey = @EstimateKey


	-- First we need to find out if the template requires a comparison with the current approved budget
	declare @CompareToOriginal int

	select @CompareToOriginal = CompareToOriginal
	from   tEstimateTemplate (nolock)
	where  EstimateTemplateKey = @EstimateTemplateKey

	select @CompareToOriginal = isnull(@CompareToOriginal, 1)

	-- The key in #curr_details will be Entity/WorkTypeKey/EntityKey because I want to isolate Labor at the top 
	-- the problem is that a service and an item could have the same billing item 
	create table #curr_details (
		WorkTypeKey int null
		,Entity varchar(50) null -- tItem/tService
		,EntityKey int null 
		,Quantity decimal(24, 4) null
		,Rate decimal(24,4) null
		,Gross money null
		,Taxable int null
		,Taxable2 int null
		)
		
	-- this is for the budget details
	create table #orig_details (
		WorkTypeKey int null
		,Entity varchar(50) null -- tItem/tService
		,EntityKey int null 
		,Quantity decimal(24, 4) null
		,Rate decimal(24,4) null
		,Gross money null
		,Taxable int null
		,Taxable2 int null
		)

	-- this is for the comparision between original and current details
	create table #details (
		WorkTypeKey int null
		,Entity varchar(50) null -- tItem/tService
		,EntityKey int null

		,Quantity decimal(24, 4) null
		,Rate decimal(24,4) null
		,Gross money null

		,OrigQuantity decimal(24, 4) null
		,OrigRate decimal(24,4) null
		,OrigGross money null

		,Taxable int null
		,Taxable2 int null

		,WorkTypeName varchar(500) null
		,ItemName varchar(500) null
		)

	-- for estimates by tasks, I need a link between tasks and billing items + we need the Taxable flags
	-- because there will be no service/item in tEstimateTask
	create table #bi_task (TaskKey int null, WorkTypeKey int null, Taxable int null, Taxable2 int null)

	if @Entity = 'tProject'
		insert #bi_task (TaskKey, WorkTypeKey, Taxable, Taxable2)
		select TaskKey, isnull(WorkTypeKey, 0) , isnull(Taxable,0), isnull(Taxable2, 0)
		from tTask (nolock)
		where ProjectKey = @EntityKey
		and   TaskType = 2 -- detail
		and   TrackBudget = 1

	if @Entity = 'tLead'
		insert #bi_task (TaskKey, WorkTypeKey, Taxable, Taxable2)
		select TaskKey, isnull(WorkTypeKey, 0) , isnull(Taxable,0), isnull(Taxable2, 0)
		from tEstimateTaskTemp (nolock)
		where EntityKey = @EntityKey
		and   Entity = 'tLead'
		and   TaskType = 2 -- detail
		and   TrackBudget = 1


	-- no matter what, create the 0 buckets
	insert #curr_details (WorkTypeKey, Entity, EntityKey)
	values (0, 'tService', 0)

	insert #curr_details (WorkTypeKey, Entity, EntityKey)
	values (0, 'tItem', 0)
	
	insert #curr_details (WorkTypeKey, Entity, EntityKey)
	select WorkTypeKey, 'tService', 0
	from   tWorkType (nolock)
	where CompanyKey = @CompanyKey

	insert #curr_details (WorkTypeKey, Entity, EntityKey)
	select WorkTypeKey, 'tItem', 0
	from   tWorkType (nolock)
	where CompanyKey = @CompanyKey

	-- and copy them to budget details
	insert #orig_details (WorkTypeKey, Entity, EntityKey)
	select WorkTypeKey, Entity, EntityKey
	from   #curr_details
	
	/*
	STEP 1 PROCESS THE CURRENT ESTIMATE
	*/

	/*
	 1 Summarize the tEstimateTask recs
	*/

	update #curr_details
	set    #curr_details.Quantity = (SELECT sum(et.Hours)
			from tEstimateTask et (nolock)
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey = @EstimateKey 
			and   bi.WorkTypeKey = #curr_details.WorkTypeKey
			)
	where  #curr_details.Entity = 'tService'
	and    #curr_details.EntityKey = 0

	update #curr_details
	set    #curr_details.Gross = (SELECT sum(et.EstLabor)
			from tEstimateTask et (nolock)
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey = @EstimateKey 
			and   bi.WorkTypeKey = #curr_details.WorkTypeKey
			)
	where  #curr_details.Entity = 'tService'
	and    #curr_details.EntityKey = 0

	-- in tEstimateTask we do not have quantities, so calc Gross + Taxable
	update #curr_details
	set    #curr_details.Gross = (SELECT sum(et.EstExpenses)
			from tEstimateTask et (nolock)
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey = @EstimateKey 
			and   bi.WorkTypeKey = #curr_details.WorkTypeKey
			)

			,#curr_details.Taxable = (SELECT max(bi.Taxable)
			from tEstimateTask et (nolock)
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey = @EstimateKey 
			and   bi.WorkTypeKey = #curr_details.WorkTypeKey
			and   isnull(et.EstExpenses, 0) <> 0
			)

			,#curr_details.Taxable2 = (SELECT max(bi.Taxable2)
			from tEstimateTask et (nolock)
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey = @EstimateKey 
			and   bi.WorkTypeKey = #curr_details.WorkTypeKey
			and   isnull(et.EstExpenses, 0) <> 0
			)

	where  #curr_details.Entity = 'tItem'
	and    #curr_details.EntityKey = 0


	/*
	2) now summarize the tEstimateTaskLabor 
	*/

	-- tEstimateTaskLabor with no service
	update #curr_details
	set    #curr_details.Quantity = isnull(#curr_details.Quantity, 0) + isnull((
			select Sum(ISNULL(etl.Hours, 0))
			from tEstimateTaskLabor etl (nolock)
			where etl.EstimateKey = @EstimateKey 
			and   isnull(etl.ServiceKey,0) = 0
			), 0)
	where  #curr_details.Entity = 'tService'
	and    #curr_details.EntityKey = 0
	and    #curr_details.WorkTypeKey = 0

	update #curr_details
	set    #curr_details.Gross = isnull(#curr_details.Gross, 0) + isnull((
			select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl (nolock)
			where etl.EstimateKey = @EstimateKey 
			and   isnull(etl.ServiceKey,0) = 0
			), 0)
	where  #curr_details.Entity = 'tService'
	and    #curr_details.EntityKey = 0
	and    #curr_details.WorkTypeKey = 0

	-- now summarize the tEstimateTaskLabor with service
	insert #curr_details (WorkTypeKey, Entity, EntityKey, Quantity, Gross)
	select isnull(s.WorkTypeKey,0), 'tService', etl.ServiceKey
		, Sum(ISNULL(etl.Hours, 0)), Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
	from tEstimateTaskLabor etl (nolock)
	inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey
	where etl.EstimateKey = @EstimateKey 
	group by isnull(s.WorkTypeKey,0), etl.ServiceKey

	/*
	 3) now summarize the tEstimateTaskExpense 
	*/

	-- tEstimateTaskExpense with no item
	update #curr_details
	set    #curr_details.Quantity = isnull(#curr_details.Quantity, 0) + ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		

			 ,#curr_details.Gross = isnull(#curr_details.Gross, 0) + ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		

		   ,#curr_details.Taxable = ISNULL((Select Max(isnull(ete.Taxable, 0))
		    from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		
			,#curr_details.Taxable2 = ISNULL((Select Max(isnull(ete.Taxable2, 0))
		    from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 	

	where  #curr_details.Entity = 'tItem'
	and    #curr_details.EntityKey = 0
	and    #curr_details.WorkTypeKey = 0

	-- now summarize the tEstimateTaskExpense with item
	insert #curr_details (WorkTypeKey, Entity, EntityKey, Quantity, Gross, Taxable, Taxable2)
	select isnull(i.WorkTypeKey,0), 'tItem', ete.ItemKey
		, Sum(case 
				when e.ApprovedQty = 1 Then ete.Quantity
				when e.ApprovedQty = 2 Then ete.Quantity2
				when e.ApprovedQty = 3 Then ete.Quantity3
				when e.ApprovedQty = 4 Then ete.Quantity4
				when e.ApprovedQty = 5 Then ete.Quantity5
				when e.ApprovedQty = 6 Then ete.Quantity6											 
				end ) 
		, Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end ) 
		,Max(isnull(ete.Taxable,0))
		,Max(isnull(ete.Taxable2,0))
	from tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
	inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
	where ete.EstimateKey = @EstimateKey 
	And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
	group by isnull(i.WorkTypeKey,0), ete.ItemKey

	delete #curr_details where isnull(Quantity, 0) = 0 and isnull(Gross, 0) = 0 

	update #curr_details 
	set    Rate = Gross / Quantity
	where  isnull(Quantity, 0) <> 0
	 
	 update #curr_details
	 set Taxable = isnull(Taxable, 0)
	    ,Taxable2 = isnull(Taxable2, 0)

	/*
	STEP 2 PROCESS THE BUDGET DATA
	*/

	/*
	 1 Summarize the tEstimateTask recs
	*/

if @CompareToOriginal = 1
begin

	update #orig_details
	set    #orig_details.Quantity = (SELECT sum(et.Hours)
			from tEstimateTask et (nolock)
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey 
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where e.EstimateKey <> @EstimateKey 
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved
			and   bi.WorkTypeKey = #orig_details.WorkTypeKey
			)
	where  #orig_details.Entity = 'tService'
	and    #orig_details.EntityKey = 0

	update #orig_details
	set    #orig_details.Gross = (SELECT sum(et.EstLabor)
			from tEstimateTask et (nolock)
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey 
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey <> @EstimateKey 
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved
			and   bi.WorkTypeKey = #orig_details.WorkTypeKey
			)
	where  #orig_details.Entity = 'tService'
	and    #orig_details.EntityKey = 0

	-- in tEstimateTask we do not have quantities, so calc Gross + Taxable
	update #orig_details
	set    #orig_details.Gross = (SELECT sum(et.EstExpenses)
			from tEstimateTask et (nolock)
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey 
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey <> @EstimateKey
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved 
			and   bi.WorkTypeKey = #orig_details.WorkTypeKey
			)

			,#orig_details.Taxable = (SELECT max(bi.Taxable)
			from tEstimateTask et (nolock)
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey 
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey <> @EstimateKey 
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved
			and   bi.WorkTypeKey = #orig_details.WorkTypeKey
			and   isnull(et.EstExpenses, 0) <> 0
			)

			,#orig_details.Taxable2 = (SELECT max(bi.Taxable2)
			from tEstimateTask et (nolock)
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey 
			inner join #bi_task bi on et.TaskKey =bi.TaskKey
			where et.EstimateKey <> @EstimateKey
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved 
			and   bi.WorkTypeKey = #orig_details.WorkTypeKey
			and   isnull(et.EstExpenses, 0) <> 0
			)

	where  #orig_details.Entity = 'tItem'
	and    #orig_details.EntityKey = 0


	/*
	2) now summarize the tEstimateTaskLabor 
	*/

	-- tEstimateTaskLabor with no service
	update #orig_details
	set    #orig_details.Quantity = isnull(#orig_details.Quantity, 0) + isnull((
			select Sum(ISNULL(etl.Hours, 0))
			from tEstimateTaskLabor etl (nolock)
			inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey 
			where etl.EstimateKey <> @EstimateKey
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved 
			and   isnull(etl.ServiceKey,0) = 0
			), 0)
	where  #orig_details.Entity = 'tService'
	and    #orig_details.EntityKey = 0
	and    #orig_details.WorkTypeKey = 0

	update #orig_details
	set    #orig_details.Gross = isnull(#orig_details.Gross, 0) + isnull((
			select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl (nolock)
			inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey 
			where etl.EstimateKey <> @EstimateKey
			and   e.Entity = @Entity
			and   e.EntityKey = @EntityKey
			and   e.Approved = 1 -- already approved 
			and   isnull(etl.ServiceKey,0) = 0
			), 0)
	where  #orig_details.Entity = 'tService'
	and    #orig_details.EntityKey = 0
	and    #orig_details.WorkTypeKey = 0

	-- now summarize the tEstimateTaskLabor with service
	insert #orig_details (WorkTypeKey, Entity, EntityKey, Quantity, Gross)
	select isnull(s.WorkTypeKey,0), 'tService', etl.ServiceKey
		, Sum(ISNULL(etl.Hours, 0)), Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
	from tEstimateTaskLabor etl (nolock)
	inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey 
	inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey
	where etl.EstimateKey <> @EstimateKey
	and   e.Entity = @Entity
	and   e.EntityKey = @EntityKey
	and   e.Approved = 1 -- already approved 
	group by isnull(s.WorkTypeKey,0), etl.ServiceKey

	/*
	 3) now summarize the tEstimateTaskExpense 
	*/

	-- tEstimateTaskExpense with no item
	update #orig_details
	set    #orig_details.Quantity = isnull(#orig_details.Quantity, 0) + ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey 
					Where e.EstimateKey <> @EstimateKey
					and   e.Entity = @Entity
					and   e.EntityKey = @EntityKey
					and   e.Approved = 1 -- already approved   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		

			 ,#orig_details.Gross = isnull(#orig_details.Gross, 0) + ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey 
					Where e.EstimateKey <> @EstimateKey
					and   e.Entity = @Entity
					and   e.EntityKey = @EntityKey
					and   e.Approved = 1 -- already approved   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		

		   ,#orig_details.Taxable = ISNULL((Select Max(isnull(ete.Taxable, 0))
		    from tEstimateTaskExpense ete  (nolock) 
					inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey 
					Where e.EstimateKey <> @EstimateKey
					and   e.Entity = @Entity
					and   e.EntityKey = @EntityKey
					and   e.Approved = 1 -- already approved   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 		
			,#orig_details.Taxable2 = ISNULL((Select Max(isnull(ete.Taxable2, 0))
		    from tEstimateTaskExpense ete  (nolock) 
					inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey 
					Where e.EstimateKey <> @EstimateKey
					and   e.Entity = @Entity
					and   e.EntityKey = @EntityKey
					and   e.Approved = 1 -- already approved   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(ete.ItemKey, 0) = 0), 0) 	

	where  #orig_details.Entity = 'tItem'
	and    #orig_details.EntityKey = 0
	and    #orig_details.WorkTypeKey = 0

	-- now summarize the tEstimateTaskExpense with item
	insert #orig_details (WorkTypeKey, Entity, EntityKey, Quantity, Gross, Taxable, Taxable2)
	select isnull(i.WorkTypeKey,0), 'tItem', ete.ItemKey
		, Sum(case 
				when e.ApprovedQty = 1 Then ete.Quantity
				when e.ApprovedQty = 2 Then ete.Quantity2
				when e.ApprovedQty = 3 Then ete.Quantity3
				when e.ApprovedQty = 4 Then ete.Quantity4
				when e.ApprovedQty = 5 Then ete.Quantity5
				when e.ApprovedQty = 6 Then ete.Quantity6											 
				end ) 
		, Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end ) 
		,Max(isnull(ete.Taxable,0))
		,Max(isnull(ete.Taxable2,0))
	from tEstimateTaskExpense ete (nolock)
	inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey 
	inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
	where ete.EstimateKey <> @EstimateKey
	and   e.Entity = @Entity
	and   e.EntityKey = @EntityKey
	and   e.Approved = 1 -- already approved 
	And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
	group by isnull(i.WorkTypeKey,0), ete.ItemKey

	delete #orig_details where isnull(Quantity, 0) = 0 and isnull(Gross, 0) = 0 

	update #orig_details 
	set    Rate = Gross / Quantity
	where  isnull(Quantity, 0) <> 0
	 
	 update #orig_details
	 set Taxable = isnull(Taxable, 0)
	    ,Taxable2 = isnull(Taxable2, 0)

end -- if CompareToOriginal 

	/*
	STEP 3: Merge the original and current details
	*/
	
	if @CompareToOriginal = 0
	begin
		-- if we do not compare, take the current details as is
		insert #details (WorkTypeKey, Entity, EntityKey, Quantity, Rate, Gross, Taxable, Taxable2)
		select WorkTypeKey, Entity, EntityKey, Quantity, Rate, Gross, Taxable, Taxable2
		from   #curr_details
	end
	else
	begin
		-- if we compare, we have to merge the 2 sets of details
		insert #details (WorkTypeKey, Entity, EntityKey, Quantity, Rate, Gross, OrigQuantity, OrigRate, OrigGross, Taxable, Taxable2)
		select WorkTypeKey, Entity, EntityKey, Quantity, Rate, Gross, 0,0,0,0, 0
		from   #curr_details

		-- update orig values where there is a match
		update #details
		set    #details.OrigQuantity = b.Quantity
		      ,#details.OrigRate = b.Rate
			  ,#details.OrigGross = b.Gross
		from   #orig_details b
		where  #details.WorkTypeKey = b.WorkTypeKey
		and    #details.Entity = b.Entity
		and    #details.EntityKey = b.EntityKey

		-- insert where there is no match
		insert #details (WorkTypeKey, Entity, EntityKey, Quantity, Rate, Gross, OrigQuantity, OrigRate, OrigGross, Taxable, Taxable2)
		select WorkTypeKey, Entity, EntityKey, 0,0,0, Quantity, Rate, Gross, 0, 0
		from   #orig_details
		where  not exists (select *
							from #curr_details
							where #curr_details.WorkTypeKey =  #orig_details.WorkTypeKey
							and   #curr_details.Entity =  #orig_details.Entity
							and   #curr_details.EntityKey =  #orig_details.EntityKey
							)

		-- now update the taxable flags
		-- it is taxable if it is taxable in either one
		update #details
		set    #details.Taxable = 1
		from   #curr_details b
		where  #details.WorkTypeKey = b.WorkTypeKey 
		and    #details.Entity = b.Entity
		and    #details.EntityKey = b.EntityKey
		and    b.Taxable = 1

		update #details
		set    #details.Taxable2 = 1
		from   #curr_details b
		where  #details.WorkTypeKey = b.WorkTypeKey 
		and    #details.Entity = b.Entity
		and    #details.EntityKey = b.EntityKey
		and    b.Taxable2 = 1

		update #details
		set    #details.Taxable = 1
		from   #orig_details b
		where  #details.WorkTypeKey = b.WorkTypeKey 
		and    #details.Entity = b.Entity
		and    #details.EntityKey = b.EntityKey
		and    b.Taxable = 1

		update #details
		set    #details.Taxable2 = 1
		from   #orig_details b
		where  #details.WorkTypeKey = b.WorkTypeKey 
		and    #details.Entity = b.Entity
		and    #details.EntityKey = b.EntityKey
		and    b.Taxable2 = 1

	end

	update  #details
	set     #details.WorkTypeName = wt.WorkTypeName
	from    tWorkType wt (nolock) 
	where   #details.WorkTypeKey = wt.WorkTypeKey

	update  #details
	set     #details.ItemName = i.ItemName
	from    tItem i (nolock) 
	where   #details.EntityKey = i.ItemKey
	and     #details.Entity = 'tItem'
	
	update  #details
	set     #details.ItemName = s.Description
	from    tService s (nolock) 
	where   #details.EntityKey = s.ServiceKey
	and     #details.Entity = 'tService'
	  
	update  #details
	set     #details.WorkTypeName = isnull(#details.WorkTypeName, @kNoBillingItem )
	      
	update  #details
	set     #details.ItemName = isnull(#details.ItemName, @kNoItem )
	where   #details.Entity = 'tItem'

	update  #details
	set     #details.ItemName = isnull(#details.ItemName, @kNoService )
	where   #details.Entity = 'tService'

	-- final protection against nulls
	update  #details
	set Quantity = isnull(Quantity, 0)
	   ,Gross = isnull(Gross, 0)
	   ,OrigQuantity = isnull(OrigQuantity, 0)
	   ,OrigGross = isnull(OrigGross, 0)

	update  #details
	set Rate = isnull(Rate, Gross)
	   ,OrigRate = isnull(OrigRate, OrigGross)

	--select * from #bi_task
	--select 'current', * from #curr_details
	--select 'orig', * from #orig_details 
	--select 'merged', * from #details  

	select  *
	from    #details 
	order by Entity desc -- Labor at the top
		, WorkTypeName, ItemName


	RETURN 1
GO
