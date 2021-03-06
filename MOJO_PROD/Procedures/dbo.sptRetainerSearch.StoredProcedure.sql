USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerSearch]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerSearch]
	@CompanyKey int
	,@ClientKey int

AS -- Encrypt
	
  /*
  || When     Who Rel   What
  || 01/31/08 GHL 8.5   (20123) Using now tInvoiceSummary rather than tInvoiceLine    
  ||                     Restriction costs to LinkVoucherDetailKey null   
  */

	CREATE TABLE #tCost(ProjectKey INT NULL, RetainerKey INT, Billed MONEY NULL, TotalLabor MONEY NULL, TotalExpense MONEY NULL)
	
	INSERT #tCost 
	SELECT ProjectKey, RetainerKey, 0, 0, 0
	FROM   tProject (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    ISNULL(RetainerKey, 0) > 0
	
	UPDATE #tCost
		SET #tCost.TotalLabor = ISNULL((SELECT SUM(BillableCost)
									FROM   vProjectCosts (NOLOCK)
									WHERE  Type = 'LABOR'
									--AND    BillingStatus = 'Billed'
									AND    CompanyKey = @CompanyKey
									AND    ProjectKey = #tCost.ProjectKey
									AND    LinkVoucherDetailKey IS NULL
									), 0)
									
	UPDATE #tCost
		SET #tCost.TotalExpense = ISNULL((SELECT SUM(BillableCost)
									FROM   vProjectCosts (NOLOCK)
									WHERE  Type <> 'LABOR'
									--AND    BillingStatus = 'Billed'
									AND    CompanyKey = @CompanyKey
									AND    ProjectKey = #tCost.ProjectKey
									AND    LinkVoucherDetailKey IS NULL
									), 0)
	
	UPDATE #tCost
		SET #tCost.Billed = ISNULL((SELECT SUM(isum.Amount)								
									FROM	tInvoiceSummary isum (NOLOCK)
									INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
									WHERE   i.CompanyKey = @CompanyKey
									AND     isum.ProjectKey = #tCost.ProjectKey), 0)
		
										
	SELECT r.*
		  ,c.CustomerID
		  ,c.CompanyName
		  ,c.AccountManagerKey
		  ,ISNULL(am.FirstName, '')+' '+ISNULL(am.LastName, '') As AE
		  ,ISNULL((SELECT SUM(il.TotalAmount)								
						FROM	tInvoiceLine il (NOLOCK)
							INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey 
						WHERE   i.CompanyKey = @CompanyKey
						AND     il.RetainerKey = r.RetainerKey
						AND     il.BillFrom = 1	-- That is the retainer part	
			), 0) +
			(SELECT SUM(Billed) FROM #tCost WHERE #tCost.RetainerKey = r.RetainerKey) -- Extras
			AS TotalBilled
		  ,(SELECT SUM(TotalLabor) FROM #tCost WHERE #tCost.RetainerKey = r.RetainerKey) AS TotalLabor
		  ,(SELECT SUM(TotalExpense) FROM #tCost WHERE #tCost.RetainerKey = r.RetainerKey) AS TotalExpense
		  , CAST(0 AS MONEY) AS Variance			
		  FROM tRetainer r (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON r.ClientKey = c.CompanyKey 
		LEFT OUTER JOIN tUser am (NOLOCK) ON c.AccountManagerKey = am.UserKey
	WHERE
		r.CompanyKey = @CompanyKey
	AND (@ClientKey IS NULL OR r.ClientKey = @ClientKey )
	
	RETURN 1
GO
