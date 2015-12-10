USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditGetApplyList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditGetApplyList]

	(
		@InvoiceKey int,
		@Side tinyint
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 5/14/07  BSH 8.4.3 (9206) Corrected unapplied amount calculation to watch for receipts too. 
|| 09/27/13 GHL 10.572 (181928) Filter out voided invoices
*/

Declare @ClientKey int, @ParentCompanyKey int, @GLCompanyKey int

Select @ClientKey = ClientKey, @GLCompanyKey = GLCompanyKey from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @ClientKey
	
	SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)


if @Side =0
--Find Credits to apply to this invoice

Select
	1 as Applied,
	i.InvoiceKey, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
	ABS(i.InvoiceTotalAmount) as InvoiceTotalAmount, 
	ABS(ISNULL(InvoiceTotalAmount, 0)) - ISNULL((Select Sum(Amount) from tInvoiceCredit (nolock) Where tInvoiceCredit.CreditInvoiceKey = i.InvoiceKey), 0) as UnAppliedAmount,
	ic.InvoiceCreditKey,
	ic.Amount,
	ic.Description
From 
	tInvoice i (nolock)
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey
Where
	ic.InvoiceKey = @InvoiceKey

UNION ALL

Select
	0 as Applied,
	i.InvoiceKey, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
	ABS(i.InvoiceTotalAmount) as InvoiceTotalAmount, 
	ABS(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
	0,
	0,
	NULL
From 
	tInvoice i (nolock)
Where
	i.InvoiceStatus = 4 and
	i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
	i.InvoiceTotalAmount < 0 and
	ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
	ISNULL(i.VoidInvoiceKey, 0) = 0 AND
	i.InvoiceKey not in (Select CreditInvoiceKey from tInvoiceCredit (nolock) Where tInvoiceCredit.InvoiceKey = @InvoiceKey) AND
	ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0) < 0


else
--Apply the credit to invoices

Select
	1 as Applied,
	i.InvoiceKey, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
	i.InvoiceTotalAmount, 
	(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
	ic.InvoiceCreditKey,
	ic.Amount,
	ic.Description
From 
	tInvoice i (nolock)
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.InvoiceKey
Where
	ic.CreditInvoiceKey = @InvoiceKey

UNION ALL

Select
	0 as Applied,
	i.InvoiceKey, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
	i.InvoiceTotalAmount, 
	(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
	0,
	0,
	NULL
From 
	tInvoice i (nolock)
Where
	i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
	i.InvoiceTotalAmount > 0 and
	ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
	ISNULL(i.VoidInvoiceKey, 0) = 0 AND
	i.InvoiceKey not in (Select InvoiceKey from tInvoiceCredit Where tInvoiceCredit.CreditInvoiceKey = @InvoiceKey) and
	(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) > 0
GO
