USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditGetApplyListForClient]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditGetApplyListForClient]
	(
		@ClientKey int,      -- pass client in case InvoiceKey = 0, should always be > 0
	    @GLCompanyKey int,   -- pass gl company in case InvoiceKey = 0, 0 Blank, > 0 valid company 
		@InvoiceKey int,
		@Side tinyint,
		@Restrict tinyint,    -- applied only
		@CurrencyID varchar(10) = null 
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 10/11/10 GHL 10.536 Created for new flash invoice screen
||                     Difference with sptInvoiceCreditGetApplyList is that:
||                     1) InvoiceKey may be 0
||                     2) Show the unapplied list or the applied list   
|| 09/27/13 GHL 10.572 (181928) Filter out voided invoices
|| 09/27/13 GHL 10.572  Added support for multi currencies
|| 11/06/13 GHL 10.573  (194937) query invoices where VoidInvoiceKey = 0 or VoidInvoiceKey = InvoiceKey
*/

Declare @ParentCompanyKey int

SELECT @ParentCompanyKey = ParentCompanyKey
FROM   tCompany (NOLOCK)
WHERE  CompanyKey = @ClientKey
	
SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)

declare @VoidInvoiceKey int
select @VoidInvoiceKey = VoidInvoiceKey from tInvoice (nolock) where InvoiceKey = @InvoiceKey

if @Restrict = 0
begin
	if @Side =0
	--Find Credits to apply to this invoice

	Select
		0 as Applied,
		i.InvoiceKey, 
		i.InvoiceNumber, 
		i.InvoiceDate, 
		ABS(i.InvoiceTotalAmount) as InvoiceTotalAmount, 
		ABS(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
		- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnappliedAmount,
		0,
		0,
		NULL
	From 
		tInvoice i (nolock)
	Where
		i.InvoiceStatus = 4 and
		i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey 
		OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
		OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
		i.InvoiceTotalAmount < 0 and
		ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
		(
			ISNULL(i.VoidInvoiceKey, 0) = 0 
			OR ISNULL(i.VoidInvoiceKey, 0) = @InvoiceKey
			OR ISNULL(i.VoidInvoiceKey, 0) = @VoidInvoiceKey
		) AND
		ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND    
		i.InvoiceKey not in (Select CreditInvoiceKey from tInvoiceCredit (nolock) Where tInvoiceCredit.InvoiceKey = @InvoiceKey) AND
		ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
		- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0) < 0


	else
	--Apply the credit to invoices


	Select
		0 as Applied,
		i.InvoiceKey, 
		i.InvoiceNumber, 
		i.InvoiceDate, 
		i.InvoiceTotalAmount, 
		(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
		- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnappliedAmount,
		0,
		0,
		NULL
	From 
		tInvoice i (nolock)
	Where
		i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey 
		OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
		OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
		i.InvoiceTotalAmount > 0 and
		ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
		(
			ISNULL(i.VoidInvoiceKey, 0) = 0 
			OR ISNULL(i.VoidInvoiceKey, 0) = @InvoiceKey
			OR ISNULL(i.VoidInvoiceKey, 0) = @VoidInvoiceKey
		) AND
		ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND  
		i.InvoiceKey not in (Select InvoiceKey from tInvoiceCredit Where tInvoiceCredit.CreditInvoiceKey = @InvoiceKey) and
		(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
		- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) > 0

end

else 

begin
	-- Applied only

	if @Side =0
	--Find Credits to apply to this invoice

	Select
		1 as Applied,
		i.InvoiceKey, 
		i.InvoiceNumber, 
		i.InvoiceDate, 
		ABS(i.InvoiceTotalAmount) as InvoiceTotalAmount, 
		ABS(ISNULL(InvoiceTotalAmount, 0)) - ISNULL((Select Sum(Amount) from tInvoiceCredit (nolock) Where tInvoiceCredit.CreditInvoiceKey = i.InvoiceKey), 0) 
			as UnappliedAmount,
		ic.InvoiceCreditKey,
		ic.Amount,
		ic.Description
	From 
		tInvoice i (nolock)
		inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey
	Where
		ic.InvoiceKey = @InvoiceKey

	
	else
	--Apply the credit to invoices

	Select
		1 as Applied,
		i.InvoiceKey, 
		i.InvoiceNumber, 
		i.InvoiceDate, 
		i.InvoiceTotalAmount, 
		(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) 
			as UnappliedAmount,
		ic.InvoiceCreditKey,
		ic.Amount,
		ic.Description
	From 
		tInvoice i (nolock)
		inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.InvoiceKey
	Where
		ic.CreditInvoiceKey = @InvoiceKey



end
GO
