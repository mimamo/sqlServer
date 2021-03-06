USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailIncomeAdjustment]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailIncomeAdjustment]
	@GLCompanyKey int,
	@ClientKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@IncomeAdjustment money OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created for the Profit By Client Detail report
*/

	SELECT	@IncomeAdjustment = ISNULL(SUM(t.Credit - t.Debit), 0)
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		t.Entity = 'GENJRNL'
	AND		ISNULL(t.Overhead, 0) = 0
	AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		t.ClientKey = @ClientKey
GO
