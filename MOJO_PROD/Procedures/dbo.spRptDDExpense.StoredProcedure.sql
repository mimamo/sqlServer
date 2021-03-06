USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDExpense]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptDDExpense]
	(
		@ProjectKey INT
	)
AS	--Encrypt

  /*
  || When     Who Rel   What
  || 07/09/07 GHL 8.5   Added restriction on ERs 
  || 07/10/07 QMD 8.5   Expense Type reference changed to tItem                   
  */
	
	SET NOCOUNT ON
	
	-- Vouchers or Vendor Invoices	
	Select
		@ProjectKey As ProjectKey,	-- For grids
		'Voucher' As TransactionType,
		isnull(ta.TaskKey, 0) As TaskKey,
		isnull(ta.TaskID, '[No Task]') As TaskID,
		isnull(i.ItemKey, 0) As ItemKey,
		isnull(i.ItemName, '[No Item]') As ItemName,
		
		v.InvoiceDate As TransactionDate,
		vd.Quantity,
		vd.TotalCost,
		vd.BillableCost,
		NULL As UserName,		

		c.CompanyName,
		c.VendorID,		
		v.InvoiceNumber,
		(Select PurchaseOrderNumber from tPurchaseOrder p (nolock) 
			inner join tPurchaseOrderDetail pd 
			on p.PurchaseOrderKey = pd.PurchaseOrderKey 
			Where pd.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey) as PurchaseOrderNumber,
			
		vd.ShortDescription AS Description	
			
	From
		tVoucherDetail vd (nolock)
		Inner Join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
		Inner Join tCompany c (nolock) on c.CompanyKey = v.VendorKey
		Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
		Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
	Where
		vd.ProjectKey = @ProjectKey
		
	-- And Misc Costs	
	UNION ALL
	
		Select
		@ProjectKey As ProjectKey,	-- For grids
		'MiscCost' As TransactionType,
		isnull(ta.TaskKey, 0) As TaskKey,
		isnull(ta.TaskID, '[No Task]') As TaskID,
		isnull(i.ItemKey, 0) As ItemKey,
		isnull(i.ItemName, '[No Item]') As ItemName,

		m.ExpenseDate As TransactionDate,
		m.Quantity,
		m.TotalCost,
		m.BillableCost,
		u.FirstName + ' ' + u.LastName as UserName,

		NULL,
		NULL,		
		NULL,
		NULL,
		m.ShortDescription
	
	From
		tMiscCost m (nolock)
		Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
		Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
		left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
	Where
		m.ProjectKey = @ProjectKey

	-- And Expense Reports
	UNION ALL
	
	Select
		@ProjectKey As ProjectKey,	-- For grids
		'ExpenseReceipt' As TransactionType,
		isnull(ta.TaskKey, 0) As TaskKey,
		isnull(ta.TaskID, '[No Task]') As TaskID,
		isnull(i.ItemKey, 0) As ItemKey,
		isnull(i.ItemName, '[No Item]') As ItemName,
		
		er.ExpenseDate As TransactionDate,
		er.ActualQty,
		er.ActualCost,
		er.BillableCost,		
		u.FirstName + ' ' + u.LastName as UserName,
		
		NULL,
		NULL,		
		NULL,
		NULL,
		er.Description
	
	From
		tExpenseReceipt er (nolock)
		Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
		Inner Join tUser u (nolock) on u.UserKey = er.UserKey
		Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
	Where
		er.ProjectKey = @ProjectKey
	And
		er.VoucherDetailKey IS NULL

	
	RETURN 1
GO
