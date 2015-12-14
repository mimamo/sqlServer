USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUNUGetExtract]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUNUGetExtract]
	(
	@CompanyKey int,
	@Type smallint,
	@AsOfDate smalldatetime = null
	)
	
AS

/*


   + <Debtor>
+ <Invoice>
+ <Payment>
+ <CreditNote>
+ <Allocation>
+ <Journal>

<Debtor>
  <customerId>964</customerId> 
  <name>J.Smith Contracting Ltd</name> 
  <governmentNumber /> 
  <debtorAddress1>P O Box 999-999</debtorAddress1> 
  <debtorAddress2>Mt Eden</debtorAddress2> 
  <debtorAddress3>Auckland</debtorAddress3> 
  <debtorAddress4 /> 
  <postCode /> 
  <contactName /> 
  <phone>09 2562344</phone> 
  <fax>09 2756186</fax> 
  <terms>7</terms> 
  <customerSince /> 
  <active>true</active> 
  <currentBalance>843.75</currentBalance> 
</Debtor>
<Invoice>
   <documentType>1</documentType> 
   <techTransactionID>00009758</techTransactionID> 
    <documentNumber>00009758</documentNumber> 
    <originalAmount>320.63</originalAmount> 
   <amount>120.00</amount> 
    <date>2008-11-22</date> 
   <actualDate>2008-11-22</actualDate> 
   <due>2008-12-20</due> 
   <customerRef>Services supplied</customerRef> 
    <customerId>963</customerId> 
   <customerName>F.Bloggs Works Ltd - Whangarei Branch</customerName> 
</Invoice>
<Payment>
  <paymentType></paymentType> 
  <documentType>22</documentType> 
  <techTransactionID>00009782</techTransactionID> 
  <documentNumber>CR003196</documentNumber> 
  <originalAmount>-946.70</originalAmount>
  <amount>0.00</amount> 
   <date>2008-11-21</date> 
  <actualDate>2008-11-21</actualDate> 
  <customerRef>Cheq 311111 </customerRef>
  <customerId>964</customerId> 
  <customerName>J.Smith Contracting Ltd</customerName> 
</Payment>
<CreditNote>
	<creditType></creditType> 
	<documentType>21</documentType> 
	<techTransactionID>00009614</techTransactionID> 
	<documentNumber>CN0004322</documentNumber> 
	<originalAmount>-390.15</originalAmount> 
	<amount>-100.00</amount> 
	 <date>2008-09-30</date> 
	 <actualDate>2008-09-30</actualDate> 
	<customerRef>Returned faulty goods</customerRef> 
	 <customerId>969</customerId> 
	  <customerName>XYZ  Earthmoving Ltd</customerName> 
</CreditNote>
<Allocation>
  <techTransactionID>00009432</ techTransactionID> 
  <documentNumber></documentNumber > 
   <invoiceNumber>00009758</invoiceNumber> 
  <paymentSource>cash</paymentSource> 
  <paymentNumber>00009888</paymentNumber> 
   <amount>-413.44</amount> 
   <date>2008-11-21</date> 
  <actualDate>2008-11-21</actualDate> 
  <customerRef> </customerRef>
  <customerId>338</customerId> 
  <customerName>H.Brown Ltd</customerName> 
</Allocation>
<Journal>
   <techTransactionID>JV000234</techTransactionID> 
    <documentNumber>JV000234</documentNumber> 
    <journalType>BD</journalType> 
   <amount>-100.56</amount> 
   <date>2008-11-21</date> 
  <customerRef>Bad Debt Writeoff</customerRef> 
   <customerId>338</customerId> 
   <customerName>Fletcher Construction Engineering</customerName> 
</Journal>

*/

if @Type = 0
BEGIN
/*
Need an initial feed, this will need to be:
   -  all open invoices,
   - all debtors referred to in those initial invoices,
   - any credits or payments that may relate to those invoices (there may be
   very little or nothing here, afterall they are still open invoices)
   - and the allocation of those credits and payments
   - as well as any journal entries that relate to those invoices. */

	Create table #tmpInv (
	InvoiceKey    INT NULL,
	ClientKey     INT NULL,
	 )

	Insert #tmpInv (InvoiceKey, ClientKey)
	Select InvoiceKey, ClientKey
	From tInvoice (nolock) 
	Where CompanyKey = @CompanyKey
	and InvoiceTotalAmount - RetainerAmount - AmountReceived > 0

	Select CustomerID as customerId,
		CompanyName as [name],
		EINNumber as governmentNumber,
		Address1 as debtorAddress1,
		Address2 as debtorAddress2,
		Address3 as debtorAddress3,
		NULL as debtorAddress4, 
		PostalCode as postCode,
		FirstName + ' ' + LastName as contactName,
		c.DateAdded as customerSince,
		c.Phone as phone, 
		c.Fax as fax,
		TermsNet as terms,
		case when c.Active = 1 then 'true' else 'false' end as Active, 
		0 as currentBalance
	From
		tCompany c (nolock) 
		left outer join tUser u (nolock) on c.PrimaryContact = u.UserKey
		left outer join tAddress a (nolock) on c.DefaultAddressKey = a.AddressKey
	Where c.CompanyKey in (Select Distinct ClientKey from #tmpInv)


	Select
	    1 as documentType,
		'INVOICE' + Cast(InvoiceKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		InvoiceTotalAmount as originalAmount,
		InvoiceTotalAmount - RetainerAmount - AmountReceived as amount,
		InvoiceDate as [date], --2008-11-22
		InvoiceDate as actualDate, 
		DueDate as due,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey

	Where i.CompanyKey = @CompanyKey and InvoiceKey in (Select InvoiceKey from #tmpInv)

	Select 
		NULL as paymentType,
		22 AS documentType,
		'RECEIPT' + Cast(CheckKey as Varchar) as techTransactionID,
		ReferenceNumber as documentNumber,
		CheckAmount as originalAmount,
		CheckAmount - (Select Sum(Amount) from tCheckAppl Where CheckKey = ch.CheckKey) as amount,
		CheckDate as [date], -->2008-11-21</date> 
		CheckDate as actualDate,
		ReferenceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tCheck ch (nolock)
		inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	Where
		ch.CheckKey in (Select CheckKey from tCheckAppl (nolock) Where InvoiceKey in (Select InvoiceKey from #tmpInv))

	Select 
	NULL AS creditType,
	21 as documentType,
	'CREDIT' + Cast(InvoiceKey as Varchar) as techTransactionID,
	InvoiceNumber as documentNumber,
	InvoiceTotalAmount as originalAmount,
	InvoiceTotalAmount - (Select Sum(Amount) from tInvoiceCredit (nolock) Where InvoiceKey = i.InvoiceKey) as amount, 
	InvoiceDate as [date], --2008-11-22
		InvoiceDate as actualDate, 
	InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey

	Where i.CompanyKey = @CompanyKey and InvoiceKey in (Select CreditInvoiceKey from tInvoiceCredit (nolock) Where InvoiceKey in (Select InvoiceKey from #tmpInv))

	Select
	  'CREDITALLOC'+ Cast(InvoiceCreditKey as Varchar) as techTransactionID,
	   i.InvoiceNumber as documentNumber,
	   'INVOICE' + Cast(ic.InvoiceKey as varchar) as invoiceNumber,
	  'credit' as paymentSource,
	   'INVOICE' + Cast(i.InvoiceKey as varchar) as paymentNumber,
	   ic.Amount as amount,
	   i.InvoiceDate as [date],
	   i.InvoiceDate as actualDate,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey
	inner join #tmpInv ici (nolock) on ic.InvoiceKey = ici.InvoiceKey
	Where i.CompanyKey = @CompanyKey

	UNION ALL

	Select
	  'RECEIPTALLOC'+ Cast(CheckApplKey as Varchar) as techTransactionID,
	   i.InvoiceNumber as documentNumber,
	   'INVOICE' + Cast(i.InvoiceKey as varchar) as invoiceNumber,
	  'cash' as paymentSource,
	   'RECEIPT' + Cast(ch.CheckKey as Varchar) as paymentNumber,
	   ca.Amount as amount,
	   ch.CheckDate as [date],
	   ch.CheckDate as actualDate,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tCheckAppl ca (nolock) on i.InvoiceKey = ca.InvoiceKey
	inner join tCheck ch (nolock) on ca.CheckKey = ch.CheckKey
	inner join #tmpInv ici (nolock) on ca.InvoiceKey = ici.InvoiceKey
	Where i.CompanyKey = @CompanyKey


	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		'INVOICE' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and t.Entity = 'INVOICE'
	inner join #tmpInv ici (nolock) on i.InvoiceKey = ici.InvoiceKey

	Where i.CompanyKey = @CompanyKey

	UNION ALL

	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		'CREDIT' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and t.Entity = 'INVOICE'
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey
	inner join #tmpInv ici (nolock) on ic.InvoiceKey = ici.InvoiceKey

	Where i.CompanyKey = @CompanyKey


	UNION ALL

	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		ReferenceNumber as documentNumber,
		'RECEIPT' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		ReferenceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tCheck ch (nolock)
	inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on ch.CheckKey = t.EntityKey and t.Entity = 'RECEIPT'
	Where
		ch.CompanyKey = @CompanyKey and ch.CheckKey in (Select CheckKey from tCheckAppl (nolock) Where InvoiceKey in (Select InvoiceKey from #tmpInv))




END    

if @Type = 1
BEGIN
-- any tran in the last 32 days

/*

Then there is the feed thereafter, which is simply the last 32 days worth of
transactions so it will be:
   - All Debtors that had any transaction in the last 32 days.
   - Any invoice in the last 32 days
   - Any Credit note, or payment in the last 32 days
   - The allocation of said credit notes, payments to invoices (even if the
   invoice being allocated to was outside the 32 day period you don't need to
   include it, as they'll have it from a previous feed and will be able to
   match)
   - The journals for above transactions.
*/

	if @AsOfDate is null
		Select @AsOfDate = DATEADD(d, -32, GETDATE())


	Select @AsOfDate = dbo.fFormatDateNoTime(@AsOfDate)

	Create table #tmpClient (
		ClientKey     INT NULL,
	 )

	 Insert #tmpClient(ClientKey)
	 Select Distinct ClientKey from tInvoice (nolock) Where CompanyKey = @CompanyKey and PostingDate >= @AsOfDate and PostingDate <= GETDATE()

	 
	 Insert #tmpClient(ClientKey)
	 Select Distinct ClientKey from tCheck (nolock) Where CompanyKey = @CompanyKey and PostingDate >= @AsOfDate and PostingDate <= GETDATE() and ClientKey not in (Select ClientKey from #tmpClient)

	Select CustomerID as customerId,
		CompanyName as [name],
		EINNumber as governmentNumber,
		Address1 as debtorAddress1,
		Address2 as debtorAddress2,
		Address3 as debtorAddress3,
		NULL as debtorAddress4, 
		PostalCode as postCode,
		FirstName + ' ' + LastName as contactName,
		c.DateAdded as customerSince,
		c.Phone as phone, 
		c.Fax as fax,
		TermsNet as terms,
		case when c.Active = 1 then 'true' else 'false' end as Active, 
		0 as currentBalance
	From
		tCompany c (nolock) 
		left outer join tUser u (nolock) on c.PrimaryContact = u.UserKey
		left outer join tAddress a (nolock) on c.DefaultAddressKey = a.AddressKey
		inner join #tmpClient cl on c.CompanyKey = cl.ClientKey


	Select
	    1 as documentType,
		'INVOICE' + Cast(InvoiceKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		InvoiceTotalAmount as originalAmount,
		InvoiceTotalAmount - RetainerAmount - AmountReceived as amount,
		InvoiceDate as [date], --2008-11-22
		InvoiceDate as actualDate, 
		DueDate as due,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey

	Where i.CompanyKey = @CompanyKey and PostingDate >= @AsOfDate and PostingDate <= GETDATE() and InvoiceTotalAmount > 0



	Select 
		'' as paymentType,
		21 AS documentType,
		'RECEIPT' + Cast(CheckKey as Varchar) as techTransactionID,
		ReferenceNumber as documentNumber,
		CheckAmount as originalAmount,
		CheckAmount - (Select Sum(Amount) from tCheckAppl Where CheckKey = ch.CheckKey) as amount,
		CheckDate as [date], -->2008-11-21</date> 
		CheckDate as actualDate,
		ReferenceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tCheck ch (nolock)
		inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	Where
		ch.CompanyKey = @CompanyKey and PostingDate >= @AsOfDate and PostingDate <= GETDATE()

	Select 
	'' AS creditType,
	22 as documentType,
	'CREDIT' + Cast(InvoiceKey as Varchar) as techTransactionID,
	InvoiceNumber as documentNumber,
	InvoiceTotalAmount as originalAmount,
	InvoiceTotalAmount - (Select Sum(Amount) from tInvoiceCredit (nolock) Where InvoiceKey = i.InvoiceKey) as amount, 
	InvoiceDate as [date], --2008-11-22
		InvoiceDate as actualDate, 
	InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey

	Where 
		i.CompanyKey = @CompanyKey and PostingDate >= @AsOfDate and PostingDate <= GETDATE() and InvoiceTotalAmount < 0


	Select
	  'CREDITALLOC'+ Cast(InvoiceCreditKey as Varchar) as techTransactionID,
	   i.InvoiceNumber as documentNumber,
	   'INVOICE' + Cast(ic.InvoiceKey as varchar) as invoiceNumber,
	  'credit' as paymentSource,
	   'INVOICE' + Cast(i.InvoiceKey as varchar) as paymentNumber,
	   ic.Amount as amount,
	   i.InvoiceDate as [date],
	   i.InvoiceDate as actualDate,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey
	Where i.CompanyKey = @CompanyKey and i.PostingDate >= @AsOfDate and i.PostingDate <= GETDATE()

	UNION ALL

	Select
	  'RECEIPTALLOC'+ Cast(CheckApplKey as Varchar) as techTransactionID,
	   i.InvoiceNumber as documentNumber,
	   'INVOICE' + Cast(i.InvoiceKey as varchar) as invoiceNumber,
	  'cash' as paymentSource,
	   'RECEIPT' + Cast(ch.CheckKey as Varchar) as paymentNumber,
	   ca.Amount as amount,
	   ch.CheckDate as [date],
	   ch.CheckDate as actualDate,
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tCheckAppl ca (nolock) on i.InvoiceKey = ca.InvoiceKey
	inner join tCheck ch (nolock) on ca.CheckKey = ch.CheckKey
	Where i.CompanyKey = @CompanyKey and ch.PostingDate >= @AsOfDate and ch.PostingDate <= GETDATE()


	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		'INVOICE' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and t.Entity = 'INVOICE'

	Where i.CompanyKey = @CompanyKey and i.PostingDate >= @AsOfDate and i.PostingDate <= GETDATE()

	UNION ALL

	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		InvoiceNumber as documentNumber,
		'CREDIT' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		InvoiceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and t.Entity = 'INVOICE'
	inner join tInvoiceCredit ic (nolock) on i.InvoiceKey = ic.CreditInvoiceKey

	Where i.CompanyKey = @CompanyKey and i.PostingDate >= @AsOfDate and i.PostingDate <= GETDATE()


	UNION ALL

	Select
	   'JOURNAL' + Cast(TransactionKey as varchar) as techTransactionID,
		ReferenceNumber as documentNumber,
		'RECEIPT' as journalType,
		Debit - Credit as amount,
	   TransactionDate as [date],
		ReferenceNumber as customerRef, 
		CustomerID as customerId,
		CompanyName as customerName
	From tCheck ch (nolock)
	inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	inner join tTransaction t (nolock) on ch.CheckKey = t.EntityKey and t.Entity = 'RECEIPT'
	Where
		ch.CompanyKey = @CompanyKey and  ch.PostingDate >= @AsOfDate and ch.PostingDate <= GETDATE()





END
GO
