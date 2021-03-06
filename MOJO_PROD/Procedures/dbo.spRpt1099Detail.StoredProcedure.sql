USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRpt1099Detail]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRpt1099Detail]
(
	@CompanyKey int,
	@MinAmount money,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@GLCompanyKey INT = -1,		-- -1 All, 0 Blank or NULL, >0 valid GLCompany
	@UserKey int = null
)

AS
--Encrypt

/*
|| When     Who Rel  What
|| 01/29/08 GHL 8.503 (20133) Take >= @MinAmount instead of > @MinAmount 
|| 10/27/08 GHL 10.011 (34982) Added GLCompanyKey param for 1099 reporting
|| 03/17/09 MFT 10.021  (40077) Added Exclude1099
|| 02/1/11  GWG 10.540 Fixed the addition of exclude 1099 was not exculding vendors where exclude from 1099 was putting them under the limit
|| 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 05/11/12 GHL 10.556 (142929) Added 1099 for credit cards
|| 01/09/14 GHL 10.576 (202119) Credit cards are payments
|| 03/04/14 GHL 10.578 Added conversion to home currency
|| 03/24/14 RLB 10.578 (203504) Added Exclude1099 on CC to the voucher cc calculation
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


create table #tmpPayment (
    PaymentKey int null
	,PaymentDetailKey int null
	,CompanyKey int null
	,VendorKey int null
	,CompanyName varchar(200) null
	,VendorID varchar(50) null
	,Type1099 smallint null
	,EINNumber varchar(30) null
	,Address1 varchar(100) null
	,Address2 varchar(100) null
	,Address3 varchar(100) null
	,City varchar(100) null
	,State varchar(50) null
	,PostalCode varchar(20) null
	,Country varchar(50) null
	,CheckNumber varchar(50) null
	,PaymentAmount money null
	,PaymentDate smalldatetime null
    ,GPFlag int null		-- General Purpose flag
	,PaymentType varchar(25) null
)

-- First Pass: get all payments against regular vouchers, same as before

insert #tmpPayment(
    PaymentKey 
	,CompanyKey 
	,VendorKey 
	,CompanyName
	,VendorID 
	,Type1099 
	,EINNumber
	,Address1 
	,Address2 
	,Address3 
	,City 
	,State 
	,PostalCode 
	,Country 
	,CheckNumber 
	,PaymentAmount
	,PaymentDate
	,GPFlag  
	,PaymentType
	)
Select
	p.PaymentKey
	,p.CompanyKey
	,p.VendorKey
	,c.CompanyName
	,c.VendorID
	,c.Type1099
	,c.EINNumber
	,ad.Address1
	,ad.Address2
	,ad.Address3
	,ad.City
	,ad.State
	,ad.PostalCode
	,ad.Country
	,p.CheckNumber
	, ROUND 
		(
			(
			p.PaymentAmount 
			- ISNULL((SELECT SUM(ISNULL(Exclude1099, 0)) FROM tPaymentDetail (nolock) WHERE PaymentKey = p.PaymentKey),0) 
			) 
			* isnull(p.ExchangeRate, 1)
		,2)
		AS PaymentAmount
	,p.PaymentDate
	,0
	,'Payment'
From 
	tPayment p (nolock)
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
Where 
	PaymentDate	>= @StartDate and
	PaymentDate <= @EndDate	and
	c.Type1099 > 0 and
	p.CompanyKey = @CompanyKey 
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

-- Now remove the payments against credit cards
-- there is a special process by payment detail line for credit cards
update #tmpPayment
set    #tmpPayment.GPFlag = 1
from   tPayment p (nolock)
inner  join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
inner  join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
where  #tmpPayment.PaymentKey = p.PaymentKey
and    isnull(v.CreditCard, 0) = 1 

delete #tmpPayment where GPFlag = 1


-- Second Pass: insert payments against credit cards

-- we have to link through tVoucher.BoughtFromKey to get to the vendor
-- NOT the vendor on the payment (which is a vendor like AMEX)
-- no need to check Exclude1099 because there is no Exclude1099 when applying credit cards to payments
insert #tmpPayment(
	PaymentKey
	,PaymentDetailKey
	,VendorKey
	,CompanyName
	,VendorID
	,Type1099
	,EINNumber
	,Address1
	,Address2
	,Address3
	,City
	,State
	,PostalCode
	,Country
	,CheckNumber
	,PaymentAmount
	,PaymentDate
	,PaymentType
	)
select ccc.VoucherKey
	,ccc.VoucherKey
	,ccc.BoughtFromKey
	,c.CompanyName
	,c.VendorID
	,c.Type1099
	,c.EINNumber
	,ad.Address1
	,ad.Address2
	,ad.Address3
	,ad.City
	,ad.State
	,ad.PostalCode
	,ad.Country
	,isnull(ccc.InvoiceNumber, 'Credit Card')
	,ROUND 
		(
			(
			ccc.VoucherTotal  
			- (
			      ISNULL((SELECT SUM(ISNULL(Exclude1099, 0)) FROM tVoucherCC vcc (nolock) WHERE vcc.VoucherCCKey = ccc.VoucherKey),0)
			      +
			      ISNULL((SELECT SUM(ISNULL(Exclude1099, 0)) FROM tVoucherDetail vod (nolock) WHERE vod.VoucherKey = ccc.VoucherKey),0)
			  )
			) 
			* isnull(ccc.ExchangeRate, 1)
		,2)
		AS PaymentAmount
	,ccc.InvoiceDate
	,'Credit Card'
from tVoucher ccc (nolock)
inner join tCompany c (nolock) on ccc.BoughtFromKey = c.CompanyKey -- this is the real Vendor
left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
where ccc.InvoiceDate	>= @StartDate 
and	  ccc.InvoiceDate <= @EndDate	
and   c.Type1099 > 0 
and   ccc.CompanyKey = @CompanyKey 
and   isnull(ccc.CreditCard, 0) = 1 
AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND ccc.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(ccc.GLCompanyKey, 0) = @GLCompanyKey)
			)	

Delete #tmpPayment Where VendorKey in 
	(Select VendorKey from (
		Select VendorKey, Sum(PaymentAmount) as Amt from #tmpPayment Group By VendorKey ) as tbl
	Where Amt < @MinAmount)
	

Select * from #tmpPayment

Order By
	VendorID, CheckNumber
GO
