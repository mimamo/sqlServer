USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMCUnrealizedGain]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMCUnrealizedGain]
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
  || 08/21/13 GHL 10.571   Creation for multi currencies 
  ||                       Reports unrealized gain/loss when applying payments to invoices
  || 08/30/13 GHL 10.571   Showing not amounts in HC at both rates (Payment + Invoice)
  || 02/18/14 GHL 10.577   Calculating now OpenAmount as a function of EndDate
  */

  	SET NOCOUNT ON

	/*
	I calculate a gain as:
	- in AR = Amount applied * (Payment Rate - Invoice Rate)
	- in AP = Amount applied * (Invoice Rate - Payment Rate) = -1 * Amount applied * (Payment Rate - Invoice Rate)
	*/

	/* Assume done in vb

	create table #currency (
		CurrencyID varchar(10) null
		,ExchangeRate decimal(24, 7) null
		)

	*/

	-- the Open Amount is a function of the time, we must recalc the Open Amount based on EndDate
	create table #invoice (
		Entity varchar(10) null -- tInvoice or tVoucher
		,EntityKey int null
		,InvoiceTotal money null
		,AmountPaid money null
		,OpenAmount money null
	)

	create table #unrealized (
		Type varchar(30) null
		,TypeName varchar(30) null
		,GLCompanyKey int null
		,InvoiceNumber varchar(50) null
		,InvoiceKey int null
		,InvoiceDate  smalldatetime null
		,PostingDate  smalldatetime null
		,Description varchar(250) null
		,Amount money null
		,CurrencyID varchar(10) null
		,PaymentExchangeRate decimal(24, 6) null
		,InvoiceExchangeRate decimal(24, 6) null
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

	insert #invoice (Entity, EntityKey, InvoiceTotal)
	select 'tInvoice', i.InvoiceKey, isnull(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0)
	from tInvoice i (nolock)
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
		And   i.InvoiceStatus = 4 
	   
	   -- now calculate the Open Amount
	   update #invoice
	   set    #invoice.AmountPaid = ISNULL((
			select sum(ca.Amount) 
			from tCheckAppl ca (nolock)
			inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey 
			Where ca.InvoiceKey = #invoice.EntityKey
			and  c.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and c.CheckDate <= @EndDate)
				Or
				(@DateOption = 1 and c.PostingDate <= @EndDate)
				)
			), 0) 
			+
			ISNULL((
			select sum(ic.Amount) 
			from tInvoiceCredit ic (nolock)
			inner join tInvoice i2 (nolock) on ic.CreditInvoiceKey = i2.InvoiceKey 
			Where ic.InvoiceKey = #invoice.EntityKey
			and  i2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and i2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and i2.PostingDate <= @EndDate)
				)
			), 0) 
			-
			ISNULL((
			select sum(ic.Amount) 
			from tInvoiceCredit ic (nolock)
			inner join tInvoice i2 (nolock) on ic.InvoiceKey = i2.InvoiceKey 
			Where ic.CreditInvoiceKey = #invoice.EntityKey
			and  i2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and i2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and i2.PostingDate <= @EndDate)
				)
			), 0) 
			+
			ISNULL((
			select sum(iab.Amount) 
			from tInvoiceAdvanceBill iab (nolock)
			inner join tInvoice i2 (nolock) on iab.AdvBillInvoiceKey = i2.InvoiceKey 
			Where iab.InvoiceKey = #invoice.EntityKey
			and  i2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and i2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and i2.PostingDate <= @EndDate)
				)
			), 0) 
		where Entity = 'tInvoice'

	insert #invoice (Entity, EntityKey, InvoiceTotal)
	select 'tVoucher', v.VoucherKey, isnull(v.VoucherTotal, 0)
	from tVoucher v (nolock)
	where v.CompanyKey = @CompanyKey
		and	(   
			(@DateOption = 0 and (v.InvoiceDate >= @StartDate and  v.InvoiceDate <= @EndDate))
			Or
			(@DateOption = 1 and (v.PostingDate >= @StartDate and  v.PostingDate <= @EndDate))
			)
		and   isnull(v.CurrencyID, '')  <> @HomeCurrencyID
		and   v.CurrencyID is not null
		and   (@CurrencyID is null Or isnull(v.CurrencyID, '') = @CurrencyID)
		AND   (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) )
		AND   (v.Posted >= @PostStatus)
		And   v.Status = 4 
		
	update #invoice
	   set    #invoice.AmountPaid = ISNULL((
			select sum(pd.Amount +  isnull(DiscAmount, 0))
			from tPaymentDetail pd (nolock)
			inner join tPayment p (nolock) on pd.PaymentKey = p.PaymentKey 
			Where pd.VoucherKey = #invoice.EntityKey
			and  p.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and p.PaymentDate <= @EndDate)
				Or
				(@DateOption = 1 and p.PostingDate <= @EndDate)
				)
			), 0)
			+
			ISNULL((
			select sum(vc.Amount) 
			from tVoucherCredit vc (nolock)
			inner join tVoucher v2 (nolock) on vc.CreditVoucherKey = v2.VoucherKey 
			Where vc.VoucherKey = #invoice.EntityKey
			and  v2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and v2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and v2.PostingDate <= @EndDate)
				)
			), 0) 
			-
			ISNULL((
			select sum(vc.Amount) 
			from tVoucherCredit vc (nolock)
			inner join tVoucher v2 (nolock) on vc.VoucherKey = v2.VoucherKey 
			Where vc.CreditVoucherKey = #invoice.EntityKey
			and  v2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and v2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and v2.PostingDate <= @EndDate)
				)
			), 0) 
			+
			ISNULL((
			select sum(vcc.Amount) 
			from tVoucherCC vcc (nolock)
			inner join tVoucher v2 (nolock) on vcc.VoucherCCKey = v2.VoucherKey 
			Where vcc.VoucherKey = #invoice.EntityKey
			and  v2.Posted >= @PostStatus
			and	(   
				(@DateOption = 0 and v2.InvoiceDate <= @EndDate)
				Or
				(@DateOption = 1 and v2.PostingDate <= @EndDate)
				)
			), 0) 
	where Entity = 'tVoucher'

 	update #invoice
	set OpenAmount = isnull(InvoiceTotal, 0) - isnull(AmountPaid, 0)
	
	insert #unrealized (
		Type 
		,TypeName
		,GLCompanyKey
		,InvoiceNumber
		,InvoiceKey 
		,InvoiceDate
		,PostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,Gain)
	select 'tInvoice'
		,'Client Invoice'
		,i.GLCompanyKey
		,i.InvoiceNumber
		,i.InvoiceKey
		,i.InvoiceDate
		,i.PostingDate
		,co.CompanyName
		,b.OpenAmount 
		,i.CurrencyID
		,1 -- for now assume 1 for payment rate
		,i.ExchangeRate
		,0
	from   tInvoice i (nolock)
		inner join tCompany co (nolock) on i.ClientKey = co.CompanyKey
		inner join #invoice b on i.InvoiceKey = b.EntityKey and b.Entity = 'tInvoice'
	where b.OpenAmount <> 0   

	insert #unrealized (
		Type
		,TypeName 
		,GLCompanyKey
		,InvoiceNumber
		,InvoiceKey 
		,InvoiceDate
		,PostingDate
		,Description
		,Amount 
		,CurrencyID
		,PaymentExchangeRate 
		,InvoiceExchangeRate 
		,Gain)
	select  case when isnull(v.CreditCard, 0) = 0 then 'tVoucher' else 'tVoucherCC' end
		,case when isnull(v.CreditCard, 0) = 0 then 'Vendor Invoice' else 'Credit Card' end
		,v.GLCompanyKey
		,v.InvoiceNumber
		,v.VoucherKey
		,v.InvoiceDate
		,v.PostingDate
		,co.CompanyName
		,b.OpenAmount  
		,v.CurrencyID
		,1 -- for now assume 1 for payment rate
		,v.ExchangeRate
		,0
	from   tVoucher v (nolock)
		inner join tCompany co (nolock) on v.VendorKey = co.CompanyKey
		inner join #invoice b on v.VoucherKey = b.EntityKey and b.Entity = 'tVoucher'
	where b.OpenAmount <> 0   
	
	-- If the user selected ALL Companies and we restrict
	-- we need to look up into tUserGLCompanyAccess
	IF @GLCompanyKey =-1 AND @RestrictToGLCompany = 1
	begin
		update #unrealized set GLCompanyKey = isnull(GLCompanyKey, 0)

		-- this does not delete null GLCompanyKey
		delete #unrealized
		where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
	end

	update #unrealized
	set    #unrealized.PaymentExchangeRate = b.ExchangeRate 
	from   #currency b
	where  #unrealized.CurrencyID = b.CurrencyID
	
	update #unrealized
	set    PaymentExchangeRate = isnull(PaymentExchangeRate, 1)
	      ,InvoiceExchangeRate = isnull(InvoiceExchangeRate, 1)

	update #unrealized
	set    Gain = round(Amount * (PaymentExchangeRate - InvoiceExchangeRate), 2)
	where  Type = 'tInvoice'

	update #unrealized
	set    Gain = -1 * round(Amount * (PaymentExchangeRate - InvoiceExchangeRate), 2)
	where  Type <> 'tInvoice'

	Delete #unrealized where Gain = 0

	if @DateOption = 0
		select InvoiceDate as DisplayDate
		, ROUND(Amount * PaymentExchangeRate, 2) as HPAmount 
		, ROUND(Amount * InvoiceExchangeRate, 2) as HIAmount 
		, * 
		from #unrealized order by InvoiceDate
	else
		select PostingDate as DisplayDate
		, ROUND(Amount * PaymentExchangeRate, 2) as HPAmount 
		, ROUND(Amount * InvoiceExchangeRate, 2) as HIAmount 
		, * 
		from #unrealized order by PostingDate
GO
