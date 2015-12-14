USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMCRealizedGain]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMCRealizedGain]
	(
	@CompanyKey int
	,@GLCompanyKey int			= -1    -- -1 All, 0 NULL, >0 valid GLCompany
	,@UserKey int				= null
	,@CurrencyID varchar(10)	= null
	,@DateOption int			= 0		-- 0 date range applied to InvoiceDate, 1 PostingDate 
	,@StartDate smalldatetime	= null
	,@EndDate smalldatetime		= null
	,@PostStatus int			= 0		-- 0 Posted/non Posted, 1 Posted Only
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 08/19/13 GHL 10.571   Creation for multi currencies 
  ||                       Reports realized gain/loss when applying payments to invoices
  || 08/20/13 GHL 10.571   Added DateOption and PostStatus so that it will match the GL if 
  ||                       DateOption = 1 and PostStatus = 1
  || 08/23/13 GHL 10.571   Pulling now 2 reference numbers + date range should be applied
  ||                       to entity that causes the realized gain (i.e) on prepayment, this 
  ||                       is the invoice
  || 08/30/13 GHL 10.571   Showing now amounts in HC at both rates (Payment + Invoice)
  || 01/16/14 GHL 10.576   For credits, use credit date because this is what we do in GL Posting
  */

  	SET NOCOUNT ON

	/*
	Dates used for the data range (later date or date at which the gain realization occurs)

	receipt					receipt date
	credit invoice			credit invoice date because of Posting
	payment					payment date
	credit voucher			real voucher date because it will usually be after
	adv bill				credit invoice date because of Posting
	CC charge applied to V	credit card charge date because it is after voucher

	I calculate a gain as:
	- in AR = Amount applied * (Payment Rate - Invoice Rate)
	- in AP = Amount applied * (Invoice Rate - Payment Rate) = -1 * Amount applied * (Payment Rate - Invoice Rate)

	*/

	create table #realized (
		AppType varchar(30) null			-- Unique application type, not displayed 
		,AppTypeName varchar(100) null		-- same as Type, but can be changed. Displayed
		,GLCompanyKey int null
		,AppKey int null
		,PaymentKey int null
		,InvoiceKey int null
		,AppDate  smalldatetime null
		,AppPostingDate  smalldatetime null
		,Description varchar(250) null
		,Amount money null
		,CurrencyID varchar(10) null
		,PaymentExchangeRate decimal(24, 6) null
		,InvoiceExchangeRate decimal(24, 6) null
		,PaymentReferenceNumber varchar(100) null
		,InvoiceReferenceNumber varchar(100) null
		,Gain money null
		)

	-- HC should not be null
	declare @HomeCurrencyID varchar(10)
	Declare @RestrictToGLCompany int

	select @HomeCurrencyID = CurrencyID 
	from tPreference (nolock) where CompanyKey = @CompanyKey
	 
	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	if @StartDate is null
		select @StartDate = '01/01/1900'
	if @EndDate is null
		select @EndDate = '01/01/2050'


	insert #realized (
		AppType 
		,AppTypeName
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tCheckAppl' 
		,'Receipt'
		,c.GLCompanyKey
		,ca.CheckApplKey
		,ca.CheckKey
		,ca.InvoiceKey
		,c.CheckDate
		,c.PostingDate
		,co.CompanyName
		,ca.Amount
		,c.CurrencyID
		,c.ExchangeRate
		,i.ExchangeRate
		,c.ReferenceNumber 
		,i.InvoiceNumber 
		,ROUND(ca.Amount * (c.ExchangeRate - i.ExchangeRate), 2)
	from   tCheckAppl ca (nolock)
		inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey 
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		inner join tCompany co (nolock) on c.ClientKey = co.CompanyKey
	where c.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (c.CheckDate >= @StartDate and  c.CheckDate <= @EndDate))
			Or
			(@DateOption = 1 and (c.PostingDate >= @StartDate and  c.PostingDate <= @EndDate))
			)
		and   isnull(c.CurrencyID, '') <> @HomeCurrencyID
		and   c.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(c.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) )
		AND   (c.Posted >= @PostStatus)
		AND   ca.Prepay = 0

	insert #realized (
		AppType 
		,AppTypeName
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tCheckApplPrepay' 
		,'Receipt'
		,c.GLCompanyKey
		,ca.CheckApplKey
		,ca.CheckKey
		,ca.InvoiceKey
		,i.InvoiceDate -- because this is a prepayment
		,i.PostingDate
		,co.CompanyName
		,ca.Amount
		,c.CurrencyID
		,c.ExchangeRate
		,i.ExchangeRate
		,c.ReferenceNumber 
		,i.InvoiceNumber 
		,ROUND(ca.Amount * (c.ExchangeRate - i.ExchangeRate), 2)
	from   tCheckAppl ca (nolock)
		inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey 
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		inner join tCompany co (nolock) on c.ClientKey = co.CompanyKey
	where c.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (i.InvoiceDate >= @StartDate and  i.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (c.PostingDate >= @StartDate and  c.PostingDate <= @EndDate))
			)
		and   isnull(c.CurrencyID, '') <> @HomeCurrencyID
		and   c.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(c.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) )
		AND   (c.Posted >= @PostStatus)
		AND   ca.Prepay = 1

	insert #realized (
		AppType 
		,AppTypeName
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tInvoiceCredit'
	    ,'Credit Invoice'
		,i.GLCompanyKey
		,ic.InvoiceCreditKey
		,ic.CreditInvoiceKey
		,ic.InvoiceKey
		,cr.InvoiceDate
		,cr.PostingDate
		,co.CompanyName
		,ic.Amount
		,i.CurrencyID
		,cr.ExchangeRate
		,i.ExchangeRate
		,cr.InvoiceNumber
		,i.InvoiceNumber
		,ROUND(ic.Amount * (cr.ExchangeRate - i.ExchangeRate), 2)
	from   tInvoiceCredit ic (nolock)
		inner join tInvoice cr (nolock) on ic.CreditInvoiceKey = cr.InvoiceKey 
		inner join tInvoice i (nolock) on ic.InvoiceKey = i.InvoiceKey
		inner join tCompany co (nolock) on i.ClientKey = co.CompanyKey
	where cr.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (cr.InvoiceDate >= @StartDate and  cr.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (cr.PostingDate >= @StartDate and  cr.PostingDate <= @EndDate))
			)
		and   isnull(cr.CurrencyID, '')  <> @HomeCurrencyID
		and   cr.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(cr.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(cr.GLCompanyKey, 0)) )
		AND   (cr.Posted >= @PostStatus)

	insert #realized (
		AppType
		,AppTypeName 
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tPaymentDetail'
		,'Payment'
		,p.GLCompanyKey
		,pd.PaymentDetailKey
		,p.PaymentKey
		,pd.VoucherKey
		,p.PaymentDate
		,p.PostingDate
		,co.CompanyName
		,pd.Amount
		,p.CurrencyID
		,p.ExchangeRate
		,v.ExchangeRate
		,p.CheckNumber
		,v.InvoiceNumber
		,-1 * ROUND(pd.Amount * (p.ExchangeRate - v.ExchangeRate), 2) -- X by -1, because if payment is more than voucher, we loose
	from   tPaymentDetail pd (nolock)
		inner join tPayment p (nolock) on pd.PaymentKey = p.PaymentKey 
		inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		inner join tCompany co (nolock) on p.VendorKey = co.CompanyKey
	where p.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (p.PaymentDate >= @StartDate and  p.PaymentDate <= @EndDate))
			Or
			(@DateOption = 1 and (p.PostingDate >= @StartDate and  p.PostingDate <= @EndDate))
			)
		and   isnull(p.CurrencyID, '')  <> @HomeCurrencyID
		and   p.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(p.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		AND   (p.Posted >= @PostStatus)
		AND    pd.Prepay = 0

	insert #realized (
		AppType
		,AppTypeName 
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tPaymentDetailPrepay'
		,'Payment'
		,p.GLCompanyKey
		,pd.PaymentDetailKey
		,p.PaymentKey
		,pd.VoucherKey
		,v.InvoiceDate
		,v.PostingDate
		,co.CompanyName
		,pd.Amount
		,p.CurrencyID
		,p.ExchangeRate
		,v.ExchangeRate
		,p.CheckNumber
		,v.InvoiceNumber
		,-1 * ROUND(pd.Amount * (p.ExchangeRate - v.ExchangeRate), 2) -- X by -1, because if payment is more than voucher, we loose
	from   tPaymentDetail pd (nolock)
		inner join tPayment p (nolock) on pd.PaymentKey = p.PaymentKey 
		inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		inner join tCompany co (nolock) on p.VendorKey = co.CompanyKey
	where p.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (v.InvoiceDate >= @StartDate and  v.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (v.PostingDate >= @StartDate and  v.PostingDate <= @EndDate))
			)
		and   isnull(p.CurrencyID, '')  <> @HomeCurrencyID
		and   p.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(p.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		AND   (p.Posted >= @PostStatus)
		AND    pd.Prepay = 1

	insert #realized (
		AppType 
		,AppTypename
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tVoucherCredit' 
		,'Credit Voucher'
		,v.GLCompanyKey
		,vc.VoucherCreditKey
		,vc.CreditVoucherKey
		,vc.VoucherKey
		,cr.InvoiceDate
		,cr.PostingDate
		,co.CompanyName
		,vc.Amount
		,v.CurrencyID
		,cr.ExchangeRate
		,v.ExchangeRate
		,cr.InvoiceNumber
		,v.InvoiceNumber
		,-1 * ROUND(vc.Amount * (cr.ExchangeRate - v.ExchangeRate), 2)
	from   tVoucherCredit vc (nolock)
		inner join tVoucher cr (nolock) on vc.CreditVoucherKey = cr.VoucherKey 
		inner join tVoucher v (nolock) on vc.VoucherKey = v.VoucherKey
		inner join tCompany co (nolock) on cr.VendorKey = co.CompanyKey
	where cr.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (cr.InvoiceDate >= @StartDate and  cr.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (cr.PostingDate >= @StartDate and  cr.PostingDate <= @EndDate))
			)
		and   isnull(cr.CurrencyID, '')  <> @HomeCurrencyID
		and   cr.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(cr.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(cr.GLCompanyKey, 0)) )
		AND   (cr.Posted >= @PostStatus)

	insert #realized (
		AppType 
		,AppTypeName
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tInvoiceAdvanceBill' 
		,'Adv Billing'
		,i.GLCompanyKey
		,iab.InvoiceAdvanceBillKey
		,iab.AdvBillInvoiceKey
		,iab.InvoiceKey
		,i.InvoiceDate -- I think it is more accurate to show the real invoice date
		,i.PostingDate
		,co.CompanyName
		,iab.Amount
		,i.CurrencyID
		,ab.ExchangeRate
		,i.ExchangeRate
		,ab.InvoiceNumber
		,i.InvoiceNumber
		,ROUND(iab.Amount * (ab.ExchangeRate - i.ExchangeRate), 2)
	from   tInvoiceAdvanceBill iab (nolock)
		inner join tInvoice ab (nolock) on iab.AdvBillInvoiceKey = ab.InvoiceKey 
		inner join tInvoice i (nolock) on iab.InvoiceKey = i.InvoiceKey
		inner join tCompany co (nolock) on i.ClientKey = co.CompanyKey
	where i.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (i.InvoiceDate >= @StartDate and  i.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (i.PostingDate >= @StartDate and  i.PostingDate <= @EndDate))
			)
		and   isnull(i.CurrencyID, '')  <> @HomeCurrencyID
		and   i.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(i.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
		AND   (i.Posted >= @PostStatus)

	insert #realized (
		AppType 
		,AppTypeName
		,GLCompanyKey
		,AppKey 
		,PaymentKey 
		,InvoiceKey 
		,AppDate
		,AppPostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,PaymentReferenceNumber 
		,InvoiceReferenceNumber 
		,Gain)
	select 'tVoucherCC' 
		,'Credit Card'
		,ccc.GLCompanyKey
		,0 -- none
		,vcc.VoucherCCKey
		,vcc.VoucherKey
		,ccc.InvoiceDate -- I think it is more accurate to show the CC charge date
		,ccc.PostingDate
		,co.CompanyName
		,vcc.Amount
		,ccc.CurrencyID
		,ccc.ExchangeRate
		,v.ExchangeRate
		,ccc.InvoiceNumber
		,v.InvoiceNumber
		,-1 * ROUND(vcc.Amount * (ccc.ExchangeRate - v.ExchangeRate), 2)
	from   tVoucherCC vcc (nolock)
		inner join tVoucher ccc (nolock) on vcc.VoucherCCKey = ccc.VoucherKey 
		inner join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey 
		inner join tCompany co (nolock) on v.VendorKey = co.CompanyKey
	where v.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (ccc.InvoiceDate >= @StartDate and  ccc.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (ccc.PostingDate >= @StartDate and  ccc.PostingDate <= @EndDate))
			)
		and   isnull(ccc.CurrencyID, '')  <> @HomeCurrencyID
		and   ccc.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(ccc.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(ccc.GLCompanyKey, 0)) )
		AND   (ccc.Posted >= @PostStatus)

	delete from #realized where isnull(Gain, 0) = 0

	-- If the user selected ALL Companies and we restrict
	-- we need to look up into tUserGLCompanyAccess
	IF @GLCompanyKey =-1 AND @RestrictToGLCompany = 1
	begin
		update #realized set GLCompanyKey = isnull(GLCompanyKey, 0)

		-- this does not delete null GLCompanyKey
		delete #realized
		where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
	end

	if @DateOption = 0
		select AppDate as DisplayDate
		, ROUND(Amount * PaymentExchangeRate, 2) as HPAmount 
		, ROUND(Amount * InvoiceExchangeRate, 2) as HIAmount 
		, * 
		from #realized order by AppDate
	else
		select AppPostingDate as DisplayDate
		, ROUND(Amount * PaymentExchangeRate, 2) as HPAmount 
		, ROUND(Amount * InvoiceExchangeRate, 2) as HIAmount 
		, * 
		from #realized order by AppPostingDate
	
	RETURN 1
GO
