USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBridgerConwayBilling]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBridgerConwayBilling]
	(
	@CompanyKey int
	,@StartDate datetime
	,@EndDate datetime
	)
AS --Encrypt

	SET NOCOUNT ON
	
	/*
	|| When     Who Rel   What
	|| 07/01/08 GHL 8.515 Creation for Bridger Conway
	*/
	
	IF @StartDate IS NULL
		SELECT @StartDate = '1/1/2000'
	IF @EndDate IS NULL
		SELECT @EndDate = '1/1/2050'
		
		
	SELECT  i.InvoiceNumber
			,i.InvoiceDate
			,i.InvoiceTotalAmount
			,wt.WorkTypeName
			,e.EstimateNumber
			,e.EstimateDate
			,e.ExpenseGross
			,e.ExpenseNet
			,cl.CustomerID + ' / ' + cl.CompanyName as ClientFullName
			,cl.CustomerID
			,cl.CompanyName as ClientName
			,p.ProjectNumber + ' / ' + p.ProjectName as ProjectFullName
			,p.ProjectNumber
			,p.ProjectName
			,u.FirstName + ' ' + u.LastName AS AccountManagerName
			,c.ClassName
	FROM	tInvoice i (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
		INNER JOIN tCompany cl (NOLOCK) ON i.ClientKey = cl.CompanyKey
		LEFT OUTER JOIN tEstimate e (NOLOCK) ON il.EstimateKey = e.EstimateKey
		LEFT OUTER JOIN tWorkType wt (NOLOCK) ON il.WorkTypeKey = wt.WorkTypeKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON i.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tUser u (NOLOCK) ON p.AccountManager = u.UserKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON i.ClassKey = c.ClassKey
	WHERE i.CompanyKey = @CompanyKey
	AND   i.InvoiceDate BETWEEN @StartDate AND @EndDate
	ORDER BY i.InvoiceDate, i.InvoiceNumber, il.InvoiceLineKey
	
	RETURN 1
GO
