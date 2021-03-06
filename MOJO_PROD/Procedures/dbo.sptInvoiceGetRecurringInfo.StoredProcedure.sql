USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetRecurringInfo]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetRecurringInfo]
 @InvoiceKey int
AS --Encrypt

Declare @Paid int, @WIPPost int, @UseDetail int, @HasPrepay int

If Exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 0)
	Select @Paid = 1

IF EXISTS(SELECT 1 FROM tTime (nolock) inner join tInvoiceLine (nolock) on tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tExpenseReceipt (nolock) inner join tInvoiceLine (nolock) on tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tMiscCost (nolock) inner join tInvoiceLine (nolock) on tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) inner join tInvoiceLine (nolock) on tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
If Exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 1)
	Select @HasPrepay = 1

If Exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @InvoiceKey and BillFrom = 2)
	Select @UseDetail = 1

  SELECT 
	tInvoice.*
	,tCompany.CompanyName as ClientName
	,tCompany.CustomerID as ClientID
	,ISNULL(@Paid, 0) as Paid
	,ISNULL(@WIPPost, 0) as WIPPost
	,ISNULL(@HasPrepay, 0) as HasPrepay
	,ISNULL(@UseDetail, 0) as UseDetail
  FROM 
	tInvoice (nolock) 
	inner join tCompany (nolock) on tInvoice.ClientKey = tCompany.CompanyKey
  WHERE
	InvoiceKey = @InvoiceKey
 RETURN 1
GO
