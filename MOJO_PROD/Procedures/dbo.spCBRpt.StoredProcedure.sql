USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCBRpt]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCBRpt]
	(
		@CompanyKey INT
		,@StartDate SMALLDATETIME
		,@EndDate SMALLDATETIME		
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

	SET NOCOUNT ON

	SELECT	1				AS PostingType
			,SUM(cp.Credit)	AS Credit
			,0				AS Debit
			,gla.AccountNumber collate SQL_Latin1_General_CP1_CI_AS	AS AccountNumber
	FROM    tCBPosting cp (NOLOCK)
			INNER JOIN tGLAccount gla (NOLOCK) ON cp.GLAccountKey = gla.GLAccountKey  
			INNER JOIN tCBBatch b (NOLOCK) ON cp.CBBatchKey = b.CBBatchKey
	WHERE   b.CompanyKey = @CompanyKey
	AND     ISNULL(cp.GLAccountKey, 0) > 0 	
	AND		b.EndDate <= @EndDate
	AND     b.StartDate >= @StartDate		 
	GROUP BY gla.AccountNumber,cp.GLAccountKey

	UNION

	SELECT  2				AS PostingType
			,0				AS Credit
			,SUM(cp.Debit)	AS Debit
			,ISNULL(c.ProjectNumber, '') + ' - ' + ISNULL(c.TaskNumber, '')  collate SQL_Latin1_General_CP1_CI_AS		AS AccountNumber
	FROM    tCBPosting cp (NOLOCK)
			INNER JOIN tCBCode c (NOLOCK) ON cp.CBCodeKey = c.CBCodeKey  
			INNER JOIN tCBBatch b (NOLOCK) ON cp.CBBatchKey = b.CBBatchKey
	WHERE   b.CompanyKey = @CompanyKey
	AND		b.EndDate <= @EndDate
	AND     b.StartDate >= @StartDate		 
	AND     ISNULL(cp.CBCodeKey, 0) > 0 	
	GROUP BY c.ProjectNumber , c.TaskNumber,cp.CBCodeKey




	RETURN 1
GO
