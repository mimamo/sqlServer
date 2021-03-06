USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGetNotifyInfo]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGetNotifyInfo]
	(
	@Entity varchar(100)
	,@EntityKey int
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 11/03/11 GHL 10.549   Added support of credit cards           
  */

if @Entity = 'INVOICE'
	Select InvoiceKey
	      ,InvoiceNumber
	      ,InvoiceDate
	      ,BCompanyName As ClientName
	      ,BilledAmount
	      ,OpenAmount
	      ,InvoiceStatus
	from vInvoice 
	Where InvoiceKey = @EntityKey 
else if @Entity IN ('VOUCHER', 'CREDITCARD')
	Select VoucherKey
	      ,InvoiceNumber
	      ,InvoiceDate
	      ,VendorName
	      ,VoucherTotal
	      ,OpenAmount
	      ,Status as InvoiceStatus
	from vVoucher 
	Where VoucherKey = @EntityKey 
else if @Entity = 'GENJRNL'
	SELECT 
		je.*, 
		(Select sum(DebitAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as DebitTotal,
		(Select sum(CreditAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as CreditTotal
	FROM tJournalEntry je (nolock)
	WHERE
		JournalEntryKey = @EntityKey 
else if @Entity = 'RECEIPT'
	select c.* 
	      ,cl.CompanyName as ClientName
	from   tCheck c (nolock)
	inner join tCompany cl (nolock) on c.ClientKey = cl.CompanyKey 
	where  c.CheckKey = @EntityKey 	
else if @Entity = 'PAYMENT'
	select p.* 
	      ,v.CompanyName as VendorName
	from   tPayment p (nolock) 
	inner join tCompany v (nolock) on p.VendorKey = v.CompanyKey 
	where  p.PaymentKey = @EntityKey 
	
	
	RETURN 1
GO
