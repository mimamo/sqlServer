USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateER]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdateER]
 @ExpenseReceiptKey int,
 @AmountBilled money,
 @InvoiceLineKey int
 
AS --Encrypt

  
 UPDATE tExpenseReceipt
 SET	AmountBilled = @AmountBilled,
		InvoiceLineKey = @InvoiceLineKey
 WHERE	ExpenseReceiptKey = @ExpenseReceiptKey
 
 
 RETURN 1
GO
