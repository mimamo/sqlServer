USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetToInvoiceList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetToInvoiceList]
	(
		@CompanyKey INT,
		@ClientKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON

	SELECT b.*
		  ,b.LaborTotal + b.ExpenseTotal as TMTotal
		  ,p.ProjectNumber 
		  ,p.ProjectName
		  ,c.CustomerID
		  ,c.CompanyName		  	
	FROM   tBilling b (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON b.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tCompany c (NOLOCK) ON b.ClientKey = c.CompanyKey
	WHERE  b.CompanyKey = @CompanyKey 
	AND    (@ClientKey IS NULL OR (b.ClientKey = @ClientKey))
	AND    ISNULL(b.ParentWorksheet, 0) = 0	-- Not a parent
	AND    ISNULL(b.ParentWorksheetKey, 0) = 0	-- Does not have a parent
	AND    b.Status = 4				-- Approved
	
	UNION ALL
	
	SELECT b.*
		  ,b.LaborTotal + b.ExpenseTotal as TMTotal
		  ,p.ProjectNumber 
		  ,p.ProjectName
		  ,c.CustomerID
		  ,c.CompanyName
	FROM   tBilling b (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON b.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tCompany c (NOLOCK) ON b.ClientKey = c.CompanyKey
	WHERE  b.CompanyKey = @CompanyKey 
	AND    (@ClientKey IS NULL OR (b.ClientKey = @ClientKey))
	AND    ISNULL(b.ParentWorksheet, 0) = 1	-- A parent
	AND    b.Status = 4				-- Approved
	/*
	AND    b.BillingKey NOT IN (SELECT DISTINCT b2.ParentWorksheetKey
								FROM   tBilling b2 (NOLOCK)
								WHERE  b2.CompanyKey = @CompanyKey
								AND    b2.ParentWorksheet = 0	-- Not a parent
								AND    b2.Status < 4				-- Not Approved
								)
	*/	
	RETURN 1
GO
