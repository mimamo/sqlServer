USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWIPAnalysisProjectDetail]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWIPAnalysisProjectDetail]
	(
		@CompanyKey INT			-- required
		,@ProjectKey INT		-- can be 0/NULL
		,@AsOfDate DATETIME		-- required
		,@TranType VARCHAR(20)	-- 'Labor', 'Production Expenses', 'Media Expenses', 'Other Expenses'
		,@Entity varchar(20)	-- 'tTime', 'tVoucherDetail', 'tMiscCost', 'tJournalEntryDetail', 'tTransaction' 
		,@StartAgingDate DATETIME = NULL		
		,@EndAgingDate DATETIME	= NULL	
		,@WIPAging int	= 0	
		
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 08/27/07 GHL 8.5  Creation for new WIP analysis report     
  || 11/09/07 GHL 8.5  Added voucher details posted before 85
  || 12/20/08 GWG 10.015 Removed a restriction on the exp report / voucher part where it was restricting on expense reports for a company.
						 It is possible to have a voucher with an item type 3 that would post in here.
  || 10/27/10 RLB 10.357 Changes Added for the WIP Aging Drill down on WIP Analysis Report
  || 11/11/10 RLB 10.358 Added Media Estimate ID  Media Expenses
  || 01/06/14 GHL 10.576 Converted to home currency
  || 02/25/15 GHL 10.589 Since we allow for the editing of transactions after posting to WIP (in Billing WS)
  ||                     Set Gross = WIPAmount rather than trying to recalculate
  || 02/26/15 WDF 10.589 (Abelson Taylor) Added Billing Title
  */	

-- Get Default Accounts
Declare @WIPLaborAssetAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare @WIPMediaAssetAccountKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPAssetAccountKey int

Select
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

		
	IF @TranType = 'Labor'
	BEGIN
		SELECT @WIPAssetAccountKey = @WIPLaborAssetAccountKey
		
		IF @Entity = 'tTime'

			IF @WIPAging = 1

				IF @StartAgingDate = @EndAgingDate

					BEGIN
						select t.TimeKey
							,t.TimeSheetKey
							,t.WorkDate
							,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
							,t.ActualHours
							,ROUND(t.ActualRate * t.ExchangeRate, 2) as ActualRate
							--,ROUND(ROUND(t.ActualHours * t.ActualRate,2) * t.ExchangeRate, 2)  As TotalGross
							,t.WIPAmount as TotalGross
							,ti.TitleID
							,ta.TaskName
							,s.Description AS ServiceDescription
						from tWIPPosting wp (NOLOCK)
							inner join tTime t (NOLOCK) on wp.WIPPostingKey = t.WIPPostingInKey 
							inner join tTimeSheet ts (NOLOCK) on t.TimeSheetKey = ts.TimeSheetKey
							inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
							left join tTask ta (NOLOCK) on t.TaskKey = ta.TaskKey
							left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
							left join tTitle ti (NOLOCK) on t.TitleKey = ti.TitleKey
							--left outer join tWIPPosting wpo (nolock) on t.WIPPostingOutKey = wpo.WIPPostingKey
						Where t.WorkDate < @EndAgingDate
						And   wp.CompanyKey = @CompanyKey
						And   isnull(t.ProjectKey,0) = isnull(@ProjectKey, 0)
						Order By t.WorkDate
		
						RETURN 1
					END	
				Else
						BEGIN
						select t.TimeKey
							,t.TimeSheetKey
							,t.WorkDate
							,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
							,t.ActualHours
							,ROUND(t.ActualRate * t.ExchangeRate, 2) as ActualRate
							--,ROUND(ROUND(t.ActualHours * t.ActualRate,2) * t.ExchangeRate, 2)  As TotalGross
							,t.WIPAmount as TotalGross
							,ti.TitleID
							,ta.TaskName
							,s.Description AS ServiceDescription
						from tWIPPosting wp (NOLOCK)
							inner join tTime t (NOLOCK) on wp.WIPPostingKey = t.WIPPostingInKey 
							inner join tTimeSheet ts (NOLOCK) on t.TimeSheetKey = ts.TimeSheetKey
							inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
							left join tTask ta (NOLOCK) on t.TaskKey = ta.TaskKey
							left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
							left join tTitle ti (NOLOCK) on t.TitleKey = ti.TitleKey
							--left outer join tWIPPosting wpo (nolock) on t.WIPPostingOutKey = wpo.WIPPostingKey
						Where t.WorkDate <= @StartAgingDate
						And t.WorkDate > @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey
						And   isnull(t.ProjectKey,0) = isnull(@ProjectKey, 0)
						Order By t.WorkDate
		
						RETURN 1
					END	
			ELSE
				BEGIN
					select t.TimeKey
						,t.TimeSheetKey
						,t.WorkDate
						,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
						,t.ActualHours
						,ROUND(t.ActualRate * t.ExchangeRate, 2) as ActualRate
						--,ROUND(ROUND(t.ActualHours * t.ActualRate,2) * t.ExchangeRate, 2)  As TotalGross
						,t.WIPAmount as TotalGross
						,ti.TitleID
						,ta.TaskName
						,s.Description AS ServiceDescription
					from tWIPPosting wp (NOLOCK)
						inner join tTime t (NOLOCK) on wp.WIPPostingKey = t.WIPPostingInKey 
						inner join tTimeSheet ts (NOLOCK) on t.TimeSheetKey = ts.TimeSheetKey
						inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
						left join tTask ta (NOLOCK) on t.TaskKey = ta.TaskKey
						left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
						left join tTitle ti (NOLOCK) on t.TitleKey = ti.TitleKey
						left outer join tWIPPosting wpo (nolock) on t.WIPPostingOutKey = wpo.WIPPostingKey
					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (t.WIPPostingOutKey = 0 -- Unbilled
						Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(t.ProjectKey,0) = isnull(@ProjectKey, 0)
					Order By t.WorkDate
		
					RETURN 1
				END	
	END	
	
	IF @TranType = 'Production Expenses'
	BEGIN
		SELECT @WIPAssetAccountKey = @WIPVoucherAssetAccountKey

		IF @Entity = 'tVoucherDetail'
		
			IF @WIPAging = 1
			
				IF @StartAgingDate = @EndAgingDate	
					BEGIN
					-- Voucher details posted to WIP after 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate < @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
						And   isnull(i.ItemType, 0) = 0
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate < @EndAgingDate  
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPVoucherAssetAccountKey
							Or   isnull(i.ItemType, 0) = 0
						)
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END
				Else
										BEGIN
					-- Voucher details posted to WIP after 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate <= @StartAgingDate 
						And   v.InvoiceDate > @EndAgingDate 
						And   wp.CompanyKey = @CompanyKey
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
						And   isnull(i.ItemType, 0) = 0
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate <= @StartAgingDate
						And   v.InvoiceDate > @EndAgingDate 
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPVoucherAssetAccountKey
							Or   isnull(i.ItemType, 0) = 0
						)
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END
		ELSE
							BEGIN
					-- Voucher details posted to WIP after 8.5
					Select   vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,po.PurchaseOrderNumber
							,i.ItemName
					from tWIPPosting wp (NOLOCK)
						inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
						inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (vd.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
					And   isnull(i.ItemType, 0) = 0
			
					UNION
			
					-- Voucher details posted to WIP before 8.5
					Select   vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,po.PurchaseOrderNumber
							,i.ItemName
					from tVoucherDetail vd (nolock) 
						inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
					Where v.CompanyKey = @CompanyKey 
					And   v.PostingDate <= @AsOfDate  
					And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
					And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPVoucherAssetAccountKey
						Or   isnull(i.ItemType, 0) = 0
					)
					And   (vd.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
					Order By c.VendorID, v.InvoiceNumber
			
					RETURN 1
				END
	END
	
	IF @TranType = 'Media Expenses'
	BEGIN
		SELECT @WIPAssetAccountKey = @WIPMediaAssetAccountKey
	
		IF @Entity = 'tVoucherDetail'

			IF @WIPAging = 1

				IF @StartAgingDate = @EndAgingDate

					BEGIN
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,me.EstimateID
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate < @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey			
						And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
						And   isnull(i.ItemType, 0) IN (1, 2)
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,me.EstimateID
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate < @EndAgingDate  
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPMediaAssetAccountKey
							Or   isnull(i.ItemType, 0) IN (1, 2)
							)
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END

				ELSE
										BEGIN
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,me.EstimateID
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate <= @StartAgingDate
						And	  v.InvoiceDate >  @EndAgingDate 
						And   wp.CompanyKey = @CompanyKey			
						And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
						And   isnull(i.ItemType, 0) IN (1, 2)
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,me.EstimateID
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate <= @StartAgingDate
						And   v.InvoiceDate > @EndAgingDate 
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPMediaAssetAccountKey
							Or   isnull(i.ItemType, 0) IN (1, 2)
							)
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END
		ELSE
				BEGIN
					Select   vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,po.PurchaseOrderNumber
							,me.EstimateID
							,i.ItemName
					from tWIPPosting wp (NOLOCK)
						inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
						inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey

					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (vd.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )				
					And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
					And   isnull(i.ItemType, 0) IN (1, 2)
			
					UNION
			
					-- Voucher details posted to WIP before 8.5
					Select   vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,po.PurchaseOrderNumber
							,me.EstimateID
							,i.ItemName
					from tVoucherDetail vd (nolock) 
						inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
					Where v.CompanyKey = @CompanyKey 
					And   v.PostingDate <= @AsOfDate  
					And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
					And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey  -- @WIPAssetAccountKey = @WIPMediaAssetAccountKey
						Or   isnull(i.ItemType, 0) IN (1, 2)
						)
					And   (vd.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	

					And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
					Order By c.VendorID, v.InvoiceNumber
			
					RETURN 1
				END
	END
	
	IF @TranType = 'Other Expenses'
	BEGIN
		SELECT @WIPAssetAccountKey = @WIPExpenseAssetAccountKey
				
		IF @Entity = 'tMiscCost'

			IF @WIPAging = 1

				IF @StartAgingDate = @EndAgingDate

					BEGIN
						Select mc.MiscCostKey
							,mc.Quantity
							,round(mc.UnitCost * mc.ExchangeRate, 2) as UnitCost
							--,round(mc.TotalCost * mc.ExchangeRate, 2) as TotalCost
							,mc.WIPAmount as TotalCost
							,mc.ShortDescription
							,mc.ExpenseDate
							,i.ItemName
						from tWIPPosting wp (NOLOCK)	
							Inner Join tMiscCost mc (NOLOCK) on wp.WIPPostingKey = mc.WIPPostingInKey 
							Left Join tItem i (NOLOCK) on mc.ItemKey = i.ItemKey
							left outer join tWIPPosting wpo (nolock) on mc.WIPPostingOutKey = wpo.WIPPostingKey
						Where mc.ExpenseDate < @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey
						And   isnull(mc.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
						UNION
			
						Select er.ExpenseReceiptKey
							,er.ActualQty
							,round(er.ActualUnitCost * ee.ExchangeRate, 2) as UnitCost
							--,round(er.ActualCost * ee.ExchangeRate, 2) as TotalCost
							,er.WIPAmount as TotalCost
							,er.Description
							,er.ExpenseDate
							,i.ItemName
						from tWIPPosting wp (NOLOCK)
							Inner Join tExpenseReceipt er (NOLOCK) ON wp.WIPPostingKey = er.WIPPostingInKey
							Inner Join tExpenseEnvelope ee (NOLOCK)	ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
							Left Join tItem i (NOLOCK) on er.ItemKey = i.ItemKey
							left outer join tWIPPosting wpo (nolock) on er.WIPPostingOutKey = wpo.WIPPostingKey
						Where er.ExpenseDate < @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey
						And   isnull(er.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
		
						RETURN 1
					END

				ELSE

										BEGIN
						Select mc.MiscCostKey
							,mc.Quantity
							,round(mc.UnitCost * mc.ExchangeRate, 2) as UnitCost
							--,round(mc.TotalCost * mc.ExchangeRate, 2) as TotalCost
							,mc.WIPAmount as TotalCost
							,mc.ShortDescription
							,mc.ExpenseDate
							,i.ItemName
						from tWIPPosting wp (NOLOCK)	
							Inner Join tMiscCost mc (NOLOCK) on wp.WIPPostingKey = mc.WIPPostingInKey 
							Left Join tItem i (NOLOCK) on mc.ItemKey = i.ItemKey
							left outer join tWIPPosting wpo (nolock) on mc.WIPPostingOutKey = wpo.WIPPostingKey
						Where mc.ExpenseDate <= @StartAgingDate
						And   mc.ExpenseDate >  @EndAgingDate 
						And   wp.CompanyKey = @CompanyKey
						And   isnull(mc.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
						UNION
			
						Select er.ExpenseReceiptKey
							,er.ActualQty
							,round(er.ActualUnitCost * ee.ExchangeRate, 2) as UnitCost
							--,round(er.ActualCost * ee.ExchangeRate, 2) as TotalCost 
							,er.WIPAmount as TotalCost
							,er.Description
							,er.ExpenseDate
							,i.ItemName
						from tWIPPosting wp (NOLOCK)
							Inner Join tExpenseReceipt er (NOLOCK) ON wp.WIPPostingKey = er.WIPPostingInKey
							Inner Join tExpenseEnvelope ee (NOLOCK)	ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
							Left Join tItem i (NOLOCK) on er.ItemKey = i.ItemKey
							left outer join tWIPPosting wpo (nolock) on er.WIPPostingOutKey = wpo.WIPPostingKey
						Where er.ExpenseDate <= @StartAgingDate
						And   er.ExpenseDate >  @EndAgingDate 
						And   wp.CompanyKey = @CompanyKey
						And   isnull(er.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
		
						RETURN 1
					END
		ELSE
				BEGIN
					Select mc.MiscCostKey
						,mc.Quantity
						,round(mc.UnitCost * mc.ExchangeRate, 2) as UnitCost
						--,round(mc.TotalCost * mc.ExchangeRate, 2) as TotalCost 
						,mc.WIPAmount as TotalCost
						,mc.ShortDescription
						,mc.ExpenseDate
						,i.ItemName
					from tWIPPosting wp (NOLOCK)	
						Inner Join tMiscCost mc (NOLOCK) on wp.WIPPostingKey = mc.WIPPostingInKey 
						Left Join tItem i (NOLOCK) on mc.ItemKey = i.ItemKey
						left outer join tWIPPosting wpo (nolock) on mc.WIPPostingOutKey = wpo.WIPPostingKey
					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (mc.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(mc.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
					UNION
			
					Select er.ExpenseReceiptKey
						,er.ActualQty
						,round(er.ActualUnitCost * ee.ExchangeRate, 2) as UnitCost
						--,round(er.ActualCost * ee.ExchangeRate, 2) as TotalCost 
						,er.WIPAmount as TotalCost
						,er.Description
						,er.ExpenseDate
						,i.ItemName
					from tWIPPosting wp (NOLOCK)
						Inner Join tExpenseReceipt er (NOLOCK) ON wp.WIPPostingKey = er.WIPPostingInKey
						Inner Join tExpenseEnvelope ee (NOLOCK)	ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
						Left Join tItem i (NOLOCK) on er.ItemKey = i.ItemKey
						left outer join tWIPPosting wpo (nolock) on er.WIPPostingOutKey = wpo.WIPPostingKey
					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (er.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(er.ProjectKey, 0) = isnull(@ProjectKey, 0)
		
		
					RETURN 1
				END

		IF @Entity = 'tVoucherDetail'

			IF @WIPAging = 1

				IF @StartAgingDate = @EndAgingDate

					BEGIN
						Select  vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,ev.EnvelopeNumber 
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tExpenseReceipt er (NOLOCK) on vd.VoucherDetailKey = er.VoucherDetailKey
							left outer join tExpenseEnvelope ev (NOLOCK) on er.ExpenseEnvelopeKey = ev.ExpenseEnvelopeKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate < @EndAgingDate  
						And   wp.CompanyKey = @CompanyKey
						And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
						And   isnull(i.ItemType, 0) = 3
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate < @EndAgingDate  
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey -- @WIPAssetAccountKey = @WIPExpenseAssetAccountKey
							Or
							isnull(i.ItemType, 0) = 3
							)
						And   vd.WIPPostingOutKey = 0 -- Unbilled
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END

				ELSE
					
										BEGIN
						Select  vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.InvoiceDate
								,vd.Quantity
								,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,ev.EnvelopeNumber 
								,i.ItemName
						from tWIPPosting wp (NOLOCK)
							inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
							inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tExpenseReceipt er (NOLOCK) on vd.VoucherDetailKey = er.VoucherDetailKey
							left outer join tExpenseEnvelope ev (NOLOCK) on er.ExpenseEnvelopeKey = ev.ExpenseEnvelopeKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.InvoiceDate <= @StartAgingDate
						And   v.InvoiceDate >  @EndAgingDate 
						And   wp.CompanyKey = @CompanyKey
						And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
						And   isnull(i.ItemType, 0) = 3
			
						UNION
			
						-- Voucher details posted to WIP before 8.5
						Select   vd.VoucherDetailKey
								,v.VoucherKey
								,v.InvoiceNumber
								,v.PostingDate
								,vd.Quantity
								,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
								--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
								,vd.WIPAmount as TotalCost
								,c.VendorID
								,vd.ShortDescription
								,po.PurchaseOrderNumber
								,i.ItemName
						from tVoucherDetail vd (nolock) 
							inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
							left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
							left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
							left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
							left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
							left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
						Where v.CompanyKey = @CompanyKey 
						And   v.InvoiceDate <= @StartAgingDate 
						And   v.InvoiceDate >  @EndAgingDate 
						And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
						And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey -- @WIPAssetAccountKey = @WIPExpenseAssetAccountKey
							Or
							isnull(i.ItemType, 0) = 3
							)
						And   vd.WIPPostingOutKey = 0 -- Unbilled
						And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
						Order By c.VendorID, v.InvoiceNumber
			
						RETURN 1
					END
			ELSE

				BEGIN
					Select  vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,ev.EnvelopeNumber 
							,i.ItemName
					from tWIPPosting wp (NOLOCK)
						inner join tVoucherDetail vd (nolock) on wp.WIPPostingKey = vd.WIPPostingInKey
						inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tExpenseReceipt er (NOLOCK) on vd.VoucherDetailKey = er.VoucherDetailKey
						left outer join tExpenseEnvelope ev (NOLOCK) on er.ExpenseEnvelopeKey = ev.ExpenseEnvelopeKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
					Where wp.PostingDate <= @AsOfDate  
					And   wp.CompanyKey = @CompanyKey
					And   (vd.WIPPostingOutKey = 0 -- Unbilled
							Or 
						   wpo.PostingDate > @AsOfDate  -- Billed later
						   )	
					And   isnull(vd.ProjectKey, 0) = isnull(@ProjectKey, 0)	
					And   isnull(i.ItemType, 0) = 3
			
					UNION
			
					-- Voucher details posted to WIP before 8.5
					Select   vd.VoucherDetailKey
							,v.VoucherKey
							,v.InvoiceNumber
							,v.PostingDate
							,vd.Quantity
							,round(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
							--,round(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
							,vd.WIPAmount as TotalCost
							,c.VendorID
							,vd.ShortDescription
							,po.PurchaseOrderNumber
							,i.ItemName
					from tVoucherDetail vd (nolock) 
						inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
						left outer join tItem i (NOLOCK) on vd.ItemKey = i.ItemKey 
						left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
						left outer join tPurchaseOrderDetail pod (NOLOCK) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
					Where v.CompanyKey = @CompanyKey 
					And   v.PostingDate <= @AsOfDate  
					And   (v.Posted = 1 And vd.WIPPostingInKey = -1 ) -- After 85 conversion should be -1 
					And   (vd.OldExpenseAccountKey = @WIPAssetAccountKey -- @WIPAssetAccountKey = @WIPExpenseAssetAccountKey
						Or
						isnull(i.ItemType, 0) = 3
						)
					And   vd.WIPPostingOutKey = 0 -- Unbilled
					And   isnull(vd.ProjectKey,0) = isnull(@ProjectKey,0)	
			
					Order By c.VendorID, v.InvoiceNumber
			
					RETURN 1
				END
	END
	
	IF @Entity = 'tJournalEntryDetail'
		select  jed.JournalEntryDetailKey
				,je.PostingDate
				,je.JournalNumber
				,je.Description
				,jed.Memo
				,jed.DebitAmount
				,jed.CreditAmount					
		from   tJournalEntry je (NOLOCK)
			inner join tJournalEntryDetail jed (NOLOCK) ON je.JournalEntryKey = jed.JournalEntryKey	
		Where   je.PostingDate <= @AsOfDate
		And     je.CompanyKey = @CompanyKey
		And	    je.Posted = 1
		And     jed.GLAccountKey = @WIPAssetAccountKey
		And     isnull(jed.ProjectKey, 0) = isnull(@ProjectKey, 0) 
		Order By je.PostingDate
				
	IF @Entity = 'tTransaction'
		select  t.TransactionKey
				,t.Entity
				,t.TransactionDate
				,t.Reference
				,t.Memo
				,t.Debit
				,t.Credit					
		from    vHTransaction t (NOLOCK)
		Where   t.TransactionDate <= @AsOfDate
		And     t.CompanyKey = @CompanyKey
		And     t.GLAccountKey = @WIPAssetAccountKey
		And     isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0) 
		--AND     t.Entity IN ('WIP', 'GENJRNL')
		Order By t.Entity
				,t.TransactionDate

	
	RETURN 1
GO
