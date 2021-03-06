USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseGet]
	@EstimateTaskExpenseKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/19/07  CRG 8.5     (11376) Added CalcAsArea
|| 1/23/08   CRG 8.5.0.2 (18985) Added ItemUnitCost and ItemUnitRate
*/

		SELECT ete.*
			,t.TaskID
			,i.ItemID
			,i.ItemType
			,c.VendorID
			,cl.ClassID
			,pod.PurchaseOrderKey
			,po.PurchaseOrderNumber
			,i.CalcAsArea
			,i.MinAmount
			,i.ConversionMultiplier AS DefaultMult
			,i.UnitCost AS ItemUnitCost
			,i.UnitRate AS ItemUnitRate
		FROM tEstimateTaskExpense ete (nolock)
			left outer join tTask t (nolock) on ete.TaskKey = t.TaskKey
			left outer join tItem i (nolock) on ete.ItemKey = i.ItemKey
			left outer join tPurchaseOrderDetail pod (nolock) on ete.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			left outer join tCompany c (nolock) on ete.VendorKey = c.CompanyKey
			left outer join tClass cl (nolock) on ete.ClassKey = cl.ClassKey
		WHERE
			ete.EstimateTaskExpenseKey = @EstimateTaskExpenseKey
	RETURN 1
GO
