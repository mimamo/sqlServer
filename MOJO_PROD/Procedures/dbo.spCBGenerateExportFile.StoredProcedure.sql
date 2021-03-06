USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCBGenerateExportFile]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCBGenerateExportFile]
	(
		@CBBatchKey INT
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
||                       Removed GL accounts since they are not used anymore in the Feeder file
||                       Removed grouping by cost accounts since LLNL wants 1 row per CMP Project + project/task
*/

	SET NOCOUNT ON

	SELECT  ROUND(cp.Debit, 3)		AS Debit
			,c.ProjectNumber
			,c.TaskNumber
			,p.ProjectNumber		AS OriginalTransactionReference
			,pt.ProjectNumPrefix	AS ExpenditureType
			,pt.ProjectTypeName		AS NonLaborResource
			,u.SystemID				AS EmployeeNumber
	FROM    tCBPosting cp (NOLOCK)
			INNER JOIN tCBCode c (NOLOCK) ON cp.CBCodeKey = c.CBCodeKey  
			INNER JOIN tProject p (NOLOCK) ON cp.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON p.BillingContact = u.UserKey
	WHERE   cp.CBBatchKey = @CBBatchKey 	
	AND     ISNULL(cp.CBCodeKey, 0) > 0 
	ORDER BY p.ProjectNumber, c.ProjectNumber, c.TaskNumber	

/*
	SELECT  ROUND(SUM(cp.Credit), 3) AS Credit
			,0						AS Debit
			,gla.AccountNumber collate SQL_Latin1_General_CP1_CI_AS AS AccountNumber
	FROM    tCBPosting cp (NOLOCK)
			INNER JOIN tGLAccount gla (NOLOCK) ON cp.GLAccountKey = gla.GLAccountKey  
	WHERE   cp.CBBatchKey = @CBBatchKey
	AND     ISNULL(cp.GLAccountKey, 0) > 0 	
	GROUP BY gla.AccountNumber,cp.GLAccountKey

	UNION

	SELECT  0							AS Credit
			,ROUND(SUM(cp.Debit), 3)	AS Debit
			,c.CBCode collate SQL_Latin1_General_CP1_CI_AS AS AccountNumber
	FROM    tCBPosting cp (NOLOCK)
			INNER JOIN tCBCode c (NOLOCK) ON cp.CBCodeKey = c.CBCodeKey  
	WHERE   cp.CBBatchKey = @CBBatchKey 	
	AND     ISNULL(cp.CBCodeKey, 0) > 0 	
	GROUP BY c.CBCode,cp.CBCodeKey

*/



	RETURN 1
GO
