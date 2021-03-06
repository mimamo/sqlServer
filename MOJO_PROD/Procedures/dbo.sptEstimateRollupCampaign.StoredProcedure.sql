USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateRollupCampaign]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateRollupCampaign]

	(
		@CampaignKey int
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 04/20/10 GHL 10.522 Creation for campaign estimates    
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))  
  || 01/14/13 GHL 10.564 (163923) Added contributions thru tEstimateProject
  || 03/05/15 GHL 10.590 Added support for titles for Abelson Taylor
  */
  
  if isnull(@CampaignKey, 0) = 0
	return 1
	
	declare @UseBillingTitles int
	select @UseBillingTitles = pref.UseBillingTitles
	from   tPreference pref (nolock)
		inner join tCampaign c (nolock) on c.CompanyKey = pref.CompanyKey
	where  c.CampaignKey = @CampaignKey
	select @UseBillingTitles = isnull(@UseBillingTitles, 0)

		-- Must check all estimates for a Campaign with ExternalStatus or ExternalStatus = 4 
	If Not Exists (Select 1
					From  tEstimate (nolock)
					Where CampaignKey = @CampaignKey
					And ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))
					)
		Begin
			Update tCampaignSegment
			Set EstHours = 0
			   ,EstLabor = 0
			   ,BudgetExpenses = 0
			   ,EstExpenses = 0
			   ,ApprovedCOHours = 0
			   ,ApprovedCOLabor = 0
			   ,ApprovedCOBudgetExp = 0
			   ,ApprovedCOExpense = 0
			   ,BudgetLabor = 0
			   ,ApprovedCOBudgetLabor = 0	
			   ,Contingency = 0		   
			Where CampaignKey = @CampaignKey

			Update tCampaign
			Set EstHours = 0
			   ,EstLabor = 0
			   ,BudgetExpenses = 0
			   ,EstExpenses = 0
			   ,ApprovedCOHours = 0
			   ,ApprovedCOLabor = 0
			   ,ApprovedCOBudgetExp = 0
			   ,ApprovedCOExpense = 0
			   ,Contingency = 0
			   ,BudgetLabor = 0
			   ,ApprovedCOBudgetLabor = 0
			   ,SalesTax = 0
			   ,ApprovedCOSalesTax = 0
			Where CampaignKey = @CampaignKey
			
			Delete tCampaignEstByItem Where CampaignKey = @CampaignKey
			
			Return 1   
		End				

	Update tCampaignSegment
	Set
		 EstHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				select sum(etl.Hours)
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)
			+
			ISNULL((
				select sum(et.Hours)
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)
		,BudgetLabor = 
			ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 0 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2))
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2))
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
		,EstLabor = ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 0 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2)) 
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)
		,BudgetExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 and ete.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(case 
											 when pe.ApprovedQty = 1 Then ete.TotalCost
											 when pe.ApprovedQty = 2 Then ete.TotalCost2
											 when pe.ApprovedQty = 3 Then ete.TotalCost3
											 when pe.ApprovedQty = 4 Then ete.TotalCost4
											 when pe.ApprovedQty = 5 Then ete.TotalCost5
											 when pe.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey
			inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   pe.EstType > 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
			+
			ISNULL((
			Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
		,EstExpenses =  ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 and ete.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
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
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   pe.EstType > 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
			+
			ISNULL((
			Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
		,ApprovedCOHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				select sum(etl.Hours)
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
			+
			ISNULL((
				select sum(et.Hours)
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)
		,ApprovedCOBudgetLabor = 
			ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 1 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2))
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2))
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
		,ApprovedCOLabor = ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2)) 
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			),0)
		,ApprovedCOBudgetExp = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and ete.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
			+
			ISNULL((
				Select Sum(case 
											 when pe.ApprovedQty = 1 Then ete.TotalCost
											 when pe.ApprovedQty = 2 Then ete.TotalCost2
											 when pe.ApprovedQty = 3 Then ete.TotalCost3
											 when pe.ApprovedQty = 4 Then ete.TotalCost4
											 when pe.ApprovedQty = 5 Then ete.TotalCost5
											 when pe.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey
			inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   pe.EstType > 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
			+
			ISNULL((
			Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
		,ApprovedCOExpense =  ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and ete.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)	
			+
			ISNULL((
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
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   pe.EstType > 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
			+
			ISNULL((
			Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)		
		,Contingency = ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * e.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and etl.CampaignSegmentKey = tCampaignSegment.CampaignSegmentKey), 0)
		+ ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * vea.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
			and   vea.Approved = 1
			and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)
		+ ISNULL((Select Sum((ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0)) * vea.Contingency / 100 ) 
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			inner join tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			where vea.CampaignKey = @CampaignKey
			and   vea.Approved = 1
			and   isnull(p.CampaignSegmentKey, 0) = tCampaignSegment.CampaignSegmentKey
			), 0)			
		Where
		CampaignKey = @CampaignKey
		
	Update tCampaign
	Set
		 EstHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0), 0)		
			+
			ISNULL((
				select sum(etl.Hours)
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)	
			+
			ISNULL((
				select sum(et.Hours)
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)	
		,BudgetLabor = 
			ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 0), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2))
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2))
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)	
		,EstLabor = ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 0), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2)) 
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
			),0)
		,BudgetExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0), 0)
			+
			ISNULL((
				Select Sum(case 
											 when pe.ApprovedQty = 1 Then ete.TotalCost
											 when pe.ApprovedQty = 2 Then ete.TotalCost2
											 when pe.ApprovedQty = 3 Then ete.TotalCost3
											 when pe.ApprovedQty = 4 Then ete.TotalCost4
											 when pe.ApprovedQty = 5 Then ete.TotalCost5
											 when pe.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey
			inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   pe.EstType > 1
			), 0)
			+
			ISNULL((
			Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
			), 0)
		,EstExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0), 0)
			+
			ISNULL((
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
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
				and   pe.EstType > 1
			), 0)
			+
			ISNULL((
			Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0
			), 0)
		,SalesTax = ISNULL((Select Sum(ISNULL(SalesTaxAmount,0) + ISNULL(SalesTax2Amount,0))
			from tEstimate e (nolock)
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and  e.ChangeOrder = 0), 0)
		,ApprovedCOHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
			+
			ISNULL((
				select sum(etl.Hours)
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)	
			+
			ISNULL((
				select sum(et.Hours)
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)
		,ApprovedCOBudgetLabor = 
			ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.ChangeOrder = 1), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2))
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2))
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)	
		,ApprovedCOLabor = ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
			+
			ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
				from   tEstimateTaskLabor etl (nolock)
				inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)	
			+
			ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2)) 
				from   tEstimateTask et (nolock)
				inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
			),0)
		,ApprovedCOExpense = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
			+
			ISNULL((
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
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   pe.EstType > 1
			), 0)
			+
			ISNULL((
			Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
			), 0)
		,ApprovedCOBudgetExp = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
			+
			ISNULL((
				Select Sum(case 
											 when pe.ApprovedQty = 1 Then ete.TotalCost
											 when pe.ApprovedQty = 2 Then ete.TotalCost2
											 when pe.ApprovedQty = 3 Then ete.TotalCost3
											 when pe.ApprovedQty = 4 Then ete.TotalCost4
											 when pe.ApprovedQty = 5 Then ete.TotalCost5
											 when pe.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey
			inner join tEstimate pe (nolock) on ep.ProjectEstimateKey = pe.EstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and   pe.EstType > 1
			), 0)
			+
			ISNULL((
			Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				where vea.CampaignKey = @CampaignKey
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
			), 0)
		,ApprovedCOSalesTax = ISNULL((Select Sum(ISNULL(SalesTaxAmount,0) + ISNULL(SalesTax2Amount,0))
			from tEstimate e (nolock)
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
		,Contingency = ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * e.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			), 0)
		+ ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * vea.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimateProject ep (nolock) on etl.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			where vea.CampaignKey = @CampaignKey
			and   vea.Approved = 1
			), 0)
		+ ISNULL((Select Sum((ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0)) * vea.Contingency / 100 ) 
			from tEstimateTask et  (nolock) 
			inner join tEstimateProject ep (nolock) on et.EstimateKey = ep.ProjectEstimateKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			where vea.CampaignKey = @CampaignKey
			and   vea.Approved = 1
			), 0)

	Where
		CampaignKey = @CampaignKey



	/*
							How to populate tCampaignEstByItem
	
	Entity = tItem			EstType = 1									EstType >1
	---------------------------------------------------------------------------------------------						
	Qty							0								tEstimateTaskExpense.Quantity
	
	Net				tEstimateTask.BudgetExpenses				tEstimateTaskExpense.TotalCost
	
	Gross			tEstimateTask.EstExpenses					tEstimateTaskExpense.BillableCost
																(based on tEstimate.ApprovedQty)
	
	Entity = tService		EstType = 1									EstType >1
	----------------------------------------------------------------------------------------------						
	Qty				tEstimateTask.Hours							tEstimateTaskLabor.Hours
	
	Net				tEstimateTask.Hours							tEstimateTaskLabor.Hours
					* tEstimateTask.Cost						* etl.Cost
																
	Gross			tEstimateTask.Hours							tEstimateTaskLabor.Hours
					* tEstimateTask.Rate						* etl.Rate
							OR
					tEstimateTask.EstLabor		
	
	Note: here we only have estimate by SERVICE ONLY (type 4) or SEGMENT/SERVICE (type 5)	
		  + BY PROJECT (type 6)		
	*/

	DELETE tCampaignEstByItem 
	WHERE CampaignKey = @CampaignKey 
	
	/* Old Query
	-- Sum records from tEstimateTaskExpense
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT DISTINCT @CampaignKey, ISNULL(ete.CampaignSegmentKey, 0), 'tItem', ISNULL(ete.ItemKey, 0), 0, 0, 0, 0, 0, 0
	FROM   vEstimateApproved e (nolock)
		INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON e.EstimateKey = ete.EstimateKey
	WHERE  e.Approved = 1
	AND    e.CampaignKey = @CampaignKey    
	*/

	-- Sum records from tEstimateTaskExpense
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT DISTINCT @CampaignKey, ISNULL(expenses.CampaignSegmentKey, 0), 'tItem', ISNULL(expenses.ItemKey, 0), 0, 0, 0, 0, 0, 0
	FROM	
		(
		SELECT ISNULL(ete.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(ete.ItemKey, 0) as ItemKey
		FROM   vEstimateApproved e (nolock)
			INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON e.EstimateKey = ete.EstimateKey
		WHERE  e.Approved = 1
		AND    e.CampaignKey = @CampaignKey    
		UNION
		SELECT ISNULL(p.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(ete.ItemKey, 0) as ItemKey
		FROM   vEstimateApproved e (nolock)
			INNER JOIN tEstimateProject ep (nolock) on e.EstimateKey = ep.EstimateKey
			INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON ep.ProjectEstimateKey = ete.EstimateKey
			INNER JOIN tProject p (nolock) on ep.ProjectKey = p.ProjectKey
		WHERE  e.Approved = 1
		AND    e.CampaignKey = @CampaignKey    
		) as expenses

	-- cleanup the recs with no items
	delete tCampaignEstByItem
	where  CampaignKey =@CampaignKey
	and    Entity = 'tItem' and EntityKey = 0

	-- CSKey = 0, ItemKey =0
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	values (@CampaignKey, 0, 'tItem', 0, 0, 0, 0, 0, 0, 0)

	-- CSKey > 0, ItemKey >0
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	select @CampaignKey, CampaignSegmentKey, 'tItem', 0, 0, 0, 0, 0, 0, 0
	from   tCampaignSegment (nolock)
	where  CampaignKey =@CampaignKey

	UPDATE tCampaignEstByItem  
	SET    
		tCampaignEstByItem.Qty = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and e.InternalStatus = 4)) 
			and e.ChangeOrder = 0 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Net = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.TotalCost
							when e.ApprovedQty = 2 Then ete.TotalCost2
							when e.ApprovedQty = 3 Then ete.TotalCost3
							when e.ApprovedQty = 4 Then ete.TotalCost4
							when e.ApprovedQty = 5 Then ete.TotalCost5
							when e.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Gross = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COQty = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)			 
		,tCampaignEstByItem.CONet = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.TotalCost
							when e.ApprovedQty = 2 Then ete.TotalCost2
							when e.ApprovedQty = 3 Then ete.TotalCost3
							when e.ApprovedQty = 4 Then ete.TotalCost4
							when e.ApprovedQty = 5 Then ete.TotalCost5
							when e.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		 ,tCampaignEstByItem.COGross = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(ete.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 			
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tItem'

	-- Now consider the tEstimateProject records
	UPDATE tCampaignEstByItem  
	SET    
		tCampaignEstByItem.Qty = isnull(tCampaignEstByItem.Qty, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.Quantity
							when pe.ApprovedQty = 2 Then ete.Quantity2
							when pe.ApprovedQty = 3 Then ete.Quantity3
							when pe.ApprovedQty = 4 Then ete.Quantity4
							when pe.ApprovedQty = 5 Then ete.Quantity5
							when pe.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Net = isnull(tCampaignEstByItem.Net, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.TotalCost
							when pe.ApprovedQty = 2 Then ete.TotalCost2
							when pe.ApprovedQty = 3 Then ete.TotalCost3
							when pe.ApprovedQty = 4 Then ete.TotalCost4
							when pe.ApprovedQty = 5 Then ete.TotalCost5
							when pe.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Gross = isnull(tCampaignEstByItem.Gross, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.BillableCost
							when pe.ApprovedQty = 2 Then ete.BillableCost2
							when pe.ApprovedQty = 3 Then ete.BillableCost3
							when pe.ApprovedQty = 4 Then ete.BillableCost4
							when pe.ApprovedQty = 5 Then ete.BillableCost5
							when pe.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COQty = isnull(tCampaignEstByItem.COQty, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.Quantity
							when pe.ApprovedQty = 2 Then ete.Quantity2
							when pe.ApprovedQty = 3 Then ete.Quantity3
							when pe.ApprovedQty = 4 Then ete.Quantity4
							when pe.ApprovedQty = 5 Then ete.Quantity5
							when pe.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)			 
		,tCampaignEstByItem.CONet = isnull(tCampaignEstByItem.CONet, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.TotalCost
							when pe.ApprovedQty = 2 Then ete.TotalCost2
							when pe.ApprovedQty = 3 Then ete.TotalCost3
							when pe.ApprovedQty = 4 Then ete.TotalCost4
							when pe.ApprovedQty = 5 Then ete.TotalCost5
							when pe.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		 ,tCampaignEstByItem.COGross = isnull(tCampaignEstByItem.COGross, 0)
			+ ISNULL((Select Sum(case 
							when pe.ApprovedQty = 1 Then ete.BillableCost
							when pe.ApprovedQty = 2 Then ete.BillableCost2
							when pe.ApprovedQty = 3 Then ete.BillableCost3
							when pe.ApprovedQty = 4 Then ete.BillableCost4
							when pe.ApprovedQty = 5 Then ete.BillableCost5
							when pe.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
			inner join tEstimate pe (nolock) on ete.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(ete.ItemKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 			
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tItem'

	-- Now add records from tEstimateTask when EstType = 1 to the ItemKey = 0 bucket 
	
	UPDATE tCampaignEstByItem
	SET    
		tCampaignEstByItem.Net = isnull(tCampaignEstByItem.Net, 0) + ISNULL((Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Gross = isnull(tCampaignEstByItem.Gross, 0) + ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.CONet = isnull(tCampaignEstByItem.CONet, 0) + ISNULL((Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COGross = isnull(tCampaignEstByItem.COGross, 0) + ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tItem'
	AND   tCampaignEstByItem.EntityKey = 0


	-- Sum the records from tEstimateTaskLabor 	
	/* Old query
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT DISTINCT @CampaignKey, ISNULL(etl.CampaignSegmentKey, 0), 'tService', ISNULL(etl.ServiceKey, 0), 0, 0, 0, 0, 0, 0
	FROM   vEstimateApproved e (nolock)
		INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
	WHERE  e.Approved = 1
	AND    e.CampaignKey = @CampaignKey    
    AND    etl.Hours * etl.Rate > 0
	*/
  
  INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
  SELECT DISTINCT @CampaignKey, ISNULL(labor.CampaignSegmentKey, 0), 'tService', ISNULL(labor.ServiceKey, 0), 0, 0, 0, 0, 0, 0
	FROM	
		(
		SELECT ISNULL(etl.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(etl.ServiceKey, 0) as ServiceKey
		FROM   vEstimateApproved e (nolock)
			INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
		WHERE  e.Approved = 1
		AND    e.CampaignKey = @CampaignKey    
		AND    etl.Hours * etl.Rate > 0
		UNION
		SELECT ISNULL(p.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(etl.ServiceKey, 0) as ServiceKey
		FROM   vEstimateApproved e (nolock)
			INNER JOIN tEstimateProject ep (nolock) on e.EstimateKey = ep.EstimateKey
			INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON ep.ProjectEstimateKey = etl.EstimateKey
			INNER JOIN tProject p (nolock) on ep.ProjectKey = p.ProjectKey
		WHERE  e.Approved = 1
		AND    e.CampaignKey = @CampaignKey    
		AND    etl.Hours * etl.Rate > 0
		) as labor

	-- cleanup the recs with no items
	delete tCampaignEstByItem
	where  CampaignKey =@CampaignKey
	and    Entity = 'tService' and EntityKey = 0

	-- CSKey = 0, ServiceKey =0
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	values (@CampaignKey, 0, 'tService', 0, 0, 0, 0, 0, 0, 0)

	-- CSKey > 0, ServiceKey >0
	INSERT tCampaignEstByItem (CampaignKey, CampaignSegmentKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	select @CampaignKey, CampaignSegmentKey, 'tService', 0, 0, 0, 0, 0, 0, 0
	from   tCampaignSegment (nolock)
	where  CampaignKey =@CampaignKey
	  
	UPDATE tCampaignEstByItem
	SET    
		tCampaignEstByItem.Qty = isnull((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
		,tCampaignEstByItem.Net = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
		,tCampaignEstByItem.Gross = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 0 and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COQty = isnull((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
		,tCampaignEstByItem.CONet = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
		,tCampaignEstByItem.COGross = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.CampaignKey = @CampaignKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tService'

	-- Now consider the tEstimateProject records

	UPDATE tCampaignEstByItem  
	SET    
		tCampaignEstByItem.Qty = isnull(tCampaignEstByItem.Qty, 0)
			+ ISNULL((
			Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Net = isnull(tCampaignEstByItem.Net, 0)
			+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Gross = isnull(tCampaignEstByItem.Gross, 0)
			+ ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COQty = isnull(tCampaignEstByItem.COQty, 0)
			+ ISNULL((
			Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.CONet = isnull(tCampaignEstByItem.CONet, 0)
			+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COGross = isnull(tCampaignEstByItem.COGross, 0)
			+ ISNULL((
				Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and   pe.EstType > 1
			and isnull(etl.ServiceKey, 0) = tCampaignEstByItem.EntityKey
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		 			
		
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tService'

	-- Now add records from tEstimateTask when EstType = 1 to the ServiceKey = 0 bucket 
	
	UPDATE tCampaignEstByItem
	SET    
		tCampaignEstByItem.Net = isnull(tCampaignEstByItem.Net, 0) 
		+ ISNULL((
			Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.Gross = isnull(tCampaignEstByItem.Gross, 0) + ISNULL((
			Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2)) 
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 0 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
		,tCampaignEstByItem.CONet = isnull(tCampaignEstByItem.CONet, 0) + ISNULL((
			Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1 
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0) 
		,tCampaignEstByItem.COGross = isnull(tCampaignEstByItem.COGross, 0) + ISNULL((
			Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2)) 
			from tEstimateTask et  (nolock) 
			inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
			inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
			inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
			inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
			Where vea.CampaignKey = @CampaignKey 
			and   vea.Approved = 1
			and   vea.ChangeOrder = 1
			and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByItem.CampaignSegmentKey
			), 0)
	Where tCampaignEstByItem.CampaignKey = @CampaignKey 
	AND   tCampaignEstByItem.Entity = 'tService'
	AND   tCampaignEstByItem.EntityKey = 0

---- Titles

if @UseBillingTitles = 1
begin

	DELETE tCampaignEstByTitle 
	WHERE CampaignKey = @CampaignKey 


	INSERT tCampaignEstByTitle (CampaignKey, CampaignSegmentKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
	  SELECT DISTINCT @CampaignKey, ISNULL(labor.CampaignSegmentKey, 0), ISNULL(labor.TitleKey, 0), 0, 0, 0, 0, 0, 0
		FROM	
			(
			SELECT ISNULL(etl.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(etl.TitleKey, 0) as TitleKey
			FROM   vEstimateApproved e (nolock)
				INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
			WHERE  e.Approved = 1
			AND    e.CampaignKey = @CampaignKey    
			AND    etl.Hours * etl.Rate > 0
			UNION
			SELECT ISNULL(p.CampaignSegmentKey, 0) as CampaignSegmentKey, ISNULL(etl.TitleKey, 0) as TitleKey
			FROM   vEstimateApproved e (nolock)
				INNER JOIN tEstimateProject ep (nolock) on e.EstimateKey = ep.EstimateKey
				INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON ep.ProjectEstimateKey = etl.EstimateKey
				INNER JOIN tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			WHERE  e.Approved = 1
			AND    e.CampaignKey = @CampaignKey    
			AND    etl.Hours * etl.Rate > 0
			) as labor


	-- cleanup the recs with no titles
		delete tCampaignEstByTitle
		where  CampaignKey =@CampaignKey
		and    TitleKey = 0

		-- CSKey = 0, TitleKey =0
		INSERT tCampaignEstByTitle (CampaignKey, CampaignSegmentKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
		values (@CampaignKey, 0, 0, 0, 0, 0, 0, 0, 0)

		-- CSKey > 0, TitleKey=0
		INSERT tCampaignEstByTitle (CampaignKey, CampaignSegmentKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
		select @CampaignKey, CampaignSegmentKey, 0, 0, 0, 0, 0, 0, 0
		from   tCampaignSegment (nolock)
		where  CampaignKey =@CampaignKey

		-- First update the records not linked to other projects (tEstimateProjects)
		UPDATE tCampaignEstByTitle
		SET    
			tCampaignEstByTitle.Qty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey 
				and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
			,tCampaignEstByTitle.Net = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey 
				and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
			,tCampaignEstByTitle.Gross = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COQty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey 
				and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
			,tCampaignEstByTitle.CONet = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey 
				and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
			,tCampaignEstByTitle.COGross = isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.CampaignKey = @CampaignKey 
				and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(etl.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
		Where tCampaignEstByTitle.CampaignKey = @CampaignKey 
	

		-- Now consider the tEstimateProject records

		-- EstType > 1 and UseTitle = 0, use tEstimateTaskLabor
		UPDATE tCampaignEstByTitle  
		SET    
			tCampaignEstByTitle.Qty = isnull(tCampaignEstByTitle.Qty, 0)
				+ ISNULL((
				Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.Net = isnull(tCampaignEstByTitle.Net, 0)
				+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.Gross = isnull(tCampaignEstByTitle.Gross, 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COQty = isnull(tCampaignEstByTitle.COQty, 0)
				+ ISNULL((
				Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.CONet = isnull(tCampaignEstByTitle.CONet, 0)
				+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COGross = isnull(tCampaignEstByTitle.COGross, 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
				from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 0 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 	
		Where tCampaignEstByTitle.CampaignKey = @CampaignKey 


		-- EstType > 1 and UseTitle = 1, use tEstimateTaskLaborTitle
		UPDATE tCampaignEstByTitle  
		SET    
			tCampaignEstByTitle.Qty = isnull(tCampaignEstByTitle.Qty, 0)
				+ ISNULL((
				Select Sum(etl.Hours) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.Net = isnull(tCampaignEstByTitle.Net, 0)
				+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.Gross = isnull(tCampaignEstByTitle.Gross, 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COQty = isnull(tCampaignEstByTitle.COQty, 0)
				+ ISNULL((
				Select Sum(etl.Hours) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.CONet = isnull(tCampaignEstByTitle.CONet, 0)
				+ ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COGross = isnull(tCampaignEstByTitle.COGross, 0)
				+ ISNULL((
					Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
				from tEstimateTaskLaborTitle etl  (nolock) 
				inner join tEstimate pe (nolock) on etl.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and   pe.EstType > 1
				and   isnull(pe.UseTitle, 0) = 1 
				and isnull(etl.TitleKey, 0) = tCampaignEstByTitle.TitleKey
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 	
		Where tCampaignEstByTitle.CampaignKey = @CampaignKey 
	

		-- Now add records from tEstimateTask when EstType = 1 to the TitleKey = 0 bucket 
	
		UPDATE tCampaignEstByTitle
		SET    
			tCampaignEstByTitle.Net = isnull(tCampaignEstByTitle.Net, 0) 
			+ ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
				from tEstimateTask et  (nolock) 
				inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.Gross = isnull(tCampaignEstByTitle.Gross, 0) + ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2)) 
				from tEstimateTask et  (nolock) 
				inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 0 
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
			,tCampaignEstByTitle.CONet = isnull(tCampaignEstByTitle.CONet, 0) + ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
				from tEstimateTask et  (nolock) 
				inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1 
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0) 
			,tCampaignEstByTitle.COGross = isnull(tCampaignEstByTitle.COGross, 0) + ISNULL((
				Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2)) 
				from tEstimateTask et  (nolock) 
				inner join tEstimate pe (nolock) on et.EstimateKey = pe.EstimateKey
				inner join tEstimateProject ep (nolock) on pe.EstimateKey = ep.ProjectEstimateKey
				inner join tProject p (nolock) on ep.ProjectKey =p.ProjectKey
				inner join vEstimateApproved vea (nolock) on ep.EstimateKey = vea.EstimateKey
				Where vea.CampaignKey = @CampaignKey 
				and   vea.Approved = 1
				and   vea.ChangeOrder = 1
				and isnull(p.CampaignSegmentKey, 0) = tCampaignEstByTitle.CampaignSegmentKey
				), 0)
		Where tCampaignEstByTitle.CampaignKey = @CampaignKey 
		AND   tCampaignEstByTitle.TitleKey = 0

		delete tCampaignEstByTitle
		where  CampaignKey = @CampaignKey
		and    isnull(Qty, 0) = 0
		and    isnull(Net, 0) = 0
		and    isnull(Gross, 0) = 0
		and    isnull(COQty, 0) = 0
		and    isnull(CONet, 0) = 0
		and    isnull(COGross, 0) = 0

end -- if UseBillingTitles = 1

	delete tCampaignEstByItem
	where  CampaignKey = @CampaignKey
	and    isnull(Qty, 0) = 0
	and    isnull(Net, 0) = 0
	and    isnull(Gross, 0) = 0
	and    isnull(COQty, 0) = 0
	and    isnull(CONet, 0) = 0
	and    isnull(COGross, 0) = 0

	  
RETURN 1
GO
