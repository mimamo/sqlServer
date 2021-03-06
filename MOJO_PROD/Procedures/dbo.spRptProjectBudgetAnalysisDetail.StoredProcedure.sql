USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysisDetail]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysisDetail]
	(
		@CompanyKey int
		,@ProjectKey int
		,@GroupBy int -- 1 Project, 2 Task, 3 Item, 4 Service or Title (then use Entity = tService or tTitle) 
		,@TaskKey int			-- NULL or -1 [No Task] or valid TaskKey
		,@Entity varchar(50)	-- NULL or tService or tItem or tWorkType or tTitle 
		,@EntityKey int			-- NULL or 0 [No Service]/[No Item] or ServiceKey or ItemKey or TitleKey
		,@ParmStartDate datetime
		,@ParmEndDate datetime
		,@DataField VARCHAR(100)	-- One of the columns in the temp table in spRptProjectBudgetAnalysis
		-- See sptLayoutProjectItemRollup for the following entities
		,@GroupEntity varchar(50) = NULL --'tCampaign', 'tCampaignNoSegment', 'tCampaignSegment', 'tProject' 
		,@GroupEntityKey int = NULL
	)
AS --Encrypt

	SET NOCOUNT ON

 /*
  || When     Who Rel   What
  || 10/10/07 GHL 8.5	Creation for new budget analysis 
  || 10/26/07 GHL 8.5   Corrected the adv bill applied amount
  || 11/12/07 CRG 8.5   Added Columns to OpenOrdersGrossUnbilled, InsideCostsGross, OutsideCostsGross sections for use by old HTML drilldowns.
  || 11/19/07 GHL 8.5   Added new drill downs
  || 11/27/07 GHL 8.5   (16748) Added PurchaseOrderNumber, VendorInvoiceNumber to be used by dd_expense.aspx 
  ||                    in addition to generic Number = PO# or VI# or Envelope# used by Flash (InvoiceNumber is
  ||                    the client invoice number)    
  || 12/21/07 GHL 8.5   (18297) Added TotalCost to OutsideCostsGross since users want to see Net   
  || 08/08/08 GHL 10.0.0.6 (30969) Added Expense Write Off     
  || 09/25/08 GHL 10.0.0.9 (34827) Removed non prebilled, open orders from outside costs gross 
  || 10/06/08 GHL 10.0.1.0 (35157) Fixed rounding error when calculating AppliedAmount on advance bills by
  ||		                    1) Changing amounts from money to decimal in temp table
  ||		                    2) Increasing # of digits after decimal point to 7 for the Factor
  || 10/15/08 GHL 10.0.1.0 (36763) Since we removed OpenOrdersGross from OutsideCostsGross
  ||                       we must add the OpenOrdersGross to Total Gross 
  ||                       Also removed OpenOrdersNet from OutsideCostsNet
  ||                       Also removed OpenOrdersGrossUnbilled from OutsideCostsGrossUnbilled
  ||                       Also added TotalGrossUnbilled and TotalNet
  || 01/13/09 MFT 10.0.1.6 (43803) Description fields requested for usability and to match expectations from CMP
  ||                       Changes (columns ax`dded, removed or aliased) noted inline below
  || 07/30/09 RLB 10.5.0.6 Added WriteOff's when pulling unbilled vouchers on OutsideCostsGross
  || 12/09/09 GHL 10.514   (69441) Added HoursInvoiced, LaborInvoiced, ExpenseInvoiced  
  || 01/25/10 GHL 10.517   Modified queries so that we can use them in the new budget screens
  ||                       like for the campaign where we need a group of projects
  || 11/04/11 GHL 10.549   (121468) Changed #AdvanceBills.AppliedAmt = sum(IAB.Amount) - sum(IABT.Amount) when total does not include taxes
  || 06/20/12 GHL 10.556   (146627) t.WIPPostingInKey = 0 -- not a reversal should be t.WIPPostingInKey <> -99
  ||                        because of interferences with real wip posting 
  || 03/11/13 GHL 10.565   (171324) Added cast to Decimal(24,8) when calculating open order gross unbilled for better precision   
  || 08/27/13 GHL 10.571   Made modifications for multicurrency, read PTotalCost, PAppliedCost vs TotalCost, AppliedCost
  || 01/08/14 KMC 10.576   Updated the @EndDate for when no EndDate parameter was sent in, which had defaulted to 1/1/2015 prior.
  || 03/05/14 GHL 10.577   Added aliases i.e. like PTotalCost as TotalCost in some queries
  || 10/08/14 WDF 10.585   (Abelson Taylor) Added Entity of tTitle
  || 10/23/14 GHL 10.485  (233784 and 233644) check InvoiceLineKey on prebilled pod + remove check on pod.DateBilled for OutsideCostsGross   
  ||                       because closed orders can be billed now on new media screens        
  || 10/24/14 GHL 10.485   Changed if @Entity <> 'tTitle' to if isnull(@Entity, '') <> 'tTitle' 
  ||                       because By Task has Entity null and if statement would not work
  ||                       Also read tInvoiceSummaryTitle  
  || 01/30/15 GHL 10.588   Whenever possible, pull both ServiceDescription and TitleDescription because
  ||                       because Abelson Taylor wants to see both    
 */
 
 -- decided to always have a date to facilitate queries
	-- but also needed to keep @ParmEndDate to know if user originally wanted EndDate or not
	-- If no dates are required and by project, we can query tProjectRollup  
	DECLARE @StartDate datetime, @EndDate datetime
	IF @ParmStartDate IS NULL
		SELECT @StartDate =  '1/1/1970'
	ELSE
		SELECT @StartDate = @ParmStartDate 
	IF @ParmEndDate IS NULL
		SELECT @EndDate =  '1/1/' + CAST((YEAR(GETDATE()) + 5) AS VARCHAR)
	ELSE
		SELECT @EndDate = @ParmEndDate 
	
	IF @GroupBy = 1 -- By Project, no other info
		SELECT @TaskKey = NULL, @Entity = NULL, @EntityKey = NULL
	IF @GroupBy = 2 -- By Task, no entity
		SELECT @EntityKey = NULL, @Entity = NULL
	IF @GroupBy >= 3 -- By Entity, no task
		SELECT @TaskKey = NULL
	
	-- When showing the service/items grids, put amount billed with blank entity arbitrarly on the service grids  
	DECLARE @NullEntityOnInvoices int
	IF @GroupBy > 1 AND @Entity = 'tService' AND @EntityKey = 0 
		SELECT @NullEntityOnInvoices = 1
	ELSE
		SELECT @NullEntityOnInvoices = 0
	
	/* Important Note:
	   When filtering by title, the data with blank entity from tInvoiceSummary is placed in tInvoiceSummaryTitle
	   i.e. no need to check for @NullEntityOnInvoices here
	*/

	-- populate projects temp table based on layout entities
	-- same as sptLayoutProjectItemRollup
	
	create table #projects(ProjectKey int null)

	if @GroupEntity = 'tProject'
		insert #projects (ProjectKey) values (@GroupEntityKey)
	else if @GroupEntity = 'tCampaignSegment'
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignSegmentKey = @GroupEntityKey
	else if @GroupEntity = 'tCampaign'
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignKey = @GroupEntityKey
	else if @GroupEntity = 'tCampaignNoSegment'
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignKey = @GroupEntityKey
		and isnull(CampaignSegmentKey, 0) = 0

	if isnull(@ProjectKey, 0) > 0
	begin
		if (select count(*) from #projects where ProjectKey = @ProjectKey) = 0
			insert #projects (ProjectKey) values (@ProjectKey)
	end
	
 /*	Query tTime table for these data fields
 
		,Hours decimal(24,4) null
		,HoursBilled decimal(24,4) null
		,LaborNet money null
		,LaborGross money null
		,LaborBilled money null			
		,LaborUnbilled money null			
		,LaborWriteOff money null
			
 */
 		
 			
	IF @DataField IN ('Hours', 'LaborNet', 'LaborGross')
	BEGIN
		-- Return ALL rows
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
					'LABOR' AS TransactionType,
					t.TimeSheetKey AS HeaderKey,
					CAST(t.TimeKey AS VARCHAR(100))  AS DetailKey,
					u.FirstName + ' ' + u.LastName as UserName,
					t.WorkDate,
					t.ActualHours,
					CASE 
						 WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
						 ELSE 0 
					END AS HoursBilled,
					t.CostRate,
					t.ActualRate,
					ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
					ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
					CASE 
						 WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
						 ELSE 0 
					END AS LaborBilled,
					t.DateBilled,
					i.InvoiceNumber,
					t.WriteOff,
					t.Comments,
					ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
					ISNULL(s.Description, '[No Service]') as [ServiceDescription],
					ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
					ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
					Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
					Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
					Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
				Where   t.WorkDate >= @StartDate
				And     t.WorkDate <= @EndDate
				And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
				And     (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(t.ServiceKey, 0) = @EntityKey))
				Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
				RETURN 1
		END
		ELSE
		BEGIN
			Select
					'LABOR' AS TransactionType,
					t.TimeSheetKey AS HeaderKey,
					CAST(t.TimeKey AS VARCHAR(100))  AS DetailKey,
					u.FirstName + ' ' + u.LastName as UserName,
					t.WorkDate,
					t.ActualHours,
					CASE 
						 WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
						 ELSE 0 
					END AS HoursBilled,
					t.CostRate,
					t.ActualRate,
					ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
					ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
					CASE 
						 WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
						 ELSE 0 
					END AS LaborBilled,
					t.DateBilled,
					i.InvoiceNumber,
					t.WriteOff,
					t.Comments,
					ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
					ISNULL(s.Description, '[No Service]') as [ServiceDescription],
					ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
					ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
					Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
					Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
					Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
				Where   t.WorkDate >= @StartDate
				And     t.WorkDate <= @EndDate
				And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
				And     (@Entity IS NULL OR (@Entity = 'tTitle' AND ISNULL(t.TitleKey, 0) = @EntityKey))
				Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
				RETURN 1
		END
	END

	IF @DataField = 'TransferInLabor'
	BEGIN
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
					'LABOR'                                  AS TransactionType,
					CAST(t.TimeKey AS VARCHAR(100))          AS DetailKey,
					u.FirstName + ' ' + u.LastName           AS Description,
					t.WorkDate                               AS TransactionDate,
					t.TransferInDate                         AS TransferDate,
					t.ActualHours                            AS Quantity ,
					ROUND(t.ActualHours * t.CostRate, 2)     AS TotalCost,				
					ROUND(t.ActualHours * t.ActualRate, 2)   AS BillableCost,
					ISNULL(s.Description, '[No Service]')    AS ItemName,
					ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
					t.TransferComment
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Inner Join tTime t2 (nolock) on t.TransferFromKey = t2.TimeKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Where   t.TransferInDate >= @StartDate
				And     t.TransferInDate <= @EndDate
				AND     t.ProjectKey <> t2.ProjectKey 
				Order By t.TransferInDate, u.FirstName + ' ' + u.LastName	
				
				RETURN 1
		END
		ELSE
		BEGIN
			Select
					'LABOR'                                  AS TransactionType,
					CAST(t.TimeKey AS VARCHAR(100))          AS DetailKey,
					u.FirstName + ' ' + u.LastName           AS Description,
					t.WorkDate                               AS TransactionDate,
					t.TransferInDate                         AS TransferDate,
					t.ActualHours                            AS Quantity ,
					ROUND(t.ActualHours * t.CostRate, 2)     AS TotalCost,				
					ROUND(t.ActualHours * t.ActualRate, 2)   AS BillableCost,
					ISNULL(ti.TitleName, '[No Title]')       AS ItemName,
					ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
					t.TransferComment
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Inner Join tTime t2 (nolock) on t.TransferFromKey = t2.TimeKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Where   t.TransferInDate >= @StartDate
				And     t.TransferInDate <= @EndDate
				AND     t.ProjectKey <> t2.ProjectKey 
				Order By t.TransferInDate, u.FirstName + ' ' + u.LastName	
				
				RETURN 1
		END
	END

	IF @DataField = 'TransferOutLabor'
	BEGIN
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
				'LABOR'                                  AS TransactionType,
				CAST(t.TimeKey AS VARCHAR(100))          AS DetailKey,
				u.FirstName + ' ' + u.LastName           AS Description,
				t.WorkDate                               AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
                t.ActualHours                            AS Quantity ,
				ROUND(t.ActualHours * t.CostRate, 2)     AS TotalCost,				
				ROUND(t.ActualHours * t.ActualRate, 2)   AS BillableCost,
				ISNULL(s.Description, '[No Service]')    AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tTime t2 (nolock) on t.TransferToKey = t2.TimeKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.WIPPostingInKey <> -99
			Order By t.TransferOutDate, u.FirstName + ' ' + u.LastName 	
			
			RETURN 1
		END
		ELSE
		BEGIN
			Select
				'LABOR'                                  AS TransactionType,
				CAST(t.TimeKey AS VARCHAR(100))          AS DetailKey,
				u.FirstName + ' ' + u.LastName           AS Description,
				t.WorkDate                               AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
				t.ActualHours                            AS Quantity ,
				ROUND(t.ActualHours * t.CostRate, 2)     AS TotalCost,				
				ROUND(t.ActualHours * t.ActualRate, 2)   AS BillableCost,
				ISNULL(ti.TitleName, '[No Title]')		 AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tTime t2 (nolock) on t.TransferToKey = t2.TimeKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.WIPPostingInKey <> -99
			Order By t.TransferOutDate, u.FirstName + ' ' + u.LastName 	
			
			RETURN 1
		END
	END

	IF @DataField = 'TransferInExpense'
	BEGIN
			Select
				'MISC COST'                              AS TransactionType,
				CAST(t.MiscCostKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                       AS Description,
				t.ExpenseDate                            AS TransactionDate,
				t.TransferInDate                         AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.TotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tMiscCost t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tMiscCost t2 (nolock) on t.TransferFromKey = t2.MiscCostKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferInDate >= @StartDate
			And     t.TransferInDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 

			UNION ALL

			Select
				'VOUCHER'                                AS TransactionType,
				CAST(t.VoucherDetailKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                       AS Description,
				v.InvoiceDate                            AS TransactionDate,
				t.TransferInDate                         AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tVoucherDetail t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
				Inner Join tVoucherDetail t2 (nolock) on t.TransferFromKey = t2.VoucherDetailKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferInDate >= @StartDate
			And     t.TransferInDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 

		UNION ALL

			Select
				'EXP RECEIPT'                                AS TransactionType,
				CAST(t.ExpenseReceiptKey AS VARCHAR(100))      AS DetailKey,
				t.Description                            AS Description,
				t.ExpenseDate                            AS TransactionDate,
				t.TransferInDate                         AS TransferDate,
                t.ActualQty                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tExpenseReceipt t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tExpenseReceipt t2 (nolock) on t.TransferFromKey = t2.ExpenseReceiptKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferInDate >= @StartDate
			And     t.TransferInDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.VoucherDetailKey is null

		UNION ALL

			Select
				'ORDER'                                AS TransactionType,
				CAST(t.PurchaseOrderDetailKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                            AS Description,
				po.PODate                                AS TransactionDate,
				t.TransferInDate                         AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				CASE po.BillAt 
					WHEN 0 THEN ISNULL(t.BillableCost, 0)
					WHEN 1 THEN ISNULL(t.PTotalCost,0)
					WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
				END AS BillableCost,

				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tPurchaseOrderDetail t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tPurchaseOrderDetail t2 (nolock) on t.TransferFromKey = t2.PurchaseOrderDetailKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferInDate >= @StartDate
			And     t.TransferInDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			
			Order By t.TransferInDate	
			
			RETURN 1
	END

	IF @DataField = 'TransferOutExpense'
	BEGIN
			Select
				'MISC COST'                              AS TransactionType,
				CAST(t.MiscCostKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                       AS Description,
				t.ExpenseDate                            AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.TotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tMiscCost t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tMiscCost t2 (nolock) on t.TransferToKey = t2.MiscCostKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.WIPPostingInKey <> -99 

			UNION ALL

			Select
				'VOUCHER'                                AS TransactionType,
				CAST(t.VoucherDetailKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                       AS Description,
				v.InvoiceDate                            AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tVoucherDetail t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
				Inner Join tVoucherDetail t2 (nolock) on t.TransferToKey = t2.VoucherDetailKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.WIPPostingInKey <> -99 

		UNION ALL

			Select
				'EXP RECEIPT'                                AS TransactionType,
				CAST(t.ExpenseReceiptKey AS VARCHAR(100))      AS DetailKey,
				t.Description                            AS Description,
				t.ExpenseDate                            AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
                t.ActualQty                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				t.BillableCost                           AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tExpenseReceipt t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tExpenseReceipt t2 (nolock) on t.TransferToKey = t2.ExpenseReceiptKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND     t.VoucherDetailKey is null
			AND     t.WIPPostingInKey <> -99 

		UNION ALL

			Select
				'ORDER'                                AS TransactionType,
				CAST(t.PurchaseOrderDetailKey AS VARCHAR(100))      AS DetailKey,
				t.ShortDescription                            AS Description,
				po.PODate                                AS TransactionDate,
				t.TransferOutDate                        AS TransferDate,
                t.Quantity                               AS Quantity ,
				t.PTotalCost                              AS TotalCost,				
				CASE po.BillAt 
					WHEN 0 THEN ISNULL(t.BillableCost, 0)
					WHEN 1 THEN ISNULL(t.PTotalCost,0)
					WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
				END AS BillableCost,
				ISNULL(i.ItemName, '[No Item]')          AS ItemName,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				t.TransferComment
			From
				tPurchaseOrderDetail t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Inner Join tPurchaseOrderDetail t2 (nolock) on t.TransferToKey = t2.PurchaseOrderDetailKey
				Left Outer Join tPurchaseOrderDetail t3 (nolock) on t.TransferToKey = t3.PurchaseOrderDetailKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Left Outer Join tItem i (nolock) on t.ItemKey = i.ItemKey
			Where   t.TransferOutDate >= @StartDate
			And     t.TransferOutDate <= @EndDate
			AND     t.ProjectKey <> t2.ProjectKey 
			AND    (t3.ProjectKey is null or t.ProjectKey <> t3.ProjectKey)  -- not a reversal

			Order By t.TransferOutDate	
			
			RETURN 1
	END

	IF @DataField IN ('HoursBilled', 'LaborBilled', 'LaborWriteOff')
	BEGIN
		-- Return Only Billed time entries
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100)) AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where   t.WorkDate >= @StartDate
			And     t.WorkDate <= @EndDate
			And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(t.ServiceKey, 0) = @EntityKey))
			AND     t.DateBilled <= @EndDate
			AND     (@DataField <> 'LaborWriteOff' OR t.WriteOff = 1) 
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1
			
		END
		ELSE
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100)) AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where   t.WorkDate >= @StartDate
			And     t.WorkDate <= @EndDate
			And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tTitle' AND ISNULL(t.TitleKey, 0) = @EntityKey))
			AND     t.DateBilled <= @EndDate
			AND     (@DataField <> 'LaborWriteOff' OR t.WriteOff = 1) 
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1
		END	
	END

	IF @DataField IN ('HoursInvoiced', 'LaborInvoiced')
	BEGIN
		-- Return Only Billed time entries
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100)) AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where   (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And     (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(t.ServiceKey, 0) = @EntityKey))
			And		t.DateBilled >= @StartDate
			AND     t.DateBilled <= @EndDate
			AND     t.InvoiceLineKey > 0 
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1
		END
		ELSE
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100)) AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where   (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And     (@Entity IS NULL OR (@Entity = 'tTitle' AND ISNULL(t.TitleKey, 0) = @EntityKey))
			And		t.DateBilled >= @StartDate
			AND     t.DateBilled <= @EndDate
			AND     t.InvoiceLineKey > 0 
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1
		END	
	END

	IF @DataField IN ('LaborUnbilled')
	BEGIN
		-- Return only Unbilled time entries
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100))  AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where	t.WorkDate >= @StartDate
			And     t.WorkDate <= @EndDate
			And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(t.ServiceKey, 0) = @EntityKey))
			AND     (t.DateBilled IS NULL OR t.DateBilled > @EndDate)
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1
		END
		ELSE
		BEGIN
			Select
				'LABOR' AS TransactionType,
				t.TimeSheetKey AS HeaderKey,
				CAST(t.TimeKey AS VARCHAR(100))  AS DetailKey,
				u.FirstName + ' ' + u.LastName as UserName,
				t.WorkDate,
				t.ActualHours,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(t.BilledHours, 0)
					 ELSE 0 
				END AS HoursBilled,
				t.CostRate,
				t.ActualRate,
				ROUND(t.ActualHours * t.CostRate, 2) as LaborNet,				
				ROUND(t.ActualHours * t.ActualRate, 2) as LaborGross,
				CASE 
				     WHEN t.DateBilled <= @EndDate THEN ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0)
					 ELSE 0 
				END AS LaborBilled,
				t.DateBilled,
				i.InvoiceNumber,
				t.WriteOff,
				t.Comments,
				ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
				ISNULL(s.Description, '[No Service]') as [ServiceDescription],
				ISNULL(ti.TitleName, '[No Title]') as [TitleDescription],
				ISNULL(t.BilledComment, t.Comments) AS Description --Added 1/13/2009, MFT
			From
				tTime t (nolock)
				Inner Join #projects on t.ProjectKey = #projects.ProjectKey
				Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
				Inner Join tUser u (nolock) on u.UserKey = t.UserKey
				Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Left Outer Join tInvoiceLine il (NOLOCK) on t.InvoiceLineKey = il.InvoiceLineKey
				Left Outer Join tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			Where	t.WorkDate >= @StartDate
			And     t.WorkDate <= @EndDate
			And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tTitle' AND ISNULL(t.TitleKey, 0) = @EntityKey))
			AND     (t.DateBilled IS NULL OR t.DateBilled > @EndDate)
			Order By u.FirstName + ' ' + u.LastName, t.WorkDate	
				
			RETURN 1		
		END
	END

/*
		,InsideCostsNet money null
		,InsideCostsGrossUnbilled money null
		,InsideCostsGross money null
*/
		
	IF @DataField IN ('InsideCostsNet', 'InsideCostsGross')
	BEGIN
		-- Return ALL rows
		Select
			CAST('MISC COST' AS VARCHAR(20)) As TransactionType,
			m.MiscCostKey AS HeaderKey,
			CAST(m.MiscCostKey AS VARCHAR(100)) AS DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			m.ExpenseDate,
			m.Quantity,
			m.UnitCost,
			m.TotalCost,
			m.BillableCost,
			m.AmountBilled,
			m.DateBilled,
			iv.InvoiceNumber,
			m.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			m.ShortDescription AS Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
			
		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
			Left Outer Join tInvoiceLine il (NOLOCK) on m.InvoiceLineKey = il.InvoiceLineKey
			Left Outer Join tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
			
		-- And Expense Reports
		UNION ALL
		
		Select
			CAST('EXP RECEIPT' AS VARCHAR(20)) As TransactionType,
			ee.ExpenseEnvelopeKey AS HeaderKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)) AS  DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			er.ExpenseDate,
			er.ActualQty AS Quantity,
			er.ActualUnitCost AS UnitCost,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			er.AmountBilled,
			er.DateBilled,
			iv.InvoiceNumber,
			er.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			er.Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
			Left Outer Join tInvoiceLine il (NOLOCK) on er.InvoiceLineKey = il.InvoiceLineKey
			Left Outer Join tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
		Where
			er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	  er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
		
		Order By u.FirstName + ' ' + u.LastName, ExpenseDate
			
		RETURN 1	
	END
	
	--select @TaskKey, @Entity, @EntityKey, @StartDate, @EndDate
	
	IF @DataField IN ('ExpenseWriteOff')
	BEGIN
		-- Return ALL rows
		Select
			CAST('MISC COST' AS VARCHAR(20)) As TransactionType,
			m.MiscCostKey AS HeaderKey,
			CAST(m.MiscCostKey AS VARCHAR(100)) AS DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			m.ExpenseDate,
			m.Quantity,
			m.UnitCost,
			m.TotalCost,
			m.BillableCost,
			m.AmountBilled,
			m.DateBilled,
			m.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			m.ShortDescription AS Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,

			-- Flex DD
			CAST(NULL AS VARCHAR(200)) AS HeaderNumber,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
			
		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where  (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
		AND   m.DateBilled <= @EndDate  
		AND   m.WriteOff = 1 
			
		-- And Expense Reports
		UNION ALL
		
		Select
			CAST('EXP RECEIPT' AS VARCHAR(20)) As TransactionType,
			ee.ExpenseEnvelopeKey AS HeaderKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)) AS  DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			er.ExpenseDate,
			er.ActualQty AS Quantity,
			er.ActualUnitCost AS UnitCost,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			er.AmountBilled,
			er.DateBilled,
			er.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			er.Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,
			
			-- Flex DD
			u.FirstName + ' ' + u.LastName as HeaderName,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	  er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
		AND   er.DateBilled <= @EndDate  
		AND   er.WriteOff = 1 
	
			UNION ALL
		
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
		        ,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,CAST(NULL AS VARCHAR(200)) AS UserName
				,v.InvoiceDate AS ExpenseDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost 
				,vd.BillableCost 
				,vd.AmountBilled
				,vd.DateBilled
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,CAST(NULL AS VARCHAR(100)) AS Description
				,i.ItemKey
				,ta.TaskKey
				,ta.ProjectKey
			
				-- Flex DD
				,v.InvoiceNumber AS HeaderNumber
				
				-- dd_expenses.aspx	
				,cv.VendorID
				,CAST(NULL AS VARCHAR(100)) as PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber
				
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		AND   vd.DateBilled <= @EndDate  
		AND   vd.WriteOff = 1 
	
		Order By ExpenseDate
			
		RETURN 1	
	END

	IF @DataField IN ('ExpenseBilled')
	BEGIN
		-- Return ALL rows
		Select
			CAST('MISC COST' AS VARCHAR(20)) As TransactionType,
			m.MiscCostKey AS HeaderKey,
			CAST(m.MiscCostKey AS VARCHAR(100)) AS DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			m.ExpenseDate,
			m.Quantity,
			m.UnitCost,
			m.TotalCost,
			m.BillableCost,
			m.AmountBilled,
			m.DateBilled,
			m.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			m.ShortDescription AS Description,
			i.ItemKey,
			i.ItemType,
			ta.TaskKey,
			ta.ProjectKey,
			
			--Flex DD
			CAST(NULL AS VARCHAR(100)) AS HeaderNumber,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
			
		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
		AND   m.DateBilled <= @EndDate  
		AND   m.WriteOff = 0 
			
		-- And Expense Reports
		UNION ALL
		
		Select
			CAST('EXP RECEIPT' AS VARCHAR(20)) As TransactionType,
			ee.ExpenseEnvelopeKey AS HeaderKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)) AS  DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			er.ExpenseDate,
			er.ActualQty AS Quantity,
			er.ActualUnitCost AS UnitCost,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			er.AmountBilled,
			er.DateBilled,
			er.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			er.Description,
			i.ItemKey,
			i.ItemType,
			ta.TaskKey,
			ta.ProjectKey,
			
			--Flex DD
			u.FirstName + ' ' + u.LastName AS HeaderNumber,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	  er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
		AND   er.DateBilled <= @EndDate  
		AND   er.WriteOff = 0 
	
			UNION ALL
		
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,CAST(NULL AS VARCHAR(200)) AS UserName
				,case when po.POKind = 0 then po.PODate
				 else pod.DetailOrderDate end as ExpenseDate
				,pod.Quantity
				,pod.UnitCost
				,pod.PTotalCost as TotalCost
				,pod.BillableCost 
				,pod.AmountBilled
				,pod.DateBilled
				,0 AS WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,CAST(NULL AS VARCHAR(100)) AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				--Flex DD
				,po.PurchaseOrderNumber As HeaderNumber
				
				--dd_expenses.aspx
				,cv.VendorID
				,po.PurchaseOrderNumber 
				,CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
				
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
		AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
		AND  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
		AND   pod.DateBilled <= @EndDate  
		AND   pod.InvoiceLineKey > 0 

		UNION ALL
		
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
		        ,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,CAST(NULL AS VARCHAR(200)) AS UserName
				,v.InvoiceDate AS ExpenseDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,vd.BillableCost 
				,vd.AmountBilled
				,vd.DateBilled
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,CAST(NULL AS VARCHAR(100)) AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- Flex DD
				,v.InvoiceNumber AS HeaderNumber
				
				--dd_expenses.aspx
				,cv.VendorID
				,CAST(NULL AS VARCHAR(100)) as PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber
				
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		AND   vd.DateBilled <= @EndDate  
		AND   vd.WriteOff = 0 
	
		Order By ExpenseDate
			
		RETURN 1	
	END

	IF @DataField IN ('ExpenseInvoiced')
	BEGIN
		-- Return ALL rows
		Select
			CAST('MISC COST' AS VARCHAR(20)) As TransactionType,
			m.MiscCostKey AS HeaderKey,
			CAST(m.MiscCostKey AS VARCHAR(100)) AS DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			m.ExpenseDate,
			m.Quantity,
			m.UnitCost,
			m.TotalCost,
			m.BillableCost,
			m.AmountBilled,
			m.DateBilled,
			m.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			m.ShortDescription AS Description,
			i.ItemKey,
			i.ItemType,
			ta.TaskKey,
			ta.ProjectKey,
			
			--Flex DD
			CAST(NULL AS VARCHAR(100)) AS HeaderNumber,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
			
		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And   m.DateBilled >= @StartDate
		AND   m.DateBilled <= @EndDate  
		AND   m.InvoiceLineKey > 0 
			
		-- And Expense Reports
		UNION ALL
		
		Select
			CAST('EXP RECEIPT' AS VARCHAR(20)) As TransactionType,
			ee.ExpenseEnvelopeKey AS HeaderKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)) AS  DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			er.ExpenseDate,
			er.ActualQty AS Quantity,
			er.ActualUnitCost AS UnitCost,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			er.AmountBilled,
			er.DateBilled,
			er.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			er.Description,
			i.ItemKey,
			i.ItemType,
			ta.TaskKey,
			ta.ProjectKey,
			
			--Flex DD
			u.FirstName + ' ' + u.LastName AS HeaderNumber,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	  er.DateBilled >= @StartDate
		AND   er.DateBilled <= @EndDate  
		AND   er.InvoiceLineKey > 0 
	
			UNION ALL
		
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,CAST(NULL AS VARCHAR(200)) AS UserName
				,case when po.POKind = 0 then po.PODate
				 else pod.DetailOrderDate end as ExpenseDate
				,pod.Quantity
				,pod.UnitCost
				,pod.PTotalCost as TotalCost
				,pod.BillableCost 
				,pod.AmountBilled
				,pod.DateBilled
				,0 AS WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,CAST(NULL AS VARCHAR(100)) AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				--Flex DD
				,po.PurchaseOrderNumber As HeaderNumber
				
				--dd_expenses.aspx
				,cv.VendorID
				,po.PurchaseOrderNumber 
				,CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
				
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
		AND   pod.DateBilled >= @StartDate  
		AND   pod.DateBilled <= @EndDate  
		AND   pod.InvoiceLineKey > 0 

		UNION ALL
		
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
		        ,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,CAST(NULL AS VARCHAR(200)) AS UserName
				,v.InvoiceDate AS ExpenseDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,vd.BillableCost 
				,vd.AmountBilled
				,vd.DateBilled
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,CAST(NULL AS VARCHAR(100)) AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- Flex DD
				,v.InvoiceNumber AS HeaderNumber
				
				--dd_expenses.aspx
				,cv.VendorID
				,CAST(NULL AS VARCHAR(100)) as PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber
				
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		AND   vd.DateBilled >= @StartDate
		AND   vd.DateBilled <= @EndDate  
		AND   vd.InvoiceLineKey > 0
	
		Order By ExpenseDate
			
		RETURN 1	
	END
	
	IF @DataField IN ('InsideCostsGrossUnbilled')
	BEGIN
		Select
			CAST('MISC COST' AS VARCHAR(50)) As TransactionType,
			m.MiscCostKey AS HeaderKey,
			CAST(m.MiscCostKey AS VARCHAR(100)) AS DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			m.ExpenseDate,
			m.Quantity,
			m.UnitCost,
			m.TotalCost,
			m.BillableCost,
			m.AmountBilled,
			m.DateBilled,
			iv.InvoiceNumber,
			m.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			m.ShortDescription AS Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
			Left outer join tInvoiceLine il (nolock) on m.InvoiceLineKey = il.InvoiceLineKey
			Left outer join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
		AND   (m.DateBilled IS NULL OR m.DateBilled > @EndDate) 
			
		-- And Expense Reports
		UNION ALL
		
		Select
			CAST('EXP RECEIPT'  AS VARCHAR(50)) As TransactionType,
			ee.ExpenseEnvelopeKey AS HeaderKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)) AS  DetailKey,
			u.FirstName + ' ' + u.LastName as UserName,
			er.ExpenseDate,
			er.ActualQty AS Quantity,
			er.ActualUnitCost AS UnitCost,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			er.AmountBilled,
			er.DateBilled,
			iv.InvoiceNumber,
			er.WriteOff,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			er.Description,
			i.ItemKey,
			ta.TaskKey,
			ta.ProjectKey,
			
			--dd_expenses.aspx
			CAST(NULL AS VARCHAR(100)) AS VendorID,
			CAST(NULL AS VARCHAR(100)) AS PurchaseOrderNumber,
			CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
			Left outer join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
			Left outer join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	 er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
		AND   (er.DateBilled IS NULL OR er.DateBilled > @EndDate) 
		
		Order By UserName, ExpenseDate
			
		RETURN 1	
	END

/*
		,AdvanceBilled money null
		,AdvanceBilledOpen money null
		,AmountBilled money null
		,AmountBilledNoTax money null

*/

	IF @DataField IN ('AdvanceBilled', 'AmountBilled', 'AmountBilledNoTax')
	BEGIN
		IF isnull(@Entity, '') <> 'tTitle'
		BEGIN
			SELECT 'INVOICE' AS TransactionType,
					iv.InvoiceKey AS HeaderKey,
					CAST(il.InvoiceLineKey AS VARCHAR(100)) AS DetailKey,
					iv.InvoiceNumber, iv.InvoiceKey
					,c.CustomerID
					,iv.InvoiceDate
					,il.LineSubject
					,iroll.Amount
					,iroll.SalesTaxAmount
					,iroll.Amount + iroll.SalesTaxAmount AS TotalAmount
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
					,CASE WHEN iroll.Entity = 'tItem' THEN i.ItemName
						WHEN iroll.Entity = 'tService' THEN s.Description 
						ELSE '[None]'
					END As ItemName
			FROM   tInvoiceSummary iroll (NOLOCK)
				Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
				INNER JOIN tInvoice iv (NOLOCK) ON iroll.InvoiceKey = iv.InvoiceKey
				INNER JOIN tInvoiceLine il (NOLOCK) ON iroll.InvoiceLineKey = il.InvoiceLineKey
				LEFT OUTER JOIN tTask ta (NOLOCK) ON iroll.TaskKey = ta.TaskKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON iroll.EntityKey = i.ItemKey AND iroll.Entity = 'tItem'
				LEFT OUTER JOIN tService s (NOLOCK) ON iroll.EntityKey = s.ServiceKey AND iroll.Entity = 'tService'
				LEFT OUTER JOIN tCompany c (NOLOCK) ON iv.ClientKey = c.CompanyKey
			WHERE iv.InvoiceDate >= @StartDate
			AND   iv.InvoiceDate <= @EndDate
			And  (@TaskKey IS NULL OR (ISNULL(iroll.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (iroll.Entity = @Entity AND ISNULL(iroll.EntityKey, 0) = @EntityKey)
					OR (@NullEntityOnInvoices = 1 AND iroll.Entity IS NULL AND ISNULL(iroll.EntityKey, 0) = @EntityKey)
			)
			AND  ((@DataField = 'AdvanceBilled' AND iv.AdvanceBill = 1)  OR 
				  (@DataField = 'AmountBilled' AND iv.AdvanceBill = 0) OR
				  (@DataField = 'AmountBilledNoTax' AND iv.AdvanceBill = 0)
				  )
			
			RETURN 1 
		END
		ELSE
		BEGIN
			-- Titles only
			SELECT 'INVOICE' AS TransactionType,
					iv.InvoiceKey AS HeaderKey,
					CAST(il.InvoiceLineKey AS VARCHAR(100)) AS DetailKey,
					iv.InvoiceNumber, iv.InvoiceKey
					,c.CustomerID
					,iv.InvoiceDate
					,il.LineSubject
					,iroll.Amount
					,iroll.SalesTaxAmount
					,iroll.Amount + iroll.SalesTaxAmount AS TotalAmount
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
					,CASE WHEN iroll.TitleKey is not null THEN ti.TitleName
						ELSE '[None]'
					END As ItemName
			FROM   tInvoiceSummaryTitle iroll (NOLOCK)
				Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
				INNER JOIN tInvoice iv (NOLOCK) ON iroll.InvoiceKey = iv.InvoiceKey
				INNER JOIN tInvoiceLine il (NOLOCK) ON iroll.InvoiceLineKey = il.InvoiceLineKey
				LEFT OUTER JOIN tTask ta (NOLOCK) ON iroll.TaskKey = ta.TaskKey
				LEFT OUTER JOIN tTitle ti (NOLOCK) ON iroll.TitleKey = ti.TitleKey 
				LEFT OUTER JOIN tCompany c (NOLOCK) ON iv.ClientKey = c.CompanyKey
			WHERE iv.InvoiceDate >= @StartDate
			AND   iv.InvoiceDate <= @EndDate
			And  (@TaskKey IS NULL OR (ISNULL(iroll.TaskKey, -1) = @TaskKey))
			And  isnull(iroll.TitleKey, 0) = @EntityKey
			AND  ((@DataField = 'AdvanceBilled' AND iv.AdvanceBill = 1)  OR 
				  (@DataField = 'AmountBilled' AND iv.AdvanceBill = 0) OR
				  (@DataField = 'AmountBilledNoTax' AND iv.AdvanceBill = 0)
				  )
			
			RETURN 1 		
		END
	END

			
	-- ADVANCE BILLS: AppliedAmount is time sensitive so I need to prepare the data
	IF @DataField = 'AdvanceBilledOpen'
	BEGIN

		-- Changed amounts from money to decimal and increased # of digits after decimal point to 7 for the Factor
		-- This limits the rounding errors
		CREATE TABLE #AdvanceBills (InvoiceKey int null, InvoiceTotalAmount decimal(24,4) null, AppliedAmount decimal(24,4) null, Factor decimal(24,7) null)

		-- If at project level, include sales taxes
		-- If at task level, do not include sales taxes
		IF @GroupBy > 1	 
		BEGIN
			-- do not include sales taxes
			INSERT #AdvanceBills (InvoiceKey, InvoiceTotalAmount, AppliedAmount, Factor)
			SELECT DISTINCT i.InvoiceKey, i.TotalNonTaxAmount, 0, 0
			FROM   tInvoice i (NOLOCK)
			INNER JOIN tInvoiceSummary iroll (NOLOCK) ON i.InvoiceKey = iroll.InvoiceKey
			Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
			WHERE  i.CompanyKey = @CompanyKey
			AND    i.AdvanceBill = 1
			AND    i.InvoiceDate <= @EndDate
			AND    i.InvoiceDate >= @StartDate
			AND    i.InvoiceTotalAmount <> 0
		END
		ELSE
			INSERT #AdvanceBills (InvoiceKey, InvoiceTotalAmount, AppliedAmount, Factor)
			SELECT DISTINCT i.InvoiceKey, i.InvoiceTotalAmount, 0, 0
			FROM   tInvoice i (NOLOCK)
			INNER JOIN tInvoiceSummary iroll (NOLOCK) ON i.InvoiceKey = iroll.InvoiceKey
			Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
			WHERE  i.CompanyKey = @CompanyKey
			AND    i.AdvanceBill = 1
			AND    i.InvoiceDate <= @EndDate
			AND    i.InvoiceDate >= @StartDate
			AND    i.InvoiceTotalAmount <> 0
				
				
		IF @GroupBy > 1
			-- do not include sales taxes
			UPDATE #AdvanceBills
			SET    #AdvanceBills.AppliedAmount = ISNULL((
				-- Gil: we cannot do this, we are limited to iab.Amount
				--SELECT SUM(i.TotalNonTaxAmount)  
				SELECT SUM(iab.Amount)
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
				WHERE  iab.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
				-- Gil: 11/4/11 removed taxes because we took Total = TotalNonTaxAmount
				-
				ISNULL((
				SELECT SUM(iabt.Amount)
				FROM   tInvoiceAdvanceBillTax iabt (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iabt.InvoiceKey = i.InvoiceKey
				WHERE  iabt.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
		ELSE		
			-- include taxes, so we can iab.Amount
			UPDATE #AdvanceBills
			SET    #AdvanceBills.AppliedAmount = ISNULL((
				SELECT SUM(iab.Amount)
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
				WHERE  iab.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
			
		-- this is the factor we will need to multiply the line amounts by to get advance bill open amounts
		UPDATE #AdvanceBills
		SET #AdvanceBills.Factor = (1 - AppliedAmount/ InvoiceTotalAmount)

		IF @GroupBy > 1
			-- do not include sales taxes
			if isnull(@Entity, '') <> 'tTitle'
				SELECT 'INVOICE' AS TransactionType,
						iv.InvoiceKey AS HeaderKey,
						NULL AS DetailKey,
						iv.InvoiceNumber
						,c.CustomerID
						,iv.InvoiceDate
						,ab.InvoiceTotalAmount
						,SUM(iroll.Amount * ab.Factor) AS AppliedAmount
				FROM   tInvoiceSummary iroll (NOLOCK)
					Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
					INNER JOIN tInvoice iv (NOLOCK) ON iroll.InvoiceKey = iv.InvoiceKey
					INNER JOIN #AdvanceBills ab (NOLOCK) ON iroll.InvoiceKey = ab.InvoiceKey
					LEFT OUTER JOIN tCompany c (NOLOCK) ON iv.ClientKey = c.CompanyKey
				WHERE (@TaskKey IS NULL OR (ISNULL(iroll.TaskKey, -1) = @TaskKey))
				And  (@Entity IS NULL OR (iroll.Entity = @Entity AND ISNULL(iroll.EntityKey, 0) = @EntityKey)
					OR (@NullEntityOnInvoices = 1 AND iroll.Entity IS NULL AND ISNULL(iroll.EntityKey, 0) = @EntityKey)
				)
				And  iv.AdvanceBill = 1
				GROUP BY iv.InvoiceKey, iv.InvoiceNumber,c.CustomerID,iv.InvoiceDate,ab.InvoiceTotalAmount
			else
				SELECT 'INVOICE' AS TransactionType,
						iv.InvoiceKey AS HeaderKey,
						NULL AS DetailKey,
						iv.InvoiceNumber
						,c.CustomerID
						,iv.InvoiceDate
						,ab.InvoiceTotalAmount
						,SUM(iroll.Amount * ab.Factor) AS AppliedAmount
				FROM   tInvoiceSummaryTitle iroll (NOLOCK)
					Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
					INNER JOIN tInvoice iv (NOLOCK) ON iroll.InvoiceKey = iv.InvoiceKey
					INNER JOIN #AdvanceBills ab (NOLOCK) ON iroll.InvoiceKey = ab.InvoiceKey
					LEFT OUTER JOIN tCompany c (NOLOCK) ON iv.ClientKey = c.CompanyKey
				WHERE (@TaskKey IS NULL OR (ISNULL(iroll.TaskKey, -1) = @TaskKey))
				And  isnull(iroll.TitleKey, 0) = @EntityKey
				And  iv.AdvanceBill = 1
				GROUP BY iv.InvoiceKey, iv.InvoiceNumber,c.CustomerID,iv.InvoiceDate,ab.InvoiceTotalAmount
			
		ELSE
			-- for the whole project
			SELECT 'INVOICE' AS TransactionType,
					iv.InvoiceKey AS HeaderKey,
					NULL AS DetailKey,
					iv.InvoiceNumber
					,c.CustomerID
					,iv.InvoiceDate
					,ab.InvoiceTotalAmount
					,SUM((iroll.Amount + iroll.SalesTaxAmount) * ab.Factor) AS AppliedAmount
			FROM   tInvoiceSummary iroll (NOLOCK)
				Inner Join #projects on iroll.ProjectKey = #projects.ProjectKey
				INNER JOIN tInvoice iv (NOLOCK) ON iroll.InvoiceKey = iv.InvoiceKey
				INNER JOIN #AdvanceBills ab (NOLOCK) ON iroll.InvoiceKey = ab.InvoiceKey
				LEFT OUTER JOIN tCompany c (NOLOCK) ON iv.ClientKey = c.CompanyKey
			WHERE (@TaskKey IS NULL OR (ISNULL(iroll.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (iroll.Entity = @Entity AND ISNULL(iroll.EntityKey, 0) = @EntityKey))
			And  iv.AdvanceBill = 1
			GROUP BY iv.InvoiceKey, iv.InvoiceNumber,c.CustomerID,iv.InvoiceDate,ab.InvoiceTotalAmount
			 
		RETURN 1
		
	END


/*
		Here we need to recalculate the open orders applied cost 
		
		,OpenOrdersNet money null
		,OutsideCostsNet money null
		
		,OpenOrdersGrossUnbilled money null
		,OutsideCostsGrossUnbilled money null
		
		,OutsideCostsGross money null
		
*/

	-- OPEN ORDERS: AppliedCost is time sensitive data so I need to recalc
	CREATE TABLE #OpenOrders (PurchaseOrderKey int null, PurchaseOrderDetailKey int null, BillAt int null, POKind int null
							, AppliedCost money null, TotalCost money null, BillableCost money null)
	
	CREATE INDEX IX_OO on #OpenOrders (PurchaseOrderDetailKey)
	
	--exec spTime 'After create Open Orders temp', @t output
	
	IF @ParmStartDate IS NULL AND @ParmEndDate IS NULL 
	BEGIN
		INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
		SELECT DISTINCT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
		FROM   tPurchaseOrderDetail pod (NOLOCK)
			Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
			INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
		WHERE  pod.DateClosed IS NULL
	END
	ELSE
	BEGIN
			INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
			SELECT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
			FROM   tPurchaseOrderDetail pod (NOLOCK)
					Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
			WHERE  pod.PurchaseOrderKey = po.PurchaseOrderKey
			AND    po.CompanyKey = @CompanyKey  
			AND    ( (po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
			AND    ( (po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
			AND    (pod.DateClosed IS NULL OR pod.DateClosed  > @EndDate)

		-- AppliedCost is time sensitive data	
		UPDATE #OpenOrders
		SET    #OpenOrders.AppliedCost = ISNULL((SELECT Sum(vd.PTotalCost)
			FROM   tVoucherDetail vd (nolock)
					,tVoucher v (nolock) 
			WHERE  vd.PurchaseOrderDetailKey = #OpenOrders.PurchaseOrderDetailKey     
			AND    vd.VoucherKey = v.VoucherKey
			AND    v.InvoiceDate <= @EndDate
			AND    v.CompanyKey = @CompanyKey   
			), 0) 
		
	
	END
	
	-- Take care of media
	UPDATE #OpenOrders
	SET    BillableCost = CASE BillAt 
					WHEN 0 THEN ISNULL(BillableCost, 0)
					WHEN 1 THEN ISNULL(TotalCost,0)
					WHEN 2 THEN ISNULL(BillableCost,0) - ISNULL(TotalCost,0) 
				END
	WHERE  POKind > 0

	-- Now apply the formula to BillableCost
	UPDATE #OpenOrders
	SET    BillableCost = CASE 
							WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
							WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
								THEN BillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8)) )	
							ELSE BillableCost 
						END


	--select * from #OpenOrders
	
	IF @DataField IN ('OpenOrdersNet')
	BEGIN
		-- Return ALL rows
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
		        ,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.PTotalCost - oo.AppliedCost AS TotalCost -- Only interested in OpenNet, must be added to outside cost
				,oo.BillableCost 
				,pod.DateClosed
				,pod.AmountBilled
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,i.ItemType
				,pod.ShortDescription AS Description --Added 1/13/2009, MFT
				-- dd_po.aspx
				,po.PurchaseOrderNumber
				
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE
			(@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))

			
		
		ORDER BY TransactionType, VendorID, Number

		RETURN 1
			
	END	

	IF @DataField IN ('OpenOrdersGrossUnbilled')
	BEGIN
		-- Return ONLY Unbilled rows
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.PTotalCost - oo.AppliedCost AS TotalCost -- Only interested in OpenNet, must be added to outside cost
				,oo.BillableCost 
				,pod.DateClosed
				,pod.AmountBilled
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,po.PurchaseOrderKey
				,ta.ProjectKey
				,ta.TaskKey
				,i.ItemKey
				,i.ItemType
				,pod.ShortDescription AS Description --Aliased 1/13/2009, MFT
				--,pod.LongDescription --Removed 1/13/2009, MFT

				-- dd_po.aspx
				,po.PurchaseOrderNumber

		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE
			(pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
		And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
					
		ORDER BY TransactionType, VendorID, Number

		RETURN 1
			
	END	


	IF @DataField IN ('OutsideCostsNet')
	BEGIN
		/* removed 10/15/08 GHL
		
		-- Return ALL rows
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.TotalCost - oo.AppliedCost AS TotalCost -- Only interested in OpenNet, must be added to outside cost
				,oo.BillableCost 
				,pod.DateClosed
				,pod.AmountBilled
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,i.ItemType
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE
			(@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))

		UNION ALL
		*/
		
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
		        ,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,v.InvoiceNumber AS Number
				,v.InvoiceDate AS TransactionDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,vd.BillableCost 
				,NULL AS DateClosed
				,vd.AmountBilled
				,vd.DateBilled
				,iv.InvoiceNumber				
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,0 AS ItemType
				,vd.ShortDescription AS Description --Added 1/13/2009, MFT
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
	
		
		ORDER BY TransactionType, VendorID, Number

		RETURN 1
			
	END	


	IF @DataField IN ('OutsideCostsGrossUnbilled')
	BEGIN
		/*
		-- 10/15/08 GHL
		
		-- Return ONLY Unbilled rows
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.TotalCost - oo.AppliedCost AS TotalCost -- Only interested in OpenNet, must be added to outside cost
				,oo.BillableCost 
				,pod.DateClosed
				,pod.AmountBilled
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,pod.ShortDescription AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
				
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE
			(pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
		And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
					
		UNION ALL
		*/
		
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,v.InvoiceNumber AS Number
				,v.InvoiceDate AS TransactionDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,vd.BillableCost 
				,NULL AS DateClosed
				,vd.AmountBilled
				,vd.DateBilled
				,iv.InvoiceNumber				
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,vd.ShortDescription AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber
				
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
			LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			LEFT OUTER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		And  (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate)
	
		
		ORDER BY TransactionType, VendorID, Number

		RETURN 1
			
	END	

	 
	--For this case, we need to merge the AmountBilled and the Gross of unbilled into one column
	-- Choose AmountBilled for that column
	IF @DataField IN ('OutsideCostsGross')
	BEGIN
	
		--The amount billed of all pre-billed orders
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.PTotalCost as TotalCost
				,pod.DateClosed
				,pod.AmountBilled  
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,pod.ShortDescription AS Description
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber
				
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE po.CompanyKey = @CompanyKey
		And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
		AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
			OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
		AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
			OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
		AND pod.DateBilled <= @EndDate
		AND isnull(pod.InvoiceLineKey, 0) > 0 -- 233644

		UNION ALL
				
		--The amount billed of all billed vouchers
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,v.InvoiceNumber AS Number
				,v.InvoiceDate AS TransactionDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,NULL AS DateClosed
				,vd.AmountBilled
				,vd.DateBilled
				,iv.InvoiceNumber				
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,vd.ShortDescription
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey
				
				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber
				
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
			LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			LEFT OUTER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		And  vd.DateBilled <= @EndDate
		AND   vd.WriteOff = 0

		UNION ALL	

		--The gross amount of unbilled vouchers not tied to an order
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,v.InvoiceNumber AS Number
				,v.InvoiceDate AS TransactionDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,NULL AS DateClosed
				,vd.BillableCost AS AmountBilled
				,vd.DateBilled
				,iv.InvoiceNumber				
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,vd.ShortDescription
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey

				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber

		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
			LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			LEFT OUTER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))	
		AND   v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND   (
               (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                or 
               (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
              )
		AND   vd.PurchaseOrderDetailKey IS NULL	

		UNION ALL
		
		--The gross amount of unbilled vouchers  tied to a closed order line from a non pre-billed order
		SELECT CAST('VOUCHER' AS VARCHAR(20)) AS TransactionType
				,v.VoucherKey AS HeaderKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,v.InvoiceNumber AS Number
				,v.InvoiceDate AS TransactionDate
				,vd.Quantity
				,vd.UnitCost
				,vd.PTotalCost as TotalCost
				,NULL AS DateClosed
				,vd.BillableCost AS AmountBilled
				,vd.DateBilled
				,iv.InvoiceNumber				
				,vd.WriteOff 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,vd.ShortDescription
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey

				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,v.InvoiceNumber AS VendorInvoiceNumber

		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
			INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))	
		AND   v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND   (
               (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                or 
               (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
              )
		--AND   pod.DateClosed <= @EndDate
		--AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate) -- 233644


		/* Removed for 34827
		UNION ALL
	
		--The gross of any non pre-billed open orders that are open.		
		SELECT CAST('ORDER' AS VARCHAR(20)) AS TransactionType
				,po.PurchaseOrderKey AS HeaderKey
		        ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100)) AS DetailKey
				,cv.VendorID
				,po.PurchaseOrderNumber AS Number
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
				,pod.Quantity
				,pod.UnitCost
				,pod.TotalCost
				,pod.DateClosed
				,oo.BillableCost AS AmountBilled
				,pod.DateBilled
				,iv.InvoiceNumber				
				,0 AS WriteOff
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,pod.ShortDescription
				,i.ItemKey
				,i.ItemType
				,ta.TaskKey
				,ta.ProjectKey

				-- for dd_expense.aspx
				,po.PurchaseOrderNumber 
				,CAST(NULL AS VARCHAR(100)) AS VendorInvoiceNumber

		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on pod.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE
			(pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
		And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))

		*/
		
		RETURN 1
													
	END 

/*
From here, we have different types of transactions, labor, inside costs, etcc.
Use a temp table and restrict the number of fields
*/

	CREATE TABLE #tTransaction (TransactionType VARCHAR(50) NULL
						,ProjectKey int null
						,HeaderKey INT NULL  
						,DetailKey VARCHAR(100) NULL -- because of TimeKey
						,TransactionDate DATETIME NULL
						,VendorID VARCHAR(100) NULL
						,Number VARCHAR(100) NULL
						,Description VARCHAR(500) NULL
						,Quantity DECIMAL(24,4) NULL
						,Net MONEY NULL
						,Gross MONEY NULL
						,TaskName VARCHAR(200) NULL
						,ItemName VARCHAR(200) NULL
						,ItemType INT NULL -- for drill downs
						,CostType VARCHAR(50) NULL
						) 
	

	IF @DataField IN ('TotalCostsGross', 'TotalGross')
	BEGIN
		-- 5 components of outside costs first 
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
						
		--The amount billed of all pre-billed orders
		SELECT CAST('ORDER' AS VARCHAR(20)) 
				,pod.ProjectKey
				,pod.PurchaseOrderKey
				,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100))
				,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END 
				,cv.VendorID
				,po.PurchaseOrderNumber 
				,pod.ShortDescription 
				,pod.Quantity
				,pod.PTotalCost
				,pod.AmountBilled  
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
				,isnull(i.ItemName, '[No Item]')
				,i.ItemType 
				,'OutsideCostsGross_POB'
		FROM   tPurchaseOrder po (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
			Inner Join #projects on pod.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
		WHERE po.CompanyKey = @CompanyKey
		And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
		AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
			OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
		AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
			OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
		AND pod.DateBilled <= @EndDate

		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
				
		--The amount billed of all billed vouchers
		SELECT CAST('VOUCHER' AS VARCHAR(20)) 
				,vd.ProjectKey
				,vd.VoucherKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100))
				,v.InvoiceDate 
				,cv.VendorID
				,v.InvoiceNumber 
				,vd.ShortDescription
				,vd.Quantity
				,vd.PTotalCost
				,vd.AmountBilled
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]')
				,isnull(i.ItemName, '[No Item]')
				,i.ItemType
				,'OutsideCostsGross_VDB'
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		And  vd.DateBilled <= @EndDate
		AND   vd.WriteOff = 0

		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
		
		--The gross amount of unbilled vouchers not tied to an order
		SELECT CAST('VOUCHER' AS VARCHAR(20)) 
				,vd.ProjectKey
				,vd.VoucherKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100))
				,v.InvoiceDate 
				,cv.VendorID
				,v.InvoiceNumber 
				,vd.ShortDescription
				,vd.Quantity
				,vd.PTotalCost
				,vd.BillableCost
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
				,isnull(i.ItemName, '[No Item]')
				,i.ItemType
				,'OutsideCostsGross_VDU'
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			LEFT OUTER JOIN tInvoiceLine il (NOLOCK) on vd.InvoiceLineKey = il.InvoiceLineKey
			LEFT OUTER JOIN tInvoice iv (NOLOCK) on il.InvoiceKey = iv.InvoiceKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))	
		AND   v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND   (
               (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                or 
               (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
              )
		AND   vd.PurchaseOrderDetailKey IS NULL	
		
		
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
		
		--The gross amount of unbilled vouchers  tied to a closed order line from a non pre-billed order
		SELECT CAST('VOUCHER' AS VARCHAR(20)) 
				,vd.ProjectKey
				,vd.VoucherKey
				,CAST(vd.VoucherDetailKey AS VARCHAR(100))
				,v.InvoiceDate 
				,cv.VendorID
				,v.InvoiceNumber 
				,vd.ShortDescription
				,vd.Quantity
				,vd.PTotalCost
				,vd.BillableCost
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
				,isnull(i.ItemName, '[No Item]') 
				,i.ItemType
				,'OutsideCostsGross_VDUPO'
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
		WHERE (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))	
		AND   v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND   (
               (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                or 
               (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
              )
		--AND   pod.DateClosed <= @EndDate -- take all
		AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)


		
		-- Now Inside costs
		-- Misc Costs
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)

		Select
			CAST('MISC COST' AS VARCHAR(20)) 
			,m.ProjectKey	
			,m.MiscCostKey, CAST(m.MiscCostKey AS VARCHAR(100))
			,m.ExpenseDate
			,NULL, NULL, m.ShortDescription 
			,m.Quantity
			,m.TotalCost
			,m.BillableCost
			,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
			,isnull(i.ItemName, '[No Item]') 
			,i.ItemType
			,'InsideCostsGross_MC'
		From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
			
		-- And Expense Reports
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
		
		Select
			CAST('EXP RECEIPT' AS VARCHAR(20)) 
			,er.ProjectKey
			,er.ExpenseEnvelopeKey, CAST(er.ExpenseReceiptKey AS VARCHAR(100)), er.ExpenseDate			
			,NULL, ee.EnvelopeNumber, u.FirstName + ' ' + u.LastName 
			,er.ActualQty
			,er.PTotalCost 
			,er.BillableCost
			,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
			,isnull(i.ItemName, '[No Item]')
			,i.ItemType
			,'InsideCostsGross_ER'
		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	  er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
			
	  	
	  	IF @DataField IN ('TotalGross')
	  	BEGIN
			-- And now labor if this the TotalGross column
			IF @Entity <> 'tTitle'
			BEGIN
				INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
								,VendorID ,Number ,Description 
								,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)

				Select
					'LABOR', t.ProjectKey, t.TimeSheetKey, CAST(t.TimeKey AS VARCHAR(100)), t.WorkDate 
					,NULL, NULL, u.FirstName + ' ' + u.LastName 
					,t.ActualHours
					,ROUND(t.ActualHours * t.CostRate, 2) 				
					,ROUND(t.ActualHours * t.ActualRate, 2) 
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
					,ISNULL(s.Description, '[No Service]')			
					,0, 'LaborGross'
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
				Where	t.WorkDate >= @StartDate
				And     t.WorkDate <= @EndDate
				And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
				And     (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(t.ServiceKey, 0) = @EntityKey))
			END
			ELSE
			BEGIN
				INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
								,VendorID ,Number ,Description 
								,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)

				Select
					'LABOR', t.ProjectKey, t.TimeSheetKey, CAST(t.TimeKey AS VARCHAR(100)), t.WorkDate 
					,NULL, NULL, u.FirstName + ' ' + u.LastName 
					,t.ActualHours
					,ROUND(t.ActualHours * t.CostRate, 2) 				
					,ROUND(t.ActualHours * t.ActualRate, 2) 
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') 
					,ISNULL(ti.TitleName, '[No Title]')			
					,0, 'LaborGross'
				From
					tTime t (nolock)
					Inner Join #projects on t.ProjectKey = #projects.ProjectKey
					Left Outer Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
					Inner Join tUser u (nolock) on u.UserKey = t.UserKey
					Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
				Where	t.WorkDate >= @StartDate
				And     t.WorkDate <= @EndDate
				And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
				And     (@Entity IS NULL OR (@Entity = 'tTitle' AND ISNULL(t.TitleKey, 0) = @EntityKey))				
			END
				
			INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
							,VendorID ,Number ,Description 
							,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
			
			--The gross of any non pre-billed open orders that are open.		
			SELECT CAST('ORDER' AS VARCHAR(20)) 
					,pod.ProjectKey
					,pod.PurchaseOrderKey
					,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100))
					,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END 
					,cv.VendorID
					,po.PurchaseOrderNumber
					,pod.ShortDescription 
					,pod.Quantity
					,pod.PTotalCost
					,oo.BillableCost  
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]')
					,isnull(i.ItemName, '[No Item]') 
					,i.ItemType
					,'OutsideCostsGross_POU'
			FROM   tPurchaseOrder po (NOLOCK)
				INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
				INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
				Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
				Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
				Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
			WHERE
				(pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
			And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
			
		END
			
	--SELECT SUM(Gross) FROM #tTransaction where CostType like 'OutsideCostsGross%'
	--SELECT SUM(Gross) FROM #tTransaction where CostType like 'InsideCostsGross%'
	--SELECT SUM(Gross) FROM #tTransaction
	
		SELECT * FROM #tTransaction
		ORDER BY TransactionType, Number, TransactionDate 
			
		RETURN 1
													
	END 

	IF @DataField IN ('TotalCostsGrossUnbilled')
	BEGIN
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
						
		-- Inside Costs Unbilled
		Select
			'MISC COST' , m.ProjectKey, m.MiscCostKey,
			CAST(m.MiscCostKey AS VARCHAR(100)),m.ExpenseDate,
			null, null, m.ShortDescription,
			m.Quantity,
			m.TotalCost,
			m.BillableCost,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]'),
			isnull(i.ItemName, '[No Item]'),
			i.ItemType, 'InsideCostsGrossUnbilled_MC'
			From
			tMiscCost m (nolock)
			Inner Join #projects on m.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on m.TaskKey = ta.TaskKey
			Left Outer Join tUser u (nolock) on m.EnteredByKey = u.UserKey
			Left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where (@TaskKey IS NULL OR (ISNULL(m.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(m.ItemKey, 0) = @EntityKey))
		And	  m.ExpenseDate >= @StartDate
		And   m.ExpenseDate <= @EndDate
		AND   (m.DateBilled IS NULL OR m.DateBilled > @EndDate) 
			
		-- And Expense Reports
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
		
		Select
			'EXP RECEIPT', er.ProjectKey, ee.ExpenseEnvelopeKey,
			CAST(er.ExpenseReceiptKey AS VARCHAR(100)), er.ExpenseDate,
			null, ee.EnvelopeNumber, u.FirstName + ' ' + u.LastName + ' - ' + er.Description,
			er.ActualQty AS Quantity,
			er.PTotalCost AS TotalCost,
			er.BillableCost,
			ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName,
			isnull(i.ItemName, '[No Item]') As ItemName,
			i.ItemType, 'InsideCostsGrossUnbilled_ER'
		
		From
			tExpenseReceipt er (nolock)
			Inner Join #projects on er.ProjectKey = #projects.ProjectKey
			Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
			Left Outer Join tTask ta (nolock) on er.TaskKey = ta.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on er.ItemKey = i.ItemKey
		Where er.VoucherDetailKey IS NULL
		And  (@TaskKey IS NULL OR (ISNULL(er.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(er.ItemKey, 0) = @EntityKey))
		And	 er.ExpenseDate >= @StartDate
		And   er.ExpenseDate <= @EndDate
		AND   (er.DateBilled IS NULL OR er.DateBilled > @EndDate) 
				
/*	
		-- Open orders gross unbilled	
		INSERT #tTransaction (TransactionType, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
		SELECT 'ORDER' ,po.PurchaseOrderKey ,CAST(pod.PurchaseOrderDetailKey AS VARCHAR(100))
					,CASE WHEN po.POKind = 0 THEN po.PODate ELSE pod.DetailOrderDate END AS TransactionDate
					,cv.VendorID, po.PurchaseOrderNumber, pod.ShortDescription
					,pod.Quantity
					,pod.TotalCost - oo.AppliedCost AS TotalCost -- Only interested in OpenNet, must be added to outside cost
					,oo.BillableCost 
					,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
					,isnull(i.ItemName, '[No Item]') As ItemName
					,i.ItemType, 'OutsideCostsGrossUnbilled_OO'
			FROM   tPurchaseOrder po (NOLOCK)
				INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
				INNER JOIN #OpenOrders oo ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
				Left Outer Join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
				Left Outer Join tItem i (nolock) on pod.ItemKey = i.ItemKey
				Left Outer Join tCompany cv (nolock) on po.VendorKey = cv.CompanyKey			 				 
			WHERE
				(pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
			And  (@TaskKey IS NULL OR (ISNULL(pod.TaskKey, -1) = @TaskKey))
			And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(pod.ItemKey, 0) = @EntityKey))
*/						
						
		-- vouchers gross unbilled	
		INSERT #tTransaction (TransactionType, ProjectKey, HeaderKey, DetailKey, TransactionDate 
						,VendorID ,Number ,Description 
						,Quantity ,Net ,Gross ,TaskName ,ItemName, ItemType, CostType)
			SELECT 'VOUCHER' ,vd.ProjectKey, v.VoucherKey ,CAST(vd.VoucherDetailKey AS VARCHAR(100)),v.InvoiceDate
				,cv.VendorID,v.InvoiceNumber,vd.ShortDescription
				,vd.Quantity
				,vd.PTotalCost 
				,vd.BillableCost 
				,ISNULL(ISNULL(ta.TaskID + '-', '') + ta.TaskName , '[No Task]') AS TaskName
				,isnull(i.ItemName, '[No Item]') As ItemName
				,i.ItemType, 'OutsideCostsGrossUnbilled_VD'
		FROM   tVoucher v (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK) ON v.VoucherKey = vd.VoucherKey
			Inner Join #projects on vd.ProjectKey = #projects.ProjectKey
			Left Outer Join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
			Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
			Left Outer Join tCompany cv (nolock) on v.VendorKey = cv.CompanyKey			 				 
		WHERE v.InvoiceDate <= @EndDate
		AND   v.InvoiceDate >= @StartDate
		AND  (@TaskKey IS NULL OR (ISNULL(vd.TaskKey, -1) = @TaskKey))
		And  (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(vd.ItemKey, 0) = @EntityKey))
		And  (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate)
	

		SELECT * FROM #tTransaction
		ORDER BY TransactionType, Number, TransactionDate 
			
		RETURN 1

	
	END
	
	
	
	RETURN 1
GO
