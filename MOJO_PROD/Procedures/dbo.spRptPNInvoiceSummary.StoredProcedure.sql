USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPNInvoiceSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPNInvoiceSummary]
	(
	@CompanyKey int,
	@StartDate datetime,
	@EndDate datetime,
	@ClientKey int,
	@ClassKey int
	)
AS --Encrypt

/*
|| When      Who Rel       What
|| 12/29/08  GHL 10.015    Creation for Enhancement 38366
||                         Requirements are:
||                         - 1 line per invoice
||                         - For GL 511, need to figure out Net of Vouchers/Misc Cost/Exp Receipts
||                           and calculate Markup = Amt Billed - Net
||                         Cols should be:
||                         - GL 345 Sls Tax (GLAccountKey = 68)
||                         - GL 510 Retainer (GLAccountKey = 155)
||                         - GL 517 Agency Time (GLAccountKey = 157)
||                         - GL 511 Production Income, Expense Net (GLAccountKey = 156)
||                         - GL 511 Production Income, Markup (GLAccountKey = 156)
||                         - GL 346 Advance Billing (GLAccountKey = 152)
||                         Filter Options:
||                         -- Date Range for Invoice Date 
||                         -- Client 
||                         -- Office
||
||                         Database shows that there is a single project per invoice
||                         Parent Company in the Excel report
||                         
||                         Initially PN wanted a report similar to Invoice Summary
||                         But MW created a custom report based on vReport_GLTransaction
||                         So we decided to run off the report from tTransaction
|| 2/9/09	MFT 10.0.1.8  (46195) Changed Office param to Class
|| 3/3/09	MFT 10.0.2.0  (48204) Changed the name of the #summary Office fields to Class to match param
|| 10/29/10 RLB 10.5.3.7  (93336) changed how Expense Net calculated
*/

	SET NOCOUNT ON
	 
	CREATE TABLE #summary (
		InvoiceKey int null
		,InvoiceDate datetime null
		,InvoiceNumber varchar(35) null
		,ClientKey int null
		,ClientFullName varchar(250) null
		,ParentClientKey int null
		,ParentClientFullName varchar(250) null
		,ProjectKey int null				-- Project on header
		,ProjectNumber varchar(50) null
		,ProjectName varchar(100) null
		,ClientProjectNumber varchar(200) null
		,ClientDivisionName varchar(300) null	-- from project
		,ClientProductName varchar(300) null	-- from project
        ,ClassKey int null					-- from project
        ,ClassID varchar(50) null
        ,ClassName varchar(200) null
        
        ,InvoiceTotalAmount money null
      	,Amount345 money null
      	,Amount510 money null
      	,Amount517 money null
      	,Amount511 money null
      	,NetAmount511 money null
      	,MUAmount511 money null -- Markup
      	,Amount346 money null
		)
	
	-- Hardcode GL accounts
	DECLARE @GLAccountKey345 INT	SELECT @GLAccountKey345 = 68
	DECLARE @GLAccountKey510 INT	SELECT @GLAccountKey510 = 155
	DECLARE @GLAccountKey517 INT	SELECT @GLAccountKey517 = 157
	DECLARE @GLAccountKey511 INT	SELECT @GLAccountKey511 = 156
	DECLARE @GLAccountKey346 INT	SELECT @GLAccountKey346 = 152

	IF @StartDate IS NULL
		SELECT @StartDate = '1/1/1950'

	IF @EndDate IS NULL
		SELECT @EndDate = '1/1/2050'

		
	-- One line per invoice
	INSERT #summary(
		InvoiceKey, InvoiceNumber, InvoiceDate, InvoiceTotalAmount
		,ClientKey, ClientFullName
		,ParentClientKey, ParentClientFullName
		,ProjectKey, ProjectNumber, ProjectName, ClientProjectNumber 
        ,ClientDivisionName, ClientProductName
        ,ClassKey, ClassID, ClassName
		)
	SELECT DISTINCT 
		-- t.EntityKey, i.InvoiceNumber, i.InvoiceDate   Modified to show even if the invoice was $0
		i.InvoiceKey, i.InvoiceNumber, i.InvoiceDate
		-- On the spreadsheet they gave us, they subtract RetainerAmount (amount applied to adv bills)
		, i.InvoiceTotalAmount - ISNULL(RetainerAmount, 0)  
	    ,i.ClientKey, ISNULL(cl.CustomerID + ' - ' , '') + ISNULL(cl.CompanyName, '')  
	    ,cl.ParentCompanyKey, ISNULL(pcl.CustomerID + ' - ' , '') + ISNULL(pcl.CompanyName, '')  
	    ,i.ProjectKey, p.ProjectNumber, p.ProjectName, p.ClientProjectNumber 
        ,cd.DivisionName, cp.ProductName
        ,c.ClassKey, c.ClassID, c.ClassName
	FROM   
		--tTransaction t (NOLOCK)
		--INNER JOIN tInvoice i (NOLOCK) ON t.EntityKey = i.InvoiceKey     Modified to show even if the invoice was $0
		tInvoice i (NOLOCK) 
		INNER JOIN tCompany cl (NOLOCK) ON i.ClientKey = cl.CompanyKey
		LEFT OUTER JOIN tCompany pcl (NOLOCK) ON cl.ParentCompanyKey = pcl.CompanyKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON i.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON i.ClassKey = c.ClassKey
		LEFT OUTER JOIN tClientProduct cp (NOLOCK) ON p.ClientProductKey = cp.ClientProductKey
		LEFT OUTER JOIN tClientDivision cd (NOLOCK) ON cp.ClientDivisionKey = cd.ClientDivisionKey
	WHERE  --t.Entity = 'INVOICE' AND        Modified to show even if the invoice was $0
	i.InvoiceDate >= @StartDate
	AND    i.InvoiceDate <= @EndDate
	AND    (@ClientKey IS NULL OR i.ClientKey = @ClientKey) 
	AND    (@ClassKey IS NULL OR c.ClassKey = @ClassKey) 
		
	-- Sales Taxes	
	UPDATE #summary
	SET    #summary.Amount345 = (SELECT SUM(t.Credit - t.Debit)
		FROM tTransaction t (NOLOCK)
		WHERE t.Entity = 'INVOICE'
		AND   t.EntityKey = #summary.InvoiceKey
		AND   t.GLAccountKey = @GLAccountKey345
		)
	
	-- Retainer
	UPDATE #summary
	SET    #summary.Amount510 = (SELECT SUM(t.Credit - t.Debit)
		FROM tTransaction t (NOLOCK)
		WHERE t.Entity = 'INVOICE'
		AND   t.EntityKey = #summary.InvoiceKey
		AND   t.GLAccountKey = @GLAccountKey510
		)
	
	-- Agency Time
	UPDATE #summary
	SET    #summary.Amount517 = (SELECT SUM(t.Credit - t.Debit)
		FROM tTransaction t (NOLOCK)
		WHERE t.Entity = 'INVOICE'
		AND   t.EntityKey = #summary.InvoiceKey
		AND   t.GLAccountKey = @GLAccountKey517
		)

	-- Prodcution Income
	-- This should be on a line so I take Credit - Debit 
	UPDATE #summary
	SET    #summary.Amount511 = (SELECT SUM(t.Credit - t.Debit)
		FROM tTransaction t (NOLOCK)
		WHERE t.Entity = 'INVOICE'
		AND   t.EntityKey = #summary.InvoiceKey
		AND   t.GLAccountKey = @GLAccountKey511
		)
	
	-- Now calculate the Net for GL Account511
UPDATE #summary
	SET    #summary.NetAmount511 = (SELECT SUM(v.TotalCost)
		FROM vProjectCosts v (NOLOCK)
		where v.Type in ('VOUCHER', 'EXPRPT', 'MISCCOST')
		AND v.InvoiceLineKey in (
		select t.DetailLineKey from tTransaction t (nolock)
		where t.Entity = 'INVOICE'
		and t.EntityKey = #summary.InvoiceKey
		and t.GLAccountKey = @GLAccountKey511
		))
	
	-- Now calculate the Markup for GL Account511
	UPDATE #summary
	SET    #summary.MUAmount511 = ISNULL(Amount511, 0) - ISNULL(NetAmount511, 0)
	
	UPDATE #summary
	SET    #summary.MUAmount511 = NULL 
	WHERE  #summary.MUAmount511 = 0
	
	UPDATE #summary
	SET    #summary.Amount346 = (SELECT SUM(t.Credit - t.Debit)
		FROM tTransaction t (NOLOCK)
		WHERE t.Entity = 'INVOICE'
		AND   t.EntityKey = #summary.InvoiceKey
		AND   t.GLAccountKey = @GLAccountKey346
		)
		
    SELECT * FROM #summary
		 
	RETURN 1
GO
