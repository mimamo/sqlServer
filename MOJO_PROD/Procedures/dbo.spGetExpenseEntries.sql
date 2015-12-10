USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetExpenseEntries]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetExpenseEntries]
 @InvoiceLineKey int,
 @FromDate smalldatetime,
 @ToDate smalldatetime
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/10/07 QMD 8.5   Expense Type reference changed to tItem
  || 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
  */

 DECLARE @ProjectKey int
 
 SELECT @ProjectKey = ProjectKey
 FROM tInvoiceLine (NOLOCK)
 WHERE InvoiceLineKey = @InvoiceLineKey

 SELECT DISTINCT t.*, i.ItemName, ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS Person
 FROM   tExpenseReceipt t (NOLOCK)
        INNER JOIN tUser u (NOLOCK) ON t.UserKey = u.UserKey
        INNER JOIN tExpenseEnvelope e (nolock) ON t.ExpenseEnvelopeKey = e.ExpenseEnvelopeKey
		LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
WHERE  t.ProjectKey = @ProjectKey
        AND  e.Status = 4  --approved
        AND  t.InvoiceLineKey IS NULL
        AND  t.WriteOff = 0
        AND  ((t.ExpenseDate BETWEEN @FromDate AND @ToDate)
            OR ((@FromDate IS NULL) AND (t.ExpenseDate <= @ToDate))
            OR ((@ToDate IS NULL) AND (t.ExpenseDate >= @FromDate))
            OR ((@FromDate IS NULL) AND (@ToDate IS NULL)))
 ORDER BY t.ExpenseDate
GO
