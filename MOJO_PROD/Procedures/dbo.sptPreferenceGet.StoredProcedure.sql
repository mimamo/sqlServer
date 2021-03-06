USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceGet]
	@CompanyKey int,
	@CheckTime smalldatetime = NULL, --Optional because it's used in many places
	@UserKey int = null
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/12/07 GHL 8.5     Added 2 new vendor invoice accounts for wip posting
|| 02/11/08 CRG 1.0.0.0 Added @CheckTime for the ListManager
|| 12/17/09 RLB 10.515  Added TimeZoneIndex for mail settings page
|| 03/15/13 GHL 10.565  Temporarily added IOBillAt and BCBillAt to fix problem with media estimate
||                      will be removed after 10.565
*/

IF @CheckTime IS NULL
	OR EXISTS
			(SELECT NULL
			FROM	tPreference (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		LastModified > @CheckTime)
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
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPMediaWOAccountKey) as WIPMediaWOAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherAssetAccountKey) as WIPVoucherAssetAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.WIPVoucherWOAccountKey) as WIPVoucherWOAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.LaborOverUnderAccountKey) as LaborOverUnderAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.ExpenseOverUnderAccountKey) as ExpenseOverUnderAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POAccruedExpenseAccountKey) as POAccruedExpenseAccountNumber
			,(Select AccountNumber from tGLAccount (nolock) Where tGLAccount.GLAccountKey = tPreference.POPrebillAccrualAccountKey) as POPrebillAccrualAccountNumber
			,(Select ClassID from tClass (nolock) Where tClass.ClassKey = tPreference.DefaultClassKey) AS DefaultClassID
			,(Select TimeZoneIndex from tUser (nolock) where UserKey = @UserKey) as TimeZoneIndex
			,0 as IOBillAt
			,0 as BCBillAt
	FROM	tPreference (NOLOCK) 
	WHERE	CompanyKey = @CompanyKey
   
 RETURN 1
GO
