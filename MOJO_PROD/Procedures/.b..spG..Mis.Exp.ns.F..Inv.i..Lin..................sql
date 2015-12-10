USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetMiscExpenseForInvoiceLine]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGetMiscExpenseForInvoiceLine]
 @InvoiceLineKey int
 
AS --Encrypt
 SELECT t.*
 FROM tMiscCost t (NOLOCK)
 WHERE t.InvoiceLineKey = @InvoiceLineKey
 ORDER BY ExpenseDate
GO
