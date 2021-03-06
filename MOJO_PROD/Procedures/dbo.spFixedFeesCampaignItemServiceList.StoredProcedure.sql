USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCampaignItemServiceList]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCampaignItemServiceList]
	(
	@CampaignKey int
	,@EstimateKey int = 0-- 0 = All
	)
AS	--Encrypt

  /*
  || When     Who Rel   What
  || 05/10/10 GHL 10.522 Creation for campaign FF billing
  || 12/02/10 GHL 10.539 Changed signature of spBillingLinesGroupByBillingItem
  ||                     for billing by project
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  || 01/14/13 GHL 10.564 (163923) Added contributions thru tEstimateProject
  */
  
	SET NOCOUNT ON
	
	create table #item (
		Entity varchar(50) null
		,EntityKey int null
		,EntityID varchar(250) null
		,EntityName varchar(500) null
		,EntityDescription text null
		
		,WorkTypeKey int null
		,WorkTypeID varchar(200) null
		,WorkTypeName varchar(250) null
		,WorkTypeDescription text null
		
		,DisplayOrder int null
		,Taxable int null
		,Taxable2 int null
		
		,EstHours decimal(24, 4) null
		,EstLabor money null
		,EstExpenses money null
		
		,ActHours decimal(24, 4) null
		,ActLabor money null
		,ActExpenses money null

		,Billed money null

		,RootEntity varchar(50) null
		,RootEntityKey int null

		)
	
	DECLARE @kNoItemDisplayOrder INT SELECT @kNoItemDisplayOrder = 9999 -- At bottom, -1 At top
	
	DECLARE @CompanyKey INT
	        ,@LayoutKey INT
	               
	SELECT @CompanyKey = CompanyKey
	       ,@LayoutKey = isnull(LayoutKey, 0)
	FROM   tCampaign (NOLOCK)
	WHERE  CampaignKey = @CampaignKey	
	
	insert #item(Entity, EntityKey, EntityID, EntityName, EntityDescription, WorkTypeKey)
	select 'tService', 0, '[No Service]', '[No Service]', '[No Service]', 0
	insert #item(Entity, EntityKey, EntityID, EntityName, EntityDescription, WorkTypeKey)
	select 'tItem', 0, '[No Item]', '[No Item]', '[No Item]', 0
	
	insert #item(Entity, EntityKey, EntityID, EntityName, EntityDescription
	, WorkTypeKey, Taxable, Taxable2)
	select 'tService', ServiceKey, ServiceCode, isnull(InvoiceDescription, Description), null
	, isnull(WorkTypeKey, 0),isnull(Taxable, 0), isnull(Taxable2, 0)
	from   tService (nolock)
	where  CompanyKey = @CompanyKey
	
	insert #item(Entity, EntityKey, EntityID, EntityName, EntityDescription
	, WorkTypeKey, Taxable, Taxable2)
	select 'tItem', ItemKey, ItemID, ItemName, StandardDescription
	, isnull(WorkTypeKey, 0),isnull(Taxable, 0), isnull(Taxable2, 0)
	from   tItem (nolock)
	where  CompanyKey = @CompanyKey
	
	-- Estimate data
	
	if @EstimateKey = 0
		update #item
		set    #item.EstHours = isnull((
						select sum(cebi.Qty + cebi.COQty) from tCampaignEstByItem cebi (nolock) 
						where cebi.CampaignKey = @CampaignKey
						and   cebi.Entity = 'tService' 
						and   #item.Entity = 'tService' 
						and   cebi.EntityKey = #item.EntityKey 
						), 0)
						
	          ,#item.EstLabor = isnull((
						select sum(cebi.Gross + cebi.COGross) from tCampaignEstByItem cebi (nolock) 
						where cebi.CampaignKey = @CampaignKey
						and   cebi.Entity = 'tService' 
						and   #item.Entity = 'tService' 
						and   cebi.EntityKey = #item.EntityKey 
						), 0)

	          ,#item.EstExpenses = isnull((
						select sum(cebi.Gross + cebi.COGross) from tCampaignEstByItem cebi (nolock) 
						where cebi.CampaignKey = @CampaignKey
						and   cebi.Entity = 'tItem' 
						and   #item.Entity = 'tItem' 
						and   cebi.EntityKey = #item.EntityKey 
						), 0)
		else
		begin
			-- there is an estimate
			update #item
			set    #item.EstHours = isnull((
						Select Sum(etl.Hours) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and #item.Entity = 'tService'
						and isnull(etl.ServiceKey, 0) = #item.EntityKey
					),0)
					 + ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl  (nolock) 
						inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and #item.Entity = 'tService'
					and isnull(etl.ServiceKey, 0) = #item.EntityKey
					), 0)
					 + ISNULL((
					Select Sum(et.Hours) 
					from tEstimateTask et  (nolock) 
						inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and #item.Entity = 'tService'
					and #item.EntityKey = 0
					), 0)
				  ,#item.EstLabor = isnull((
						Select Sum(Round(etl.Hours * etl.Rate,2)) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and #item.Entity = 'tService'
						and isnull(etl.ServiceKey, 0) = #item.EntityKey
					),0)
					+ ISNULL((
					Select Sum(Round(etl.Hours * etl.Rate,2)) 
					from tEstimateTaskLabor etl  (nolock) 
						inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and #item.Entity = 'tService'
					and isnull(etl.ServiceKey, 0) = #item.EntityKey
					), 0)
					 + ISNULL((
					Select Sum(Round(et.Hours * et.Rate,2))
					from tEstimateTask et  (nolock) 
						inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and #item.Entity = 'tService'
					and #item.EntityKey = 0
					), 0)	
				  ,#item.EstExpenses = isnull((
						Select Sum(case 
									when e.ApprovedQty = 1 Then ete.BillableCost
									when e.ApprovedQty = 2 Then ete.BillableCost2
									when e.ApprovedQty = 3 Then ete.BillableCost3
									when e.ApprovedQty = 4 Then ete.BillableCost4
									when e.ApprovedQty = 5 Then ete.BillableCost5
									when e.ApprovedQty = 6 Then ete.BillableCost6											 
									end ) 
						from tEstimateTaskExpense ete  (nolock) 
							inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and #item.Entity = 'tItem'
						and isnull(ete.ItemKey, 0) = #item.EntityKey
				), 0)
				+ ISNULL((
					Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.BillableCost
							when pe.ApprovedQty = 2 Then ete.BillableCost2
							when pe.ApprovedQty = 3 Then ete.BillableCost3
							when pe.ApprovedQty = 4 Then ete.BillableCost4
							when pe.ApprovedQty = 5 Then ete.BillableCost5
							when pe.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
					from tEstimateTaskExpense ete  (nolock) 
						inner join tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey 
						inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and pe.EstType > 1
					and #item.Entity = 'tItem'
					and isnull(ete.ItemKey, 0) = #item.EntityKey
				), 0)
				+ ISNULL((
					Select Sum(et.EstExpenses) 
					from tEstimateTask et  (nolock) 
						inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and #item.Entity = 'tItem'
					and #item.EntityKey = 0
				), 0)	
		end
					
		-- Actuals			
		update #item
		set    #item.ActHours = ISNULL((select sum(roll.Hours) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And #item.Entity = 'tService'
					And isnull(roll.EntityKey, 0) = #item.EntityKey
					), 0) 
					
				,#item.ActLabor = ISNULL((select sum(roll.LaborGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And #item.Entity = 'tService'
					And isnull(roll.EntityKey, 0) = #item.EntityKey
					), 0) 			

				 ,#item.ActExpenses = ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tItem'
					And #item.Entity = 'tItem'
					And isnull(roll.EntityKey, 0) = #item.EntityKey
					), 0) 			
					
				
	if @EstimateKey = 0
	begin
			update #item
			set    #item.Billed = 
			ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE inv.CampaignKey = @CampaignKey
				AND   isum.Entity = 'tService'
				AND   ISNULL(isum.EntityKey, 0) = #item.EntityKey
				), 0)
			where #item.Entity = 'tService'

			update #item
			set    #item.Billed = 
			ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE inv.CampaignKey = @CampaignKey
				AND   isnull(isum.Entity, 'tItem') = 'tItem' -- nulls with tInvoiceSummary go with expenses
				AND   ISNULL(isum.EntityKey, 0) = #item.EntityKey
				), 0)
			where #item.Entity = 'tItem'

	end
	else
	begin
			update #item
			set    #item.Billed = 
			ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				inner join tInvoiceLine il (nolock) on inv.InvoiceKey = il.InvoiceKey
 				WHERE inv.CampaignKey = @CampaignKey
				AND   isum.Entity = 'tService'
				AND   il.EstimateKey = @EstimateKey 
				AND   ISNULL(isum.EntityKey, 0) = #item.EntityKey
				), 0)
			where #item.Entity = 'tService'

			update #item
			set    #item.Billed = 
			ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				inner join tInvoiceLine il (nolock) on inv.InvoiceKey = il.InvoiceKey
 				WHERE inv.CampaignKey = @CampaignKey
				AND   isnull(isum.Entity, 'tItem') = 'tItem' -- nulls with tInvoiceSummary go with expenses
				AND   il.EstimateKey = @EstimateKey 
				AND   ISNULL(isum.EntityKey, 0) = #item.EntityKey
				), 0)
			WHERE #item.Entity = 'tItem'
	end
				

	delete #item 
	where  EstHours = 0 And EstLabor = 0 And EstExpenses = 0 
	    And ActHours = 0 And ActLabor = 0 And ActExpenses = 0
		And Billed = 0
		
	if @LayoutKey = 0
	begin
		-- no layout, rely on WT display order then Item Name
		
		update #item 
		set    #item.DisplayOrder = @kNoItemDisplayOrder
		      ,#item.WorkTypeID = '[No Billing Item]'
			  ,#item.WorkTypeName = '[No Billing Item]'
			  ,#item.WorkTypeDescription = '[No Billing Item]'
				
		update #item
		set    #item.WorkTypeID = wt.WorkTypeID
			  ,#item.WorkTypeName = wt.WorkTypeName
			  ,#item.WorkTypeDescription = wt.Description
			  ,#item.DisplayOrder = isnull(wt.DisplayOrder, 0)
		from   tWorkType wt (nolock)
		where  #item.WorkTypeKey = wt.WorkTypeKey 

		-- Now update entity specific WorkTypeNames
		UPDATE	#item
		SET		#item.WorkTypeName = cust.Subject
				,#item.WorkTypeDescription = cust.Description
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#item.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = 'tCampaign'
		AND		cust.EntityKey = @CampaignKey

		-- the Display Order are null in tWorkType, so reorg by BI name
		declare @DisplayOrder int
		        ,@WorkTypeName varchar(250)
		        
		select @DisplayOrder = 1, @WorkTypeName = '' 
		while (1=1)
		begin
			select @WorkTypeName = min(WorkTypeName)
			from   #item
			where  WorkTypeName is not null
			and    WorkTypeName > @WorkTypeName
			and    DisplayOrder = 0
			
			if @WorkTypeName is null
				break
				
			update #item
			set    #item.DisplayOrder = @DisplayOrder
			where  WorkTypeName = @WorkTypeName
				
			select @DisplayOrder = @DisplayOrder + 1
		end
	
		/*
		select * 
		      ,0 As BillAmt
		      ,0 As Selected 
		from   #item 
		order by DisplayOrder, WorkTypeName, EntityName
		*/

	end
	else
	begin
		-- the items have been reorganized on the layout 
		update #item
		set    #item.WorkTypeKey = 0
	          ,#item.DisplayOrder = @kNoItemDisplayOrder
		      ,#item.WorkTypeID = '[No Billing Item]'
			  ,#item.WorkTypeName = '[No Billing Item]'
			  ,#item.WorkTypeDescription = '[No Billing Item]'
	           
	    update #item
		set    #item.WorkTypeKey = 0
		      ,#item.DisplayOrder = lb.LayoutOrder
		      ,#item.WorkTypeID = '[No Billing Item]'
			  ,#item.WorkTypeName = '[No Billing Item]'
			  ,#item.WorkTypeDescription = '[No Billing Item]'
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #item.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #item.EntityKey = lb.EntityKey
		and    lb.ParentEntity = 'tProject'
		       
		-- get WT key only when parent entity is tWorkType	
		update #item
		set    #item.WorkTypeKey = lb.ParentEntityKey
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #item.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #item.EntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tWorkType'
	

		update #item
		set    #item.WorkTypeID = wt.WorkTypeID
			  ,#item.WorkTypeName = wt.WorkTypeName
			  ,#item.WorkTypeDescription = wt.Description
		from   tWorkType wt (nolock)
		where  #item.WorkTypeKey = wt.WorkTypeKey 
		
		-- Now update entity specific WorkTypeNames
		UPDATE	#item
		SET		#item.WorkTypeName = cust.Subject
			   ,#item.WorkTypeDescription = cust.Description
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#item.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = 'tCampaign'
		AND		cust.EntityKey = @CampaignKey

		-- but always get the Layout Order
		update #item
		set    #item.DisplayOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #item.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #item.EntityKey = lb.EntityKey     				
	
		/*
		select * 
		      ,0 As BillAmt
		      ,0 As Selected 
		from #item 
		order by DisplayOrder, WorkTypeName, EntityName
		*/
	end
			
	update #item
	set    RootEntity = 'tCampaign'
	      ,RootEntityKey = @CampaignKey
			
	-- Output
    create table #line(
		LineKey INT IDENTITY(1,1)
		,ParentLineKey int null
		,LineSubject varchar(500) null
		,LineDescription text null
		,Entity varchar(50) null
		,EntityKey int null
		,WorkTypeKey int null
		
		,DisplayOrder int null
		,NewDisplayOrder int null
		,InvoiceOrder int null
		,DisplayOption int null
		,LineType int null

		,RootEntity varchar(50) null
		,RootEntityKey int null
		)
		
	exec spBillingLinesGroupByBillingItem @CompanyKey, @LayoutKey, 'tCampaign', @CampaignKey, 'tCampaign', @CampaignKey

	select #line.LineKey
			,#line.ParentLineKey
			,#line.LineSubject 
			,#line.LineDescription 
			,#line.Entity 
			,#line.EntityKey 
			,#line.WorkTypeKey 
		
			,#line.DisplayOrder  As OldDisplayOrder  -- for the CMHD in Flex
			,#line.NewDisplayOrder As DisplayOrder
			,#line.InvoiceOrder 
			,#line.DisplayOption 
			,#line.LineType 
			,#line.LineType - 1 as LineLevel 

			,#line.RootEntity 
			,#line.RootEntityKey 

	       ,#line.LineSubject as EntityName

	       ,isnull(EstHours, 0) as EstHours
		   ,isnull(EstLabor, 0) as EstLabor 
		   ,isnull(EstExpenses, 0) as EstExpenses
		   ,0 as EstTotal
		   	
		   ,isnull(ActHours, 0) as ActHours
		   ,isnull(ActLabor, 0) as ActLabor
		   ,isnull(ActExpenses, 0) as ActExpenses 
		   ,0 as ActTotal

		    ,isnull(Billed, 0) as Billed

	        ,0 as [Percent]
			,0 as BillAmt
		    ,0 as Remaining
		    ,0 as Selected
	
	from   #line
	left outer join #item on #line.Entity = #item.Entity and #line.EntityKey = #item.EntityKey
	order by InvoiceOrder
													
	RETURN 1
GO
