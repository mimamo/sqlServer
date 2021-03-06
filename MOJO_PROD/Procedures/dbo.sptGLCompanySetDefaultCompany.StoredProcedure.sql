USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanySetDefaultCompany]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanySetDefaultCompany]
	@CompanyKey int,
	@GLCompanyKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/22/13 RLB 105.64  Added for GL Company enhancement set selected GL Company on all transactions that do not have one set
|| 02/12/13 GHL 10.565  Added tBillingGroup
|| 09/04/13 GHL 10.572  Added currency rates
|| 02/24/14 KMC 10.577  (206727) Added tUser
|| 03/14/14 RLB 10.578  (209798) Added tCCEntry
|| 04/10/14 RLB 10.579  (212536) Added CC GL Accounts
*/

	UPDATE tTransaction SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tCashTransaction SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tCashTransactionLine SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tProject SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tQuote SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tPurchaseOrder SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tVoucher SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tCCEntry set GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tPayment SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tInvoice SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tRetainer SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tCheck SET GLCompanyKey = @GLCompanyKey WHERE ClientKey in (Select CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey) AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tJournalEntry SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tBilling SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tGLAccountRec SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tMediaEstimate SET GLCompanyKey = @GLCompanyKey  WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tDeposit SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tCampaign SET GLCompanyKey = @GLCompanyKey  WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tWIPPosting SET GLCompanyKey = @GLCompanyKey  WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tBillingGroup SET GLCompanyKey = @GLCompanyKey  WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0

	UPDATE tPreference SET UseGLCompany = 1, RequireGLCompany = 1, DefaultGLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey

	UPDATE tCurrencyRate SET GLCompanyKey = @GLCompanyKey  WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0
	
	UPDATE tUser SET GLCompanyKey = @GLCompanyKey WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) = 0 AND Active = 1 AND ISNULL(Locked, 0) = 0

	UPDATE tGLAccount SET DefaultCCGLCompanyKey = @GLCompanyKey WHERE  CompanyKey = @CompanyKey AND ISNULL(DefaultCCGLCompanyKey, 0) = 0 AND  AccountType = 23 AND Rollup = 0

	-- Leave this one at the end
	UPDATE tGLBudgetDetail SET GLCompanyKey = @GLCompanyKey WHERE GLBudgetKey in (Select GLBudgetKey from tGLBudget (nolock) where CompanyKey = @CompanyKey) AND ISNULL(GLCompanyKey, 0) = 0
	
	RETURN 1
GO
