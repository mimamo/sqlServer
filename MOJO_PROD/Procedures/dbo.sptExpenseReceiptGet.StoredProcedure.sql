USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReceiptGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseReceiptGet]
 @ExpenseReceiptKey int
AS --Encrypt
 
 SELECT rct.*
		,ISNULL(p.ProjectNumber, '') as ProjectNumber
        ,ISNULL(t.TaskID, '') AS TaskID
		,p.GLCompanyKey
 FROM   tExpenseReceipt rct (nolock)
	LEFT OUTER JOIN tProject p (NOLOCK) ON p.ProjectKey = rct.ProjectKey
	LEFT OUTER JOIN tTask t (NOLOCK) ON rct.TaskKey = t.TaskKey
 WHERE  rct.ExpenseReceiptKey = @ExpenseReceiptKey
 
 
 
 RETURN 1
GO
