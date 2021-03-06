USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingValidateTransfers]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingValidateTransfers]
	(
		@BillingKey int
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/06/08 GHL 8.512 (27863) creation for validation of transfers	
  || 12/01/09 GHL 10.514 Commented out optional new transfers. They are now the general rule.       
  */

	SET NOCOUNT ON
	
	IF NOT EXISTS (SELECT 1 FROM tBillingDetail (NOLOCK) WHERE BillingKey = @BillingKey AND Action = 5)
		RETURN 1
	
	DECLARE	@NewTransfers int	select @NewTransfers = 1
	/*
	if exists (select 1 
				from tBilling b (nolock)
				inner join tPreference pref (nolock) on b.CompanyKey = pref.CompanyKey
			where b.BillingKey = @BillingKey
			and lower(pref.Customizations) like '%newtransfers%'
			) 
			select @NewTransfers = 1
		else
			select @NewTransfers = 0
	*/
	
	-- projects do not accept time entries
	IF EXISTS (SELECT 1 
				FROM  tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
					INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey 
				WHERE bd.BillingKey = @BillingKey
				AND  bd.Action = 5
				AND  bd.Entity = 'tTime'
				AND  ps.TimeActive = 0
				)
				RETURN -1  
	
	-- projects do not accept expense entries
	IF EXISTS (SELECT 1 
				FROM  tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
					INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey 
				WHERE bd.BillingKey = @BillingKey
				AND  bd.Action = 5
				AND  bd.Entity <> 'tTime'
				AND  ps.ExpenseActive = 0
				)
				RETURN -2
	
	IF @NewTransfers = 0
		BEGIN
			-- we cannot do the WIP adjustment if the new project is not billable 
			-- same validation as spProcessTranTransfer and spGLPostWIPAdjustment
						
	-- Non billable projects and WIP			
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
				INNER JOIN tTime t (nolock) ON bd.EntityGuid = t.TimeKey 
			WHERE bd.BillingKey = @BillingKey
			AND p.NonBillable = 1 
			AND bd.Action = 5
			AND bd.Entity = 'tTime' 
			AND t.WIPPostingInKey <> 0
			AND t.WIPPostingOutKey = 0
				)
				RETURN -3
				
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
				INNER JOIN tMiscCost t (nolock) ON bd.EntityKey = t.MiscCostKey 
			WHERE bd.BillingKey = @BillingKey
			AND p.NonBillable = 1 
			AND bd.Action = 5
			AND bd.Entity = 'tMiscCost' 
			AND t.WIPPostingInKey <> 0
			AND t.WIPPostingOutKey = 0
				)
				RETURN -3
	
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
				INNER JOIN tExpenseReceipt t (nolock) ON bd.EntityKey = t.ExpenseReceiptKey 
			WHERE bd.BillingKey = @BillingKey
			AND p.NonBillable = 1 
			AND bd.Action = 5
			AND bd.Entity = 'tExpenseReceipt' 
			AND t.WIPPostingInKey <> 0
			AND t.WIPPostingOutKey = 0
				)
				RETURN -3
		  
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tProject p (NOLOCK) ON bd.TransferProjectKey = p.ProjectKey
				INNER JOIN tVoucherDetail t (nolock) ON bd.EntityKey = t.VoucherDetailKey 
			WHERE bd.BillingKey = @BillingKey
			AND p.NonBillable = 1 
			AND bd.Action = 5
			AND bd.Entity = 'tVoucherDetail' 
			AND t.WIPPostingInKey <> 0
			AND t.WIPPostingOutKey = 0
				)
				RETURN -3
		  
	-- Marked as billed and out of WIP
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tTime t (nolock) ON bd.EntityGuid = t.TimeKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tTime' 
			AND t.InvoiceLineKey = 0
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -4

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tMiscCost t (nolock) ON bd.EntityKey = t.MiscCostKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tMiscCost' 
			AND t.InvoiceLineKey = 0
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -4

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tExpenseReceipt t (nolock) ON bd.EntityKey = t.ExpenseReceiptKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tExpenseReceipt' 
			AND t.InvoiceLineKey = 0
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -4

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tVoucherDetail t (nolock) ON bd.EntityKey = t.VoucherDetailKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tVoucherDetail' 
			AND t.InvoiceLineKey = 0
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -4



	-- no WO 
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tTime t (nolock) ON bd.EntityGuid = t.TimeKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tTime' 
			AND t.WriteOff = 1
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tMiscCost t (nolock) ON bd.EntityKey = t.MiscCostKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tMiscCost' 
			AND t.WriteOff = 1
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tExpenseReceipt t (nolock) ON bd.EntityKey = t.ExpenseReceiptKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tExpenseReceipt' 
			AND t.WriteOff = 1
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tVoucherDetail t (nolock) ON bd.EntityKey = t.VoucherDetailKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tVoucherDetail' 
			AND t.WriteOff = 1
				)
				RETURN -5



		END -- Old transfers
			


	IF @NewTransfers = 1
		BEGIN
			-- same validation as spProcessTranTransfers 
						
		  
	-- no WO and out of WIP
	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tTime t (nolock) ON bd.EntityGuid = t.TimeKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tTime' 
			AND t.WriteOff = 1
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tMiscCost t (nolock) ON bd.EntityKey = t.MiscCostKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tMiscCost' 
			AND t.WriteOff = 1
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tExpenseReceipt t (nolock) ON bd.EntityKey = t.ExpenseReceiptKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tExpenseReceipt' 
			AND t.WriteOff = 1
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -5

	IF EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tVoucherDetail t (nolock) ON bd.EntityKey = t.VoucherDetailKey 
			WHERE bd.BillingKey = @BillingKey
			AND bd.Action = 5
			AND bd.Entity = 'tVoucherDetail' 
			AND t.WriteOff = 1
			AND t.WIPPostingOutKey <> 0
				)
				RETURN -5

		END -- New transfers
			
				  
	RETURN 1
GO
