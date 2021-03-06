USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailGet]
	@VoucherDetailKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/05/07 GHL 8.4.3   (9297) Added new PO Cost fields to support prebilled orders  
|| 08/06/07 BSH 8.5     (9659)Get Office, Department
|| 09/25/07 GHL 8437    (13173) Added POKind to build correct link to PO
|| 12/12/11 GHL 10.550  Corrected PO Cost fields 
|| 10/22/14 GHL 10.585 (228260) When closing, mark as billed, when opening, mark as unbilled
||                      For this reason, look at InvoiceLineKey to calculate POAmountBilled
*/	
		SELECT vd.*
		       ,p.ProjectNumber
		       ,p.ProjectName
		       ,p.GetMarkupFrom
		       ,t.TaskID
		       ,t.TaskName
		       ,cl.ClassID
		       ,cl.ClassName
		       ,c.CustomerID as ClientID
		       ,i.ItemID
		       ,i.ItemName
		       ,gl.AccountName
		       ,gl.AccountNumber as ExpenseAccountNumber
		       ,pod.LineNumber as POLineNumber
		       ,po.PurchaseOrderNumber
		       ,po.PurchaseOrderKey
		       ,po.POKind
		       ,case when pod.InvoiceLineKey > 0 then isnull(pod.AmountBilled, 0) else 0 end as POAmountBilled
			   ,pod.BillableCost as POBillableCost
		       ,pod.ShortDescription as POShortDescription
		       ,o.OfficeName
		       ,d.DepartmentName
		       ,pod.TotalCost as POTotalCost

			   /*
		       ,ISNULL((SELECT SUM(vd2.TotalCost) 
						FROM tVoucherDetail vd2 (NOLOCK)
						INNER JOIN tPurchaseOrderDetail pod2 (NOLOCK) ON vd2.PurchaseOrderDetailKey = pod2.PurchaseOrderDetailKey
						WHERE pod2.PurchaseOrderKey = pod.PurchaseOrderKey
						AND   vd2.PurchaseOrderDetailKey <> pod.PurchaseOrderDetailKey), 0) AS POOtherAppliedCost 
		       
		       ,ISNULL((SELECT SUM(vd2.TotalCost * (1 + vd2.Markup / 100)) 
						FROM tVoucherDetail vd2 (NOLOCK)
						INNER JOIN tPurchaseOrderDetail pod2 (NOLOCK) ON vd2.PurchaseOrderDetailKey = pod2.PurchaseOrderDetailKey
						WHERE pod2.PurchaseOrderKey = pod.PurchaseOrderKey
						AND   vd2.PurchaseOrderDetailKey <> pod.PurchaseOrderDetailKey), 0) AS POOtherAppliedBillableCost 
		       */

			   ,ISNULL((SELECT SUM(vd2.TotalCost)
						FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedCost 

			   ,ISNULL((SELECT SUM(vd2.TotalCost * (1 + vd2.Markup / 100))
						FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedBillableCost 
		       	
		       
		FROM tVoucherDetail vd (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tTask t (NOLOCK) ON vd.TaskKey = t.TaskKey 
			left outer join tClass cl (nolock) on vd.ClassKey = cl.ClassKey
			left outer join tCompany c (nolock) on vd.ClientKey = c.CompanyKey
			left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
			left outer join tGLAccount gl (nolock) on vd.ExpenseAccountKey = gl.GLAccountKey
			left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			left outer join tOffice o (nolock) on vd.OfficeKey = o.OfficeKey
		left outer join tDepartment d (nolock) on vd.DepartmentKey = d.DepartmentKey
		WHERE
			vd.VoucherDetailKey = @VoucherDetailKey
					
	RETURN 1
GO
