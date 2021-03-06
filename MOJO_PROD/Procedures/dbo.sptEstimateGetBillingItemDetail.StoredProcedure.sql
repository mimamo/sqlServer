USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetBillingItemDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetBillingItemDetail]
	(
		@EstimateKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 04/09/07 GHL 8.4   Media Logic. Bug 8839. Estimate 'By Task Only' not displaying 
  ||                    correct billing item for a task
  || 04/27/10  GHL 10.522  Reading now tEstimateTaskTemp or tTask
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */
  
	SET NOCOUNT ON

Declare @CompanyKey INT
Declare @LeadKey int
Declare @Entity varchar(50)
Declare @EntityKey int
Declare @ReadTempTaskTable int
 
select @LeadKey = LeadKey
      ,@CompanyKey = CompanyKey
from   tEstimate (nolock)
where  EstimateKey = @EstimateKey

-- for now we only have 1 entity but we could have more in the future
if isnull(@LeadKey, 0) > 0
begin
	select @Entity = 'tLead', @EntityKey = @LeadKey 
	
	if exists (select 1 from tEstimateTaskTemp (nolock) where Entity = @Entity and EntityKey = @EntityKey)
		select @ReadTempTaskTable = 1
end

if isnull(@ReadTempTaskTable, 0) = 0	
	-- no entity, so read tTask
	
	SELECT	wt.WorkTypeKey
			,0 AS DisplayOrder
			,wt.WorkTypeID
			,wt.WorkTypeName 
			,
			-- Hours from tEstimateTask for tasks WITH billing item
	        ISNULL((Select Sum(isnull(et.Hours, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			-- Hours from tEstimateTaskLabor for services WITH billing item
			+ isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstHours
			,
			-- Labor from tEstimateTask for tasks WITH billing item
			ISNULL((Select Sum(isnull(et.EstLabor, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			-- Labor from tEstimateTaskLabor for services WITH billing item
			+ isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstLabor
			,
			-- Expenses from tEstimateTask for tasks WITH billing item		
			ISNULL((Select Sum(et.EstExpenses) 
    				from tEstimateTask et (NOLOCK)
    					Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
    				Where et.EstimateKey = @EstimateKey
    				And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
    				
    		-- Expenses from tEstimateTaskExpense for items WITH billing item		
			+ ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take here
					And isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstExpenses
	FROM	tWorkType wt (NOLOCK)
	WHERE   wt.CompanyKey = @CompanyKey

	UNION
		
	SELECT  0 AS WorkTypeKey				-- To capture services or items without billing items
			,1 AS DisplayOrder				-- Needed to isolate/sort this line on report
	        ,'NO ID' AS WorkTypeID
	        ,'Other Items' AS WorkTypeName	
	        , 
	        -- Hours from tEstimateTask WITHOUT billing item
	        ISNULL((Select Sum(isnull(et.Hours, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And isnull(t.WorkTypeKey, 0) = 0), 0) 
			+ -- Hours from tEstimateTaskLabor for services WITHOUT billing item
			isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = 0), 0) 
			+ -- Hours from tEstimateTaskLabor for persons
			isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
					Where etl.EstimateKey = @EstimateKey   
					And isnull(etl.UserKey, 0) > 0), 0) 
			 AS EstHours
    	    , -- Labor from tEstimateTask for tasks WITHOUT billing item
	        ISNULL((Select Sum(isnull(et.EstLabor, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And isnull(t.WorkTypeKey, 0) = 0), 0) 
			+ -- Labor from tEstimateTaskLabor for services WITHOUT billing item
			isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = 0), 0) 
			+ -- Labor from tEstimateTaskLabor for persons
			isnull((Select Sum(ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
					from tEstimateTaskLabor etl  (NOLOCK)
					Where etl.EstimateKey = @EstimateKey   
					And isnull(etl.UserKey, 0) > 0), 0) 
			 AS EstLabor
    	    ,ISNULL((Select Sum(isnull(et.EstExpenses, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tTask t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And isnull(t.WorkTypeKey, 0) = 0), 0)  		
    		+ -- Expenses from tEstimateTaskExpense for items WITHOUT billing item
			ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(i.WorkTypeKey, 0) = 0), 0) 		
			+ -- Expenses from tEstimateTaskExpense for WITHOUT item, yes there are some records where ItemKey = 0
			ISNULL((Select Sum(case 
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
    		AS EstExpenses
	       
else

	-- Read tEstimateTempTask
	
	SELECT	wt.WorkTypeKey
			,0 AS DisplayOrder
			,wt.WorkTypeID
			,wt.WorkTypeName 
			,
			-- Hours from tEstimateTask for tasks WITH billing item
	        ISNULL((Select Sum(isnull(et.Hours, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			-- Hours from tEstimateTaskLabor for services WITH billing item
			+ isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstHours
			,
			-- Labor from tEstimateTask for tasks WITH billing item
			ISNULL((Select Sum(isnull(et.EstLabor, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			-- Labor from tEstimateTaskLabor for services WITH billing item
			+ isnull((Select Sum(ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstLabor
			,
			-- Expenses from tEstimateTask for tasks WITH billing item		
			ISNULL((Select Sum(et.EstExpenses) 
    				from tEstimateTask et (NOLOCK)
    					Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey
    				Where et.EstimateKey = @EstimateKey
    				And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
    				
    		-- Expenses from tEstimateTaskExpense for items WITH billing item		
			+ ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take here
					And isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			AS EstExpenses
	FROM	tWorkType wt (NOLOCK)
	WHERE   wt.CompanyKey = @CompanyKey

	UNION
		
	SELECT  0 AS WorkTypeKey				-- To capture services or items without billing items
			,1 AS DisplayOrder				-- Needed to isolate/sort this line on report
	        ,'NO ID' AS WorkTypeID
	        ,'Other Items' AS WorkTypeName	
	        , 
	        -- Hours from tEstimateTask WITHOUT billing item
	        ISNULL((Select Sum(isnull(et.Hours, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = 0), 0) 
			+ -- Hours from tEstimateTaskLabor for services WITHOUT billing item
			isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = 0), 0) 
			+ -- Hours from tEstimateTaskLabor for persons
			isnull((Select Sum(ISNULL(etl.Hours, 0))
					from tEstimateTaskLabor etl  (NOLOCK)
					Where etl.EstimateKey = @EstimateKey   
					And isnull(etl.UserKey, 0) > 0), 0) 
			 AS EstHours
    	    , -- Labor from tEstimateTask for tasks WITHOUT billing item
	        ISNULL((Select Sum(isnull(et.EstLabor, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = 0), 0) 
			+ -- Labor from tEstimateTaskLabor for services WITHOUT billing item
			isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
					from tEstimateTaskLabor etl  (NOLOCK)
						Inner Join tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey 
					Where etl.EstimateKey = @EstimateKey   
					And isnull(s.WorkTypeKey, 0) = 0), 0) 
			+ -- Labor from tEstimateTaskLabor for persons
			isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
					from tEstimateTaskLabor etl  (NOLOCK)
					Where etl.EstimateKey = @EstimateKey   
					And isnull(etl.UserKey, 0) > 0), 0) 
			 AS EstLabor
    	    ,ISNULL((Select Sum(isnull(et.EstExpenses, 0)) 
					from tEstimateTask et (NOLOCK)
						Inner Join tEstimateTaskTemp t (NOLOCK) ON et.TaskKey = t.TaskKey 
					Where et.EstimateKey = @EstimateKey
					And   t.Entity = @Entity
					And   t.EntityKey = @EntityKey
					And isnull(t.WorkTypeKey, 0) = 0), 0)  		
    		+ -- Expenses from tEstimateTaskExpense for items WITHOUT billing item
			ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
					inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
					Where e.EstimateKey = @EstimateKey   
					And e.EstType > 1 -- When EstType = 1 expenses are rolled up to EstimateTask, so do not take
					And isnull(i.WorkTypeKey, 0) = 0), 0) 		
			+ -- Expenses from tEstimateTaskExpense for WITHOUT item, yes there are some records where ItemKey = 0
			ISNULL((Select Sum(case 
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
    		AS EstExpenses
	       	
	RETURN 1
GO
