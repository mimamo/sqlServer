USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCampaignSegmentList]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCampaignSegmentList]
	(
	@CampaignKey int
	,@EstimateKey int = 0 -- 0 = All
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/10/10 GHL 10.522 Creation for campaign FF billing
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  || 01/14/13 GHL 10.564 (163923) Added contributions thru tEstimateProject
  */
  
	SET NOCOUNT ON

	DECLARE @kNoItemDisplayOrder INT SELECT @kNoItemDisplayOrder = 9999 -- At bottom, -1 At top

	if @EstimateKey = 0
		
		select  'tCampaignSegment'				as Entity
		        ,cs.CampaignSegmentKey          as EntityKey
		        ,NULL                           as	EntityID
		        ,cs.SegmentName					as	EntityName
                ,cs.SegmentDescription			as	EntityDescription
                ,cs.DisplayOrder                as  DisplayOrder
                
                -- Amounts of ALL Estimates are already on tCampaignSegment
                ,isnull(cs.EstHours, 0) + isnull(cs.ApprovedCOHours, 0)			as EstHours
                ,isnull(cs.EstLabor, 0) + isnull(cs.ApprovedCOLabor, 0)			as EstLabor 
                ,isnull(cs.EstExpenses, 0) + isnull(cs.ApprovedCOExpense, 0)	as EstExpenses 
                 
                -- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 			
					As ActExpenses
			 
				 -- Billed	
				 ,ISNULL((
				  select sum(il.TotalAmount) 
				  from tInvoiceLine il (nolock) 
				      inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
				  where i.CampaignKey = @CampaignKey
				  and   il.CampaignSegmentKey = cs.CampaignSegmentKey   
				  ), 0) 			
					As Billed
				
			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
				 ,2 As LineType -- detail

		from    tCampaignSegment cs (nolock)
		where   cs.CampaignKey = @CampaignKey
        
		/*
		UNION ALL
		
				select  'tCampaignSegment'				as Entity
		        ,0                                      as EntityKey
		        ,'[No Segment]'                         as EntityID
		        ,'[No Segment]'					        as EntityName
                ,'[No Segment]'			                as EntityDescription
                ,@kNoItemDisplayOrder                   as DisplayOrder
                
                -- ALL estimates should have a segment, so return 0 here
                ,0                                      as EstHours
                ,0                                      as EstLabor 
                ,0                                      as EstExpenses 
                 
                -- Actuals
                ,ISNULL((select sum(roll.Hours) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignKey, 0) = @CampaignKey
					and   isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 			
					As ActExpenses
			 
				 -- Billed	
				 ,ISNULL((
				  select sum(il.TotalAmount) 
				  from tInvoiceLine il (nolock) 
				      inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
				  where i.CampaignKey = @CampaignKey
				  and   isnull(il.CampaignSegmentKey, 0) = 0   
				  ), 0) 			
					As Billed
					 
			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
		*/

		order by DisplayOrder
	
	else
	
		select  'tCampaignSegment'				as Entity
		        ,cs.CampaignSegmentKey          as EntityKey
		        ,NULL                           as	EntityID
		        ,cs.SegmentName					as	EntityName
                ,cs.SegmentDescription			as	EntityDescription
                ,cs.DisplayOrder                as  DisplayOrder
                
                -- Amounts on Estimates 
                , ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl  (nolock) 
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and isnull(etl.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0)
				   + ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl  (nolock) 
						inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
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
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0)
					As EstHours
                
				, ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
					from tEstimateTaskLabor etl  (nolock) 
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and isnull(etl.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
					from tEstimateTaskLabor etl  (nolock) 
						inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2))
					from tEstimateTask et  (nolock) 
						inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey 
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0)
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
				Where e.CampaignKey = @CampaignKey
				and e.EstimateKey = @EstimateKey
				and e.Approved = 1
				and isnull(ete.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
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
						inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
						inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
						inner join vEstimateApproved e (nolock) on ep.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.EstimateKey = @EstimateKey
					and e.Approved = 1
					and pe.EstType > 1
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
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
					and isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
				), 0)
				As EstExpenses
                 
                -- Actuals ...not by estimates 
                ,ISNULL((select sum(roll.Hours) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = cs.CampaignSegmentKey
					), 0) 			
					As ActExpenses
			 
				 -- Billed	
				 ,ISNULL((
				  select sum(il.TotalAmount) 
				  from tInvoiceLine il (nolock) 
				      inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
				  where i.CampaignKey = @CampaignKey
				  and   il.CampaignSegmentKey = cs.CampaignSegmentKey 
				  and   il.EstimateKey = @EstimateKey   
				  ), 0) 			
					As Billed

                 ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
				 ,2 As LineType -- detail
					 
		from    tCampaignSegment cs (nolock)
		where   cs.CampaignKey = @CampaignKey
		
		/*
		UNION ALL
		
				select  'tCampaignSegment'				as Entity
		        ,0                                      as EntityKey
		        ,'[No Segment]'                         as EntityID
		        ,'[No Segment]'					        as EntityName
                ,'[No Segment]'			                as EntityDescription
                ,@kNoItemDisplayOrder                   as DisplayOrder
                
                -- ALL estimates should have a segment, so return 0 here
                ,0                                      as EstHours
                ,0                                      as EstLabor 
                ,0                                      as EstExpenses 
                 
                -- Actuals
                ,ISNULL((select sum(roll.Hours) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 
					As ActHours
		
				,ISNULL((select sum(roll.LaborGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 			
					As ActLabor

				 ,ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectRollup roll (nolock)
						inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey 
					Where isnull(p.CampaignSegmentKey, 0) = 0
					), 0) 			
					As ActExpenses
			 
				 -- Billed	
				 ,ISNULL((
				  select sum(il.TotalAmount) 
				  from tInvoiceLine il (nolock) 
				      inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
				  where i.CampaignKey = @CampaignKey
				  and   isnull(il.CampaignSegmentKey, 0) = 0   
				  and   isnull(il.EstimateKey, 0) = @EstimateKey
				  ), 0) 			
					As Billed

			     ,0 As [Percent]
			     ,0 As BillAmt
		         ,0 As Selected 
		*/
					 		
		order by DisplayOrder

			
	RETURN 1
GO
