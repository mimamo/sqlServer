USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountDelete]
	@GLAccountKey int

AS --Encrypt

  /*
  || When     Who Rel        What
  || 06/12/12 QMD 10.5.5.7   Added delete from tGLAccountMultiCompanyPayments
  */


DECLARE @CompanyKey int

	Select @CompanyKey = CompanyKey from tGLAccount (nolock) Where GLAccountKey = @GLAccountKey

	IF EXISTS(SELECT 1 FROM tVoucher (nolock) WHERE APAccountKey = @GLAccountKey)
		RETURN -1

	IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) WHERE ExpenseAccountKey = @GLAccountKey)
		RETURN -1

	IF EXISTS(SELECT 1 FROM tInvoice (nolock) WHERE ARAccountKey = @GLAccountKey)
		RETURN -1

	IF EXISTS(SELECT 1 FROM tInvoiceLine (nolock) WHERE SalesAccountKey = @GLAccountKey)
		RETURN -1

	IF EXISTS(SELECT 1 FROM tCheck (nolock) WHERE CashAccountKey = @GLAccountKey)
		RETURN -1
		
	IF EXISTS(SELECT 1 FROM tCheckAppl (nolock) WHERE SalesAccountKey = @GLAccountKey)
		RETURN -1
		
	IF EXISTS(SELECT 1 FROM tPayment (nolock) WHERE CashAccountKey = @GLAccountKey)
		RETURN -1
		
	IF EXISTS(SELECT 1 FROM tPaymentDetail (nolock) WHERE GLAccountKey = @GLAccountKey)
		RETURN -1

	IF EXISTS(SELECT 1 FROM tItem (nolock) WHERE ExpenseAccountKey = @GLAccountKey)
		RETURN -1
		
	IF EXISTS(SELECT 1 FROM tJournalEntryDetail (nolock) WHERE GLAccountKey = @GLAccountKey)
		RETURN -1
			
	IF EXISTS(SELECT 1 FROM tTransaction (nolock) WHERE GLAccountKey = @GLAccountKey)
		RETURN -1
		
		
	IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE ParentAccountKey = @GLAccountKey)
		RETURN -2
		
	DELETE
	FROM tGLBudgetDetail
	WHERE
		GLAccountKey = @GLAccountKey 

	DELETE 
	FROM tGLAccountMultiCompanyPayments
	WHERE GLAccountKey =@GLAccountKey
			AND CompanyKey = @CompanyKey
		
	DELETE
	FROM tGLAccount
	WHERE
		GLAccountKey = @GLAccountKey 
		
	exec sptGLAccountOrder @CompanyKey, 0, 0, -1

	RETURN 1
GO
