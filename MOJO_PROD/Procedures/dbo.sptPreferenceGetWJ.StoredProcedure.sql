USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGetWJ]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceGetWJ]
	@CompanyKey int,
	@UserKey int = null
AS --Encrypt

/*
|| When     Who Rel     What
|| 1/12/10  RLB 10516   Created for new Flex Transaction Preference page
|| 3/18/10  RLB 10520   Added Account Name and Billing ID and Name for Control Accounts flex page
|| 4/19/10  GWG 10522   Added default class id and name
|| 12/02/10 GHL 10539   Added media and voucher income account info
|| 07/20/11 RLB 10546   (116481) Added DefaultGLCompany information
|| 08/19/11 RLB 10547   (108788) Added CheckMethod
|| 06/19/12 RLB 10557   Added for HMI change from company to user time detail options
|| 11/30/12 GHL 10562   Added forecast accounts
|| 09/04/13 GHL 10572   Added multi currency fields and validation
|| 04/03/14 GHL 10578   Added forecast cost account
|| 03/25/15 MAS 10590   Added tActivityType left outer to get DefaultActivityTypeName for Plantimun
*/

Declare @CurrencyLocked int
Declare @CurrencyID varchar(10)
select @CurrencyID = CurrencyID from tPreference (nolock) where CompanyKey =  @CompanyKey

Select @CurrencyLocked = 0
-- I lock the home currency and currency flag as soon as a multi curr transaction exists 
if isnull(@CurrencyID, '') <> ''
begin
	if exists (select 1 from tGLAccount (nolock) 
		where CompanyKey = @CompanyKey 
		and CurrencyID is not null 
		and CurrencyID <> @CurrencyID) 
			select @CurrencyLocked = 1

	if @CurrencyLocked = 0 And exists (select 1 from tTransaction (nolock) 
		where CompanyKey = @CompanyKey 
		and CurrencyID is not null 
		and CurrencyID <> @CurrencyID) 
			select @CurrencyLocked = 1

end

	SELECT	tPreference.*
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultARAccountKey) as DefaultARAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey) as DefaultSalesAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultAPAccountKey) as DefaultAPAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultExpenseAccountKey) as DefaultExpenseAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultCashAccountKey) as DefaultCashAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WriteOffAccountKey) as WriteOffAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.AdvBillAccountKey) as AdvBillAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedCashAccountKey) as UnappliedCashAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedPaymentAccountKey) as UnappliedPaymentAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DiscountAccountKey) as DiscountAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborAssetAccountKey) as WIPLaborAssetAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborIncomeAccountKey) as WIPLaborIncomeAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborWOAccountKey) as WIPLaborWOAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseAssetAccountKey) as WIPExpenseAssetAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseIncomeAccountKey) as WIPExpenseIncomeAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseWOAccountKey) as WIPExpenseWOAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaAssetAccountKey) as WIPMediaAssetAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaIncomeAccountKey) as WIPMediaIncomeAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaWOAccountKey) as WIPMediaWOAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherAssetAccountKey) as WIPVoucherAssetAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherIncomeAccountKey) as WIPVoucherIncomeAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherWOAccountKey) as WIPVoucherWOAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.LaborOverUnderAccountKey) as LaborOverUnderAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ExpenseOverUnderAccountKey) as ExpenseOverUnderAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POAccruedExpenseAccountKey) as POAccruedExpenseAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POPrebillAccrualAccountKey) as POPrebillAccrualAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastLaborAccountKey) as ForecastLaborAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastProductionAccountKey) as ForecastProductionAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastMediaAccountKey) as ForecastMediaAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastCostAccountKey) as ForecastCostAccountNumber

			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.RealizedGainAccountKey) as RealizedGainAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.RoundingDiffAccountKey) as RoundingDiffAccountNumber
			
			,(Select ClassID from tClass (nolock) Where tClass.ClassKey = tPreference.DefaultClassKey) AS DefaultClassID
			,(Select ClassName from tClass (nolock) Where tClass.ClassKey = tPreference.DefaultClassKey) AS DefaultClassName
			,(Select GLCompanyID from tGLCompany (nolock) Where tGLCompany.GLCompanyKey = tPreference.DefaultGLCompanyKey) AS DefaultGLCompanyID
			,(Select GLCompanyName from tGLCompany (nolock) Where tGLCompany.GLCompanyKey = tPreference.DefaultGLCompanyKey) AS DefaultGLCompanyName
			,(Select TimeZoneIndex from tUser (nolock) where UserKey = @UserKey) as TimeZoneIndex
			,(Select RequireUserTimeDetails from tUser (nolock) where UserKey = @UserKey) as RequireUserTimeDetails
			,tTimeOption.ShowServicesOnGrid
			,tTimeOption.ReqProjectOnTime
			,tTimeOption.ReqServiceOnTime
			,tTimeOption.TimeSheetPeriod
			,tTimeOption.StartTimeOn
			,tTimeOption.AllowOverlap
			,tTimeOption.PrintAsGrid
			,tTimeOption.AllowCustomDates
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultARAccountKey) as DefaultARAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey) as DefaultSalesAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultAPAccountKey) as DefaultAPAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultExpenseAccountKey) as DefaultExpenseAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DefaultCashAccountKey) as DefaultCashAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WriteOffAccountKey) as WriteOffAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.AdvBillAccountKey) as AdvBillAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedCashAccountKey) as UnappliedCashAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.UnappliedPaymentAccountKey) as UnappliedPaymentAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.DiscountAccountKey) as DiscountAccountName

			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborAssetAccountKey) as WIPLaborAssetAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborIncomeAccountKey) as WIPLaborIncomeAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPLaborWOAccountKey) as WIPLaborWOAccountName
			
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseAssetAccountKey) as WIPExpenseAssetAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseIncomeAccountKey) as WIPExpenseIncomeAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPExpenseWOAccountKey) as WIPExpenseWOAccountName
			
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaAssetAccountKey) as WIPMediaAssetAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaIncomeAccountKey) as WIPMediaIncomeAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaWOAccountKey) as WIPMediaWOAccountName
			
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherAssetAccountKey) as WIPVoucherAssetAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherIncomeAccountKey) as WIPVoucherIncomeAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherWOAccountKey) as WIPVoucherWOAccountName
			
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.LaborOverUnderAccountKey) as LaborOverUnderAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ExpenseOverUnderAccountKey) as ExpenseOverUnderAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POAccruedExpenseAccountKey) as POAccruedExpenseAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POPrebillAccrualAccountKey) as POPrebillAccrualAccountName

			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastLaborAccountKey) as ForecastLaborAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastProductionAccountKey) as ForecastProductionAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastMediaAccountKey) as ForecastMediaAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ForecastCostAccountKey) as ForecastCostAccountName

			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.RealizedGainAccountKey) as RealizedGainAccountName
			,(Select AccountName from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.RoundingDiffAccountKey) as RoundingDiffAccountName
			
			,(Select WorkTypeID from tWorkType (nolock) where tWorkType.WorkTypeKey = tPreference.AdvBillItemKey) as AdvBillItemID
			,(Select WorkTypeName from tWorkType (nolock) where tWorkType.WorkTypeKey = tPreference.AdvBillItemKey) as AdvBillItemName
			,(Select CheckMethod from tCheckMethod (nolock) where tCheckMethod.CheckMethodKey = tPreference.CheckMethodKey) as CheckMethod

			,(Select Description from tCurrency (nolock) where tCurrency.CurrencyID = tPreference.CurrencyID) as CurrencyDescription
			,@CurrencyLocked as CurrencyLocked
			,tActivityType.TypeName as DefaultActivityTypeName
	FROM	tPreference (NOLOCK) 
	left outer join tTimeOption (nolock) on tPreference.CompanyKey = tTimeOption.CompanyKey
	left outer join tActivityType (nolock) on tPreference.DefaultActivityTypeKey = tActivityType.ActivityTypeKey
	WHERE	tPreference.CompanyKey = @CompanyKey

 RETURN 1
GO
