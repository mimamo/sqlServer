USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCreditGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCreditGetList]

	(
		@VendorKey int,
		@VoucherKey int,
		@Side tinyint,
		@GLCompanyKey int,
		@AppliedOnly tinyint = 0,
		@CurrencyID varchar(10) = null
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 5/14/07  BSH 8.4.3 (9206) Corrected unapplied amount calculation to watch for payments too. 
|| 10/09/07 BSH 8.5   (96490) Updates for 8.5, limit selections by GLCompany. 
|| 01/12/12 GHL 10.552 Added AppliedOnly for flex screens so that we can display applied vouchers in a grid  
|| 11/07/13 GHL 10.574 Added CurrencyID for multi currency functionality
|| 12/10/13 GHL 10.574 Changed ISNULL(v.CurrencyID, 0) to ISNULL(v.CurrencyID, '')
*/

if @AppliedOnly = 0
begin
if @Side = 0
		--Find Credits that apply to this voucher
		Select
			1 as Applied,
			v.VoucherKey,
			v.InvoiceNumber,
			v.InvoiceDate,
			ABS(v.VoucherTotal) as VoucherTotal,
			ABS(ISNULL(VoucherTotal, 0)) - ABS(ISNULL(AmountPaid, 0)) as UnAppliedAmount,
			vc.VoucherCreditKey,
			vc.Amount,
			vc.Description
		From
			tVoucher v (nolock)
			inner join tVoucherCredit vc (nolock) on v.VoucherKey = vc.CreditVoucherKey
		Where
			vc.VoucherKey = @VoucherKey
		
			
		UNION ALL

		Select
			0 as Applied,
			v.VoucherKey, 
			v.InvoiceNumber, 
			v.InvoiceDate, 
			ABS(v.VoucherTotal) as VoucherTotal, 
			ABS(ISNULL(VoucherTotal, 0)) - ABS(ISNULL(AmountPaid, 0)) as UnAppliedAmount,
			0,
			0,
			NULL
		From 
			tVoucher v (nolock)
		Where
			v.VendorKey = @VendorKey and
			v.VoucherTotal < 0 and
			ISNULL(v.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(v.CurrencyID, '') = ISNULL(@CurrencyID, '') and
			v.VoucherKey not in (Select CreditVoucherKey from tVoucherCredit (nolock) Where tVoucherCredit.VoucherKey = @VoucherKey) AND
			--ABS(ISNULL(VoucherTotal, 0)) - ISNULL((Select Sum(Amount) from tVoucherCredit Where tVoucherCredit.CreditVoucherKey = v.VoucherKey), 0) > 0
			ABS(ISNULL(VoucherTotal, 0)) - ABS(ISNULL(AmountPaid, 0)) > 0
ELSE
		-- Find voucher to apply an amount to
		Select
			1 as Applied,
			v.VoucherKey,
			v.InvoiceNumber,
			v.InvoiceDate,
			v.VoucherTotal,
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) as UnAppliedAmount,
			vc.VoucherCreditKey,
			vc.Amount,
			vc.Description
		From
			tVoucher v (nolock)
			inner join tVoucherCredit vc (nolock) on v.VoucherKey = vc.VoucherKey
		Where
			vc.CreditVoucherKey = @VoucherKey
			
			
		UNION ALL

		Select
			0 as Applied,
			v.VoucherKey, 
			v.InvoiceNumber, 
			v.InvoiceDate, 
			v.VoucherTotal,
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) as UnAppliedAmount,
			0,
			0,
			NULL
		From 
			tVoucher v (nolock)
		Where
			v.VendorKey = @VendorKey and
			ISNULL(v.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and 
			ISNULL(v.CurrencyID, '') = ISNULL(@CurrencyID, '') and
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) > 0 and
			v.VoucherKey not in (Select VoucherKey from tVoucherCredit (nolock) Where tVoucherCredit.CreditVoucherKey = @VoucherKey)
end

else

-- Applied only
begin

if @Side = 0
		--Find Credits that apply to this voucher
		Select
			1 as Applied,
			v.VoucherKey,
			v.InvoiceNumber,
			v.InvoiceDate,
			ABS(v.VoucherTotal) as VoucherTotal,
			ABS(ISNULL(VoucherTotal, 0)) - ABS(ISNULL(AmountPaid, 0)) as UnAppliedAmount,
			vc.VoucherCreditKey,
			vc.Amount,
			vc.Description
		From
			tVoucher v (nolock)
			inner join tVoucherCredit vc (nolock) on v.VoucherKey = vc.CreditVoucherKey
		Where
			vc.VoucherKey = @VoucherKey
		
		
ELSE
		-- Find voucher to apply an amount to
		Select
			1 as Applied,
			v.VoucherKey,
			v.InvoiceNumber,
			v.InvoiceDate,
			v.VoucherTotal,
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) as UnAppliedAmount,
			vc.VoucherCreditKey,
			vc.Amount,
			vc.Description
		From
			tVoucher v (nolock)
			inner join tVoucherCredit vc (nolock) on v.VoucherKey = vc.VoucherKey
		Where
			vc.CreditVoucherKey = @VoucherKey
			
		
end
GO
