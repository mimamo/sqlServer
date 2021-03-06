USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutProjectItemRollup]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutProjectItemRollup]
	(
	@CompanyKey int
	,@Entity varchar(50) -- 'tCampaign', 'tCampaignNoSegment', 'tCampaignSegment', 'tProject', etc...
	,@EntityKey int
	,@LayoutKey int
	)
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 01/07/10  GHL 10.5.1.? Creation for campaign layouts
||                        Returns:
||                        Billing Item 1, Item 1, rollup values
||                        Billing Item 1, Item 2, rollup values
||                        Billing Item 2, Item 3, rollup values
||                        Billing Item 2, Item 4, rollup values
|| 01/14/10  CRG 10.5.1.7 Modified to use customized billing item names for the entity
|| 01/26/10  GHL 10.5.1.7 Added @Entity,@EntityKey as part of the results to be used in grids for drill downs
|| 4/21/10   GHL 10.5.2.2 Added additional columns for campaign estimates 
|| 10/7/10   RLB 10.5.3.6 (89933)Added Sales Tax   AmountBilled - AmountBilledNoTax
|| 10/7/10   RLB 10.5.3.7 Added Total Gross Unbilled Fixed Fee
|| 11/15/10  GHL 10.5.3.8 (93504) During testing for 93504, found out that TotalGross was incorrect due to the fact that
||                        OpenOrderGross used to be calculated for unbilled po, but now includes them
||                        so use OpenOrderGrossUnbilled = tProjectItemRollup.OpenOrderUnbilled 
|| 01/04/13  WDF 10.5.6.3 Added DepartmentName
|| 01/07/13  GHL 10.5.6.3 Added nolock hints
|| 02/18/13 GHL 10.5.6.5 (168695) Added Allocated hours
|| 03/06/13 GHL 10.566   (167702) Added Total Gross After WriteOff
|| 06/27/13 MFT 10.569   (177496) Corrected HoursBilledRemaining calc
|| 10/08/13 GHL 10.573    Using now PTotalCost to support multi currency
|| 10/31/13 GHL 10.573    When LayoutKey = 0, manufacture a unique WorkTypeDisplayOrder for sorts on grids
||                       (because of some sorting issues on the project budget screen by BI and Item, 
||                        Phoenix Marketing, project OAPI1001)
||                       (193975) Added PurchasedQty and Budgeted Quantities
|| 11/15/13 GHL 10.573   (196880) Corrected typo with the WorkTypeDisplayOrder when LayoutKey > 0
|| 03/09/15 GHL 10.590   Added values for ItemID for ServiceKey = 0 for Abelson Taylor
||                       Could happen now if estimate is by title only
*/

	create table #projects(ProjectKey int null)

	-- other data, non summarized in tProjectRollup...
	create table #project_other(Entity varchar(50) null, EntityKey int null, AllocatedHours decimal(24,4) null)
	
	-- Project Item Rollup table	
	create table #roll (
	    Entity varchar(50) NULL, -- tItem, tService
		EntityKey int NULL,      -- ItemKey, ServiceKey
		ItemID varchar(50),      -- ItemID or ServiceCode
		ItemName varchar(200),   -- ItemName or Description
		DepartmentName varchar(200) NULL,
		WorkTypeKey int,
		WorkTypeID varchar(100),
		WorkTypeName varchar(200),		
		WorkTypeDisplayOrder int, -- WorkType display order

		-- these fields are in tProjectItemRollup
		Hours decimal(24, 4) NULL ,
		HoursApproved decimal(24, 4) NULL ,
		HoursBilled decimal(24, 4) NULL ,
		HoursInvoiced decimal(24, 4) NULL ,
		LaborNet money NULL ,
		LaborNetApproved money NULL ,
		LaborGross money NULL ,
		LaborGrossApproved money NULL ,
		LaborUnbilled money NULL ,
		LaborBilled money NULL ,
		LaborInvoiced money NULL ,
		LaborWriteOff money NULL ,
		MiscCostNet money NULL ,
		MiscCostGross money NULL ,
		MiscCostUnbilled money NULL ,
		MiscCostWriteOff money NULL ,
		MiscCostBilled money NULL ,
		MiscCostInvoiced money NULL ,
		ExpReceiptNet money NULL ,
		ExpReceiptNetApproved money NULL ,
		ExpReceiptGross money NULL ,
		ExpReceiptGrossApproved money NULL ,
		ExpReceiptUnbilled money NULL ,
		ExpReceiptWriteOff money NULL ,
		ExpReceiptBilled money NULL ,
		ExpReceiptInvoiced money NULL ,
		VoucherNet money NULL ,
		VoucherNetApproved money NULL ,
		VoucherGross money NULL ,
		VoucherGrossApproved money NULL ,
		VoucherOutsideCostsGross money NULL ,
		VoucherOutsideCostsGrossApproved money NULL ,
		VoucherUnbilled money NULL ,
		VoucherWriteOff money NULL ,
		VoucherBilled money NULL ,
		VoucherInvoiced money NULL ,
		OpenOrdersNet money NULL ,
		OpenOrderNetApproved money NULL ,
		OpenOrderGross money NULL ,
		OpenOrderGrossApproved money NULL ,
		OpenOrderUnbilled money NULL ,
		OrderPrebilled money NULL ,
		AmountBilled money NULL ,
		AmountBilledNoTax money NULL ,
		AdvanceBilled money NULL ,
		AdvanceBilledOpen money NULL,
		AllocatedHours decimal(24,4) null,
		SalesTax money NULL,
		TotalGrossUnbilledFixedFee money NULL,
		EstQty decimal(24,4) NULL,
		EstNet money NULL,
		EstGross money NULL,
		EstCOQty decimal(24,4) NULL,
		EstCONet money NULL,
		EstCOGross money NULL,
		
		-- Actuals fields...Cloned from spRptBudgetAnalysis
		OutsideCostsNet money null
		,InsideCostsNet money null
		
		,OpenOrdersGrossUnbilled money null
		,OutsideCostsGrossUnbilled money null
		,InsideCostsGrossUnbilled money null
		
		,OutsideCostsGross money null
		,InsideCostsGross money null
		
		,ExpenseWriteOff money null		
		,ExpenseBilled money null		
		,ExpenseInvoiced money null		
				
		-- Budget fields...Cloned from spRptBudgetAnalysis
		,CurrentBudgetHours decimal(24,4) null
		,CurrentBudgetQty decimal(24,4) null
		,CurrentBudgetLaborNet money null
		,CurrentBudgetLaborGross money null
		,CurrentBudgetExpenseNet money null
		,CurrentBudgetExpenseGross money null
		,CurrentBudgetContingency money null
		,CurrentTotalBudget money null
		,CurrentTotalBudgetCont money null
		,CurrentTotalBudgetWithTax money null		-- not calc'ed, but added for rendering on the grid (was blank)
		,CurrentTotalBudgetContWithTax money null

		,COBudgetHours decimal(24,4) null
		,COBudgetQty decimal(24,4) null
		,COBudgetLaborNet money null
		,COBudgetLaborGross money null
		,COBudgetExpenseNet money null
		,COBudgetExpenseGross money null
		,COBudgetContingency money null
		,COTotalBudget money null
		,COTotalBudgetCont money null
		,COTotalBudgetWithTax money null
		,COTotalBudgetContWithTax money null

		,OriginalBudgetHours decimal(24,4) null
		,OriginalBudgetQty decimal(24,4) null
		,OriginalBudgetLaborNet money null
		,OriginalBudgetLaborGross money null
		,OriginalBudgetExpenseNet money null
		,OriginalBudgetExpenseGross money null
		,OriginalBudgetContingency money null
		,OriginalTotalBudget money null
		,OriginalTotalBudgetCont money null
		,OriginalTotalBudgetWithTax money null
		,OriginalTotalBudgetContWithTax money null
		
		-- Campaign Budget fields
		,C_CurrentBudgetHours decimal(24,4) null
		,C_CurrentBudgetLaborNet money null
		,C_CurrentBudgetLaborGross money null
		,C_CurrentBudgetExpenseNet money null
		,C_CurrentBudgetExpenseGross money null
		,C_CurrentBudgetContingency money null
		,C_CurrentTotalBudget money null
		,C_CurrentTotalBudgetWithTax money null
		,C_CurrentTotalBudgetCont money null
		,C_CurrentTotalBudgetContWithTax money null

		,C_COBudgetHours decimal(24,4) null
		,C_COBudgetLaborNet money null
		,C_COBudgetLaborGross money null
		,C_COBudgetExpenseNet money null
		,C_COBudgetExpenseGross money null
		,C_COBudgetContingency money null
		,C_COTotalBudget money null
		,C_COTotalBudgetWithTax money null
		,C_COTotalBudgetCont money null
		,C_COTotalBudgetContWithTax money null

		,C_OriginalBudgetHours decimal(24,4) null
		,C_OriginalBudgetLaborNet money null
		,C_OriginalBudgetLaborGross money null
		,C_OriginalBudgetExpenseNet money null
		,C_OriginalBudgetExpenseGross money null
		,C_OriginalBudgetContingency money null
		,C_OriginalTotalBudget money null
		,C_OriginalTotalBudgetWithTax money null
		,C_OriginalTotalBudgetCont money null
		,C_OriginalTotalBudgetContWithTax money null

		-- Totals...Cloned from spRptBudgetAnalysis
		,TotalCostsNet money null				-- InsideCostsNet + OutsideCostsNet
		,TotalCostsGrossUnbilled money null		-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled
		,TotalCostsGross money null				-- InsideCostsGross + OutsideCostsGross

		,TotalNet money null					-- InsideCostsNet + OutsideCostsNet + OpenOrdersNet + LaborNet
		,TotalGrossUnbilled money null			-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled + OpenOrdersGrossUnbilled + LaborGrossUnbilled
		,TotalGross money null					-- InsideCostsGross + OutsideCostsGross + OpenOrdersGrossUnbilled + LaborGross
		,TotalGrossAfterWriteOff money null     -- TotalGross - LaborWriteOff - ExpenseWriteOff

		-- Variance calcs...Cloned from spRptBudgetAnalysis
		,HoursBilledRemaining decimal(24,4) null
		,HoursBilledRemainingP decimal(24,4) null
		,HoursRemaining decimal(24,4) null
		,HoursRemainingP decimal(24,4) null
		,LaborNetRemaining money null
		,LaborNetRemainingP decimal(24,4) null
		,LaborGrossRemaining money null
		,LaborGrossRemainingP decimal(24,4) null

		,CostsNetRemaining money null
		,CostsNetRemainingP decimal(24,4) null
		,CostsGrossRemaining money null
		,CostsGrossRemainingP decimal(24,4) null

		,ToBillRemaining money null
		,ToBillRemainingP decimal(24,4) null
		,GrossRemaining money null
		,GrossRemainingP decimal(24,4) null
				
		-- New fields added, not part of the project rollup table		
		,BilledDifference money null
		,PurchasedQty decimal(24,4) NULL -- MiscCost and VI only
	
	) 

	declare @CampaignKey int
	
	select @LayoutKey = isnull(@LayoutKey, 0)
	
	if not exists (select 1 from tLayout (nolock) where LayoutKey = @LayoutKey)
		select @LayoutKey = 0
	
	if @Entity = 'tProject'
	begin
		insert #projects (ProjectKey) values (@EntityKey)

		select @CampaignKey = CampaignKey
		from   tProject (nolock)
		where  ProjectKey = @EntityKey
	end
	else if @Entity = 'tCampaignSegment'
	begin
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignSegmentKey = @EntityKey
	
		-- needed for index in tCampaignEstByItem
		select @CampaignKey = CampaignKey
		from   tCampaignSegment (nolock)
		where  CampaignSegmentKey = @EntityKey
	end
	else if @Entity = 'tCampaign'
	begin
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignKey = @EntityKey

		select @CampaignKey = @EntityKey
	end
	else if @Entity = 'tCampaignNoSegment'
	begin
		insert #projects (ProjectKey) 
		select ProjectKey from tProject (nolock) 
		where CompanyKey = @CompanyKey 
		and CampaignKey = @EntityKey
		and isnull(CampaignSegmentKey, 0) = 0
		
		select @CampaignKey = @EntityKey
	end
	
	insert #roll (
	    Entity, 
		EntityKey,
		ItemID, 
		ItemName,
		WorkTypeKey,
		WorkTypeID,
		WorkTypeName,	
		WorkTypeDisplayOrder,	
		Hours,
		HoursApproved,
		HoursBilled,
		HoursInvoiced,
		LaborNet,
		LaborNetApproved,
		LaborGross,
		LaborGrossApproved ,
		LaborUnbilled ,
		LaborBilled ,
		LaborInvoiced ,
		LaborWriteOff,
		MiscCostNet,
		MiscCostGross,
		MiscCostUnbilled,
		MiscCostWriteOff,
		MiscCostBilled,
		MiscCostInvoiced,
		ExpReceiptNet,
		ExpReceiptNetApproved,
		ExpReceiptGross,
		ExpReceiptGrossApproved,
		ExpReceiptUnbilled,
		ExpReceiptWriteOff,
		ExpReceiptBilled,
		ExpReceiptInvoiced,
		VoucherNet,
		VoucherNetApproved,
		VoucherGross,
		VoucherGrossApproved,
		VoucherOutsideCostsGross,
		VoucherOutsideCostsGrossApproved,
		VoucherUnbilled,
		VoucherWriteOff,
		VoucherBilled,
		VoucherInvoiced,
		OpenOrdersNet,
		OpenOrderNetApproved,
		OpenOrderGross,
		OpenOrderGrossApproved,
		OpenOrderUnbilled,
		OrderPrebilled,
		AmountBilled,
		AmountBilledNoTax,
		AdvanceBilled,
		AdvanceBilledOpen,
		EstQty,
		EstNet,
		EstGross,
		EstCOQty,
		EstCONet,
		EstCOGross)
   select Entity, 
		EntityKey,
		case when Entity = 'tItem' then '[No Item ID]' else '[No Service Code]' end, --ItemID, 
		case when Entity = 'tItem' then '[No Item]' else '[No Service]' end, --ItemName,
		0,    --WorkTypeKey,
		'[No Billing Item ID]', --WorkTypeID,
		'[No Billing Item]', --WorkTypeName,
		0,    --WorkTypeDisplayOrder		
		sum(Hours),
		sum(HoursApproved),
		sum(HoursBilled),
		sum(HoursInvoiced),
		sum(LaborNet),
		sum(LaborNetApproved),
		sum(LaborGross),
		sum(LaborGrossApproved),
		sum(LaborUnbilled),
		sum(LaborBilled),
		sum(LaborInvoiced),
		sum(LaborWriteOff),
		sum(MiscCostNet),
		sum(MiscCostGross),
		sum(MiscCostUnbilled),
		sum(MiscCostWriteOff),
		sum(MiscCostBilled),
		sum(MiscCostInvoiced),
		sum(ExpReceiptNet),
		sum(ExpReceiptNetApproved),
		sum(ExpReceiptGross),
		sum(ExpReceiptGrossApproved),
		sum(ExpReceiptUnbilled),
		sum(ExpReceiptWriteOff),
		sum(ExpReceiptBilled),
		sum(ExpReceiptInvoiced),
		sum(VoucherNet),
		sum(VoucherNetApproved),
		sum(VoucherGross),
		sum(VoucherGrossApproved),
		sum(VoucherOutsideCostsGross),
		sum(VoucherOutsideCostsGrossApproved),
		sum(VoucherUnbilled),
		sum(VoucherWriteOff),
		sum(VoucherBilled),
		sum(VoucherInvoiced),
		sum(OpenOrderNet),
		sum(OpenOrderNetApproved),
		sum(OpenOrderGross),
		sum(OpenOrderGrossApproved),
		sum(OpenOrderUnbilled),
		sum(OrderPrebilled),
		sum(BilledAmount),
		sum(BilledAmountNoTax),
		sum(AdvanceBilled),
		sum(AdvanceBilledOpen),
		sum(EstQty),
		sum(EstNet),
		sum(EstGross),
		sum(EstCOQty),
		sum(EstCONet),
		sum(EstCOGross)
	from tProjectItemRollup roll (nolock)
	inner join #projects b on roll.ProjectKey = b.ProjectKey
	group by Entity, EntityKey
	
	-- now add the items on the campaign estimates
	-- they may likely not be in tProjectItemRollup 

	if @Entity = 'tCampaign'
	insert #roll (
	    Entity, 
		EntityKey,
		WorkTypeKey,
		WorkTypeDisplayOrder)
	select distinct 'tItem', cebi.EntityKey, 0,0
	from   tCampaignEstByItem cebi (nolock)
	where  cebi.CampaignKey = @CampaignKey
	and    cebi.Entity = 'tItem'
	and    cebi.EntityKey not in (select EntityKey from #roll where Entity = 'tItem')
			
	if @Entity = 'tCampaignSegment'
	insert #roll (
	    Entity, 
		EntityKey,
		WorkTypeKey,
		WorkTypeDisplayOrder)
	select distinct 'tItem', cebi.EntityKey, 0,0
	from   tCampaignEstByItem cebi (nolock)
	where  cebi.CampaignKey = @CampaignKey
	and    cebi.CampaignSegmentKey = @EntityKey
	and    cebi.Entity = 'tItem'
	and    cebi.EntityKey not in (select EntityKey from #roll where Entity = 'tItem')

	if @Entity = 'tCampaign'	
	insert #roll (
	    Entity, 
		EntityKey,
		WorkTypeKey,
		WorkTypeDisplayOrder)
	select distinct 'tService', cebi.EntityKey, 0,0
	from   tCampaignEstByItem cebi (nolock)
	where  cebi.CampaignKey = @CampaignKey
	and    cebi.Entity = 'tService'
	and    cebi.EntityKey not in (select EntityKey from #roll where Entity = 'tService')
	
	if @Entity = 'tCampaignSegment'	
	insert #roll (
	    Entity, 
		EntityKey,
		WorkTypeKey,
		WorkTypeDisplayOrder)
	select distinct 'tService', cebi.EntityKey, 0,0
	from   tCampaignEstByItem cebi (nolock)
	where  cebi.CampaignKey = @CampaignKey
	and    cebi.CampaignSegmentKey = @EntityKey
	and    cebi.Entity = 'tService'
	and    cebi.EntityKey not in (select EntityKey from #roll where Entity = 'tService')

	insert #project_other (Entity, EntityKey, AllocatedHours)
	select 'tService', isnull(tu.ServiceKey, 0), sum(tu.Hours)
	from   tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	inner join #projects p (nolock) on t.ProjectKey = p.ProjectKey
	group by isnull(tu.ServiceKey, 0) 

	insert #roll (
	    Entity, 
		EntityKey,
		WorkTypeKey,
		WorkTypeDisplayOrder
		)
	select 'tService', b.EntityKey, 0,0
	from   #project_other b
	where  b.Entity = 'tService'
	and    b.EntityKey not in (select EntityKey from #roll where Entity = 'tService')

	update #roll
	set    #roll.AllocatedHours = b.AllocatedHours
	from   #project_other b
	where  #roll.Entity = b.Entity
	and    #roll.EntityKey = b.EntityKey

	-- now updates actuals like in Budget Analysis and budget fields 
	update #roll
	set    #roll.OutsideCostsNet = #roll.VoucherNet
	      ,#roll.InsideCostsNet = #roll.MiscCostNet + #roll.ExpReceiptNet
	      ,#roll.OpenOrdersGrossUnbilled = #roll.OpenOrderUnbilled -- used to be calculated unbilled, so use new field OpenOrderUnbilled 
	      ,#roll.OutsideCostsGrossUnbilled = #roll.VoucherUnbilled
	      ,#roll.InsideCostsGrossUnbilled = #roll.MiscCostUnbilled + #roll.ExpReceiptUnbilled
	      ,#roll.OutsideCostsGross = #roll.OrderPrebilled + #roll.VoucherOutsideCostsGross -- + roll.OpenOrderGross (34827)
		  ,#roll.InsideCostsGross = #roll.MiscCostGross + #roll.ExpReceiptGross
		  ,#roll.ExpenseWriteOff = #roll.MiscCostWriteOff + #roll.ExpReceiptWriteOff + #roll.VoucherWriteOff
		  ,#roll.ExpenseBilled = #roll.MiscCostBilled + #roll.ExpReceiptBilled + #roll.VoucherBilled + #roll.OrderPrebilled
		  ,#roll.ExpenseInvoiced = #roll.MiscCostInvoiced + #roll.ExpReceiptInvoiced + #roll.VoucherInvoiced + #roll.OrderPrebilled

	      ,#roll.CurrentBudgetHours = case when Entity = 'tService' then EstQty + EstCOQty else 0 end
		  ,#roll.CurrentBudgetQty = case when Entity = 'tItem' then EstQty + EstCOQty else 0 end
		  ,#roll.CurrentBudgetLaborNet = case when Entity = 'tService' then EstNet + EstCONet else 0 end
		  ,#roll.CurrentBudgetLaborGross = case when Entity = 'tService' then EstGross + EstCOGross else 0 end
		  ,#roll.CurrentBudgetExpenseNet = case when Entity = 'tItem' then EstNet + EstCONet else 0 end
		  ,#roll.CurrentBudgetExpenseGross = case when Entity = 'tItem' then EstGross + EstCOGross else 0 end
		  ,#roll.CurrentBudgetContingency = 0
		  ,#roll.CurrentTotalBudget = EstGross + EstCOGross
		  ,#roll.CurrentTotalBudgetCont = EstGross + EstCOGross

		  ,#roll.COBudgetHours = case when Entity = 'tService' then EstCOQty else 0 end
		  ,#roll.COBudgetQty = case when Entity = 'tItem' then EstCOQty else 0 end
		  ,#roll.COBudgetLaborNet = case when Entity = 'tService' then EstCONet else 0 end
		  ,#roll.COBudgetLaborGross = case when Entity = 'tService' then EstCOGross else 0 end
		  ,#roll.COBudgetExpenseNet = case when Entity = 'tItem' then EstCONet else 0 end
		  ,#roll.COBudgetExpenseGross = case when Entity = 'tItem' then EstCOGross else 0 end
		  ,#roll.COBudgetContingency= 0
		  ,#roll.COTotalBudget = EstCOGross 
		  ,#roll.COTotalBudgetCont = EstCOGross

		  ,#roll.OriginalBudgetHours = case when Entity = 'tService' then EstQty else 0 end
		  ,#roll.OriginalBudgetQty = case when Entity = 'tItem' then EstQty else 0 end
		  ,#roll.OriginalBudgetLaborNet = case when Entity = 'tService' then EstNet else 0 end
		  ,#roll.OriginalBudgetLaborGross = case when Entity = 'tService' then EstGross else 0 end
		  ,#roll.OriginalBudgetExpenseNet = case when Entity = 'tItem' then EstNet else 0 end
		  ,#roll.OriginalBudgetExpenseGross = case when Entity = 'tItem' then EstGross else 0 end
		  ,#roll.OriginalBudgetContingency = 0
		  ,#roll.OriginalTotalBudget = EstGross 
		  ,#roll.OriginalTotalBudgetCont = EstGross
	      
	    -- now update the campaign budget fields (from estimates on campaigns)  

	    if @Entity = 'tCampaignSegment'
		begin
			update #roll
			set    #roll.C_CurrentBudgetHours = case when #roll.Entity = 'tService' then cebi.Qty + cebi.COQty else 0 end	
			      ,#roll.C_CurrentBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.Net + cebi.CONet else 0 end
		          ,#roll.C_CurrentBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.Gross + cebi.COGross else 0 end
		          ,#roll.C_CurrentBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.Net + cebi.CONet else 0 end
		          ,#roll.C_CurrentBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.Gross + cebi.COGross else 0 end
		          ,#roll.C_CurrentBudgetContingency = 0
		          ,#roll.C_CurrentTotalBudget = cebi.Gross + cebi.COGross
		          ,#roll.C_CurrentTotalBudgetCont = cebi.Gross + cebi.COGross

				  ,#roll.C_COBudgetHours = case when #roll.Entity = 'tService' then cebi.COQty else 0 end
				  ,#roll.C_COBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.CONet else 0 end
				  ,#roll.C_COBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.COGross else 0 end
				  ,#roll.C_COBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.CONet else 0 end
				  ,#roll.C_COBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.COGross else 0 end
				  ,#roll.C_COBudgetContingency= 0
				  ,#roll.C_COTotalBudget = cebi.COGross 
				  ,#roll.C_COTotalBudgetCont = cebi.COGross

				  ,#roll.C_OriginalBudgetHours = case when #roll.Entity = 'tService' then cebi.Qty else 0 end
				  ,#roll.C_OriginalBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.Net else 0 end
				  ,#roll.C_OriginalBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.Gross else 0 end
				  ,#roll.C_OriginalBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.Net else 0 end
				  ,#roll.C_OriginalBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.Gross else 0 end
				  ,#roll.C_OriginalBudgetContingency = 0
				  ,#roll.C_OriginalTotalBudget = cebi.Gross 
				  ,#roll.C_OriginalTotalBudgetCont = cebi.Gross
		  
			from   tCampaignEstByItem cebi (nolock)
			where  cebi.CampaignSegmentKey = @EntityKey
			and    cebi.CampaignKey = @CampaignKey
			and    cebi.Entity = #roll.Entity COLLATE DATABASE_DEFAULT
			and    cebi.EntityKey = #roll.EntityKey
			
		end
		
		if @Entity = 'tCampaign'
		begin
			update #roll
			set    #roll.C_CurrentBudgetHours = case when #roll.Entity = 'tService' then cebi.Qty + cebi.COQty else 0 end	
			      ,#roll.C_CurrentBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.Net + cebi.CONet else 0 end
		          ,#roll.C_CurrentBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.Gross + cebi.COGross else 0 end
		          ,#roll.C_CurrentBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.Net + cebi.CONet else 0 end
		          ,#roll.C_CurrentBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.Gross + cebi.COGross else 0 end
		          ,#roll.C_CurrentBudgetContingency = 0
		          ,#roll.C_CurrentTotalBudget = cebi.Gross + cebi.COGross
		          ,#roll.C_CurrentTotalBudgetCont = cebi.Gross + cebi.COGross

				  ,#roll.C_COBudgetHours = case when #roll.Entity = 'tService' then cebi.COQty else 0 end
				  ,#roll.C_COBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.CONet else 0 end
				  ,#roll.C_COBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.COGross else 0 end
				  ,#roll.C_COBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.CONet else 0 end
				  ,#roll.C_COBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.COGross else 0 end
				  ,#roll.C_COBudgetContingency= 0
				  ,#roll.C_COTotalBudget = cebi.COGross 
				  ,#roll.C_COTotalBudgetCont = cebi.COGross

				  ,#roll.C_OriginalBudgetHours = case when #roll.Entity = 'tService' then cebi.Qty else 0 end
				  ,#roll.C_OriginalBudgetLaborNet = case when #roll.Entity = 'tService' then cebi.Net else 0 end
				  ,#roll.C_OriginalBudgetLaborGross = case when #roll.Entity = 'tService' then cebi.Gross else 0 end
				  ,#roll.C_OriginalBudgetExpenseNet = case when #roll.Entity = 'tItem' then cebi.Net else 0 end
				  ,#roll.C_OriginalBudgetExpenseGross = case when #roll.Entity = 'tItem' then cebi.Gross else 0 end
				  ,#roll.C_OriginalBudgetContingency = 0
				  ,#roll.C_OriginalTotalBudget = cebi.Gross 
				  ,#roll.C_OriginalTotalBudgetCont = cebi.Gross
		  
			from   
					(select CampaignKey, Entity, EntityKey
					, Sum(Qty) As Qty, Sum(Net) As Net, Sum(Gross) As Gross
					, Sum(COQty) As COQty, Sum(CONet) As CONet, Sum(COGross) As COGross
					 from   tCampaignEstByItem  (nolock)
					 where CampaignKey = @EntityKey
					 group by CampaignKey, Entity, EntityKey) as cebi  
			where  cebi.Entity = #roll.Entity COLLATE DATABASE_DEFAULT
			and    cebi.EntityKey = #roll.EntityKey
			
		end
		
		UPDATE #roll
		SET #roll.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey in (select ProjectKey from #projects)
								AND   #roll.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #roll.EntityKey
								AND  t.InvoiceLineKey > 0  
								), 0) 
								+
								ISNULL((
								SELECT SUM(mc.AmountBilled - mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey in (select ProjectKey from #projects)
								AND   #roll.Entity = 'tItem'
								AND   ISNULL(mc.ItemKey, 0) = #roll.EntityKey
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled - er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey in (select ProjectKey from #projects)
								AND   #roll.Entity = 'tItem'
								AND   ISNULL(er.ItemKey, 0) = #roll.EntityKey
								AND   er.VoucherDetailKey IS NULL 
								AND   er.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled - vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey in (select ProjectKey from #projects)
								AND   #roll.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #roll.EntityKey
								AND   vd.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled - 
										CASE po.BillAt 
											WHEN 0 THEN ISNULL(pod.BillableCost, 0)
											WHEN 1 THEN ISNULL(pod.PTotalCost,0)
											WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
											END) -- BillableCost 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND  pod.ProjectKey in (select ProjectKey from #projects)
								AND   #roll.Entity = 'tItem'
								AND   ISNULL(pod.ItemKey, 0) = #roll.EntityKey
								AND pod.InvoiceLineKey > 0
								), 0)
	
	-- just for the project budget screen 			 
	if @Entity = 'tProject'
	begin
		 update #roll
		set    #roll.PurchasedQty = ISNULL((
			select sum(mc.Quantity) from tMiscCost mc (nolock)
			where  mc.ProjectKey = @EntityKey -- use index by Project
			and    mc.ItemKey = #roll.EntityKey and #roll.Entity = 'tItem' 
		),0)

		 update #roll
		set    #roll.PurchasedQty = ISNULL(#roll.PurchasedQty, 0) + ISNULL((
			select sum(vd.Quantity) from tVoucherDetail vd (nolock)
			where  vd.ProjectKey = @EntityKey -- use index by Project
			and    vd.ItemKey = #roll.EntityKey and #roll.Entity = 'tItem' 
		),0)

	end

	-- Final Calculations
	UPDATE #roll
	SET    OutsideCostsNet				= ISNULL(OutsideCostsNet, 0) -- + ISNULL(OpenOrdersNet, 0)  -- 10/15/2008
		   ,OutsideCostsGrossUnbilled	= ISNULL(OutsideCostsGrossUnbilled,0) -- + ISNULL(OpenOrdersGrossUnbilled, 0) -- 10/15/2008	
	
	UPDATE #roll
    SET    TotalCostsNet			= ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)  
          ,TotalCostsGrossUnbilled	= ISNULL(InsideCostsGrossUnbilled,0) + ISNULL(OutsideCostsGrossUnbilled, 0)
          ,TotalCostsGross			= ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)	
		  
		  -- These 2 added 10/15/2008
		  ,TotalNet					= ISNULL(LaborNet, 0) + ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)
		                              + ISNULL(OpenOrdersNet, 0) 
		  ,TotalGrossUnbilled		= ISNULL(LaborUnbilled, 0) + ISNULL(InsideCostsGrossUnbilled, 0) + ISNULL(OutsideCostsGrossUnbilled, 0)
		                              + ISNULL(OpenOrdersGrossUnbilled, 0) 
	
		  ,TotalGross				= ISNULL(LaborGross, 0) + ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)
		                              + ISNULL(OpenOrdersGrossUnbilled, 0) -- Added 10/15/2008
		  ,SalesTax					= ISNULL(AmountBilled,0) - ISNULL(AmountBilledNoTax, 0)
		  ,TotalGrossUnbilledFixedFee = ISNULL(TotalGross,0) - ISNULL(AmountBilledNoTax, 0)

	UPDATE #roll
    SET  TotalGrossUnbilledFixedFee = ISNULL(TotalGross,0) - ISNULL(AmountBilledNoTax, 0)
	
	--select 	LaborGross , InsideCostsGross, + OutsideCostsGross, OpenOrdersGrossUnbilled from #roll
		
	-- mainly for better rendering on grid
	update #roll 
	    set Hours = isnull(Hours , 0),
		HoursApproved  = isnull(HoursApproved , 0),
		HoursBilled  = isnull(HoursBilled , 0),
		HoursInvoiced  = isnull(HoursInvoiced , 0),
		LaborNet  = isnull( LaborNet, 0),
		LaborNetApproved  = isnull(LaborNetApproved , 0),
		LaborGross  = isnull(LaborGross , 0),
		LaborGrossApproved  = isnull(LaborGrossApproved , 0),
		LaborUnbilled  = isnull(LaborUnbilled , 0),
		LaborBilled  = isnull(LaborBilled , 0),
		LaborInvoiced  = isnull(LaborInvoiced , 0),
		LaborWriteOff = isnull(LaborWriteOff , 0),
		MiscCostNet = isnull(MiscCostNet , 0),
		MiscCostGross  = isnull(MiscCostGross , 0),
		MiscCostUnbilled  = isnull(MiscCostUnbilled , 0),
		MiscCostWriteOff = isnull(MiscCostWriteOff , 0),
		MiscCostBilled = isnull(MiscCostBilled , 0),
		MiscCostInvoiced = isnull(MiscCostInvoiced , 0),
		ExpReceiptNet = isnull(ExpReceiptNet , 0),
		ExpReceiptNetApproved = isnull(ExpReceiptNetApproved , 0),
		ExpReceiptGross = isnull(ExpReceiptGross , 0),
		ExpReceiptGrossApproved = isnull(ExpReceiptGrossApproved , 0),
		ExpReceiptUnbilled = isnull(ExpReceiptUnbilled , 0),
		ExpReceiptWriteOff = isnull(ExpReceiptWriteOff , 0),
		ExpReceiptBilled = isnull(ExpReceiptBilled , 0),
		ExpReceiptInvoiced = isnull(ExpReceiptInvoiced , 0),
		VoucherNet = isnull(VoucherNet , 0),
		VoucherNetApproved = isnull(VoucherNetApproved , 0),
		VoucherGross  = isnull(VoucherGross , 0),
		VoucherGrossApproved = isnull(VoucherGrossApproved , 0),
		VoucherOutsideCostsGross = isnull(VoucherOutsideCostsGross , 0),
		VoucherOutsideCostsGrossApproved = isnull(VoucherOutsideCostsGrossApproved , 0),
		VoucherUnbilled = isnull(VoucherUnbilled , 0),
		VoucherWriteOff = isnull(VoucherWriteOff , 0),
		VoucherBilled = isnull(VoucherBilled , 0),
		VoucherInvoiced = isnull(VoucherInvoiced , 0),
		OpenOrdersNet = isnull(OpenOrdersNet , 0),
		OpenOrderNetApproved = isnull(OpenOrderNetApproved , 0),
		OpenOrderGross = isnull(OpenOrderGross , 0),
		OpenOrderGrossApproved = isnull(OpenOrderGrossApproved , 0),
		OrderPrebilled = isnull( OrderPrebilled, 0),
		AmountBilled = isnull(AmountBilled , 0),
		AmountBilledNoTax  = isnull(AmountBilledNoTax , 0),
		AdvanceBilled  = isnull(AdvanceBilled , 0),
		AdvanceBilledOpen = isnull(AdvanceBilledOpen , 0),
		AllocatedHours = isnull(AllocatedHours , 0),

		EstQty = isnull(EstQty , 0),
		EstNet = isnull(EstNet , 0),
		EstGross = isnull(EstGross , 0),
		EstCOQty  = isnull(EstCOQty , 0),
		EstCONet = isnull( EstCONet, 0),
		EstCOGross  = isnull(EstCOGross , 0),
		
		-- Actuals fields...Cloned from spRptBudgetAnalysis
		OutsideCostsNet = isnull(OutsideCostsNet , 0)
		,InsideCostsNet = isnull( InsideCostsNet, 0)
		
		,OpenOrdersGrossUnbilled  = isnull(OpenOrdersGrossUnbilled , 0)
		,OutsideCostsGrossUnbilled  = isnull(OutsideCostsGrossUnbilled , 0)
		,InsideCostsGrossUnbilled  = isnull(InsideCostsGrossUnbilled , 0)
		
		,OutsideCostsGross = isnull(OutsideCostsGross , 0)
		,InsideCostsGross = isnull(InsideCostsGross , 0)
		
		,ExpenseWriteOff = isnull(ExpenseWriteOff , 0)
		,ExpenseBilled = isnull(ExpenseBilled , 0)	
		,ExpenseInvoiced = isnull(ExpenseInvoiced , 0)	
				
		-- Budget fields...Cloned from spRptBudgetAnalysis
		,CurrentBudgetHours = isnull(CurrentBudgetHours , 0)
		,CurrentBudgetQty = isnull(CurrentBudgetQty , 0)
		,CurrentBudgetLaborNet = isnull(CurrentBudgetLaborNet , 0)
		,CurrentBudgetLaborGross = isnull(CurrentBudgetLaborGross , 0)
		,CurrentBudgetExpenseNet = isnull(CurrentBudgetExpenseNet , 0)
		,CurrentBudgetExpenseGross = isnull(CurrentBudgetExpenseGross , 0)
		,CurrentBudgetContingency = isnull(CurrentBudgetContingency , 0)
		,CurrentTotalBudget = isnull(CurrentTotalBudget , 0)
		,CurrentTotalBudgetCont = isnull(CurrentTotalBudgetCont , 0)
		,CurrentTotalBudgetWithTax  = isnull(CurrentTotalBudgetWithTax , 0)		-- not calc'ed, but added for rendering on the grid (was blank)
		,CurrentTotalBudgetContWithTax = isnull(CurrentTotalBudgetContWithTax , 0)

		,COBudgetHours  = isnull(COBudgetHours , 0)
		,COBudgetQty  = isnull(COBudgetQty , 0)
		,COBudgetLaborNet  = isnull(COBudgetLaborNet , 0)
		,COBudgetLaborGross = isnull(COBudgetLaborGross , 0)
		,COBudgetExpenseNet = isnull(COBudgetExpenseNet , 0)
		,COBudgetExpenseGross = isnull(COBudgetExpenseGross , 0)
		,COBudgetContingency = isnull(COBudgetContingency , 0)
		,COTotalBudget  = isnull(COTotalBudget , 0)
		,COTotalBudgetCont  = isnull(COTotalBudgetCont , 0)
		,COTotalBudgetWithTax  = isnull(COTotalBudgetWithTax , 0)
		,COTotalBudgetContWithTax  = isnull(COTotalBudgetContWithTax , 0)

		,OriginalBudgetHours  = isnull( OriginalBudgetHours, 0)
		,OriginalBudgetQty  = isnull( OriginalBudgetQty, 0)
		,OriginalBudgetLaborNet  = isnull( OriginalBudgetLaborNet, 0)
		,OriginalBudgetLaborGross  = isnull(OriginalBudgetLaborGross , 0)
		,OriginalBudgetExpenseNet  = isnull(OriginalBudgetExpenseNet , 0)
		,OriginalBudgetExpenseGross  = isnull(OriginalBudgetExpenseGross , 0)
		,OriginalBudgetContingency  = isnull( OriginalBudgetContingency, 0)
		,OriginalTotalBudget  = isnull(OriginalTotalBudget , 0)
		,OriginalTotalBudgetCont = isnull(OriginalTotalBudgetCont , 0)
		,OriginalTotalBudgetWithTax = isnull(OriginalTotalBudgetWithTax , 0)
		,OriginalTotalBudgetContWithTax  = isnull(OriginalTotalBudgetContWithTax , 0)
		
		-- Campaign Budget fields
		,C_CurrentBudgetHours = isnull(C_CurrentBudgetHours , 0)
		,C_CurrentBudgetLaborNet = isnull(C_CurrentBudgetLaborNet , 0)
		,C_CurrentBudgetLaborGross = isnull(C_CurrentBudgetLaborGross , 0)
		,C_CurrentBudgetExpenseNet = isnull(C_CurrentBudgetExpenseNet , 0)
		,C_CurrentBudgetExpenseGross  = isnull(C_CurrentBudgetExpenseGross , 0)
		,C_CurrentBudgetContingency  = isnull(C_CurrentBudgetContingency , 0)
		,C_CurrentTotalBudget  = isnull(C_CurrentTotalBudget , 0)
		,C_CurrentTotalBudgetWithTax  = isnull(C_CurrentTotalBudgetWithTax , 0)
		,C_CurrentTotalBudgetCont  = isnull(C_CurrentTotalBudgetCont , 0)
		,C_CurrentTotalBudgetContWithTax  = isnull(C_CurrentTotalBudgetContWithTax , 0)

		,C_COBudgetHours = isnull(C_COBudgetHours , 0)
		,C_COBudgetLaborNet  = isnull(C_COBudgetLaborNet , 0)
		,C_COBudgetLaborGross  = isnull(C_COBudgetLaborGross , 0)
		,C_COBudgetExpenseNet  = isnull(C_COBudgetExpenseNet , 0)
		,C_COBudgetExpenseGross  = isnull(C_COBudgetExpenseGross , 0)
		,C_COBudgetContingency  = isnull(C_COBudgetContingency , 0)
		,C_COTotalBudget = isnull(C_COTotalBudget , 0)
		,C_COTotalBudgetWithTax  = isnull(C_COTotalBudgetWithTax , 0)
		,C_COTotalBudgetCont  = isnull(C_COTotalBudgetCont , 0)
		,C_COTotalBudgetContWithTax  = isnull(C_COTotalBudgetContWithTax , 0)

		,C_OriginalBudgetHours  = isnull(C_OriginalBudgetHours , 0)
		,C_OriginalBudgetLaborNet  = isnull(C_OriginalBudgetLaborNet , 0)
		,C_OriginalBudgetLaborGross  = isnull(C_OriginalBudgetLaborGross , 0)
		,C_OriginalBudgetExpenseNet  = isnull(C_OriginalBudgetExpenseNet , 0)
		,C_OriginalBudgetExpenseGross  = isnull(C_OriginalBudgetExpenseGross , 0)
		,C_OriginalBudgetContingency  = isnull(C_OriginalBudgetContingency , 0)
		,C_OriginalTotalBudget  = isnull(C_OriginalTotalBudget , 0)
		,C_OriginalTotalBudgetWithTax  = isnull(C_OriginalTotalBudgetWithTax , 0)
		,C_OriginalTotalBudgetCont  = isnull(C_OriginalTotalBudgetCont , 0)
		,C_OriginalTotalBudgetContWithTax = isnull(C_OriginalTotalBudgetContWithTax , 0)

		-- Totals...Cloned from spRptBudgetAnalysis
		,TotalCostsNet  = isnull(TotalCostsNet , 0)				-- InsideCostsNet + OutsideCostsNet
		,TotalCostsGrossUnbilled  = isnull(TotalCostsGrossUnbilled , 0)		-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled
		,TotalCostsGross  = isnull(TotalCostsGross , 0)				-- InsideCostsGross + OutsideCostsGross

		,TotalNet  = isnull(TotalNet , 0)					-- InsideCostsNet + OutsideCostsNet + OpenOrdersNet + LaborNet
		,TotalGrossUnbilled  = isnull(TotalGrossUnbilled , 0)			-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled + OpenOrdersGrossUnbilled + LaborGrossUnbilled
		,TotalGross  = isnull(TotalGross , 0)					-- InsideCostsGross + OutsideCostsGross + OpenOrdersGrossUnbilled + LaborGross
		,SalesTax = ISNULL(SalesTax, 0)
		,TotalGrossUnbilledFixedFee = ISNULL(TotalGrossUnbilledFixedFee, 0)
		-- Variance calcs...Cloned from spRptBudgetAnalysis
		,HoursBilledRemaining  = isnull(HoursBilledRemaining , 0)
		,HoursBilledRemainingP  = isnull(HoursBilledRemainingP , 0)
		,HoursRemaining  = isnull(HoursRemaining , 0)
		,HoursRemainingP  = isnull(HoursRemainingP , 0)
		,LaborNetRemaining  = isnull(LaborNetRemaining , 0)
		,LaborNetRemainingP  = isnull(LaborNetRemainingP , 0)
		,LaborGrossRemaining  = isnull(LaborGrossRemaining , 0)
		,LaborGrossRemainingP  = isnull(LaborGrossRemainingP , 0)

		,CostsNetRemaining = isnull(CostsNetRemaining , 0)
		,CostsNetRemainingP  = isnull(CostsNetRemainingP , 0)
		,CostsGrossRemaining  = isnull(CostsGrossRemaining , 0)
		,CostsGrossRemainingP  = isnull(CostsGrossRemainingP , 0)

		,ToBillRemaining  = isnull(ToBillRemaining , 0)
		,ToBillRemainingP  = isnull(ToBillRemainingP , 0)
		,GrossRemaining  = isnull(GrossRemaining , 0)
		,GrossRemainingP  = isnull(GrossRemainingP , 0)
				
		-- BilledDifference		
		,BilledDifference  = isnull(BilledDifference , 0)
			
		,PurchasedQty = isnull(PurchasedQty , 0)

	
	UPDATE #roll
	SET    HoursBilledRemaining	= CurrentBudgetHours - HoursBilled
		   ,HoursRemaining		= CurrentBudgetHours - Hours 
     	   ,LaborNetRemaining	= CurrentBudgetLaborNet - LaborNet 
		   ,LaborGrossRemaining	= CurrentBudgetLaborGross - LaborGross
		   ,CostsNetRemaining	= CurrentBudgetExpenseNet - TotalCostsNet 
		   ,CostsGrossRemaining	= CurrentBudgetExpenseGross - TotalCostsGross 
		   ,ToBillRemaining		= CurrentTotalBudget - AmountBilled 
		   ,GrossRemaining		= CurrentTotalBudget - TotalGross
		   ,TotalGrossAfterWriteOff = TotalGross - LaborWriteOff - ExpenseWriteOff

			-- If numerator is zero, I take 0% arbitrarilly	
		   ,HoursBilledRemainingP	= CASE WHEN CurrentBudgetHours = 0				THEN 0 ELSE 100 * (CurrentBudgetHours - HoursBilled) /CurrentBudgetHours END
		   ,HoursRemainingP			= CASE WHEN CurrentBudgetHours = 0		THEN 0 ELSE 100 * (CurrentBudgetHours - Hours)/CurrentBudgetHours END
		   ,LaborNetRemainingP		= CASE WHEN CurrentBudgetLaborNet = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborNet - LaborNet)/CurrentBudgetLaborNet END
	       ,LaborGrossRemainingP	= CASE WHEN CurrentBudgetLaborGross = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborGross - LaborGross)/CurrentBudgetLaborGross END
		   ,CostsNetRemainingP		= CASE WHEN CurrentBudgetExpenseNet = 0	THEN 0 ELSE 100 * (CurrentBudgetExpenseNet - TotalCostsNet)/CurrentBudgetExpenseNet END
		   ,CostsGrossRemainingP	= CASE WHEN CurrentBudgetExpenseGross = 0 THEN 0 ELSE 100 * (CurrentBudgetExpenseGross - TotalCostsGross)/CurrentBudgetExpenseGross END
		   ,ToBillRemainingP		= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - AmountBilled)/CurrentTotalBudget END
		   ,GrossRemainingP			= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - TotalGross)/CurrentTotalBudget END

	update #roll
    set    #roll.ItemID = 'No Item ID'
          ,#roll.ItemName = 'No Item'
    where  #roll.Entity = 'tItem'
    and    #roll.EntityKey = 0

	update #roll
    set    #roll.ItemID = 'No Service Code'
          ,#roll.ItemName = 'No Service'
    where  #roll.Entity = 'tService'
    and    #roll.EntityKey = 0
      
	update #roll
    set    #roll.ItemID = i.ItemID
          ,#roll.ItemName = i.ItemName
          ,#roll.WorkTypeKey = isnull(i.WorkTypeKey, 0)
    from   tItem i (nolock)
    where  #roll.Entity = 'tItem'
    and    #roll.EntityKey = i.ItemKey
     
	update #roll
    set    #roll.ItemID = s.ServiceCode
          ,#roll.ItemName = s.Description
          ,#roll.WorkTypeKey = isnull(s.WorkTypeKey, 0)
    from   tService s (nolock)
    where  #roll.Entity = 'tService'
    and    #roll.EntityKey = s.ServiceKey

	update #roll
	set    WorkTypeID = '[No Billing Item ID]'
		   ,WorkTypeName = '[No Billing Item]'
		   ,WorkTypeKey = isnull(WorkTypeKey, 0)
	where  isnull(WorkTypeKey, 0) = 0

	if @LayoutKey = 0
	begin
		-- problem here because display order in tWorkType not unique or missing
		create table #sorted (SortKey int identity(1,1), Entity varchar(50) null, EntityKey int null)
	
		-- no layout, rely on WT display order then Item Name
		update #roll
		set    #roll.WorkTypeID = wt.WorkTypeID
			  ,#roll.WorkTypeName = wt.WorkTypeName
			  ,#roll.WorkTypeDisplayOrder = wt.DisplayOrder
		from   tWorkType wt (nolock)
		where  #roll.WorkTypeKey = wt.WorkTypeKey 

		-- Now update entity specific WorkTypeNames
		UPDATE	#roll
		SET		#roll.WorkTypeName = cust.Subject
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#roll.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = @Entity
		AND		cust.EntityKey = @EntityKey

		insert  #sorted (Entity, EntityKey)
		select  Entity, EntityKey
		from    #roll
		order   by isnull(WorkTypeDisplayOrder,0), WorkTypeName, ItemName

		update  #roll
		set     #roll.WorkTypeDisplayOrder = #sorted.SortKey
		from    #sorted
		where   #roll.Entity = #sorted.Entity collate database_default
		and     #roll.EntityKey = #sorted.EntityKey

	end
	else
	begin
		-- the items have been reorganized on the layout 
		update #roll
		set    #roll.WorkTypeKey = 0
	
		-- get WT key only when parent entity is tWorkType	
		update #roll
		set    #roll.WorkTypeKey = lb.ParentEntityKey
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #roll.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #roll.EntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tWorkType'
	

		update #roll
		set    #roll.WorkTypeID = wt.WorkTypeID
			  ,#roll.WorkTypeName = wt.WorkTypeName
		from   tWorkType wt (nolock)
		where  #roll.WorkTypeKey = wt.WorkTypeKey 
		
		-- Now update entity specific WorkTypeNames
		UPDATE	#roll
		SET		#roll.WorkTypeName = cust.Subject
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#roll.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = @Entity
		AND		cust.EntityKey = @EntityKey

		-- but always get the Layout Order
		update #roll
		set    #roll.WorkTypeDisplayOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #roll.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #roll.EntityKey = lb.EntityKey     				

	end

	-- redo this because we modified WTKey
	update #roll
	set    WorkTypeID = '[No Billing Item ID]'
		   ,WorkTypeName = '[No Billing Item]'
		   ,WorkTypeKey = isnull(WorkTypeKey, 0)
	where  isnull(WorkTypeKey, 0) = 0

	-- Set the DepartmentName for tItem
	Update #roll 
	   set #roll.DepartmentName = d.DepartmentName
	from  tItem i (nolock)
	LEFT JOIN tDepartment d (nolock) ON i.DepartmentKey = d.DepartmentKey
	Where #roll.Entity = 'tItem'
	and   #roll.EntityKey = i.ItemKey

	-- Set the DepartmentName for tService
	Update #roll 
	   set #roll.DepartmentName = d.DepartmentName
	from  tService s (nolock)
	LEFT JOIN tDepartment d (nolock) ON s.DepartmentKey = d.DepartmentKey
	Where #roll.Entity = 'tService'
	and   #roll.EntityKey = s.ServiceKey


	select @Entity as GroupEntity -- how we grouped the projects
	       ,@EntityKey as GroupEntityKey
	       ,* 
	from #roll 
	order by WorkTypeDisplayOrder, WorkTypeID, ItemName

			     	
	RETURN 1
GO
