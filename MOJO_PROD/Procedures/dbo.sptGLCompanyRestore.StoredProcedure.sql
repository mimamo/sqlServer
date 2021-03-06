USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyRestore]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyRestore]
	@CompanyKey int
AS

/*
|| When     Who Rel     What
|| 02/25/13 GHL 10.565  Created to restore GL companies from a backup
*/

	SET NOCOUNT ON 
	
	Print 'tTransaction'	

	UPDATE tTransaction 
	SET    tTransaction.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tTransaction bak (nolock)
	WHERE  tTransaction.CompanyKey = @CompanyKey 
	AND    tTransaction.TransactionKey = bak.TransactionKey
	
	Print 'tCashTransaction'

	UPDATE tCashTransaction 
	SET    tCashTransaction.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tCashTransaction bak (nolock)
	WHERE  tCashTransaction.CompanyKey = @CompanyKey 
	AND    tCashTransaction.UIDCashTransactionKey = bak.UIDCashTransactionKey
	
	Print 'tCashTransactionLine'

	UPDATE tCashTransactionLine 
	SET    tCashTransactionLine.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tCashTransactionLine bak (nolock)
	WHERE  tCashTransactionLine.CompanyKey = @CompanyKey 
	AND    tCashTransactionLine.CashTransactionLineKey = bak.CashTransactionLineKey
	
	Print 'tProject'

	UPDATE tProject 
	SET    tProject.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tProject bak (nolock)
	WHERE  tProject.CompanyKey = @CompanyKey 
	AND    tProject.ProjectKey = bak.ProjectKey
	
	Print 'tQuote'

	UPDATE tQuote 
	SET    tQuote.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tQuote bak (nolock)
	WHERE  tQuote.CompanyKey = @CompanyKey 
	AND    tQuote.QuoteKey = bak.QuoteKey
	
	Print 'tPurchaseOrder'

	UPDATE tPurchaseOrder
	SET    tPurchaseOrder.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tPurchaseOrder bak (nolock)
	WHERE  tPurchaseOrder.CompanyKey = @CompanyKey 
	AND    tPurchaseOrder.PurchaseOrderKey = bak.PurchaseOrderKey
	
	Print 'tVoucher'

	UPDATE tVoucher 
	SET    tVoucher.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tVoucher bak (nolock)
	WHERE  tVoucher.CompanyKey = @CompanyKey 
	AND    tVoucher.VoucherKey = bak.VoucherKey
	
	Print 'tPayment'

	UPDATE tPayment 
	SET    tPayment.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tPayment bak (nolock)
	WHERE  tPayment.CompanyKey = @CompanyKey 
	AND    tPayment.PaymentKey = bak.PaymentKey
	
	Print 'tInvoice'

	UPDATE tInvoice 
	SET    tInvoice.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tInvoice bak (nolock)
	WHERE  tInvoice.CompanyKey = @CompanyKey 
	AND    tInvoice.InvoiceKey = bak.InvoiceKey
	
	Print 'tRetainer'

	UPDATE tRetainer 
	SET    tRetainer.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tRetainer bak (nolock)
	WHERE  tRetainer.CompanyKey = @CompanyKey 
	AND    tRetainer.RetainerKey = bak.RetainerKey
	
	Print 'tCheck'

	UPDATE tCheck 
	SET    tCheck.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tCheck bak (nolock)
	WHERE  tCheck.CompanyKey = @CompanyKey 
	AND    tCheck.CheckKey = bak.CheckKey
	
	Print 'tJournalEntry'

	UPDATE tJournalEntry
	SET    tJournalEntry.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tJournalEntry bak (nolock)
	WHERE  tJournalEntry.CompanyKey = @CompanyKey 
	AND    tJournalEntry.JournalEntryKey = bak.JournalEntryKey
	
	Print 'tBilling'

	UPDATE tBilling 
	SET    tBilling.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tBilling bak (nolock)
	WHERE  tBilling.CompanyKey = @CompanyKey 
	AND    tBilling.BillingKey = bak.BillingKey
	
	Print 'tGLAccountRec'

	UPDATE tGLAccountRec 
	SET    tGLAccountRec.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tGLAccountRec bak (nolock)
	WHERE  tGLAccountRec.CompanyKey = @CompanyKey 
	AND    tGLAccountRec.GLAccountRecKey = bak.GLAccountRecKey
	
	Print 'tMediaEstimate'

	UPDATE tMediaEstimate
	SET    tMediaEstimate.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tMediaEstimate bak (nolock)
	WHERE  tMediaEstimate.CompanyKey = @CompanyKey 
	AND    tMediaEstimate.MediaEstimateKey = bak.MediaEstimateKey
	
	Print 'tDeposit'

	UPDATE tDeposit 
	SET    tDeposit.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tDeposit bak (nolock)
	WHERE  tDeposit.CompanyKey = @CompanyKey 
	AND    tDeposit.DepositKey = bak.DepositKey
	
	Print 'tCampaign'

	UPDATE tCampaign 
	SET    tCampaign.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tCampaign bak (nolock)
	WHERE  tCampaign.CompanyKey = @CompanyKey 
	AND    tCampaign.CampaignKey = bak.CampaignKey

	Print 'tWIPPosting'

	UPDATE tWIPPosting 
	SET    tWIPPosting.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tWIPPosting bak (nolock)
	WHERE  tWIPPosting.CompanyKey = @CompanyKey 
	AND    tWIPPosting.WIPPostingKey = bak.WIPPostingKey

	Print 'tBillingGroup'

	UPDATE tBillingGroup 
	SET    tBillingGroup.GLCompanyKey = bak.GLCompanyKey 
	FROM   [Restore].dbo.tBillingGroup bak (nolock)
	WHERE  tBillingGroup.CompanyKey = @CompanyKey 
	AND    tBillingGroup.BillingGroupKey = bak.BillingGroupKey

	Print 'tPreference'

	UPDATE tPreference
	SET    tPreference.DefaultGLCompanyKey = bak.DefaultGLCompanyKey 
	FROM   [Restore].dbo.tPreference bak (nolock)
	WHERE  tPreference.CompanyKey = @CompanyKey 
	AND    tPreference.CompanyKey = bak.CompanyKey

	-- now these do not have a non composite primary key, so delete first and then reinsert
	delete tGLBudgetDetail
	from   tGLBudget bud
	where  tGLBudgetDetail.GLBudgetKey = bud.GLBudgetKey
	and    bud.CompanyKey = @CompanyKey

	insert tGLBudgetDetail
	select det.*
	from [Restore].dbo.tGLBudgetDetail det (nolock)
	inner join [Restore].dbo.tGLBudget bud (nolock) on det.GLBudgetKey = bud.GLBudgetKey
	where bud.CompanyKey  = @CompanyKey


	RETURN
GO
