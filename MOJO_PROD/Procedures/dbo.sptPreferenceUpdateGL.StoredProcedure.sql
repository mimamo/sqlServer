USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateGL]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateGL]
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
	@AccrueCostToItemExpenseAccount int
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 06/15/07 GHL 8.5    Added @AccrueCostToItemExpenseAccount for 8.5 gl invoice posting
|| 07/12/07 GHL 8.5    Added 2 new vendor invoice accounts for wip posting
*/

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
	AccrueCostToItemExpenseAccount = @AccrueCostToItemExpenseAccount  
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO
