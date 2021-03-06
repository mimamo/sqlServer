USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysisBGB]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysisBGB]
	(
	@CompanyKey INT
    ,@ParmEndDate datetime = null 
	)
AS --Encrypt

 /*
  || When     Who Rel     What
  || 09/24/12 GHL 10.560  (149474) Creation for a customization for BGB
  ||                      Get total gross for previous and current years
  ||                      Limit to approved budget
  || 04/21/15 GHL 10.591  (251986) Added calcs for past week data
 */
	SET NOCOUNT ON

	DECLARE @PrevYearStartDate datetime, @PrevYearEndDate datetime
	DECLARE @CurrYearStartDate datetime, @CurrYearEndDate datetime
	DECLARE @Year int, @YearChar varchar(4)
	
	select @Year = datepart(YYYY, GETDATE())
	select @YearChar = cast(@Year as varchar(4))
	select @CurrYearStartDate = '01/01/'+@YearChar
	select @CurrYearEndDate = '12/31/'+@YearChar
	select @Year = @Year - 1
	select @YearChar = cast(@Year as varchar(4))
	select @PrevYearStartDate = '01/01/'+@YearChar
	select @PrevYearEndDate = '12/31/'+@YearChar
	
	DECLARE @CurrDate SMALLDATETIME
	DECLARE @PastWeekStartDate DATETIME
	DECLARE @PastWeekEndDate DATETIME

	IF @ParmEndDate IS NULL
		SELECT @ParmEndDate = GETDATE()

	select @CurrDate = convert(smalldatetime, convert(varchar(10), @ParmEndDate, 101), 101) -- strip hours'
	SELECT @PastWeekEndDate = DATEADD(DAY, -1,@CurrDate) -- Ignore today's date, so this is yesterday
	SELECT @PastWeekStartDate = DATEADD(DAY, -7,@CurrDate)

	/*
		Past Week calculations
	*/

	-- Labor
	UPDATE #tRpt
	SET    #tRpt.BGBPastWeekLaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
							FROM tTime t (NOLOCK) 
							WHERE t.ProjectKey = #tRpt.ProjectKey
							AND  t.WorkDate >= @PastWeekStartDate 
							AND  t.WorkDate <= @PastWeekEndDate 	   
							), 0) 
 
	UPDATE #tRpt
	SET    #tRpt.BGBPastWeekExpenseGross = ISNULL((
							SELECT SUM(mc.BillableCost) 
							FROM tMiscCost mc (NOLOCK)
							WHERE mc.ProjectKey = #tRpt.ProjectKey
							AND   mc.ExpenseDate >= @PastWeekStartDate
							AND   mc.ExpenseDate <= @PastWeekEndDate
							), 0)
							+
							ISNULL((
							SELECT SUM(er.BillableCost) 
							FROM tExpenseReceipt er (NOLOCK)
							WHERE er.ProjectKey = #tRpt.ProjectKey
							AND   er.ExpenseDate >= @PastWeekStartDate
							AND   er.ExpenseDate <= @PastWeekEndDate
							AND   er.VoucherDetailKey IS NULL 
							), 0)
							+
							ISNULL((
							SELECT SUM(vd.BillableCost) 
							FROM tVoucherDetail vd (NOLOCK)
								INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
							WHERE vd.ProjectKey = #tRpt.ProjectKey
							AND   v.InvoiceDate >= @PastWeekStartDate
							AND   v.InvoiceDate <= @PastWeekEndDate
							), 0)

	/*
		Previous year calculations
	*/

	-- Labor
	UPDATE #tRpt
	SET    #tRpt.BGBPrevYearGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
							FROM tTime t (NOLOCK) 
							WHERE t.ProjectKey = #tRpt.ProjectKey
							AND  t.WorkDate <= @PrevYearEndDate 
							-- all prior years AND  t.WorkDate >= @PrevYearStartDate 	   
							), 0) 

	-- They just want it based on labor
	-- inside costs  
	/*
	UPDATE #tRpt
	SET    #tRpt.BGBPrevYearGross = ISNULL(BGBPrevYearGross, 0) 
							+ ISNULL((
							SELECT SUM(mc.BillableCost) 
							FROM tMiscCost mc (NOLOCK)
							WHERE mc.ProjectKey = #tRpt.ProjectKey
							AND   mc.ExpenseDate <= @PrevYearEndDate
							AND   mc.ExpenseDate >= @PrevYearStartDate
							), 0)
							+
							ISNULL((
							SELECT SUM(er.BillableCost) 
							FROM tExpenseReceipt er (NOLOCK)
							WHERE er.ProjectKey = #tRpt.ProjectKey
							AND   er.ExpenseDate <= @PrevYearEndDate
							AND   er.ExpenseDate >= @PrevYearStartDate
							AND   er.VoucherDetailKey IS NULL 
							), 0)


		--OutsideCosts
		
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET    #tRpt.BGBPrevYearGross =  ISNULL(BGBPrevYearGross, 0) 
								+ ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @PrevYearEndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @PrevYearEndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @PrevYearStartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @PrevYearStartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND pod.DateBilled <= @PrevYearEndDate
								), 0)
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET    #tRpt.BGBPrevYearGross =  ISNULL(BGBPrevYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @PrevYearEndDate
								AND   v.InvoiceDate >= @PrevYearStartDate
								AND   vd.DateBilled <= @PrevYearEndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.BGBPrevYearGross =  ISNULL(BGBPrevYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @PrevYearEndDate
								AND   v.InvoiceDate >= @PrevYearStartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @PrevYearEndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @PrevYearEndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.BGBPrevYearGross =  ISNULL(BGBPrevYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @PrevYearEndDate
								AND   v.InvoiceDate >= @PrevYearStartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @PrevYearEndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @PrevYearEndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @PrevYearEndDate)
								), 0)
	*/
	
	/*
		Current year calculations
	*/
	
	-- Labor
	UPDATE #tRpt
	SET    #tRpt.BGBCurrYearGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
							FROM tTime t (NOLOCK) 
							WHERE t.ProjectKey = #tRpt.ProjectKey
							AND  t.WorkDate <= @CurrYearEndDate 
							AND  t.WorkDate >= @CurrYearStartDate 	   
							), 0) 
	/*
	-- inside costs
	UPDATE #tRpt
	SET    #tRpt.BGBCurrYearGross = ISNULL(BGBCurrYearGross, 0) 
							+ ISNULL((
							SELECT SUM(mc.BillableCost) 
							FROM tMiscCost mc (NOLOCK)
							WHERE mc.ProjectKey = #tRpt.ProjectKey
							AND   mc.ExpenseDate <= @CurrYearEndDate
							AND   mc.ExpenseDate >= @CurrYearStartDate
							), 0)
							+
							ISNULL((
							SELECT SUM(er.BillableCost) 
							FROM tExpenseReceipt er (NOLOCK)
							WHERE er.ProjectKey = #tRpt.ProjectKey
							AND   er.ExpenseDate <= @CurrYearEndDate
							AND   er.ExpenseDate >= @CurrYearStartDate
							AND   er.VoucherDetailKey IS NULL 
							), 0)


		--OutsideCosts
		
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET    #tRpt.BGBCurrYearGross =  ISNULL(BGBCurrYearGross, 0) 
								+ ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @CurrYearEndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @CurrYearEndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @CurrYearStartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @CurrYearStartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND pod.DateBilled <= @CurrYearEndDate
								), 0)
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET    #tRpt.BGBCurrYearGross =  ISNULL(BGBCurrYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @CurrYearEndDate
								AND   v.InvoiceDate >= @CurrYearStartDate
								AND   vd.DateBilled <= @CurrYearEndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.BGBCurrYearGross =  ISNULL(BGBCurrYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @CurrYearEndDate
								AND   v.InvoiceDate >= @CurrYearStartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @CurrYearEndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @CurrYearEndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.BGBCurrYearGross =  ISNULL(BGBCurrYearGross, 0) 
								 + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @CurrYearEndDate
								AND   v.InvoiceDate >= @CurrYearStartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @CurrYearEndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @CurrYearEndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @CurrYearEndDate)
								), 0)
	
	*/
	/*
	Now compare to Total Budget
	*/
	
	/*
	Total Budget = 1000

	Previous year           Current Year
	1100 --> 1000           200 --> 0           
	500                     300           OK
	500                     700 --> 500
	*/

	-- limit the gross to the budget	
	
	update #tRpt
	set    #tRpt.BGBPrevYearGross = (isnull(OriginalTotalBudget, 0) + isnull(COTotalBudget, 0))
	      ,#tRpt.BGBCurrYearGross = 0
	where  isnull(BGBPrevYearGross, 0) > (isnull(OriginalTotalBudget, 0) + isnull(COTotalBudget, 0))
	 
	update #tRpt
	set    #tRpt.BGBCurrYearGross = (isnull(OriginalTotalBudget, 0) + isnull(COTotalBudget, 0))
										-
									 isnull(BGBPrevYearGross, 0)
	where  (isnull(BGBPrevYearGross, 0) + isnull(BGBCurrYearGross, 0))
									> 
		   (isnull(OriginalTotalBudget, 0) + isnull(COTotalBudget, 0))
	

	RETURN 1
GO
