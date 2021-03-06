USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetMaxDate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetMaxDate]
		@VoucherDetailKey INT

AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/10/07 GHL 8.5   (16982) Fixed left outer join of first query                  
  ||                    ON vd.InvoiceLineKey = il.InvoiceLineKey instead of 
  ||                    ON vd.VoucherDetailKey = il.InvoiceLineKey 
  || 12/16/08 GHL 10.015 (41844) When an advance bill is applied to a regular invoice, 
  ||                    we can only set DatePaidByClient if the adv bill is fully paid
  ||                    Algorithm is take the max of the following dates
  ||                    - Check Date
  ||                    - Credit Date
  ||                    - Advance Bill Check Date
  ||                    - Advance Bill Credit Date
  ||                    At the difference with sptInvoiceUpdateAmountPaid that processes vouchers from the adv bill to the reg invoice 
  ||                    we process voucher lines from the reg invoice to the adv bill invoice
  || 11/04/13 WDF 10.5.7.4 (191850) Add setting of date if InvoiceTotal = 0                
  */

-- Variables to capture Keys
	DECLARE @InvoiceKey INT
			,@AdvBillInvoiceKey INT
			,@InvoiceDate SMALLDATETIME
			,@MaxCheckDate SMALLDATETIME
			,@MaxCreditDate SMALLDATETIME
			,@MaxABCheckDate SMALLDATETIME
			,@MaxABCreditDate SMALLDATETIME
			,@MaxDate SMALLDATETIME
			,@CurrDatePaidByClient SMALLDATETIME

SELECT @CurrDatePaidByClient = DatePaidByClient
FROM   tVoucherDetail (nolock)
WHERE  VoucherDetailKey = @VoucherDetailKey
			
--If client invoice created from Voucher, get InvoiceKey from VoucherDetail
SELECT 
	 @InvoiceKey = il.InvoiceKey 
FROM
	tInvoiceLine il (nolock)
	INNER join tVoucherDetail vd (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
WHERE
	vd.VoucherDetailKey = @VoucherDetailKey

--If client invoice was created from PO, get InvoiceKey from PO.
if @InvoiceKey is null 
	SELECT 
		 @InvoiceKey = i.InvoiceKey 
	FROM
		tVoucherDetail vd (nolock)
		INNER join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		INNER join tInvoiceLine il (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey
		INNER join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	WHERE
		vd.VoucherDetailKey = @VoucherDetailKey

if @InvoiceKey is null and @CurrDatePaidByClient is not null
begin
	-- Could result from the modification of an invoice, so reset
	UPDATE tVoucherDetail
	SET    DatePaidByClient = NULL  
	WHERE  VoucherDetailKey = @VoucherDetailKey
	
	RETURN 1
end

if @InvoiceKey is null and @CurrDatePaidByClient is null
begin
	-- Abort if not linked to an invoice
	RETURN 1
end

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey AND 
ISNULL(InvoiceTotalAmount, 0) = 0 )
BEGIN
	SELECT  @InvoiceDate = ISNULL(InvoiceDate,'01/01/1900')
	FROM    tInvoice (NOLOCK)
	WHERE   InvoiceKey = @InvoiceKey
END

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey AND 
(ISNULL(InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) 
- ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0)) = 0 )
BEGIN
	SELECT @MaxCreditDate = ISNULL(Max(i.InvoiceDate), '01/01/1900')
	FROM   tInvoiceCredit ic (NOLOCK)
		INNER JOIN tInvoice i (NOLOCK) ON i.InvoiceKey = ic.CreditInvoiceKey
	WHERE 	ic.CreditInvoiceKey = @InvoiceKey
	
	SELECT  @MaxCheckDate = ISNULL(MAX(c.CheckDate),'01/01/1900')
	FROM    tInvoice i (NOLOCK)
		INNER JOIN tCheckAppl ca (NOLOCK) ON i.InvoiceKey = ca.InvoiceKey 
	           INNER JOIN tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
	WHERE      i.InvoiceKey = @InvoiceKey
	
END

-- now look at the advance bills linked to this invoice

if exists (select 1 from tInvoiceAdvanceBill iab (NOLOCK) where iab.InvoiceKey = @InvoiceKey)
begin

	-- Credits for the fully paid advance bills
	SELECT @MaxABCreditDate = ISNULL(Max(ci.InvoiceDate), '01/01/1900')
	FROM    tInvoiceAdvanceBill iab (NOLOCK)
		INNER JOIN tInvoice abi (NOLOCK) ON iab.AdvBillInvoiceKey = abi.InvoiceKey 
		INNER JOIN tInvoiceCredit ic (NOLOCK) ON iab.AdvBillInvoiceKey = ic.InvoiceKey
			INNER JOIN tInvoice ci (NOLOCK) ON ic.CreditInvoiceKey = ci.InvoiceKey 
	WHERE   iab.InvoiceKey = @InvoiceKey
	-- the advance bill must be fully paid
	AND  (ISNULL(abi.InvoiceTotalAmount, 0) - ISNULL(abi.AmountReceived, 0) - ISNULL(abi.WriteoffAmount, 0) 
		 - ISNULL(abi.DiscountAmount, 0) - ISNULL(abi.RetainerAmount, 0) = 0)

	-- Checks for the fully paid advance bills
	SELECT @MaxABCheckDate = ISNULL(Max(c.CheckDate), '01/01/1900')
	FROM    tInvoiceAdvanceBill iab (NOLOCK)
		INNER JOIN tInvoice abi (NOLOCK) ON iab.AdvBillInvoiceKey = abi.InvoiceKey
		INNER JOIN tCheckAppl ca (NOLOCK) ON iab.AdvBillInvoiceKey = ca.InvoiceKey
			INNER JOIN tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey 
	WHERE   iab.InvoiceKey = @InvoiceKey
	-- the advance bill must be fully paid
	AND  (ISNULL(abi.InvoiceTotalAmount, 0) - ISNULL(abi.AmountReceived, 0) - ISNULL(abi.WriteoffAmount, 0) 
		 - ISNULL(abi.DiscountAmount, 0) - ISNULL(abi.RetainerAmount, 0) = 0)

end

SELECT @MaxDate = '01/01/1900'

-- The invoices might not have been fully paid, so dates for them may be null
SELECT @InvoiceDate = ISNULL(@InvoiceDate, '01/01/1900')
SELECT @MaxCheckDate = ISNULL(@MaxCheckDate, '01/01/1900')
SELECT @MaxCreditDate = ISNULL(@MaxCreditDate, '01/01/1900')
SELECT @MaxABCheckDate = ISNULL(@MaxABCheckDate, '01/01/1900')
SELECT @MaxABCreditDate = ISNULL(@MaxABCreditDate, '01/01/1900')

if @InvoiceDate > @MaxDate
	select @MaxDate = @InvoiceDate

if @MaxCheckDate > @MaxDate
	select @MaxDate = @MaxCheckDate
	
if @MaxCreditDate > @MaxDate
	select @MaxDate = @MaxCreditDate
	
if @MaxABCheckDate > @MaxDate
	select @MaxDate = @MaxABCheckDate
	
if @MaxABCreditDate > @MaxDate
	select @MaxDate = @MaxABCreditDate
	

if @MaxDate = '01/01/1900'
begin			
	-- nothing was found
	if @CurrDatePaidByClient is not null
		UPDATE tVoucherDetail
		SET    DatePaidByClient = null
		WHERE  VoucherDetailKey = @VoucherDetailKey
end
else
begin
		UPDATE tVoucherDetail
		SET    DatePaidByClient = @MaxDate
		WHERE  VoucherDetailKey = @VoucherDetailKey
end


RETURN 1
GO
