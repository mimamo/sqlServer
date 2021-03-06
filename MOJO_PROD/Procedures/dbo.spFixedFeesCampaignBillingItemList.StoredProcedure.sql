USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCampaignBillingItemList]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCampaignBillingItemList]
	(
	@CampaignKey int
	,@EstimateKey int = 0-- 0 = All
	)
AS	--Encrypt

  /*
  || When     Who Rel   What
  || 05/10/10 GHL 10.522 Creation for campaign FF billing
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */
  
	SET NOCOUNT ON
	
/*
There is a zero bucket when no billing items cannot be found
So we have a Union All to include the zero bucket
Calculation of estimate amounts:

Expenses
--------
Link through tItem.WorkTypeKey
tEstimateTaskExpense.ItemKey is NEVER NULL

tEstimateTaskExpense = WorkTypeKey buckets (when tItem.WorkTypeKey is not null) 
						+ zero bucket (when tItem.WorkTypeKey is null)
	
Labor
-----
Link through tService.WorkTypeKey
tEstimateTaskLabor.ServiceKey is NEVER NULL (cause estimates for campaigns are service only or segment/service)

tEstimateTaskLabor = BillingItem buckets (when ServiceKey is not null and tService.WorkTypeKey not null)
						+ zero bucket (tService.WorkTypeKey null)

*/

	DECLARE @kNoItemDisplayOrder INT SELECT @kNoItemDisplayOrder = 9999 -- At bottom, -1 At top

	DECLARE @CompanyKey INT
	       
	SELECT @CompanyKey = CompanyKey
	FROM   tCampaign (NOLOCK)
	WHERE  CampaignKey = @CampaignKey


	if @EstimateKey = 0
	
		select     'tWorkType'             AS Entity
		          ,wt.WorkTypeKey          AS EntityKey 
	              ,wt.WorkTypeID           AS EntityID
	              ,isnull(wtc.Subject, wt.WorkTypeName)     AS EntityName
	              ,isnull(wtc.Description, wt.Description)  AS EntityDescription
	              
	              ,ISNULL(wt.Taxable, 0)        AS Taxable
	              ,ISNULL(wt.Taxable2, 0)       AS Taxable2	 
		          ,isnull(wt.DisplayOrder, 0)   AS DisplayOrder

				, ISNULL((Select Sum(cebi.Qty + cebi.COQty) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tService s (nolock) on cebi.EntityKey = s.ServiceKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tService'
						and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)						
					As EstHours
		          
		         , ISNULL((Select Sum(cebi.Gross + cebi.COGross) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tService s (nolock) on cebi.EntityKey = s.ServiceKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tService'
						and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)						
					As EstLabor
			
				 , ISNULL((Select Sum(cebi.Gross + cebi.COGross) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tItem i (nolock) on cebi.EntityKey = i.ItemKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tItem'
						and isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey), 0)						
					As EstExpenses
							 
				-- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tItem i (nolock) on roll.EntityKey = i.ItemKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tItem'
					And   isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 			
					As ActExpenses
				
				-- Billed
				-- no estimate requested, take them all FF and TM
				-- We do it like spRptBillingItemSummary

				,ISNULL((Select Sum(il.TotalAmount) 
					 from tInvoiceLine il (nolock) 
					 inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
					 Where invc.CampaignKey = @CampaignKey 
					 And   ISNULL(il.WorkTypeKey, 0) = wt.WorkTypeKey 
					 And   il.BillFrom = 1				-- Fixed Fee Only = tInvoiceSummary is not reliable
					 ), 0)
				     
					+ ISNULL((SELECT Sum(isum.Amount) 
					from tInvoiceSummary isum (NOLOCK)
					inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
					inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
					inner join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
					WHERE inv.CampaignKey = @CampaignKey 
					And   il.BillFrom = 2              -- TM rely on tInvoiceSummary
					AND   isum.Entity = 'tService'
					AND   ISNULL(s.WorkTypeKey, 0) = wt.WorkTypeKey 
					), 0)
					 
					+ ISNULL((SELECT Sum(isum.Amount) 
					from tInvoiceSummary isum (NOLOCK)
					inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
					inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
					inner join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
					WHERE inv.CampaignKey = @CampaignKey 
					And   il.BillFrom = 2
					AND   isum.Entity = 'tItem'
					AND   ISNULL(i.WorkTypeKey, 0) = wt.WorkTypeKey 
					), 0)
				
					As Billed

				 ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
								 
		from    tWorkType wt (nolock)
		left outer join tWorkTypeCustom wtc (nolock) 
				on wt.WorkTypeKey = wtc.WorkTypeKey 
				and wtc.Entity = 'tCampaign' and wtc.EntityKey = @CampaignKey  
		where   wt.CompanyKey = @CompanyKey
	
		UNION ALL
		
		SELECT     'tWorkType'             AS Entity  
		          ,0                       AS EntityKey 
		          ,'[No Billing Item]'     AS EntityID 
		          ,'[No Billing Item]'     AS EntityName
		          ,'[No Billing Item]'     AS EntityDescription
		  
		          ,0                       AS Taxable
		          ,0                       AS Taxable2
		          ,@kNoItemDisplayOrder    AS DisplayOrder

				, ISNULL((Select Sum(cebi.Qty + cebi.COQty) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tService s (nolock) on cebi.EntityKey = s.ServiceKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tService'
						and isnull(s.WorkTypeKey, 0) = 0), 0)						
					As EstHours

		         , ISNULL((Select Sum(cebi.Gross + cebi.COGross) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tService s (nolock) on cebi.EntityKey = s.ServiceKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tService'
						and isnull(s.WorkTypeKey, 0) = 0), 0)						
					As EstLabor

				 , ISNULL((Select Sum(cebi.Gross + cebi.COGross) 
						from tCampaignEstByItem cebi  (nolock) 
							inner join tService s (nolock) on cebi.EntityKey = s.ServiceKey 
						Where cebi.CampaignKey = @CampaignKey
						and cebi.Entity = 'tItem'
						and isnull(s.WorkTypeKey, 0) = 0), 0)						
					As EstExpenses
				  
				  -- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = 0
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = 0
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tItem i (nolock) on roll.EntityKey = i.ItemKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tItem'
					And   isnull(i.WorkTypeKey, 0) = 0
					), 0) 			
					As ActExpenses

				,ISNULL((Select Sum(il.TotalAmount) 
					 from tInvoiceLine il (nolock) 
					 inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
					 Where invc.CampaignKey = @CampaignKey 
					 And   ISNULL(il.WorkTypeKey, 0) = 0 
					 And   il.BillFrom = 1				-- Fixed Fee Only = tInvoiceSummary is not reliable
					 ), 0)
				     
					+ ISNULL((SELECT Sum(isum.Amount) 
					from tInvoiceSummary isum (NOLOCK)
					inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
					inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
					inner join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
					WHERE inv.CampaignKey = @CampaignKey 
					And   il.BillFrom = 2              -- TM rely on tInvoiceSummary
					AND   isum.Entity = 'tService'
					AND   ISNULL(s.WorkTypeKey, 0) = 0 
					), 0)
					 
					+ ISNULL((SELECT Sum(isum.Amount) 
					from tInvoiceSummary isum (NOLOCK)
					inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
					inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
					left outer join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
					WHERE inv.CampaignKey = @CampaignKey 
					And   il.BillFrom = 2
					AND   isnull(isum.Entity, 'tItem') = 'tItem'
					AND   ISNULL(i.WorkTypeKey, 0) = 0 
					), 0)
				
					As Billed

			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
					        
		 ORDER BY DisplayOrder         	      
		 
	else
			-- we have an estimate
			
			select 'tWorkType'             AS Entity
		          ,wt.WorkTypeKey          AS EntityKey 
	              ,wt.WorkTypeID           AS EntityID
	              ,isnull(wtc.Subject, wt.WorkTypeName)     AS EntityName
	              ,isnull(wtc.Description, wt.Description)  AS EntityDescription
	              
	              ,ISNULL(wt.Taxable, 0)      AS Taxable
	              ,ISNULL(wt.Taxable2, 0)     AS Taxable2	 
		          ,ISNULL(wt.DisplayOrder, 0) AS DisplayOrder

				, ISNULL((Select Sum(etl.Hours) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)						
					As EstHours

				, ISNULL((Select Sum(Round(etl.Hours * etl.Rate, 2)) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)						
					As EstLabor
		          
		        ,ISNULL((
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
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
				Where e.CampaignKey = @CampaignKey
				and e.EstimateKey = @EstimateKey
				and e.Approved = 1
				and isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
				), 0)
				As EstExpenses

				-- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tItem i (nolock) on roll.EntityKey = i.ItemKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tItem'
					And   isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
					), 0) 			
					As ActExpenses
				  
				 -- estimate requested, we should only have EstimateKey on lines of type FF omly			
			
			    ,ISNULL((Select Sum(il.TotalAmount) 
					 from tInvoiceLine il (nolock) 
						inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
					 Where invc.CampaignKey = @CampaignKey 
					 And   il.EstimateKey = @EstimateKey
					 And   ISNULL(il.WorkTypeKey, 0) = wt.WorkTypeKey 
					 ), 0)

                 As Billed
				
			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
							   
		from    tWorkType wt (nolock)
		left outer join tWorkTypeCustom wtc (nolock) 
			on wt.WorkTypeKey = wtc.WorkTypeKey 
			and wtc.Entity = 'tCampaign' and wtc.EntityKey = @CampaignKey  
		where   wt.CompanyKey = @CompanyKey
	
		UNION ALL
		
		SELECT     'tWorkType'             AS Entity  
		          ,0                       AS EntityKey 
		          ,'[No Billing Item]'     AS EntityID 
		          ,'[No Billing Item]'     AS EntityName
		          ,'[No Billing Item]'     AS EntityDescription
		  
		          ,0                       AS Taxable
		          ,0                       AS Taxable2
		          ,@kNoItemDisplayOrder    AS DisplayOrder

				, ISNULL((Select Sum(etl.Hours) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and isnull(s.WorkTypeKey, 0) = 0), 0)						
					As EstHours

				, ISNULL((Select Sum(Round(etl.Hours * etl.Rate, 2)) 
						from tEstimateTaskLabor etl  (nolock) 
							inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
						Where e.CampaignKey = @CampaignKey
						and e.EstimateKey = @EstimateKey
						and e.Approved = 1
						and isnull(s.WorkTypeKey, 0) = 0), 0)						
					As EstLabor

		        ,ISNULL((
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
					inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
				Where e.CampaignKey = @CampaignKey
				and e.EstimateKey = @EstimateKey
				and e.Approved = 1
				and isnull(i.WorkTypeKey, 0) = 0
				), 0)
				As EstExpenses

				-- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = 0
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tService s (nolock) on roll.EntityKey = s.ServiceKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tService'
					And   isnull(s.WorkTypeKey, 0) = 0
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectItemRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
						inner join tItem i (nolock) on roll.EntityKey = i.ItemKey
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					And   roll.Entity = 'tItem'
					And   isnull(i.WorkTypeKey, 0) = 0
					), 0) 			
					As ActExpenses

			    ,ISNULL((Select Sum(il.TotalAmount) 
					 from tInvoiceLine il (nolock) 
						inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
					 Where invc.CampaignKey = @CampaignKey 
					 And   il.EstimateKey = @EstimateKey
					 And   ISNULL(il.WorkTypeKey, 0) = 0 
					 ), 0)
                  
                  As Billed
                   
			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
		          
		 ORDER BY DisplayOrder, EntityName         	      
		 
		
				          
	RETURN 1
GO
