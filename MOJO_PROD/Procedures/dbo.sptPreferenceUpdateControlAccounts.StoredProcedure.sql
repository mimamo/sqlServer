USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateControlAccounts]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateControlAccounts]
	@CompanyKey int,
	@GLClosedDate smalldatetime,
	@FirstMonth int,
	@NextJournalNumber int,
	@DefaultAPAccountKey int,
	@DefaultExpenseAccountKey int,
	@DefaultARAccountKey int,
	@DefaultSalesAccountKey int,
	@DefaultCashAccountKey int,
	@WriteOffAccountKey int,
	@AdvBillAccountKey int,
	@UnappliedCashAccountKey int,
	@UnappliedPaymentAccountKey int,
	@DiscountAccountKey int,
	@WIPLaborAssetAccountKey int,
	@WIPLaborIncomeAccountKey int,
	@WIPLaborWOAccountKey int,
	@WIPExpenseAssetAccountKey int,
	@WIPExpenseIncomeAccountKey int,
	@WIPExpenseWOAccountKey int,
	@WIPMediaAssetAccountKey int,
	@WIPMediaWOAccountKey int,
	@WIPVoucherAssetAccountKey int,
	@WIPVoucherWOAccountKey int,
	@WIPRecognizeCostRev tinyint,
	@AdvBillItemKey int,
	@PostSalesUsingDetail tinyint,
	@TrackOverUnder tinyint,
	@LaborOverUnderAccountKey int,
	@ExpenseOverUnderAccountKey int,
	@POAccruedExpenseAccountKey int,
	@POPrebillAccrualAccountKey int,
	@AccrueCostToItemExpenseAccount int,
	@RequireGLAccounts tinyint,
	@PostToGL tinyint,
	@TrackWIP tinyint,
	@TrackQuantityOnHand tinyint,
	@WIPClassFromDetail tinyint,
	@DefaultClassKey int,
	@DefaultExpenseAccountFromItem tinyint,
	@UseGLCompany tinyint,
	@RequireGLCompany tinyint,
	@DefaultGLCompanyKey int,
	@DefaultGLCompanySource smallint,
	@UseOffice tinyint,
	@RequireOffice tinyint,
	@UseDepartment tinyint,
	@RequireDepartment tinyint,
	@UseClass tinyint,
	@RequireClasses tinyint,
	@UseTasks tinyint,
	@RequireTasks tinyint,
	@UseItems tinyint,
	@RequireItems tinyint,
	@WIPBookVoucherToRevenue tinyint,
	@WIPMediaIncomeAccountKey int,
	@WIPVoucherIncomeAccountKey int,
	@WIPExpensesAtGross tinyint,
	@AdvBillAccountOnly tinyint,
	@MultiCompanyClosingDate tinyint,
	@RequireOfficeOnHeaders tinyint = 0,
	@ForecastLaborAccountKey int,
	@ForecastProductionAccountKey int,
	@ForecastMediaAccountKey int,
	@ForecastCostAccountKey int,
	@MultiCurrency tinyint,
	@CurrencyID varchar(10),
	@RoundingDiffAccountKey int,
	@RealizedGainAccountKey int,
	@WIPMiscCostAtGross tinyint,
	@CreditCardPayment tinyint,
	@WIPHoldTransactionNotPosted tinyint,
	@UndoWOAfterWIP tinyint


AS --Encrypt

/*
|| When     Who Rel     What
|| 03/18/10 RLB 10520   Created for Flash Control Accounts
|| 10/29/10 GHL 10.537  Added WIP voucher income fields
|| 03/10/11 GHL 10.542  (65558) Added AdvBillAccountOnly 
|| 07/20/11 RLB 10546   (116481) Added DefaultGLCompany
|| 03/28/12 GWG 10554   Added @DefaultGLCompanySource
|| 09/26/12 RLB 10560   Added Multi Company Closing Date Option for HMI
|| 10/01/12 GHL 10560   (155304) Added RequireOfficeOnHeaders for HMI
|| 11/30/12 GHL 10562   Added Forecast default account keys 
|| 09/03/13 GHL 10572   Added multi currency accounts
|| 03/18/14 RLB 10578   (205574) Added WIP MiscCost At Gross Option
|| 03/20/14 GHL 10578   Removed defaulting of currency on bank accounts
||                      because blank currency means home currency
|| 03/28/14 GHL 10578   Added CreditCardPayment parameter for cash basis posting
||                      If set, the cash basis records will be created when posting 
||                      the credit card charge instead of waiting for the receipts  
|| 04/03/14 GHL 10578   Added forecast cost account
|| 11/06/14 RLB 10586   Added WIPHoldTransactionNotPosted for Abelson Taylor
|| 01/06/15 GHL 10588   Added UndoWOAfterWIP for Abelson Taylor
||                      If 1, users can undo a writeoff even if it is has been posted to WIP
||                      A new transaction is created similar to transfer
*/

 DECLARE @CurrAdvBillAccountOnly tinyint,@CurrMultiCurrency tinyint, @CurrCreditCardPayment tinyint
 SELECT  @CurrAdvBillAccountOnly = ISNULL(AdvBillAccountOnly, 0) 
		,@CurrMultiCurrency = ISNULL(MultiCurrency, 0) 
		,@CurrCreditCardPayment = ISNULL(CreditCardPayment, 0) 
 FROM tPreference (NOLOCK) WHERE CompanyKey = @CompanyKey

 UPDATE
  tPreference
 SET
	GLClosedDate = @GLClosedDate,
	FirstMonth = @FirstMonth,
	NextJournalNumber = @NextJournalNumber,
	DefaultAPAccountKey = @DefaultAPAccountKey,
	DefaultExpenseAccountKey = @DefaultExpenseAccountKey,
	DefaultARAccountKey = @DefaultARAccountKey,
	DefaultSalesAccountKey = @DefaultSalesAccountKey,
	DefaultCashAccountKey = @DefaultCashAccountKey,
	WriteOffAccountKey = @WriteOffAccountKey,
	AdvBillAccountKey = @AdvBillAccountKey,
	UnappliedCashAccountKey = @UnappliedCashAccountKey,
	UnappliedPaymentAccountKey = @UnappliedPaymentAccountKey,
	DiscountAccountKey = @DiscountAccountKey,
	WIPLaborAssetAccountKey = @WIPLaborAssetAccountKey,
	WIPLaborIncomeAccountKey = @WIPLaborIncomeAccountKey,
	WIPLaborWOAccountKey = @WIPLaborWOAccountKey,
	WIPExpenseAssetAccountKey = @WIPExpenseAssetAccountKey,
	WIPExpenseIncomeAccountKey = @WIPExpenseIncomeAccountKey,
	WIPExpenseWOAccountKey = @WIPExpenseWOAccountKey,
	WIPMediaAssetAccountKey = @WIPMediaAssetAccountKey,
	WIPMediaWOAccountKey = @WIPMediaWOAccountKey,
	WIPVoucherAssetAccountKey = @WIPVoucherAssetAccountKey,
	WIPVoucherWOAccountKey = @WIPVoucherWOAccountKey,
	WIPRecognizeCostRev = @WIPRecognizeCostRev,
	AdvBillItemKey = @AdvBillItemKey,
	PostSalesUsingDetail = @PostSalesUsingDetail,
	TrackOverUnder = @TrackOverUnder,
	LaborOverUnderAccountKey = @LaborOverUnderAccountKey,
	ExpenseOverUnderAccountKey = @ExpenseOverUnderAccountKey,
	POAccruedExpenseAccountKey = @POAccruedExpenseAccountKey,
	POPrebillAccrualAccountKey = @POPrebillAccrualAccountKey,
	AccrueCostToItemExpenseAccount = @AccrueCostToItemExpenseAccount,
	RequireGLAccounts = @RequireGLAccounts,
	PostToGL = @PostToGL,
	TrackWIP = @TrackWIP,
	TrackQuantityOnHand = @TrackQuantityOnHand,
	DefaultClassKey = @DefaultClassKey,
	DefaultExpenseAccountFromItem = @DefaultExpenseAccountFromItem,
	UseGLCompany = @UseGLCompany,
	RequireGLCompany = @RequireGLCompany,
	DefaultGLCompanyKey = @DefaultGLCompanyKey,
	DefaultGLCompanySource = @DefaultGLCompanySource,
	UseOffice = @UseOffice,
	RequireOffice = @RequireOffice,
	UseDepartment = @UseDepartment,
	RequireDepartment = @RequireDepartment,
	UseClass = @UseClass,
	RequireClasses = @RequireClasses,
	UseTasks = @UseTasks,
	RequireTasks = @RequireTasks,
	UseItems = @UseItems,
	RequireItems = @RequireItems,
	WIPClassFromDetail = @WIPClassFromDetail, 
	WIPBookVoucherToRevenue = @WIPBookVoucherToRevenue,
	WIPMediaIncomeAccountKey = @WIPMediaIncomeAccountKey,
	WIPVoucherIncomeAccountKey = @WIPVoucherIncomeAccountKey, 
	WIPExpensesAtGross = @WIPExpensesAtGross,
	AdvBillAccountOnly = @AdvBillAccountOnly,
	MultiCompanyClosingDate = @MultiCompanyClosingDate,
	RequireOfficeOnHeaders = @RequireOfficeOnHeaders,
	ForecastLaborAccountKey = @ForecastLaborAccountKey,
	ForecastProductionAccountKey = @ForecastProductionAccountKey,
	ForecastMediaAccountKey = @ForecastMediaAccountKey,
	ForecastCostAccountKey = @ForecastCostAccountKey,
	MultiCurrency = @MultiCurrency,
	CurrencyID = @CurrencyID,
	RoundingDiffAccountKey = @RoundingDiffAccountKey,
	RealizedGainAccountKey = @RealizedGainAccountKey,
	WIPMiscCostAtGross = @WIPMiscCostAtGross,
	CreditCardPayment = @CreditCardPayment,
	WIPHoldTransactionNotPosted = @WIPHoldTransactionNotPosted,
	UndoWOAfterWIP = @UndoWOAfterWIP
 WHERE
  CompanyKey = @CompanyKey 


  IF @CurrAdvBillAccountOnly = 0 AND @AdvBillAccountOnly = 1 AND ISNULL(@AdvBillAccountKey, 0) > 0
  BEGIN
	
	UPDATE tInvoiceLine
	SET    tInvoiceLine.SalesAccountKey = @AdvBillAccountKey
	FROM   tInvoice i (NOLOCK)
	WHERE  tInvoiceLine.InvoiceKey = i.InvoiceKey
	AND    i.CompanyKey = @CompanyKey
	AND    i.Posted = 0
	AND    i.AdvanceBill = 1
	AND    tInvoiceLine.LineType = 2 -- Detail

  END 

 RETURN 1
GO
