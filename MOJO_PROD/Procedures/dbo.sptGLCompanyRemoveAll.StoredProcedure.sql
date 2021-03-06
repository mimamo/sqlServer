USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyRemoveAll]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyRemoveAll]
	@CompanyKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/22/13 RLB 105.64  Added for GL Company enhancement remove all GL Companies from all transactions
|| 02/12/13 GHL 10.565  Added tBillingGroup, placed tGLBudgetDetail at the bottom 
|| 04/15/13 GWG 10.566  Added user and forecast to the tables
|| 08/13/13 RLB 10.571  (180046) Remove gl company on clients or vendors
|| 09/04/13 GHL 10.572  Added currency rates
|| 03/14/14 RLB 10.578  (209798) Remove tCCEntry entries
|| 04/10/14 RLB 10.579  (212536) remove CC GL Accounts
*/

	UPDATE tTransaction SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCashTransaction SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCashTransactionLine SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null
	
	UPDATE tProject SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tQuote SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tPurchaseOrder SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tVoucher SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCCEntry SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tPayment SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tInvoice SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tRetainer SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCheck SET GLCompanyKey = null WHERE ClientKey in (Select CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey) AND GLCompanyKey is not null

	UPDATE tJournalEntry SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tBilling SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tGLAccountRec SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tMediaEstimate SET GLCompanyKey = null  WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tDeposit SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND ISNULL(GLCompanyKey, 0) > 0

	UPDATE tCampaign SET GLCompanyKey = null  WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tWIPPosting SET GLCompanyKey = null  WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null
	
	UPDATE tBillingGroup SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tPreference SET UseGLCompany = 0, RequireGLCompany = 0, DefaultGLCompanyKey = NULL WHERE CompanyKey = @CompanyKey
	
	UPDATE tForecast SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tUser SET GLCompanyKey = null WHERE ISNULL(OwnerCompanyKey, CompanyKey) = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCompany SET GLCompanyKey = null WHERE OwnerCompanyKey = @CompanyKey AND GLCompanyKey is not null

	UPDATE tCurrencyRate SET GLCompanyKey = null WHERE CompanyKey = @CompanyKey AND GLCompanyKey is not null
	
	UPDATE tGLAccount  SET DefaultCCGLCompanyKey = null WHERE CompanyKey = @CompanyKey AND DefaultCCGLCompanyKey is not null AND  AccountType = 23 AND Rollup = 0

	-- Leave this one at the end
	UPDATE tGLBudgetDetail SET GLCompanyKey = -1 WHERE GLBudgetKey in (Select GLBudgetKey from tGLBudget (nolock) where CompanyKey = @CompanyKey) AND ISNULL(GLCompanyKey, 0) > 0
	
	RETURN 1
GO
