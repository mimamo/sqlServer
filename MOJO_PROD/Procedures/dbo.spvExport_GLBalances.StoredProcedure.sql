USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_GLBalances]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spvExport_GLBalances]
	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 02/20/08 GHL 8.5  Creation for customization
|| 04/16/08 GHL 8.508 (24999) Fixed the balance
*/

	SET NOCOUNT ON

	SELECT gl.AccountNumber 
		  ,ISNULL(
		  (SELECT SUM(Debit) FROM tTransaction t (NOLOCK) 
		  WHERE gl.GLAccountKey = t.GLAccountKey
		  AND   t.TransactionDate BETWEEN @StartDate AND @EndDate) 
		  ,0) AS Debit

		  ,ISNULL(
		  (SELECT SUM(Credit) FROM tTransaction t (NOLOCK) 
		  WHERE gl.GLAccountKey = t.GLAccountKey
		  AND   t.TransactionDate BETWEEN @StartDate AND @EndDate) 
		  ,0) AS Credit

 		  ,ISNULL(
		  (SELECT SUM(Debit - Credit) FROM tTransaction t (NOLOCK) 
		  WHERE gl.GLAccountKey = t.GLAccountKey
		  AND   t.TransactionDate BETWEEN @StartDate AND @EndDate) 
		  ,0) AS Balance

	FROM   tGLAccount gl (NOLOCK)
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.Active = 1
	AND    gl.Rollup = 0
	ORDER BY gl.AccountNumber

	RETURN 1
GO
