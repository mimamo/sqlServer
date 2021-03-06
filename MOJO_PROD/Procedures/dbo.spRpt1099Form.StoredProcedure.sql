USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRpt1099Form]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRpt1099Form]
(
	@CompanyKey int,
	@MinAmount money,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Form smallint,
	@VendorKey int,             -- 0 All, >0 valid vendor
	@GLCompanyKey INT = -1,		-- -1 All, 0 Blank or NULL, >0 valid GLCompany
	@UserKey int = null
)

AS --Encrypt

/*
|| When     Who Rel      What
|| 12/7/06  CRG 8.4      Added the @VendorKey parameter.
|| 01/29/08 GHL 8.503    (20078 + 20133) Sort by VendorID. Take >= @MinAmount 
|| 10/27/08 GHL 10.011   (34982) Added GLCompanyKey param for 1099 reporting
|| 03/17/09 MFT 10.021   (40077) Added Exclude1099
|| 11/4/09  CRG 10.5.1.3 (67238) Added DBA
|| 1/28/10  CRG 10.5.1.7 (72919) Now including the Exclude1099 calculation in the HAVING clause
|| 11/4/10  RLB 10.5.3.7 Changes made for the added 1096 report
|| 11/28/11 MFT 10.5.5.0 For electronic file format: added GLCompanyKey to output
|| 01/11/12 RLB 10.5.5.2 (131060) Changes made because GLCompany can be null or 0
|| 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 05/11/12 GHL 10.556 (142929) Added 1099 logic for credit cards
|| 01/09/14 GHL 10.576 (202119) Credit cards are payments
|| 03/04/14 GHL 10.578 Added conversion to home currency
|| 03/24/14 RLB 10.578 (203504) Added Exclude1099 on CC to the voucher cc calculation
|| 01/29/15 MFT 10.588 (244173) Restriced Credit Card payments to BoughtFromKey = @VendorKey so CC data will respect @VendorKey param
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

DECLARE @FormOriginal smallint

select @FormOriginal = @Form


IF @Form = 3
	BEGIN
		Select @Form = 1
	END

IF @Form = 4
	BEGIN
		Select @Form = 2
	END


-- Step 1: get the payments by GLCompany/Vendor
create table #tmpPayment 
	(
	PaymentKey int
	,GLCompanyKey int null
	,VendorKey int null
	,PaymentAmount money null
	,Exclude1099 money null
	,ExchangeRate decimal(24, 7) null
	,GPFlag int null
	,PaymentType varchar(25) null
	)

-- Pass 1: Get the payments againt regular vouchers

insert #tmpPayment (PaymentKey, GLCompanyKey, VendorKey, PaymentAmount, Exclude1099, ExchangeRate, GPFlag, PaymentType)
SELECT
	p.PaymentKey
	,isnull(p.GLCompanyKey, 0)
	,p.VendorKey
	,p.PaymentAmount
	,(ISNULL((
		select sum (Exclude1099) from tPaymentDetail pd (nolock) where pd.PaymentKey = p.PaymentKey
	),0))
	,p.ExchangeRate
	,0
	,'Payment'
FROM
	tPayment p (nolock)
	INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey
WHERE 
	p.PaymentDate >= @StartDate 
	AND p.PaymentDate <= @EndDate 
	AND c.Type1099 = @Form
	AND p.CompanyKey = @CompanyKey
	AND (p.VendorKey = @VendorKey OR @VendorKey = 0)
	--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
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


-- Pass 2: add the payments against credit cards

insert #tmpPayment (PaymentKey, GLCompanyKey, VendorKey, PaymentAmount, Exclude1099, ExchangeRate, PaymentType)
select ccc.VoucherKey, 
	ccc.GLCompanyKey, 
	ccc.BoughtFromKey, 
	ccc.VoucherTotal,
	(
		(
		     (select ISNULL(sum (Exclude1099), 0) from tVoucherDetail vod (nolock) where vod.VoucherKey = ccc.VoucherKey) 
		     + 
		     (select ISNULL(sum (Exclude1099), 0) from tVoucherCC vcc (nolock) where vcc.VoucherCCKey = ccc.VoucherKey)
		)
	 ),
	ccc.ExchangeRate, 
	'Credit Card'
from   tVoucher ccc (nolock)
INNER JOIN tCompany c (nolock) ON ccc.BoughtFromKey = c.CompanyKey
where isnull(ccc.CreditCard, 0) = 1
	AND ccc.InvoiceDate >= @StartDate 
	AND ccc.InvoiceDate <= @EndDate 
	AND c.Type1099 = @Form
	AND ccc.CompanyKey = @CompanyKey
	AND (ccc.BoughtFromKey = @VendorKey OR @VendorKey = 0)
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


update #tmpPayment 
	set PaymentAmount = isnull(PaymentAmount, 0) 
		, Exclude1099 = isnull(Exclude1099, 0)
		, ExchangeRate = isnull(ExchangeRate, 1)
		 
update #tmpPayment
set PaymentAmount = round(PaymentAmount * ExchangeRate, 2)
   ,Exclude1099 = round(Exclude1099 * ExchangeRate, 2)
	
-- Step 2: get the data to display

	IF @FormOriginal = 3 or @FormOriginal = 4 --1096 Misc/INT
		BEGIN
			Select 
				SUM(PaymentAmount) as FormTotal
				,COUNT(DISTINCT VendorKey) as FormCount
				,@Form as FormType
			FROM (
					SELECT
						c.CompanyKey
						,c.CompanyName
						,c.VendorID
						,p.VendorKey
						,SUM(PaymentAmount - Exclude1099) AS PaymentAmount
						,ISNULL(p.GLCompanyKey, 0) AS GLCompanyKey
					FROM
						#tmpPayment p (nolock)
						INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey
					GROUP BY
						 c.CompanyKey
						,c.CompanyName
						,c.VendorID
						,p.VendorKey
						,ISNULL(p.GLCompanyKey, 0) 
					HAVING
						SUM(PaymentAmount - Exclude1099) >= @MinAmount
				) as FormData
		END
			
	ELSE
		SELECT
			 c.CompanyKey
			,c.CompanyName
			,c.VendorID
			,c.Type1099
			,c.EINNumber
			,c.Box1099
			,ad.Address1
			,ad.Address2
			,ad.Address3
			,ad.City
			,ad.State
			,ad.PostalCode
			,ad.Country
			,c.Phone
			,SUM(PaymentAmount -Exclude1099) AS PaymentAmount
			,c.DBA
			,ISNULL(p.GLCompanyKey, 0) AS GLCompanyKey
		FROM 
			#tmpPayment p (nolock)
			INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey
			LEFT JOIN tAddress ad (nolock) ON c.DefaultAddressKey = ad.AddressKey

		GROUP BY
			 c.CompanyKey
			,c.CompanyName
			,c.VendorID
			,c.Type1099
			,c.EINNumber
			,c.StateEINNumber
			,c.Box1099
			,ad.Address1
			,ad.Address2
			,ad.Address3
			,ad.City
			,ad.State
			,ad.PostalCode
			,ad.Country
			,c.Phone
			,c.DBA
			,ISNULL(p.GLCompanyKey, 0)
		HAVING
			SUM(PaymentAmount - Exclude1099) >= @MinAmount
		ORDER BY
			VendorID
GO
