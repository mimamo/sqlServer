USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGet]
	@VoucherKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/31/07 BSH 8.5     (9659)Get GLCompanyName and OfficeName
|| 08/21/07 BSH 8.5     (9659)Added @LineCount to lock project on header. 
|| 11/09/07 GHL 8.5     Changed WIPPostingInKey > 0 to WIPPostingInKey <> 0
|| 04/28/09 GHL 10.024  Changed logic for @Billed flag so that we can edit the voucher even if lines are marked as billed
||                      i.e. changed (WriteOff = 1 or not InvoiceLineKey is null) 
||                      to (WriteOff = 1 or IsNull(InvoiceLineKey, 0) > 0 )
|| 06/09/09 GWG 10.026  Added the Marked as Billed flag so that the status would show.
|| 09/16/09 GHL 10.5    (63192) Added sales tax info 
|| 01/12/10 GHL 10.516  (72155) Ignore WIP due to transfers
|| 01/14/10 GHL 10.516  (72384) Ignore Marked As Billed due to transfers
|| 08/09/11 GHL 10.547  Added vendor default expense account info
|| 08/12/11 MFT 10.547  Added APAccountName & APAccountNumber to support lookup
|| 08/23/11 GHL 10.547  Added BoughtFrom info + created by info + approved by info + bought by info
||                      + AP account Full name
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
|| 11/03/11 GHL 10.459 Added recurring info
|| 11/29/11 GHL 10.550 Added tVoucherCC contribution to calculate AppliedPayment
|| 01/18/12 GHL 10.552 Added tVoucherCC to determine Paid flag
|| 04/03/12 GHL 10.555 Added GLCompanyFullName
|| 08/21/12 GHL 10.559 (151957) Added OfficeID
|| 09/17/12 GHL 10.560 Added CompanyName (used instead of VendorName in flex screen)
|| 12/3/13  GHL 10.575  If a payment is posted, the currency rate is locked
||                      because the realized gain has been calculated
|| 12/9/13  GHL 10.575  Added ProjectBillable to set tVoucherDetail.Billable 
|| 01/17/14 GHL 10.576  Added field CreditPosted to warn user if the exchange rate changes
|| 10/07/14 CRG 10.585  Added ViewedByName
|| 10/30/14 MAS 10.585  ViewedByName comes from tVoucher now as we are not using ViewByKey
|| 01/08/15 MAS 10.587  Added Publication
|| 02/10/15 GHL 10.589  Added StationID and CompanyMediaName + MediaKind (to support all company media)
*/


Declare @Billed int, @MarkedAsBilled int, @Paid int, @WIPPost int, @UsePO int
Declare @Cleared int, @BillingDetail int, @LineCount int
Declare @CreditPosted int

IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and (WriteOff = 1 or IsNull(InvoiceLineKey, 0) > 0 ) )
	Select @Billed = 1	
IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and InvoiceLineKey = 0 
	and TransferToKey is null)
	Select @MarkedAsBilled = 1	
IF EXISTS(SELECT 1 FROM tPaymentDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and ISNULL(Prepay, 0) = 0)
	Select @Paid = 1
IF EXISTS(SELECT 1 FROM tVoucherCC (NOLOCK) WHERE VoucherKey = @VoucherKey )
	Select @Paid = 1
IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey 
	and (WIPPostingInKey <> 0 or WIPPostingOutKey <> 0)
	and  TransferToKey is null)
	Select @WIPPost = 1
IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and PurchaseOrderDetailKey > 0)
	Select @UsePO = 1
If Exists(Select 1 from tTransaction (NOLOCK) Where Entity in ('VOUCHER','CREDITCARD') And EntityKey = @VoucherKey
			And   Cleared = 1 
			)
	Select @Cleared = 1
if exists(Select 1 from tBillingDetail bd (nolock)
					inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
				Where vd.VoucherKey = @VoucherKey
				And   bd.Entity = 'tVoucherDetail'
				And   b.Status < 5)
	Select @BillingDetail = 1
else
	Select @BillingDetail = 0
if exists (
			select 1
			from   tVoucherCredit vc (nolock)
				inner join tVoucher cr (nolock) on vc.CreditVoucherKey = cr.VoucherKey
			where  vc.VoucherKey = @VoucherKey
			and    cr.Posted = 1
			and    isnull(cr.CurrencyID, '') <> ''
			and    isnull(cr.OpeningTransaction, 0) = 0
			)
	Select @CreditPosted = 1

Select @LineCount = COUNT(*) from tVoucherDetail (NOLOCK) Where VoucherKey = @VoucherKey

-- These vars are required to get the Rate History displayed on the UI for each currency 
DECLARE @CompanyKey int
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @InvoiceDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int
DECLARE @PCurrencyID varchar(10)
DECLARE @PExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @PRateHistory int
DECLARE @LockRate int
DECLARE @CreditCard int

declare @RecurringParentKey int			-- this is the recurring parent voucher
declare @ParentRecurringTranKey int		-- this is the tRecurTran key of the recurring parent voucher

select @RecurringParentKey = v.RecurringParentKey
      ,@CompanyKey = v.CompanyKey
	  ,@GLCompanyKey = isnull(v.GLCompanyKey, 0) 
      ,@CurrencyID = v.CurrencyID
	  ,@PCurrencyID = v.PCurrencyID
	  ,@InvoiceDate = v.InvoiceDate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	  ,@CreditCard = v.CreditCard
from   tVoucher v (nolock)
inner join tPreference pref (nolock) on v.CompanyKey = pref.CompanyKey
where  v.VoucherKey = @VoucherKey

if isnull(@RecurringParentKey, 0) > 0
	select @ParentRecurringTranKey = RecurTranKey 
	from   tRecurTran (nolock)
	where  Entity in ('VOUCHER', 'CREDITCARD') 
	and    EntityKey = @RecurringParentKey

-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
begin
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @InvoiceDate, @ExchangeRate output, @RateHistory output

	-- we lock the rate if a payment is posted, because the Realized Gain has been calculated
	if @VoucherKey > 0
		if exists (select 1 from tPaymentDetail pd (nolock)
				inner join tPayment p (nolock) on pd.PaymentKey = p.PaymentKey
				where pd.VoucherKey = @VoucherKey
				and   pd.Prepay = 0
				and   p.Posted = 1
				)
				select @LockRate = 1

	-- for real vouchers (not CCC) check also if any credit card is posted
	if @VoucherKey > 0 And @CreditCard = 0
		if exists (select 1 from tVoucherCC vcc (nolock)
				inner join tVoucher cc (nolock) on vcc.VoucherCCKey = cc.VoucherKey
				where vcc.VoucherKey = @VoucherKey
				and   cc.Posted = 1
				)
				select @LockRate = 1

end
if @MultiCurrency = 1 and isnull(@PCurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @InvoiceDate, @PExchangeRate output, @PRateHistory output


	SELECT 
		v.*, 
		c.VendorID, 
		c.CompanyName,
		c.CompanyName AS VendorName,
		gl.AccountNumber as APAccountNumber,
		gl.AccountName as APAccountName,
		gl.AccountNumber + ' - ' + gl.AccountName as APAccountFullName,
		cl.ClassID,
		p.ProjectNumber,
		p.ProjectName,
		p.GetMarkupFrom,
		case when isnull(p.NonBillable, 0) = 1 then 0 else 1 end as ProjectBillable,
		glc.GLCompanyID,
		glc.GLCompanyName,
		isnull(glc.GLCompanyID + ' - ', '') + glc.GLCompanyName as GLCompanyFullName,
		o.OfficeID,
		o.OfficeName,
		ISNULL(@Billed, 0) as Billed,
		ISNULL(@MarkedAsBilled, 0) as MarkedAsBilled,
		ISNULL(@Paid, 0) as Paid,
		ISNULL(@Cleared, 0) as Cleared,
		ISNULL(@UsePO, 0) as UsePO,
		ISNULL(@WIPPost, 0) as WIPPost,
		ISNULL(@BillingDetail, 0) as BillingDetail,
		ISNULL((Select Sum(TotalCost) from tVoucherDetail (nolock) Where tVoucherDetail.VoucherKey = v.VoucherKey and ISNULL(PurchaseOrderDetailKey, 0) = 0), 0) as ExpenseTotal,
		ISNULL((Select Sum(TotalCost) from tVoucherDetail (nolock) Where tVoucherDetail.VoucherKey = v.VoucherKey and PurchaseOrderDetailKey > 0), 0) as POTotal,
		ISNULL((Select Sum(Amount) from tVoucherCredit (nolock) Where tVoucherCredit.VoucherKey = @VoucherKey), 0) as AppliedCredit,
		ISNULL((Select Sum(Amount) from tVoucherCredit (nolock) Where tVoucherCredit.CreditVoucherKey = @VoucherKey), 0) as AppliedOutCredit,
		ISNULL((Select Sum(Amount + DiscAmount) from tPaymentDetail (nolock) Where tPaymentDetail.VoucherKey = @VoucherKey), 0) 
		+ISNULL((Select Sum(Amount) from tVoucherCC (nolock) Where tVoucherCC.VoucherKey = @VoucherKey), 0) 
		as AppliedPayment,
		ISNULL(@LineCount, 0) as LineCount,
		st1.SalesTaxName as SalesTax1Name,
		st1.TaxRate as Tax1Rate,
		st1.PiggyBackTax as PiggyBackTax1,
		st2.SalesTaxName as SalesTax2Name,
		st2.TaxRate as Tax2Rate,
		st2.PiggyBackTax as PiggyBackTax2,

		gle.GLAccountKey as VendorDefaultExpenseAccountKey,
		gle.AccountNumber as VendorDefaultExpenseAccountNumber,
		gle.AccountName as VendorDefaultExpenseAccountName,

		bf.VendorID as BoughtFromVendorID,
		bf.CompanyName as BoughtFromCompanyName,

		isnull(uc.FirstName + ' ', '') + isnull(uc.LastName, '') as CreatedByName,
		isnull(ua.FirstName + ' ', '') + isnull(ua.LastName, '') as ApprovedByName,
		isnull(ub.FirstName + ' ', '') + isnull(ub.LastName, '') as BoughtByName,

		@ParentRecurringTranKey as ParentRecurringTranKey,

		@RateHistory as RateHistory,
		@PRateHistory as PRateHistory,
		isnull(@LockRate, 0) as LockRate,
		isnull(@CreditPosted, 0) as CreditPosted,
		cm.Name as Publication,
		cm.StationID,
		cm.Name as CompanyMediaName,
		cm.MediaKind
	FROM 
		tCompany c (nolock)
		INNER JOIN tVoucher v (nolock) ON c.CompanyKey = v.VendorKey
		LEFT OUTER JOIN tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tOffice o (nolock) on v.OfficeKey = o.OfficeKey 
		LEFT OUTER JOIN tProject p (nolock) ON v.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tGLAccount gle (nolock) on c.DefaultExpenseAccountKey = gle.GLAccountKey
		LEFT OUTER JOIN tClass cl (nolock) on v.ClassKey = cl.ClassKey
		LEFT OUTER JOIN tSalesTax st1 (nolock) on v.SalesTaxKey = st1.SalesTaxKey
		LEFT OUTER JOIN tSalesTax st2 (nolock) on v.SalesTax2Key = st2.SalesTaxKey
		LEFT OUTER JOIN tCompany bf (nolock) on v.BoughtFromKey = bf.CompanyKey
		LEFT OUTER JOIN tUser uc (nolock) on v.CreatedByKey = uc.UserKey
		LEFT OUTER JOIN tUser ua (nolock) on v.ApprovedByKey = ua.UserKey
		LEFT OUTER JOIN tUser ub (nolock) on v.BoughtByKey = ub.UserKey
		LEFT OUTER JOIN tCompanyMedia cm (nolock) on v.CompanyMediaKey = cm.CompanyMediaKey
	WHERE
		VoucherKey = @VoucherKey

	RETURN 1
GO
