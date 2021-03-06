USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailGetPOList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailGetPOList]
	@VendorKey int,
	@PurchaseOrderNumber varchar(50),
	@ProjectNumber varchar(50),
	@StartDate datetime = null,
	@EndDate datetime = null,
	@GLCompanyKey int,
	@UserKey int = null,
	@CheckGLCompanyMap int = 0, -- if we come from the ASPX screen, ICT is not working yet
	@CurrencyID varchar(10) = null
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 01/02/07 RTC 8.4001  Added POKind column 
|| 01/23/07 GHL 8.402   Added ProjectNumber parameter (Request 8004 for Jim Mudd)  
|| 03/09/07 GHL 8.406   Added NOLOCK after tVoucherDetail               
|| 04/19/07 GHL 8.42    Added StartDate and EndDate. Paid Enh 6877   
|| 04/30/07 RTC 8.4.2.1 (9048) Sort By DetailOrderDate Before LineNumber  
|| 06/05/07 GHL 8.4.3   (9297) Added AppliedBillableCost to support prebilled orders on 'Select Orders' screen
|| 08/10/07 BSH 8.5     (9659) Added GLCompanyKey, OfficeKey and DepartmentKey
|| 10/08/07 CRG 8.4.3.8 (14139) Modified how UnitCost, UnitRate and OpenQuantity are calculated for Media orders.
|| 11/16/07 GHL 8.440   (16085) When no project take ISNULL(p.NonBillable, 1)
|| 12/07/07 GHL 8.5     (16992) Replaced zero quantities by 1 for IOs
|| 06/27/08 GHL 8.514   (29509) Added BillAt so that we can make decisions based on this flag in 
||                      the javascript of voucher_po.aspx
|| 12/06/11 GHL 10.550  Added item expense account number and name for lookups in flex
|| 12/29/11 GHL 10.551  Added project costing info similarly to sptVoucherDetailGetList for Flex app
|| 02/06/12 GHL 10.552  Added Detail Order Dates to show on Flex app
|| 03/28/12 GHL 10.554  Added ICT logic
|| 05/11/12 GHL 10.556  (142898) Added InvoiceNumber for the prebilled PO
|| 08/27/12 RLB 10.559  (152699) Added Department Name so it correctly displays on the new voucher screen
|| 09/06/12 GHL 10.559  (153625) Added Office info for lookups on new voucher screen
|| 12/14/12 GHL 10.563  Added Line + Adjustment field for POD flex lookup
|| 04/17/12 GHL 10.567  Added POLineAdjustment to help out with Media Accrued Order issues
|| 04/30/12 GHL 10.567  Added POLinkID to help out with Media Accrued Order issues
|| 09/09/13 GHL 10.568  (185009) Changed order by so that ds.sortOn is not used in flex (causing timeouts) 
|| 10/15/13 GHL 10.573  Changes for GrossAmount
|| 10/30/13 GHL 10.573  Added AppliedPTotalCost = sum of vd.PTotalCost applied to a POD (needed for multi currency)  
|| 12/05/13 WDF 10.575  (198111) Added ClientName
|| 10/22/14 GHL 10.585 (228260) When closing, mark as billed, when opening, mark as unbilled
||                      For this reason, look at InvoiceLineKey to calculate POAmountBilled 
|| 11/12/14 GHL 10.585 (236238) Put back AmountBilled, I had removed it for 228260
*/	

Declare @CompanyKey int
		,@PurchaseOrderKey int
		,@ProjectKey int
		,@RestrictToGLCompany tinyint
					
select @CompanyKey = OwnerCompanyKey 
  from tCompany (nolock)
 where CompanyKey = @VendorKey

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from   tPreference (nolock)
Where  CompanyKey = @CompanyKey
 
if not @PurchaseOrderNumber is null
	Select @PurchaseOrderKey = PurchaseOrderKey from tPurchaseOrder (NOLOCK) Where VendorKey = @VendorKey and Status = 4 and Closed = 0 and PurchaseOrderNumber = @PurchaseOrderNumber

if not @ProjectNumber is null
	Select @ProjectKey = ProjectKey from tProject (NOLOCK) Where CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber

	SELECT 
		pod.PurchaseOrderDetailKey
		,pod.PurchaseOrderKey
		,pod.LineNumber
		,pod.AdjustmentNumber
		,pod.LinkID
		,pod.ProjectKey
		,pod.TaskKey
		,pod.ClassKey
		,pod.ShortDescription
		,pod.LongDescription
		,pod.ItemKey
		,pod.Quantity
		,CASE po.POKind
			-- PO
			WHEN 0 THEN	pod.UnitCost
			-- IO: Replace 0 by 1
			WHEN 1 THEN
				CASE WHEN ISNULL(pod.Quantity, 0) = 0 THEN
					CASE
						WHEN 1 - ISNULL(q.AppliedQuantity, 0) = 0 THEN pod.TotalCost
						ELSE pod.TotalCost / (1 - ISNULL(q.AppliedQuantity, 0))
					END
				 ELSE
					CASE
						WHEN ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0) = 0 THEN pod.TotalCost
						ELSE pod.TotalCost / (ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0))
					END
				END
			ELSE 
			-- BC
				CASE
					WHEN ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0) = 0 THEN pod.TotalCost
					ELSE pod.TotalCost / (ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0))
				END
		END AS UnitCost
		,pod.UnitDescription
		,pod.TotalCost
		,pod.Billable
		,pod.Markup
		,CASE po.POKind
			-- PO
			WHEN 0 THEN	pod.UnitRate
			-- IO
			WHEN 1 THEN
				CASE WHEN ISNULL(pod.Quantity, 0) = 0 THEN
					CASE
						WHEN 1 - ISNULL(q.AppliedQuantity, 0) = 0 THEN pod.BillableCost
						ELSE pod.BillableCost / (1 - ISNULL(q.AppliedQuantity, 0))
					END
				ELSE
					CASE
						WHEN ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0) = 0 THEN pod.BillableCost
						ELSE pod.BillableCost / (ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0))
					END
				END
			-- BC	
			WHEN 2 THEN pod.UnitCost
		END AS UnitRate
		,pod.BillableCost
		,pod.AppliedCost
		,pod.InvoiceLineKey
		,case when pod.InvoiceLineKey > 0 then isnull(pod.AmountBilled, 0) else 0 end as POAmountBilled
		,case when pod.InvoiceLineKey > 0 then isnull(pod.AmountBilled, 0) else 0 end as AmountBilled
		,pod.DateBilled
		,pod.Closed
		,pod.Taxable
		,pod.Taxable2
		,pod.OfficeKey
		,pod.DepartmentKey		
		,p.ProjectNumber
		,p.ProjectName
		,c.CompanyName AS ClientName
		,p.GetMarkupFrom
		,p.ItemRateSheetKey
		,ISNULL(p.NonBillable, 1) AS NonBillable
		,t.TaskID
		,t.TaskName
		,cl.ClassID
		,cl.ClassName
		,o.OfficeID
		,o.OfficeName
		,dp.DepartmentName
		,i.ItemID
		,i.ItemName
		,i.ItemType
		,i.ExpenseAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,po.PurchaseOrderNumber
		,ISNULL(po.GLCompanyKey, 0) as GLCompanyKey
		,po.PODate
		,po.DueDate
		,po.POKind
		,po.BillAt
		,pod.TotalCost - ISNULL(pod.AppliedCost, 0) as OpenNet
		--,pod.AmountBilled as POAmountBilled -- already specified above
		,pod.BillableCost as POBillableCost
		/*
		,case po.BillAt
			when 0 then pod.BillableCost - ISNULL(pod.AmountBilled, 0) 
			when 1 then pod.TotalCost - ISNULL(pod.AmountBilled, 0) 
			when 2 then (pod.BillableCost - pod.TotalCost) - ISNULL(pod.AmountBilled, 0) 
		end as OpenGross
		*/
		,pod.BillableCost -ISNULL((Select Sum(vd.GrossAmount) from tVoucherDetail vd (nolock) 
		Where vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as OpenGross
		,CASE po.POKind
			-- Regular PO
			WHEN 0 THEN	ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0)
			-- IO replace 0 qty by 1
			WHEN 1 THEN
				CASE WHEN ISNULL(pod.Quantity, 0) = 0 THEN
					CASE
						WHEN 1 - ISNULL(q.AppliedQuantity, 0) = 0 THEN 1
						ELSE 1 - ISNULL(q.AppliedQuantity, 0)
					END
				 ELSE
					CASE
						WHEN ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0) = 0 THEN 1
						ELSE ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0)
					END
				END
			-- BC	
			ELSE 
				CASE
					WHEN ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0) = 0 THEN 1
					ELSE ISNULL(pod.Quantity, 0) - ISNULL(q.AppliedQuantity, 0)
				END
		END AS OpenQuantity
		,Case po.POKind 
			When 0 then CONVERT( VARCHAR(50), po.PODate, 101)
			When 1 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101) 
			When 2 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101)+ '+' +CONVERT( VARCHAR(50), pod.DetailOrderEndDate, 101)
        End As TransactionDate
		,mrr.ReasonID
		--,ISNULL((Select Sum(vd.TotalCost * (1 + (vd.Markup / 100)) ) from tVoucherDetail vd (nolock) 
		--Where vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as AppliedBillableCost
		
		-- this must be calculated in the project currency
		,ISNULL((Select Sum(
							case when isnull(vd.PExchangeRate, 0) = 0
							then round((vd.GrossAmount * v.ExchangeRate), 2)
							else round((vd.GrossAmount * v.ExchangeRate) / vd.PExchangeRate, 2)
						    end
							) 
		
		from tVoucherDetail vd (nolock) 
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		Where vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as AppliedBillableCost
		,pod.DetailOrderDate
		,pod.DetailOrderEndDate	
		,pod.OrderDays
		,pod.OrderTime

		,inv.InvoiceKey as PrebilledInvoiceKey
		,inv.InvoiceNumber as PrebilledInvoiceNumber

		,po.PurchaseOrderNumber 
		+ ' ' + cast(pod.LineNumber as varchar(20)) 
		+ '.' + isnull(cast(pod.AdjustmentNumber as varchar(20)), '0') 
		as POLineAdjustment
		, pod.LinkID as POLinkID
		,case when po.BillAt = 0 then 'Gross'
			  when po.BillAt = 1 then 'Net'
			  when po.BillAt = 2 then 'Commission'
			  else ''
		end as BillAtDescription
		,pod.PCurrencyID
		,pod.PExchangeRate
		,ISNULL((Select Sum(vd.PTotalCost) from tVoucherDetail vd (nolock) 
		Where vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as AppliedPTotalCost
		
	FROM tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON pod.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tTask t (NOLOCK) ON pod.TaskKey = t.TaskKey 
		left outer join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
		left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
		left outer join tDepartment dp (nolock) on pod.DepartmentKey = dp.DepartmentKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
		LEFT OUTER JOIN tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
		left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey	
		LEFT OUTER JOIN 
			(SELECT SUM(Quantity) AS AppliedQuantity, PurchaseOrderDetailKey 
			FROM	tVoucherDetail (nolock)
			GROUP BY PurchaseOrderDetailKey) q ON pod.PurchaseOrderDetailKey = q.PurchaseOrderDetailKey 
		LEFT OUTER JOIN tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		LEFT OUTER JOIN tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey

	WHERE
		po.Status = 4  
	AND	pod.Closed = 0 
	AND	po.VendorKey = @VendorKey
	AND (isnull(@PurchaseOrderKey, 0) = 0 Or po.PurchaseOrderKey = @PurchaseOrderKey) -- added to replace second query below
	AND	(@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
	AND (ISNULL(po.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) OR
			(@CheckGLCompanyMap = 1 AND
			po.GLCompanyKey in (Select TargetGLCompanyKey from tGLCompanyMap (nolock) Where SourceGLCompanyKey = @GLCompanyKey) 
			)
		) 
	AND (@RestrictToGLCompany = 0 OR
		po.GLCompanyKey in (Select GLCompanyKey from tUserGLCompanyAccess (nolock) Where UserKey = @UserKey) 
		)
	AND (ISNULL(po.CurrencyID, '') = ISNULL(@CurrencyID, '') ) 
	AND (@StartDate IS NULL OR po.PODate >= @StartDate)
	AND (@EndDate IS NULL OR po.PODate <= @EndDate)		 
	AND	NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					 INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)				
	Order By
		--po.PODate, po.PurchaseOrderNumber, pod.DetailOrderDate, pod.LineNumber
		-- issue 185009: Removed ds.sortOn from flex code and placed it here
		-- Order by optimized for IO/BO
		po.PurchaseOrderNumber, pod.DetailOrderDate, pod.ShortDescription, pod.LineNumber
GO
