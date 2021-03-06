USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailGet]
	@PurchaseOrderDetailKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/16/07 BSH 8.5     (9659)Get Office, Department
|| 07/20/10 MFT 10.532  Added FieldSetKey
|| 08/03/10 MFT 10.533  Set ISNULL for FieldSetName and FieldSetKey
|| 1/15/11  GWG 10.540  Added a change so that for broadcast spots, it will try and figure out if anything on the line is still open so that the close all spots button works correctly.
*/

declare @BillingDetail tinyint
declare @kind int, @POKey int, @LinesClosed tinyint
declare @AdjNum int, @LineNumber int

	if exists(Select 1 from tBillingDetail bd (nolock)
						inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey
						inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
					Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
					And   bd.Entity = 'tPurchaseOrderDetail'
					And   b.Status < 5)
		Select @BillingDetail = 1
	else
		Select @BillingDetail = 0

	

	Select @kind = POKind, @POKey = po.PurchaseOrderKey from tPurchaseOrderDetail pod (nolock) 
	inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
	Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if @kind = 2
	BEGIN
		Select @AdjNum = AdjustmentNumber, @LineNumber = LineNumber from tPurchaseOrderDetail Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		if exists(Select 1 from tPurchaseOrderDetail Where PurchaseOrderKey = @POKey and LineNumber = @LineNumber and AdjustmentNumber = @AdjNum and Closed = 0)
			Select @LinesClosed = 0
		else
			Select @LinesClosed = 1
	END
	ELSE
	BEGIN
		Select @LinesClosed = 0
	END

	SELECT 
		pod.*,
		o.OfficeName,
		d.DepartmentName,
		isnull((select sum(isnull(pod1.AmountBilled,0)) 
		         from tPurchaseOrderDetail pod1 (nolock) 
		        where pod1.PurchaseOrderKey = pod.PurchaseOrderKey
		          and pod1.LineNumber = pod.LineNumber
		          and pod1.AdjustmentNumber = pod.AdjustmentNumber),0) as BCAmountBilled,
		p.ProjectNumber,
		p.ProjectName,
		p.GetMarkupFrom,
		p.ItemMarkup,
		t.TaskID,
		t.TaskName,
		i.ItemID,
		i.ItemName,
		cl.ClassID,
		cl.ClassName,
		inv.InvoiceNumber,
		inv.InvoiceDate,
		inv.InvoiceKey,
		@LinesClosed as LinesClosed,
		ISNULL((select fs.FieldSetName 
			from
				tFieldSet fs (nolock) 
				inner join tObjectFieldSet ofs (nolock) on fs.FieldSetKey = ofs.FieldSetKey
			where
				ofs.ObjectFieldSetKey = pod.CustomFieldKey), 'General') as FieldSetName,
		ISNULL((select fs.FieldSetKey 
			from
				tFieldSet fs (nolock) 
				inner join tObjectFieldSet ofs (nolock) on fs.FieldSetKey = ofs.FieldSetKey
			where
				ofs.ObjectFieldSetKey = pod.CustomFieldKey), 0) as FieldSetKey,
		@BillingDetail as BillingDetail,
		ISNULL(
			(SELECT	SUM(pod2.AppliedCost)
			FROM	tPurchaseOrderDetail pod2 (NOLOCK)
			WHERE	pod2.PurchaseOrderKey = pod.PurchaseOrderKey
			AND		pod2.LineNumber = pod.LineNumber
			AND		pod2.AdjustmentNumber = pod.AdjustmentNumber), 0) AS TotalAppliedCost	
	FROM 
		tPurchaseOrderDetail pod (nolock)
		left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		left outer join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
		left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
		left outer join tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
	WHERE
		pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	RETURN 1
GO
