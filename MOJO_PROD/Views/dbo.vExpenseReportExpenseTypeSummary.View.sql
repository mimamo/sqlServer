USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExpenseReportExpenseTypeSummary]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   View [dbo].[vExpenseReportExpenseTypeSummary]

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
*/

as
SELECT er.ExpenseEnvelopeKey, 
    i.ItemKey,  i.ItemName AS Description, 
    gl.AccountNumber,
    SUM(er.ActualQty) AS TotalQty, 
    SUM(er.ActualCost) AS TotalCost
FROM tExpenseReceipt er (nolock)
	LEFT OUTER JOIN tItem i (nolock) ON er.ItemKey = i.ItemKey
	LEFT OUTER JOIN tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
GROUP BY er.ExpenseEnvelopeKey, gl.AccountNumber,  i.ItemKey, i.ItemName
GO
