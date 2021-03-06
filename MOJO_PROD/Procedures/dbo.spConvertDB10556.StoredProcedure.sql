USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10556]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10556]

AS

	-- Change GLCompanyKey 0 to NULL, for new listing restrict cause 
	update tInvoice
	set    GLCompanyKey = null
	where  GLCompanyKey = 0 

	-- Patch for tCashTransactionLine GLCompanyKey
	update tCashTransactionLine
	set    tCashTransactionLine.GLCompanyKey = i.GLCompanyKey
	from   tInvoice i (nolock)
	where  tCashTransactionLine.Entity = 'INVOICE'
	and    tCashTransactionLine.EntityKey = i.InvoiceKey
	and    isnull(tCashTransactionLine.GLCompanyKey, 0) <> isnull(i.GLCompanyKey, 0)


    update tCashTransactionLine
	set    tCashTransactionLine.GLCompanyKey = v.GLCompanyKey
	from   tVoucher v (nolock)
	where  tCashTransactionLine.Entity = 'VOUCHER'
	and    tCashTransactionLine.EntityKey = v.VoucherKey
	and    isnull(tCashTransactionLine.GLCompanyKey, 0) <> isnull(v.GLCompanyKey, 0)

	--For changes made to diary Emails
	update tPreference 
	set PopEmail = PopUserID 
	where len(ISNULL(PopServer, '')) > 0 and len(ISNULL(PopUserID, '')) >0 and len(ISNULL(PopEmail, ''))  = 0 and charindex('@', PopUserID) > 0

	update tPreference 
	set PopEmail = PopUserID + '@' + PopServer
	where len(ISNULL(PopServer, '')) > 0 and len(ISNULL(PopUserID, '')) >0 and len(ISNULL(PopEmail, ''))  = 0 and charindex('@', PopUserID) = 0

-- this solves problems with the CMContact lookup on the project setup	
update tProject
set KeyPeople1 = null where KeyPeople1 = 0
update tProject
set KeyPeople2 = null where KeyPeople2 = 0
update tProject
set KeyPeople3 = null where KeyPeople3 = 0
update tProject
set KeyPeople4 = null where KeyPeople4 = 0
update tProject
set KeyPeople5 = null where KeyPeople5 = 0
update tProject
set KeyPeople6 = null where KeyPeople6 = 0

update tQuote
set    tQuote.EstimateKey = ete.EstimateKey
from   tQuoteDetail qd (nolock)  
inner join tEstimateTaskExpense ete (nolock) on qd.QuoteDetailKey = ete.QuoteDetailKey 
where  tQuote.QuoteKey = qd.QuoteKey
GO
