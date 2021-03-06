USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCloseDateChange]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCloseDateChange]
	@CompanyKey int,
	@GLCloseDate smalldatetime,
	@GLCompanyKey int = null,
	@Validate tinyint = 1,
	@UpdateMultiGLCompany tinyint = 0
	
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 7/6/10   RLB 10.532  Added for GL Close Date Warnings
|| 09/27/12 RLB 10.560  Added GLCompanyKey for HMI Multi Company Close Date changes
*/

DECLARE @VoucherCount int, @InvoiceCount int, @ReceiptCount int, @PaymentCount int, @JournalEntryCount int

IF @Validate = 1
BEGIN
	select  @VoucherCount = COUNT(*)
	from tVoucher (nolock)
	where CompanyKey = @CompanyKey
	and Posted = 0
	and PostingDate < @GLCloseDate
	and (@GLCompanyKey = null or GLCompanyKey = @GLCompanyKey)

	 select @InvoiceCount = COUNT(*)
	from tInvoice (nolock)
	where CompanyKey = @CompanyKey
	and Posted = 0
	and PostingDate < @GLCloseDate
	and (@GLCompanyKey = null or GLCompanyKey = @GLCompanyKey)

	select @ReceiptCount = COUNT(*)
	from tCheck (nolock)
	where CompanyKey = @CompanyKey
	and Posted = 0
	and PostingDate < @GLCloseDate
	and (@GLCompanyKey = null or GLCompanyKey = @GLCompanyKey)

	select @PaymentCount = COUNT(*)
	from tPayment (nolock)
	where CompanyKey = @CompanyKey
	and Posted = 0
	and PostingDate < @GLCloseDate
	and (@GLCompanyKey = null or GLCompanyKey = @GLCompanyKey)

	select @JournalEntryCount = COUNT(*)
	from tJournalEntry (nolock)
	where CompanyKey = @CompanyKey
	and Posted = 0
	and PostingDate < @GLCloseDate
	and (@GLCompanyKey = null or GLCompanyKey = @GLCompanyKey)
END

select @VoucherCount as VoucherCount, @InvoiceCount as InvoiceCount , @ReceiptCount as ReceiptCount , @PaymentCount as PaymentCount, @JournalEntryCount as JournalEntryCount

-- Added an update for the multi company gl close date
if @UpdateMultiGLCompany = 1 and ISNULL(@GLCompanyKey, 0) > 0
begin
	if @Validate = 1 and @VoucherCount = 0 and @InvoiceCount = 0 and @ReceiptCount = 0 and @PaymentCount = 0 and @JournalEntryCount = 0
		update tGLCompany set GLCloseDate = @GLCloseDate where GLCompanyKey = @GLCompanyKey
	
	if @Validate = 0
		update tGLCompany set GLCloseDate = @GLCloseDate where GLCompanyKey = @GLCompanyKey
end
GO
