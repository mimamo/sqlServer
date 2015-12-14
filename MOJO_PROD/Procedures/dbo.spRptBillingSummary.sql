USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBillingSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptBillingSummary]
	(
		@CompanyKey INT,
		@Year INT
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/09/07 GHL 8.5   Addded restriction on ERs
  || 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
  */

/*
	CREATE TABLE #tBillingSum (
		Month INT NULL
		,TotalHours decimal(9, 3) null
		,BillableHours decimal(9, 3) null
		,NonBillableHours decimal(9, 3) null
		,BillableAmountTime money null
		,BillableAmountOther money null
		,BillableAmount money null
		,InvoiceAmount money null
		,CheckAmount money null)
*/		

	TRUNCATE TABLE #tBillingSum
	
	INSERT #tBillingSum (Month) VALUES (1)
	INSERT #tBillingSum (Month) VALUES (2)
	INSERT #tBillingSum (Month) VALUES (3)
	INSERT #tBillingSum (Month) VALUES (4)
	INSERT #tBillingSum (Month) VALUES (5)
	INSERT #tBillingSum (Month) VALUES (6)
	INSERT #tBillingSum (Month) VALUES (7)
	INSERT #tBillingSum (Month) VALUES (8)
	INSERT #tBillingSum (Month) VALUES (9)
	INSERT #tBillingSum (Month) VALUES (10)
	INSERT #tBillingSum (Month) VALUES (11)
	INSERT #tBillingSum (Month) VALUES (12)
	
	-- Hours
	
	UPDATE #tBillingSum
	SET    TotalHours = (SELECT SUM(ISNULL(t.ActualHours, 0))
	FROM   tTime         t  (NOLOCK)
	       ,tTimeSheet   ts (NOLOCK)
	WHERE  DATEPART(Year, t.WorkDate) = @Year
	AND    DATEPART(Month, t.WorkDate) = #tBillingSum.Month
	AND    t.TimeSheetKey = ts.TimeSheetKey
	AND    ts.CompanyKey = @CompanyKey
	)	 	
	
	UPDATE #tBillingSum
	SET    BillableHours = (SELECT SUM(ISNULL(t.ActualHours, 0))
	FROM   tTime         t  (NOLOCK)
	       INNER JOIN tTimeSheet   ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
	       LEFT OUTER JOIN tProject  p  (NOLOCK) ON t.ProjectKey = p.ProjectKey
	WHERE  DATEPART(Year, t.WorkDate) = @Year
	AND    DATEPART(Month, t.WorkDate) = #tBillingSum.Month
	AND    ts.CompanyKey = @CompanyKey
	AND    ((p.NonBillable = 0 OR p.NonBillable IS NULL)
					AND t.ActualRate > 0)
	)
	 			
	UPDATE #tBillingSum
	SET    NonBillableHours = ISNULL(TotalHours, 0) 
	                        - ISNULL(BillableHours, 0)
	
	-- Billable Amount from time
	 
	UPDATE #tBillingSum
	SET    BillableAmountTime = (SELECT SUM(ROUND(ISNULL(t.ActualHours, 0) * ISNULL(t.ActualRate, 0), 2))
	FROM   tTime         t  (NOLOCK)
	       INNER JOIN tTimeSheet   ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
	       LEFT OUTER JOIN tProject  p  (NOLOCK) ON t.ProjectKey = p.ProjectKey
	WHERE  DATEPART(Year, t.WorkDate) = @Year
	AND    DATEPART(Month, t.WorkDate) = #tBillingSum.Month
	AND    ts.CompanyKey              = @CompanyKey
	AND    ((p.NonBillable = 0 OR p.NonBillable IS NULL)
					AND t.ActualRate > 0)
	)                         

	-- Billable Amount from 3 other tables 
	 
	UPDATE #tBillingSum
	SET    BillableAmountOther = 

	ISNULL((SELECT SUM(v.BillableCost)
	FROM   tExpenseReceipt v (NOLOCK) inner join tProject p (NOLOCK) on v.ProjectKey = p.ProjectKey
	WHERE  DATEPART(Year, v.ExpenseDate)  = @Year
	AND    DATEPART(Month, v.ExpenseDate) = #tBillingSum.Month
	AND    p.CompanyKey                   = @CompanyKey
	AND    p.NonBillable = 0
	AND    v.VoucherDetailKey IS NULL
	), 0) +                        
	ISNULL((SELECT SUM(v.BillableCost)
	FROM   tMiscCost v (NOLOCK) inner join tProject p (NOLOCK) on v.ProjectKey = p.ProjectKey
	WHERE  DATEPART(Year, v.ExpenseDate)  = @Year
	AND    DATEPART(Month, v.ExpenseDate) = #tBillingSum.Month
	AND    p.CompanyKey                   = @CompanyKey
	AND    p.NonBillable = 0
	), 0) + 
	ISNULL((SELECT SUM(v.BillableCost)
	FROM   tVoucherDetail v (NOLOCK) 
		inner join tProject p (NOLOCK) on v.ProjectKey = p.ProjectKey
		inner join tVoucher vo (nolock) on v.VoucherKey = vo.VoucherKey
	WHERE  DATEPART(Year, vo.InvoiceDate)  = @Year
	AND    DATEPART(Month, vo.InvoiceDate) = #tBillingSum.Month
	AND    p.CompanyKey                   = @CompanyKey
	AND    p.NonBillable = 0
	), 0)

	UPDATE #tBillingSum
	SET    BillableAmount = ISNULL(BillableAmountTime, 0) + ISNULL(BillableAmountOther, 0)
	
	-- Check Amount
	
	UPDATE #tBillingSum
	SET    CheckAmount = (SELECT SUM(ISNULL(ch.CheckAmount, 0))
	FROM   tCheck      ch (NOLOCK)
	      ,tCompany    c  (NOLOCK)
	WHERE  DATEPART(Year, ch.CheckDate) = @Year
	AND    DATEPART(Month, ch.CheckDate) = #tBillingSum.Month
	AND		 ch.ClientKey       = c.CompanyKey
	AND    c.OwnerCompanyKey  = @CompanyKey
	) 
	
	-- Invoice Amount
	
	UPDATE #tBillingSum
	SET    InvoiceAmount = (SELECT SUM(ISNULL(i.InvoiceTotalAmount, 0))
	FROM   tInvoice    i (NOLOCK)
	WHERE  DATEPART(Year, i.InvoiceDate) = @Year
	AND    DATEPART(Month, i.InvoiceDate) = #tBillingSum.Month
	AND    i.CompanyKey  = @CompanyKey
	) 
	
	-- Could delete when no activity
	/*
	DELETE #tBillingSum
	WHERE TotalHours IS null
	AND   BillableHours IS null
	AND   NonBillableHours IS null
	AND   BillableAmountTime IS null
	AND   BillableAmountOther IS null
	AND   BillableAmount IS null
	AND   InvoiceAmount IS null
	AND   CheckAmount IS null
	*/
	
	-- Or delete the future	only
	DECLARE @TodayYear INT
	       ,@TodayMonth INT
	       
	SELECT @TodayYear = DATEPART(year, GETDATE())
	      ,@TodayMonth = DATEPART(Month, GETDATE())
	
	IF @TodayYear = @Year
		DELETE #tBillingSum 
		WHERE  Month > @TodayMonth
		
		
	--SELECT * FROM #tBillingSum
	
	/* set nocount on */
	return 1


Grant all on spRptBillingSummary to Public
GO
