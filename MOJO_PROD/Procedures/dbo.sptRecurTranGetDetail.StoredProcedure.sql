USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGetDetail]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGetDetail]
	(
	@RecurTranKey int,
	@CompanyKey int
	)

AS 

 /*
  || When     Who Rel       What
  || 7/2/10   RLB 10532     Only pulling active users to remind
  */

SET NOCOUNT ON

declare @Entity varchar(50)
declare @EntityKey int

select @Entity = Entity
       ,@EntityKey = EntityKey
from   tRecurTran (nolock)
where   RecurTranKey = @RecurTranKey

Select *,
	CASE 
		WHEN Entity = 'INVOICE' THEN (Select InvoiceNumber from tInvoice (nolock) Where InvoiceKey = EntityKey)
		WHEN Entity = 'RECEIPT' THEN (Select ReferenceNumber from tCheck (nolock) Where CheckKey = EntityKey)
		WHEN Entity IN ('VOUCHER', 'CREDITCARD') THEN (Select InvoiceNumber from tVoucher (nolock) Where VoucherKey = EntityKey)
		WHEN Entity = 'PAYMENT' THEN (Select CheckNumber from tPayment (nolock) Where PaymentKey = EntityKey)
		WHEN Entity = 'GENJRNL' THEN (Select JournalNumber from tJournalEntry (nolock) Where JournalEntryKey = EntityKey) end as TransactionReference
from tRecurTran (nolock) Where RecurTranKey = @RecurTranKey

Select UserKey, FirstName + ' ' + LastName as UserName,
	(Select 1 from tRecurTranUser Where tRecurTranUser.UserKey = tUser.UserKey and tRecurTranUser.RecurTranKey = @RecurTranKey) as userSelected
From tUser (nolock) 
Where CompanyKey = @CompanyKey
and Active = 1
Order By FirstName, LastName


if @Entity = 'INVOICE'
	Select InvoiceKey
	      ,InvoiceNumber
	      ,InvoiceDate
	      ,BCompanyName As ClientName
	      ,BilledAmount
	      ,OpenAmount
	      ,InvoiceStatus
	from vInvoice 
	Where RecurringParentKey = @EntityKey and InvoiceKey <> @EntityKey and RecurringParentKey > 0
	Order By InvoiceDate
else if @Entity = 'VOUCHER'
	Select VoucherKey
	      ,InvoiceNumber
	      ,InvoiceDate
	      ,VendorName
	      ,VoucherTotal
	      ,OpenAmount
	      ,Status as InvoiceStatus
	from vVoucher 
	Where RecurringParentKey = @EntityKey and VoucherKey <> @EntityKey and RecurringParentKey > 0
	Order By InvoiceDate
else if @Entity = 'GENJRNL'
	SELECT 
		je.*, 
		(Select sum(DebitAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as DebitTotal,
		(Select sum(CreditAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as CreditTotal
	FROM tJournalEntry je (nolock)
	WHERE
		RecurringParentKey = @EntityKey and JournalEntryKey <> @EntityKey and RecurringParentKey > 0
	Order By
		PostingDate
else if @Entity = 'RECEIPT'
	select c.* 
	      ,cl.CompanyName as ClientName
	from   tCheck c (nolock)
	inner join tCompany cl (nolock) on c.ClientKey = cl.CompanyKey 
	where  c.RecurringParentKey = @EntityKey and c.CheckKey <> @EntityKey and RecurringParentKey > 0	
	Order by c.CheckDate
else if @Entity = 'PAYMENT'
	select p.* 
	      ,v.CompanyName as VendorName
	from   tPayment p (nolock) 
	inner join tCompany v (nolock) on p.VendorKey = v.CompanyKey 
	where  p.RecurringParentKey = @EntityKey and p.PaymentKey <> @EntityKey and RecurringParentKey > 0	
	Order by p.PaymentDate
else if @Entity = 'CREDITCARD'
	Select VoucherKey
	      ,InvoiceNumber
	      ,InvoiceDate
	      ,VendorName
	      ,VoucherTotal
	      ,OpenAmount
	      ,Status as InvoiceStatus
	from vVoucher 
	Where RecurringParentKey = @EntityKey and VoucherKey <> @EntityKey and RecurringParentKey > 0
	Order By InvoiceDate
GO
