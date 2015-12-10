USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerServiceItem]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerServiceItem]
	(
	@NewInvoiceKey INT
	,@BillingKey INT
	,@BillingMethod INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@BillingClassKey int
	,@ParentInvoiceLineKey int
	,@PostSalesUsingDetail tinyint
	)
AS --Encrypt

  /*
  || When     Who Rel     What
  || 12/02/14 GHL 10.587  Renamed original sp to spBillingInvoiceOneLinePerServiceItemFF (for Fixed Fee projects)
  ||                      Using this sp name for T&M case now 
  ||                      Calls core function spBillingPerServiceItem
  ||                      This spBillingPerServiceItem groups transactions by Service OR Item (not Service AND Item)
  */

	SET NOCOUNT ON

	truncate table #tran

	-- load transactions from #tBillingDetail to #tran
	exec spBillingLinesGetTrans @BillingKey

	-- if this is a FF project, there might be no transactions to bill
	if not exists (select 1 from #tran)
		return 1
	
	declare @RetVal int

	-- now call the core function (this is also used by mass billing)
	-- if anything goes wrong, the invoice will be deleted
	exec @RetVal = spBillingPerServiceItem @NewInvoiceKey , @ProjectKey 
			,@DefaultSalesAccountKey , @DefaultClassKey, @BillingClassKey, @PostSalesUsingDetail, @ParentInvoiceLineKey 
	  	
	truncate table #tran

	return @RetVal
GO
