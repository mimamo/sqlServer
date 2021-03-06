USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDPO]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDPO]

	(
		@ProjectKey int
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 03/17/08 CRG 1.0.0.0  Added columns for new Project Budget View        
|| 02/23/09 MFT 10.0.1.9 (47632) Aliased ShortDescription as Description
|| 08/14/12 RLB 10.5.5.9 (151605) Added type for bug fix
*/

	Select
		p.PurchaseOrderKey,
		p.PurchaseOrderNumber,
		p.Closed,
		ISNULL(ta.TaskID, '[No Task]') As TaskID,
		ISNULL(ta.TaskKey, 0) AS TaskKey,
		c.CompanyName,
		c.VendorID,
		p.PODate,
		ISNULL(i.ItemName, '[No Item]') As ItemName,
		ISNULL(i.ItemKey, 0) AS ItemKey,
		pd.ShortDescription AS Description,
		pd.LongDescription,
		pd.Quantity,
		pd.UnitCost,
		pd.TotalCost,
		pd.BillableCost,
		pd.ProjectKey,
		i.ItemID,
		CASE 
			WHEN p.Closed = 1 THEN 0 
			ELSE pd.TotalCost - ISNULL(pd.AppliedCost, 0) 
		END AS OpenAmount,
		ISNULL(c.VendorID, '') + '-' + ISNULL(c.CompanyName, '') AS VendorIDName,
		CASE p.POKind
			WHEN 1 THEN 'Insertion Order'
			WHEN 2 THEN 'Broadcast Order'
			ELSE 'Purchase Order'
		END AS Type,
		p.POKind,
		pd.Billable,
		pd.UnitRate,
		pd.AmountBilled,
		inv.InvoiceNumber,
		inv.InvoiceDate,
		inv.PostingDate,
		pd.TransferComment,
		--Date Paid By Client ?????	
		CASE p.Status
			WHEN 4 THEN 1
			ELSE 0
		END AS ApprovalStatus, --Used for grid filtering		
		CASE 
			WHEN pd.InvoiceLineKey IS NULL THEN 'Unbilled'
			ELSE 'Billed'
		END AS BillingStatus
	From
		tPurchaseOrderDetail pd (nolock)
		Inner Join tPurchaseOrder p (nolock) on p.PurchaseOrderKey = pd.PurchaseOrderKey
		Left Outer Join tTask ta (nolock) on ta.TaskKey = pd.TaskKey
		left outer Join tCompany c (nolock) on c.CompanyKey = p.VendorKey
		Left Outer Join tItem i (nolock) on pd.ItemKey = i.ItemKey
		LEFT JOIN tInvoiceLine il (nolock) ON pd.InvoiceLineKey = il.InvoiceLineKey
		LEFT JOIN tInvoice inv (nolock) ON il.InvoiceKey = inv.InvoiceKey
	Where
		pd.ProjectKey = @ProjectKey
	Order By p.PurchaseOrderNumber
GO
