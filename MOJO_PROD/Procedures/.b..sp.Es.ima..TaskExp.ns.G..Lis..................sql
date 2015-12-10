USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseGetList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseGetList]

	@EstimateKey int


AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/16/07 GHL 8.4   Added ApprovedBillableCost to show on estimate_expense_to_quote_popup
  || 12/16/09 GHL 10.515 Added TaskName/ItemName/ProjectNumber for task/item lookup in flex     
  || 12/18/09 GHL 10.515 Added fields required for ItemAreaCalc customization      
  || 02/02/10 GHL 10.518 Added DisplayOrder     
  || 04/26/12 GHL 10.555 (141612) Correcting now Taxable Taxable1 when By Task Only
  || 05/23/12 GHL 10.556 Since there is a new col tQuote.EstimateKey, we must specify
  ||                     ete.EstimateKey to lift ambiguity
  || 05/23/12 GHL 10.556 (144572) Added MarkupAmount fields = BillableCost - TotalCost
  || 07/11/14 GHL 10.582 (220671) Added PODBillableCost/PODCount, now a expense line can be linked to several PODs
  ||                     These are used on the Create PO action popup to let users know how many PO were created
  ||                     and how much
  */
  
Declare @ProjectKey int
        ,@ProjectNumber varchar(250)
        ,@ApprovedQty int
		,@EstType int

		Select @ProjectKey = e.ProjectKey
		       ,@ProjectNumber = p.ProjectNumber
			   ,@ApprovedQty = e.ApprovedQty 
			   ,@EstType = e.EstType
		from   tEstimate e (nolock) 
			left outer join tProject p (nolock) on e.ProjectKey = p.ProjectKey
		Where  e.EstimateKey = @EstimateKey
		
		-- If by Task only, correct the tax flags
		if @EstType = 1 And @EstimateKey > 0
			update tEstimateTaskExpense
			set    tEstimateTaskExpense.Taxable = t.Taxable
			      ,tEstimateTaskExpense.Taxable2 = t.Taxable2
			from   tTask t (nolock)
			where  tEstimateTaskExpense.EstimateKey = @EstimateKey
			and    tEstimateTaskExpense.TaskKey = t.TaskKey


		SELECT ete.*
			,t.TaskID
			,t.TaskName
			,pod.PurchaseOrderKey
			,po.PurchaseOrderNumber
			,qd.QuoteKey
			,q.QuoteNumber
			,c.VendorID
			,c.CompanyName as VendorName
			,cl.ClassID
			,cl.ClassName 
			,i.ItemID
			,i.ItemName
			,i.ItemType
			,isnull(i.CalcAsArea, 0) as CalcAsArea 
			,isnull(i.MinAmount, 0) as MinAmount
			,isnull(i.ConversionMultiplier, 0) as DefaultMult -- because of ete.ConversionMultiplier
			,isnull(i.UnitCost, 0) AS ItemUnitCost
			,isnull(i.UnitRate, 0) AS ItemUnitRate
			,@ProjectKey as ProjectKey
			,@ProjectNumber as ProjectNumber
			,case
				when @ApprovedQty = 1 then ete.BillableCost 
				when @ApprovedQty = 2 then ete.BillableCost2 
				when @ApprovedQty = 3 then ete.BillableCost3 
				when @ApprovedQty = 4 then ete.BillableCost4 
				when @ApprovedQty = 5 then ete.BillableCost5 
				when @ApprovedQty = 6 then ete.BillableCost6 
				else ete.BillableCost
			end as ApprovedBillableCost
			,ete.TaskKey as OldTaskKey
			,isnull(ete.BillableCost, 0) - isnull(ete.TotalCost, 0) as MarkupAmount
			,isnull(ete.BillableCost2, 0) - isnull(ete.TotalCost2, 0) as MarkupAmount2
			,isnull(ete.BillableCost3, 0) - isnull(ete.TotalCost3, 0) as MarkupAmount3
			,isnull(ete.BillableCost4, 0) - isnull(ete.TotalCost4, 0) as MarkupAmount4
			,isnull(ete.BillableCost5, 0) - isnull(ete.TotalCost5, 0) as MarkupAmount5
			,isnull(ete.BillableCost6, 0) - isnull(ete.TotalCost6, 0) as MarkupAmount6
			 
			,(
				select sum(pod2.BillableCost)
				from   tPurchaseOrderDetail pod2 (nolock)
					inner join tEstimateTaskExpenseOrder eteo (nolock) on eteo.PurchaseOrderDetailKey = pod2.PurchaseOrderDetailKey
				where eteo.EstimateTaskExpenseKey = ete.EstimateTaskExpenseKey 
			) as PODBillableCost

			,(
				select count(eteo.PurchaseOrderDetailKey)
				from tEstimateTaskExpenseOrder eteo (nolock) 
				where eteo.EstimateTaskExpenseKey = ete.EstimateTaskExpenseKey 
			) as PODCount

		FROM tEstimateTaskExpense ete (nolock)
			LEFT OUTER JOIN tTask t (nolock) on ete.TaskKey = t.TaskKey
			LEFT OUTER JOIN tPurchaseOrderDetail pod (nolock) on ete.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			LEFT OUTER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			LEFT OUTER JOIN tQuoteDetail qd (nolock) on ete.QuoteDetailKey = qd.QuoteDetailKey
			LEFT OUTER JOIN tQuote q (nolock) on qd.QuoteKey = q.QuoteKey
			left outer join tCompany c (nolock) on ete.VendorKey = c.CompanyKey
			left outer join tClass cl (nolock) on ete.ClassKey = cl.ClassKey
			left outer join tItem i (nolock) on ete.ItemKey = i.ItemKey
			left outer join tCampaignSegment cs (nolock) on ete.CampaignSegmentKey = cs.CampaignSegmentKey
		WHERE
			ete.EstimateKey = @EstimateKey
		Order By cs.DisplayOrder, ete.DisplayOrder, t.TaskID, ete.EstimateTaskExpenseKey

	RETURN 1
GO
