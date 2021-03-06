USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetExpenseForInvoiceLine]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGetExpenseForInvoiceLine]
 @InvoiceLineKey int
 
AS --Encrypt

/*
|| When     Who Rel  What
|| 07/09/07 GHL 8.5  Added restriction on ERs 
|| 07/10/07 QMD 8.5  Expense Type reference changed to tItem
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

 SELECT t.*, i.ItemName, ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS Person
 FROM   tExpenseReceipt t (NOLOCK)
        INNER JOIN tUser u (NOLOCK) ON t.UserKey = u.UserKey 
        LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey 
 WHERE  t.InvoiceLineKey = @InvoiceLineKey
 ORDER BY ExpenseDate
GO
