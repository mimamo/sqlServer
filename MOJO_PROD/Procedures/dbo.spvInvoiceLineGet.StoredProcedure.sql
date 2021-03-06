USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvInvoiceLineGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvInvoiceLineGet]
 (
  @InvoiceKey int,
  @Percentage decimal(24,4)
 )
AS --Encrypt

/*
|| When   Who     Rel     	What
|| 1/9/09 MFT/GHL 10.0.1.6	(43742) Added code to alter summary line items to be taxable if at least one item under them is taxable
||			                Note that this only applies to Taxable and Taxable2 and only through the first level of recurssion
|| 3/31/14 GHL    10.5.7.8  (210964) + (68534) Added check of Sales Tax Amount before setting Taxable
*/

update tInvoiceLine
set    Taxable = 0, Taxable2 = 0
where  InvoiceKey = @InvoiceKey
and LineType = 1

if @@ROWCOUNT > 0 
begin
	update tInvoiceLine
	set    Taxable = 1
	where  InvoiceKey = @InvoiceKey
	and    LineType = 1
	and exists (select 1 from tInvoiceLine il (nolock) 
		where il.InvoiceKey = @InvoiceKey 
		and il.Taxable = 1 
		and isnull(il.SalesTax1Amount, 0) <> 0
		and il.ParentLineKey = tInvoiceLine.InvoiceLineKey)
	  
	update tInvoiceLine
	set    Taxable2 = 1
	where  InvoiceKey = @InvoiceKey
	and LineType = 1
	and exists (select 1 from tInvoiceLine il (nolock) 
		where il.InvoiceKey = @InvoiceKey 
		and il.Taxable2 = 1
		and isnull(il.SalesTax2Amount, 0) <> 0 
		and il.ParentLineKey = tInvoiceLine.InvoiceLineKey)
END

Select @Percentage = @Percentage / 100

SELECT 
 vInvoiceLine.*,
 TotalAmount * @Percentage as pTotalAmount
FROM
 vInvoiceLine (NOLOCK)
WHERE
 InvoiceKey = @InvoiceKey
Order By InvoiceKey, InvoiceOrder
GO
