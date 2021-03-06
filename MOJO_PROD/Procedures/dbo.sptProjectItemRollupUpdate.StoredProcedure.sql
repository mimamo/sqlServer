USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectItemRollupUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectItemRollupUpdate]
	(
		@ProjectKey INT     
		,@SingleMode INT = 1  -- 1 Single Project, 0 Multi Projects
		,@TranType INT		-- -1 All, 1 Labor, 2 Misc Cost, 3 Exp Receipt, 4 Voucher, 5 PO, 6 Billed, 7 Unbilled, 8 WriteOff, 9 Estimates
		,@BaseRollup INT	-- Includes Unbilled also
		,@Approved INT		-- Used when changing status on transaction header
		,@Unbilled INT		
		,@WriteOff INT
		,@CompanyKey INT = 0
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/23/09 GHL 10.5   Creation to use in new screen layouts by service and item    
  ||                     Multi Mode needs temp table #tProjectRollup 
  ||                     
  ||                     sptProjectItemRollupUpdate null, 0, -1, 1, 1, 1, 1 -- MultiMode, all tran types
  ||                     sptProjectItemRollupUpdate 3632, 1, -1, 1, 1, 1, 1 -- SingleMode, project 3632, all tran types
  ||                     sptProjectItemRollupUpdate 3632, 0, 6, 1, 1, 1, 1 -- MultiMode, project 3632 (display), billing tran type
  ||                     sptProjectItemRollupUpdate null, 0, 9, 1, 1, 1, 1 -- MultiMode, estimate data
  || 01/06/10 GHL 10.5   Added Billed + Invoiced Data
  || 02/17/10 GHL 10.518 (73756) Added Billed Amount Approved
  || 03/03/10 GHL 10.519 (76086) Corrected the way AdvanceBill is set in #tProjectIRollup (see below)
  || 03/16/10 GHL 10.520 Modified tTime queries for the 'My Tasks' case...use a temp table
  || 05/21/10 GHL 10.530 (81186) Incluing now prebilled orders in OpenOrderGross 
  || 06/21/10 GHL 10.531 (83389) Added OpenOrderUnbilled 
  || 11/15/10 GHL 10.538 (93504) Added to VoucherOutsideCostsGross the billable cost of VI lines with prebilled order
  ||                      These VI lines should have a BillableCost = 0 except when the user increases the Billable Cost 
  ||                      In that case, these VI lines would be recognized only when they are billed
  ||                      To recognize them as soon as they are applied, I added them to VoucherOutsideCostsGross 
  || 03/11/13 GHL 10.565 (171324) Added cast to Decimal(24,8) when calculating open order gross unbilled for better precision       
  || 08/26/13 GHL 10.571  Using now PTotalCost and PAppliedCost instead of TotalCost and AppliedCost for ERs, POs, and VDs
  ||                      Did not change labor and misc costs because they are expressed in Project Currency
  || 10/01/14 GHL 10.484 Calling now sptProjectTitleRollupUpdate        
  || 10/23/14 GHL 10.485 (233784 and 233644) check InvoiceLineKey on prebilled pod + remove check on pod.DateBilled for OutsideCostsGross                 
  ||                       because closed orders can be billed now on new media screens            
  */
	SET NOCOUNT ON
	
	DECLARE @UpdateStarted DATETIME
	SELECT @UpdateStarted = GETDATE()
	
	IF @SingleMode = 1 AND ISNULL(@ProjectKey, 0) <= 0
		RETURN 1
	
	IF @SingleMode = 1 AND @CompanyKey = 0
		SELECT @CompanyKey = CompanyKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey
		
	-- this temp table contains a list of entities to calculate data for
	-- will depend on @TranType and other params
	CREATE TABLE #tEntity(
		Action int NULL,			-- 0 Insert, 1 Update, 2 Delete 
	    CompanyKey int null,		-- for Adv Billed Open loop
		ProjectKey int NULL, 
	    Entity varchar(50) NULL, 
	    EntityKey int NULL, 
	    AdvanceBill int NULL )
		
	-- Project Item Rollup table	
	CREATE TABLE #tProjectIRollup (
	    Action int NULL,			-- 0 Insert, 1 Update, 2 Delete 
	    CompanyKey int null,		-- for Adv Billed Open loop
		ProjectKey int NULL ,
		Entity varchar(50) NULL,
		EntityKey int NULL,
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
		OpenOrderNet money NULL ,
		OpenOrderNetApproved money NULL ,
		OpenOrderGross money NULL ,
		OpenOrderGrossApproved money NULL ,
		OpenOrderUnbilled money NULL ,
		OrderPrebilled money NULL ,
		BilledAmount money NULL ,
		BilledAmountApproved money NULL ,
		BilledAmountNoTax money NULL ,
		AdvanceBilled money NULL ,
		AdvanceBilledOpen money NULL,
		EstQty decimal(24,4) NULL,
		EstNet money NULL,
		EstGross money NULL,
		EstCOQty decimal(24,4) NULL,
		EstCONet money NULL,
		EstCOGross money NULL,
		AdvanceBill int NULL
	) 
	
	CREATE CLUSTERED INDEX [IX_tProjectIRollup_Temp] ON #tProjectIRollup(ProjectKey, Entity, EntityKey)
	
	DECLARE @Labor INT,@MiscCost INT,@ExpReceipt INT,@Voucher INT,@OpenOrder INT,@Billing INT, @Estimate INT
			
	SELECT	@Labor = 0,@MiscCost = 0,@ExpReceipt = 0,@Voucher = 0,@OpenOrder = 0,@Billing = 0, @Estimate = 0
					
	IF @TranType = -1	-- All
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 1, @Estimate = 1
	ELSE IF @TranType = 1 -- Labor
		SELECT @Labor = 1
	ELSE IF @TranType = 2 -- MiscCost
		SELECT @MiscCost = 1
	ELSE IF @TranType = 3 -- ExpReceipt
		SELECT @ExpReceipt = 1
	ELSE IF @TranType = 4 -- Voucher
		SELECT @Voucher = 1
		      ,@OpenOrder = 1
	ELSE IF @TranType = 5 -- PO
		SELECT @Voucher = 1
			  ,@OpenOrder = 1
	ELSE IF @TranType = 6 -- Billing
		SELECT @Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 1
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 0,@Unbilled = 1
	ELSE IF @TranType = 7 -- ALL Unbilled
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 1,@Billing = 0
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 0,@Unbilled = 1
	ELSE IF @TranType = 8 -- ALL WriteOff
		SELECT	@Labor = 1,@MiscCost = 1,@ExpReceipt = 1,@Voucher = 1,@OpenOrder = 0,@Billing = 0
				,@BaseRollup = 0,@Approved = 0,@WriteOff = 1,@Unbilled = 0
	ELSE IF @TranType = 9 -- Estimates
		SELECT @Estimate = 1
		
	IF @SingleMode = 1	
	INSERT #tProjectIRollup (Action, ProjectKey, CompanyKey, Entity, EntityKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, MiscCostNet, MiscCostGross, MiscCostUnbilled, MiscCostWriteOff
		, ExpReceiptNet,ExpReceiptNetApproved, ExpReceiptGross, ExpReceiptGrossApproved, ExpReceiptUnbilled, ExpReceiptWriteOff
		, VoucherNet,VoucherNetApproved, VoucherGross, VoucherGrossApproved, VoucherOutsideCostsGross, VoucherOutsideCostsGrossApproved, VoucherUnbilled, VoucherWriteOff
		, OpenOrderNet, OpenOrderNetApproved, OpenOrderGross, OpenOrderGrossApproved, OpenOrderUnbilled, OrderPrebilled
		, BilledAmount ,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross)
	SELECT 1, ProjectKey, @CompanyKey, Entity, EntityKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, MiscCostNet, MiscCostGross, MiscCostUnbilled, MiscCostWriteOff
		, ExpReceiptNet,ExpReceiptNetApproved, ExpReceiptGross, ExpReceiptGrossApproved, ExpReceiptUnbilled, ExpReceiptWriteOff
		, VoucherNet,VoucherNetApproved, VoucherGross, VoucherGrossApproved, VoucherOutsideCostsGross, VoucherOutsideCostsGrossApproved, VoucherUnbilled, VoucherWriteOff
		, OpenOrderNet, OpenOrderNetApproved, OpenOrderGross, OpenOrderGrossApproved, OpenOrderUnbilled, OrderPrebilled
		, BilledAmount, BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross
	FROM  tProjectItemRollup (NOLOCK)
	WHERE ProjectKey = @ProjectKey
	
	ELSE
	
	INSERT #tProjectIRollup (Action, ProjectKey, CompanyKey, Entity, EntityKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, MiscCostNet, MiscCostGross, MiscCostUnbilled, MiscCostWriteOff
		, ExpReceiptNet,ExpReceiptNetApproved, ExpReceiptGross, ExpReceiptGrossApproved, ExpReceiptUnbilled, ExpReceiptWriteOff
		, VoucherNet,VoucherNetApproved, VoucherGross, VoucherGrossApproved, VoucherOutsideCostsGross, VoucherOutsideCostsGrossApproved, VoucherUnbilled, VoucherWriteOff
		, OpenOrderNet, OpenOrderNetApproved, OpenOrderGross, OpenOrderGrossApproved, OpenOrderUnbilled, OrderPrebilled
		, BilledAmount,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross)
	SELECT 1, b.ProjectKey, b.CompanyKey, Entity, EntityKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, MiscCostNet, MiscCostGross, MiscCostUnbilled, MiscCostWriteOff
		, ExpReceiptNet,ExpReceiptNetApproved, ExpReceiptGross, ExpReceiptGrossApproved, ExpReceiptUnbilled, ExpReceiptWriteOff
		, VoucherNet,VoucherNetApproved, VoucherGross, VoucherGrossApproved, VoucherOutsideCostsGross, VoucherOutsideCostsGrossApproved, VoucherUnbilled, VoucherWriteOff
		, OpenOrderNet, OpenOrderNetApproved, OpenOrderGross, OpenOrderGrossApproved, OpenOrderUnbilled, OrderPrebilled
		, BilledAmount,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross
	FROM  tProjectItemRollup (NOLOCK)
	INNER JOIN (SELECT ProjectKey, CompanyKey FROM #tProjectRollup) As b ON b.ProjectKey = tProjectItemRollup.ProjectKey

	IF @Labor = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, 'tService', isnull(ServiceKey, 0)
		FROM   tTime (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(ServiceKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, 'tService', isnull(ServiceKey, 0)
		FROM   tTime (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, isnull(ServiceKey, 0)
	END
	
	IF @MiscCost = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tMiscCost (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(ItemKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tMiscCost (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, isnull(ItemKey, 0)
	END
	
	IF @ExpReceipt = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tExpenseReceipt (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND   VoucherDetailKey IS NULL
		GROUP BY ProjectKey, isnull(ItemKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tExpenseReceipt (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		AND   VoucherDetailKey IS NULL
		GROUP BY ProjectKey, isnull(ItemKey, 0)
	END

	IF @Voucher = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tVoucherDetail (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(ItemKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tVoucherDetail (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, isnull(ItemKey, 0)
	END

	IF @OpenOrder = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(ItemKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, 'tItem', isnull(ItemKey, 0)
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, isnull(ItemKey, 0)
	END
	
	IF @Billing = 1
	BEGIN
		-- problem with fixed fee (Entity = null, EntityKey = null)
		-- take null Entity as tService
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, isnull(Entity, 'tService'), ISNULL(EntityKey, 0)
		FROM   tInvoiceSummary (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(Entity, 'tService'), isnull(EntityKey, 0)
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, isnull(Entity, 'tService'), ISNULL(EntityKey, 0)
		FROM   tInvoiceSummary (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, isnull(Entity, 'tService'), isnull(EntityKey, 0)
		                
		UPDATE #tEntity
		SET    #tEntity.AdvanceBill = 1
		FROM   tInvoiceSummary isum (NOLOCK)
		      ,tInvoice i (NOLOCK)
		WHERE  isum.InvoiceKey = i.InvoiceKey
		AND    #tEntity.ProjectKey = isum.ProjectKey
		AND    #tEntity.Entity = isnull(isum.Entity, 'tService') COLLATE DATABASE_DEFAULT  
		AND    #tEntity.EntityKey = isnull(isum.EntityKey, 0)
		                
	END
	
	IF @Estimate = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tEntity(Action, CompanyKey, ProjectKey,Entity,EntityKey)
		SELECT 0, @CompanyKey, ProjectKey, Entity, EntityKey
		FROM   tProjectEstByItem (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, Entity, EntityKey
		ELSE
		INSERT #tEntity(Action, ProjectKey,Entity,EntityKey)
		SELECT 0, ProjectKey, Entity, EntityKey
		FROM   tProjectEstByItem (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup)
		GROUP BY ProjectKey, Entity, EntityKey
	END
	
	IF @SingleMode = 0
		UPDATE #tEntity
		SET    #tEntity.CompanyKey = b.CompanyKey
		FROM   #tProjectRollup b
		WHERE  #tEntity.ProjectKey = b.ProjectKey 
	
--select * from #tEntity
	
	UPDATE #tEntity
	SET    #tEntity.Action = 1 -- indicates an update operation
	FROM   #tProjectIRollup  
	WHERE  #tProjectIRollup.ProjectKey = #tEntity.ProjectKey 
	AND    #tProjectIRollup.Entity = #tEntity.Entity COLLATE DATABASE_DEFAULT  
	AND    #tProjectIRollup.EntityKey = #tEntity.EntityKey
	
	INSERT #tProjectIRollup (Action, CompanyKey, ProjectKey, Entity, EntityKey) 
	SELECT 0, CompanyKey, ProjectKey, Entity, EntityKey
	FROM   #tEntity 
	WHERE Action = 0 -- indicates an insert operation
	GROUP BY CompanyKey, ProjectKey, Entity, EntityKey
	
	/*			
	UPDATE #tProjectIRollup
	SET    #tProjectIRollup.AdvanceBill = isnull(#tEntity.AdvanceBill, 0)
	FROM   #tEntity 
	WHERE  #tProjectIRollup.ProjectKey = #tEntity.ProjectKey 
	AND    #tProjectIRollup.Entity = #tEntity.Entity COLLATE DATABASE_DEFAULT  
	AND    #tProjectIRollup.EntityKey = #tEntity.EntityKey
	*/
	
	-- Mark the projects as having advance bill, regardless of entity and entitykey
	-- Set to 1 and not to isnull(#tEntity.AdvanceBill, 0)
	IF @Billing = 1
	UPDATE #tProjectIRollup
	SET    #tProjectIRollup.AdvanceBill = 1
	FROM   #tEntity 
	WHERE  #tProjectIRollup.ProjectKey = #tEntity.ProjectKey 
	AND    isnull(#tEntity.AdvanceBill, 0) = 1
	
--select * from #tProjectIRollup
--select count(*) from #tProjectIRollup
	
	DECLARE @UseTempLabor INT	SELECT @UseTempLabor = 0
	
	IF isnull(@ProjectKey, 0) > 0 And @Labor = 1 And @MiscCost = 0 And @ExpReceipt = 0 And @Voucher = 0 And @OpenOrder = 0 And @Billing = 0 And @Estimate = 0
		SELECT @UseTempLabor = 1
		
	IF @UseTempLabor = 1
	BEGIN
		CREATE TABLE #tTime (TimeKey uniqueidentifier null, ProjectKey int null, ServiceKey int null
		, ActualHours decimal(24,4) null, ActualRate money null, CostRate money null
		, BilledHours decimal(24,4) null, BilledRate money null
		, DateBilled datetime null, WriteOff int null, InvoiceLineKey int null, Status int null)
		
		-- use IX_tTime_9
		INSERT #tTime (TimeKey, ProjectKey, ServiceKey, ActualHours, ActualRate, CostRate
		 , BilledHours, BilledRate, DateBilled, WriteOff, InvoiceLineKey, Status)
		SELECT t.TimeKey, t.ProjectKey, t.ServiceKey, t.ActualHours, t.ActualRate, t.CostRate
		 , t.BilledHours, t.BilledRate, t.DateBilled, t.WriteOff, t.InvoiceLineKey, 1
		FROM tTime t with (index=IX_tTime_9,nolock)
		WHERE t.ProjectKey = @ProjectKey
		
		-- use PK_tTime + let SQL decide for timesheet status
		UPDATE #tTime
		SET    #tTime.Status = ts.Status
		FROM   tTime with (index=PK_tTime, nolock)
			  ,tTimeSheet ts (NOLOCK)  
		WHERE  #tTime.TimeKey = tTime.TimeKey
		AND    tTime.TimeSheetKey = ts.TimeSheetKey
		 
	END	
						 		   
	IF @Labor = 1
	BEGIN
	
		IF @BaseRollup = 1
		BEGIN
			-- need to cleanup all rows, part of the delete action
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.Hours = 0
				   ,#tProjectIRollup.HoursBilled = 0
				   ,#tProjectIRollup.HoursInvoiced = 0
				   ,#tProjectIRollup.LaborNet = 0
			       ,#tProjectIRollup.LaborGross= 0
			       ,#tProjectIRollup.LaborUnbilled = 0
		           ,#tProjectIRollup.LaborBilled = 0
				   ,#tProjectIRollup.LaborInvoiced = 0
			
			IF @UseTempLabor = 0	   
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.Hours =  
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 

					,#tProjectIRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectIRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)
					
			       ,#tProjectIRollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
						
					,#tProjectIRollup.LaborGross =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
				
					,#tProjectIRollup.LaborUnbilled =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NULL
					), 0)
					
					,#tProjectIRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectIRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)
			
				WHERE   #tProjectIRollup.Entity = 'tService'

				ELSE
				
				UPDATE #tProjectIRollup
				SET		#tProjectIRollup.Hours =  
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 

					,#tProjectIRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectIRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)
					
			       ,#tProjectIRollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
						
					,#tProjectIRollup.LaborGross =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
				
					,#tProjectIRollup.LaborUnbilled =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NULL
					), 0)
					
					,#tProjectIRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectIRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)
			
				WHERE   #tProjectIRollup.Entity = 'tService'
					
		 END
		
		 IF @Approved = 1
		 BEGIN   
			-- need to cleanup all rows, part of the delete action
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.HoursApproved = 0
			       ,#tProjectIRollup.LaborNetApproved = 0
			       ,#tProjectIRollup.LaborGrossApproved= 0
			
			IF @UseTempLabor = 0	   
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.HoursApproved = 
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   tTimeSheet.Status = 4
					), 0) 
				
					,#tProjectIRollup.LaborNetApproved = 
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   tTimeSheet.Status = 4
					), 0) 
						
					,#tProjectIRollup.LaborGrossApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   tTimeSheet.Status = 4
					), 0) 
			WHERE   #tProjectIRollup.Entity = 'tService'

			ELSE
			
					UPDATE #tProjectIRollup
					SET		#tProjectIRollup.HoursApproved = 
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   #tTime.Status = 4
					), 0) 
				
					,#tProjectIRollup.LaborNetApproved = 
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   #tTime.Status = 4
					), 0) 
						
					,#tProjectIRollup.LaborGrossApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM #tTime (NOLOCK) 
					WHERE #tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(#tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   #tTime.Status = 4
					), 0) 
			WHERE   #tProjectIRollup.Entity = 'tService'
						
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.LaborUnbilled = 0
					,#tProjectIRollup.LaborBilled = 0
					,#tProjectIRollup.LaborInvoiced = 0
					,#tProjectIRollup.HoursBilled = 0
					,#tProjectIRollup.HoursInvoiced = 0
			
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND DateBilled IS NULL
					), 0)

					,#tProjectIRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectIRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)

					,#tProjectIRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectIRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND   InvoiceLineKey > 0
					), 0)

			WHERE   #tProjectIRollup.Entity = 'tService'
							 
		END	 
		
		IF @WriteOff = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.LaborWriteOff = 0
			
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.LaborWriteOff =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectIRollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #tProjectIRollup.EntityKey
					AND WriteOff = 1), 0)
			WHERE   #tProjectIRollup.Entity = 'tService'
							 
		END	
		
	END
	
	IF @MiscCost = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.MiscCostNet = 0
                   ,#tProjectIRollup.MiscCostGross = 0
                   ,#tProjectIRollup.MiscCostUnbilled= 0
                   ,#tProjectIRollup.MiscCostBilled= 0
                   ,#tProjectIRollup.MiscCostInvoiced= 0

			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.MiscCostNet =
					ISNULL((SELECT SUM(TotalCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
					
					,#tProjectIRollup.MiscCostGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
					
					,#tProjectIRollup.MiscCostUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NULL
					), 0) 
					
					,#tProjectIRollup.MiscCostBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)
					
					,#tProjectIRollup.MiscCostInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And InvoiceLineKey > 0
					), 0)
					
			WHERE	#tProjectIRollup.Entity = 'tItem'
		 END

		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.MiscCostUnbilled= 0
                   ,#tProjectIRollup.MiscCostBilled= 0
                   ,#tProjectIRollup.MiscCostInvoiced= 0

			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.MiscCostUnbilled =
					ISNULL((
					SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NULL
					), 0) 

					,#tProjectIRollup.MiscCostBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)
					
					,#tProjectIRollup.MiscCostInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And InvoiceLineKey > 0
					), 0)

			WHERE	#tProjectIRollup.Entity = 'tItem'
			
		END
		
		IF @WriteOff = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.MiscCostWriteOff= 0
			
			UPDATE #tProjectIRollup
			SET		#tProjectIRollup.MiscCostWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And WriteOff = 1), 0) 
			WHERE	#tProjectIRollup.Entity = 'tItem'
		END

	END

	IF @ExpReceipt = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptNet= 0
                  ,#tProjectIRollup.ExpReceiptGross= 0
                  ,#tProjectIRollup.ExpReceiptUnbilled = 0
                  ,#tProjectIRollup.ExpReceiptBilled = 0
                  ,#tProjectIRollup.ExpReceiptInvoiced = 0
                  
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptNet =
					--ISNULL((SELECT SUM(ActualCost) 
					ISNULL((SELECT SUM(PTotalCost)  -- change for MC 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					AND   VoucherDetailKey IS NULL), 0) 
						
				   ,#tProjectIRollup.ExpReceiptGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					AND   VoucherDetailKey IS NULL), 0) 
					
					,#tProjectIRollup.ExpReceiptUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And   DateBilled IS NULL
					AND   VoucherDetailKey IS NULL), 0)
			
			       ,#tProjectIRollup.ExpReceiptBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And   DateBilled IS NOT NULL
					And   WriteOff = 0
					AND   VoucherDetailKey IS NULL), 0)
					
					,#tProjectIRollup.ExpReceiptInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And   InvoiceLineKey > 0
					AND   VoucherDetailKey IS NULL), 0)
					
			WHERE	#tProjectIRollup.Entity = 'tItem'
					
		 END
	
		IF @Approved = 1
		 BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptNetApproved= 0
                  ,#tProjectIRollup.ExpReceiptGrossApproved= 0
               
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptNetApproved =
					--ISNULL((SELECT SUM(ActualCost)
					ISNULL((SELECT SUM(PTotalCost) -- change for MC 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tExpenseReceipt.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
						
					,#tProjectIRollup.ExpReceiptGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tExpenseReceipt.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
			
			WHERE	#tProjectIRollup.Entity = 'tItem'
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptUnbilled= 0
                  ,#tProjectIRollup.ExpReceiptBilled= 0
                  ,#tProjectIRollup.ExpReceiptInvoiced= 0
  
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptUnbilled =
					ISNULL((SELECT SUM(BillableCost)  
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tExpenseReceipt.ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NULL
					AND   VoucherDetailKey IS NULL), 0) 

			       ,#tProjectIRollup.ExpReceiptBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And   DateBilled IS NOT NULL
					And   WriteOff = 0
					AND   VoucherDetailKey IS NULL), 0)
					
					,#tProjectIRollup.ExpReceiptInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(ItemKey, 0) = #tProjectIRollup.EntityKey
					And   InvoiceLineKey > 0
					AND   VoucherDetailKey IS NULL), 0)
			
			WHERE	#tProjectIRollup.Entity = 'tItem'
					
		END
		
		IF @WriteOff = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptWriteOff= 0
		
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.ExpReceiptWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tExpenseReceipt.ItemKey, 0) = #tProjectIRollup.EntityKey
					And WriteOff = 1
					AND   VoucherDetailKey IS NULL), 0) 
			
			WHERE	#tProjectIRollup.Entity = 'tItem'

		END

	END

	IF @Voucher = 1
	BEGIN
		IF @BaseRollup = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherNet= 0
                  ,#tProjectIRollup.VoucherGross= 0
                  ,#tProjectIRollup.VoucherUnbilled= 0
                  ,#tProjectIRollup.VoucherBilled= 0
                  ,#tProjectIRollup.VoucherInvoiced= 0
                    
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherNet =
					--ISNULL((SELECT SUM(TotalCost)
					ISNULL((SELECT SUM(PTotalCost) -- change for MC 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
						
					,#tProjectIRollup.VoucherGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					), 0) 
					
					,#tProjectIRollup.VoucherUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NULL
					), 0)
					
					,#tProjectIRollup.VoucherBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)

                    ,#tProjectIRollup.VoucherInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And InvoiceLineKey >  0
					), 0)
					
			WHERE	#tProjectIRollup.Entity = 'tItem'
					
		 END
	
		IF @Approved = 1
		 BEGIN   
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherNetApproved= 0
                  ,#tProjectIRollup.VoucherGrossApproved= 0
            
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherNetApproved =
					--ISNULL((SELECT SUM(TotalCost)
					ISNULL((SELECT SUM(PTotalCost) --change for MC 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND tVoucher.Status = 4), 0) 
						
					,#tProjectIRollup.VoucherGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND   tVoucher.Status = 4), 0) 

			WHERE	#tProjectIRollup.Entity = 'tItem'
					
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherUnbilled= 0
                   ,#tProjectIRollup.VoucherBilled= 0
				   ,#tProjectIRollup.VoucherInvoiced= 0
								
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NULL
					), 0) 

                    ,#tProjectIRollup.VoucherBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)

                    ,#tProjectIRollup.VoucherInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And InvoiceLineKey >  0
					), 0)
					
			WHERE	#tProjectIRollup.Entity = 'tItem'
			
		END
		
		IF @WriteOff = 1
		BEGIN
			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherWriteOff= 0

			UPDATE #tProjectIRollup
			SET	   #tProjectIRollup.VoucherWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE tVoucherDetail.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(tVoucherDetail.ItemKey, 0) = #tProjectIRollup.EntityKey
					And WriteOff = 1), 0) 
			
			WHERE	#tProjectIRollup.Entity = 'tItem'
			
		END
		
		
		-- Outside Costs Gross
		 
		--1) The amount billed of all pre-billed orders
		--2) The amount billed of all billed vouchers
		--3) The gross amount of unbilled vouchers not tied to an order 
		--4) The gross amount of unbilled vouchers tied to an order line from a non pre-billed order
		
		--Note: In tProjectRollup 1 is calculated as OrderPrebilled, 2+3+4 as VoucherOutsideCostsGross
		

		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.VoucherOutsideCostsGross= 0
              ,#tProjectIRollup.VoucherOutsideCostsGrossApproved= 0
              
		--The amount billed of all pre-billed orders (ADD LATER IN REPORT)

		-- + The amount billed of all billed vouchers
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.VoucherOutsideCostsGross= ISNULL((
									SELECT SUM(vd.AmountBilled) 
									FROM tVoucherDetail vd (NOLOCK)
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									), 0)


		-- + The gross amount of unbilled vouchers not tied to an order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									AND   vd.PurchaseOrderDetailKey IS NULL
									), 0)
		-- + The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									--AND   pod.Closed = 1
									--AND   pod.DateBilled IS NULL  -- removed for (93504)
									), 0)

		-- I added the unbilled vouchers tied to a prebilled PO (93504)
		/*
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									AND   pod.DateBilled IS NOT NULL 
									), 0)
		*/

		--The amount billed of all pre-billed orders (ADD LATER IN REPORT)
			WHERE	#tProjectIRollup.Entity = 'tItem'
		
		-- + The amount billed of all billed vouchers
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.VoucherOutsideCostsGrossApproved= ISNULL((
									SELECT SUM(vd.AmountBilled) 
									FROM tVoucherDetail vd (NOLOCK)
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									), 0)
		
		-- + The gross amount of unbilled vouchers not tied to an order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									AND   v.Status = 4
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									AND   vd.PurchaseOrderDetailKey IS NULL
									), 0)
		-- + The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									WHERE vd.ProjectKey = #tProjectIRollup.ProjectKey
									AND   ISNULL(vd.ItemKey, 0) = #tProjectIRollup.EntityKey
									AND   v.Status = 4
									AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
									--AND   pod.Closed = 1
									--AND   pod.DateBilled IS NULL  -- 233784 and 233644 (make it consistent with OutsideCostsGross)
									), 0)

		-- + The gross of any non pre-billed open orders that are open. (ADD LATER IN REPORT)
								--+ @OpenOrderGross
			WHERE	#tProjectIRollup.Entity = 'tItem'
		
		
	END


	IF @OpenOrder = 1
	BEGIN
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.OpenOrderNet = 0
		      ,#tProjectIRollup.OpenOrderNetApproved = 0
		      ,#tProjectIRollup.OpenOrderGross = 0
		      ,#tProjectIRollup.OpenOrderGrossApproved = 0
		      ,#tProjectIRollup.OrderPrebilled = 0
				
		UPDATE #tProjectIRollup
		SET			#tProjectIRollup.OpenOrderNet =
					--ISNULL((SELECT SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0) )
					ISNULL((SELECT SUM(pod.PTotalCost - ISNULL(pod.PAppliedCost, 0) ) -- change for MC
					FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
					AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND     po.Status = 4), 0)
	
					,#tProjectIRollup.OpenOrderNetApproved =
					--ISNULL((SELECT SUM(pod.TotalCost)
					ISNULL((SELECT SUM(pod.PTotalCost) -- change for MC
					FROM	tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
					AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND     po.Status = 4), 0)
					- 
					--ISNULL((SELECT SUM(vd.TotalCost)
					ISNULL((SELECT SUM(vd.PTotalCost) -- change for MC
					FROM	tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						INNER JOIN tVoucherDetail vd (NOLOCK) ON pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
						INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
					AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND     po.Status = 4
					AND     v.Status = 4), 0)
					
					,#tProjectIRollup.OpenOrderGross = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8) ) / cast(TotalCost as Decimal(24,8)))	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
								END AS NewBillableCost
								,pod.PTotalCost as TotalCost
								,pod.PAppliedCost as AppliedCost
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
						AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
						--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
						) AS OpenOrders			
						
					),0)
						
					,#tProjectIRollup.OpenOrderGrossApproved = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8)))	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
								END AS NewBillableCost
								,pod.PTotalCost as TotalCost
								,pod.PAppliedCost as AppliedCost 
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND     po.Status = 4
						AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
						AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
						--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
						) AS OpenOrders			
						
					),0)
					
					,#tProjectIRollup.OpenOrderUnbilled = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8)))	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
								END AS NewBillableCost
								,pod.PTotalCost as TotalCost
 								,pod.PAppliedCost as AppliedCost
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND		pod.ProjectKey = #tProjectIRollup.ProjectKey
						AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
						AND     pod.DateBilled is null  -- Non Prebilled 
						) AS OpenOrders			
						
					),0)
		
					,#tProjectIRollup.OrderPrebilled =
					ISNULL((SELECT SUM(pod.AmountBilled)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
					WHERE	pod.ProjectKey = #tProjectIRollup.ProjectKey
					AND     ISNULL(pod.ItemKey, 0) = #tProjectIRollup.EntityKey
					AND     ISNULL(pod.InvoiceLineKey, 0) > 0), 0)
							
			WHERE	#tProjectIRollup.Entity = 'tItem'

	END
		
	IF @Billing = 1
	BEGIN
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.BilledAmount = 0
		      ,#tProjectIRollup.BilledAmountApproved = 0
		      ,#tProjectIRollup.BilledAmountNoTax = 0
		      ,#tProjectIRollup.AdvanceBilled = 0
		      ,#tProjectIRollup.AdvanceBilledOpen = 0
		      
		      
		UPDATE #tProjectIRollup
		SET			#tProjectIRollup.BilledAmount = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(isum.Entity, 'tService') = #tProjectIRollup.Entity COLLATE DATABASE_DEFAULT
					AND   ISNULL(isum.EntityKey, 0) = #tProjectIRollup.EntityKey
					),0)
					
					,#tProjectIRollup.BilledAmountApproved = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and   i.InvoiceStatus = 4
					and isum.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(isum.Entity, 'tService') = #tProjectIRollup.Entity COLLATE DATABASE_DEFAULT
					AND   ISNULL(isum.EntityKey, 0) = #tProjectIRollup.EntityKey
					),0)
					
					,#tProjectIRollup.BilledAmountNoTax = 
					ISNULL((SELECT SUM(isum.Amount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(isum.Entity, 'tService') = #tProjectIRollup.Entity COLLATE DATABASE_DEFAULT
					AND   ISNULL(isum.EntityKey, 0) = #tProjectIRollup.EntityKey
					),0)
					
					,#tProjectIRollup.AdvanceBilled = 
					ISNULL((SELECT SUM(isum.Amount  + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 1 
					and isum.ProjectKey = #tProjectIRollup.ProjectKey
					AND   ISNULL(isum.Entity, 'tService') = #tProjectIRollup.Entity COLLATE DATABASE_DEFAULT
					AND   ISNULL(isum.EntityKey, 0) = #tProjectIRollup.EntityKey
					),0)
			
	END					
				
	DECLARE @AdvanceBilledOpen MONEY
	DECLARE @Entity VARCHAR(50)
	DECLARE @EntityKey INT
	DECLARE @CurrProjectKey INT
		
IF @Billing = 1
BEGIN	
	SELECT @CurrProjectKey = -1		
	
	WHILE (1=1)
	BEGIN
		SELECT @CurrProjectKey = MIN(ProjectKey)
		FROM   #tProjectIRollup 
		WHERE  ProjectKey > @CurrProjectKey
		AND    ISNULL(AdvanceBill, 0) = 1

		IF @CurrProjectKey IS NULL
			BREAK

		SELECT @CompanyKey = CompanyKey
		FROM   #tProjectIRollup 
		WHERE  ProjectKey = @CurrProjectKey
			
		SELECT @Entity = ''
		WHILE (1=1)
		BEGIN
			SELECT @Entity = MIN(Entity)
			FROM   #tProjectIRollup 
			WHERE  Entity > @Entity
			AND    ISNULL(AdvanceBill, 0) = 1
			AND    ProjectKey = @CurrProjectKey
				
			IF @Entity IS NULL
				BREAK
					
			SELECT @EntityKey = -1
			WHILE (1=1)
			BEGIN
			
				SELECT @EntityKey = MIN(EntityKey)
				FROM   #tProjectIRollup 
				WHERE  EntityKey > @EntityKey
				AND    Entity = @Entity 
				AND    ISNULL(AdvanceBill, 0) = 1
			    AND    ProjectKey = @CurrProjectKey
			
				IF @EntityKey IS NULL
					BREAK
						
				SELECT @AdvanceBilledOpen =
				ISNULL(
					--(SELECT SUM(adv.LineAmount - (adv.LineAmount / adv.InvoiceTotalAmount) * adv.AmountApplied)
					--(SELECT SUM(adv.LineAmount * (1 - adv.AmountApplied / adv.InvoiceTotalAmount)) -- creates rounding errors
					(SELECT SUM(adv.LineAmount - (adv.LineAmount * adv.AmountApplied) / adv.InvoiceTotalAmount)
					FROM (
						SELECT ISNULL(i.InvoiceTotalAmount, 0)		AS InvoiceTotalAmount
							,ISNULL(inv.LineAmount, 0)				AS LineAmount
							,ISNULL((SELECT SUM(iab.Amount)
								FROM tInvoiceAdvanceBill iab (NOLOCK)
								WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
							, 0)									AS AmountApplied 	
						FROM tInvoice i (NOLOCK)
						INNER JOIN	-- we need unique Adv Bill invoices with line for the project
							(SELECT isum.InvoiceKey
							, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
							FROM  tInvoiceSummary isum (NOLOCK)
								INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
							WHERE isum.ProjectKey = @CurrProjectKey
							AND   isnull(isum.Entity, 'tService') = @Entity
							AND   isnull(isum.EntityKey, 0) = @EntityKey
							AND   i2.CompanyKey = @CompanyKey
							AND   i2.AdvanceBill = 1
							GROUP BY isum.InvoiceKey 
							) AS inv ON i.InvoiceKey = inv.InvoiceKey
						WHERE i.CompanyKey = @CompanyKey
						AND   i.AdvanceBill = 1
						AND   i.InvoiceTotalAmount <> 0		-- Protection against division by 0 
						) AS adv
					)
				,0)

				
				SELECT @AdvanceBilledOpen = ROUND(@AdvanceBilledOpen, 2)

				--select @ProjectKey, @Entity, @EntityKey, @AdvanceBilledOpen
			
				UPDATE #tProjectIRollup SET AdvanceBilledOpen = @AdvanceBilledOpen
				WHERE ProjectKey = @CurrProjectKey AND Entity = @Entity AND EntityKey = @EntityKey
				
			END -- EntityKey loop
			
		END -- Entity loop
	
	END -- ProjectKey loop
			
END	-- Billing=1	

				
	IF @Estimate = 1
	BEGIN
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.EstQty= 0, #tProjectIRollup.EstNet= 0, #tProjectIRollup.EstGross= 0
              ,#tProjectIRollup.EstCOQty= 0, #tProjectIRollup.EstCONet= 0, #tProjectIRollup.EstCOGross= 0
              
              
		UPDATE #tProjectIRollup
		SET	   #tProjectIRollup.EstQty= est.Qty, #tProjectIRollup.EstNet= est.Net, #tProjectIRollup.EstGross= est.Gross
              ,#tProjectIRollup.EstCOQty= est.COQty, #tProjectIRollup.EstCONet= est.CONet, #tProjectIRollup.EstCOGross= est.COGross
        FROM   tProjectEstByItem est (NOLOCK)
        WHERE  #tProjectIRollup.ProjectKey = est.ProjectKey
        AND    #tProjectIRollup.Entity = est.Entity COLLATE DATABASE_DEFAULT
        AND    #tProjectIRollup.EntityKey = est.EntityKey
        
	END
	
	
	UPDATE #tProjectIRollup
		SET #tProjectIRollup.Hours = ISNULL(#tProjectIRollup.Hours, 0)
		    ,#tProjectIRollup.HoursApproved = ISNULL(#tProjectIRollup.HoursApproved, 0)
			,#tProjectIRollup.HoursBilled = ISNULL(#tProjectIRollup.HoursBilled, 0)
			,#tProjectIRollup.HoursInvoiced = ISNULL(#tProjectIRollup.HoursInvoiced, 0)
			,#tProjectIRollup.LaborNet = ISNULL(#tProjectIRollup.LaborNet, 0)
			,#tProjectIRollup.LaborNetApproved = ISNULL(#tProjectIRollup.LaborNetApproved, 0)
			,#tProjectIRollup.LaborGross = ISNULL(#tProjectIRollup.LaborGross, 0)
			,#tProjectIRollup.LaborGrossApproved = ISNULL(#tProjectIRollup.LaborGrossApproved, 0)
			,#tProjectIRollup.LaborUnbilled = ISNULL(#tProjectIRollup.LaborUnbilled, 0)
			,#tProjectIRollup.LaborWriteOff = ISNULL(#tProjectIRollup.LaborWriteOff, 0)
			,#tProjectIRollup.LaborBilled = ISNULL(#tProjectIRollup.LaborBilled, 0)
			,#tProjectIRollup.LaborInvoiced = ISNULL(#tProjectIRollup.LaborInvoiced, 0)
			
			,#tProjectIRollup.MiscCostNet = ISNULL(#tProjectIRollup.MiscCostNet, 0)
			,#tProjectIRollup.MiscCostGross = ISNULL(#tProjectIRollup.MiscCostGross, 0)
			,#tProjectIRollup.MiscCostUnbilled = ISNULL(#tProjectIRollup.MiscCostUnbilled, 0)
			,#tProjectIRollup.MiscCostWriteOff = ISNULL(#tProjectIRollup.MiscCostWriteOff, 0)
			,#tProjectIRollup.MiscCostBilled = ISNULL(#tProjectIRollup.MiscCostBilled, 0)
			,#tProjectIRollup.MiscCostInvoiced = ISNULL(#tProjectIRollup.MiscCostInvoiced, 0)
			
			,#tProjectIRollup.ExpReceiptNet = ISNULL(#tProjectIRollup.ExpReceiptNet, 0)
			,#tProjectIRollup.ExpReceiptNetApproved = ISNULL(#tProjectIRollup.ExpReceiptNetApproved, 0)
			,#tProjectIRollup.ExpReceiptGross = ISNULL(#tProjectIRollup.ExpReceiptGross, 0)
			,#tProjectIRollup.ExpReceiptGrossApproved = ISNULL(#tProjectIRollup.ExpReceiptGrossApproved, 0)
			,#tProjectIRollup.ExpReceiptUnbilled =  ISNULL(#tProjectIRollup.ExpReceiptUnbilled, 0)
			,#tProjectIRollup.ExpReceiptWriteOff =  ISNULL(#tProjectIRollup.ExpReceiptWriteOff, 0)
			,#tProjectIRollup.ExpReceiptBilled =  ISNULL(#tProjectIRollup.ExpReceiptBilled, 0)
			,#tProjectIRollup.ExpReceiptInvoiced =  ISNULL(#tProjectIRollup.ExpReceiptInvoiced, 0)
					
			,#tProjectIRollup.VoucherNet = ISNULL(#tProjectIRollup.VoucherNet, 0)
			,#tProjectIRollup.VoucherNetApproved = ISNULL(#tProjectIRollup.VoucherNetApproved, 0)
			,#tProjectIRollup.VoucherGross = ISNULL(#tProjectIRollup.VoucherGross, 0)
			,#tProjectIRollup.VoucherGrossApproved = ISNULL(#tProjectIRollup.VoucherGrossApproved, 0)
			,#tProjectIRollup.VoucherOutsideCostsGross = ISNULL(#tProjectIRollup.VoucherOutsideCostsGross, 0)
			,#tProjectIRollup.VoucherOutsideCostsGrossApproved = ISNULL(#tProjectIRollup.VoucherOutsideCostsGrossApproved, 0)
			,#tProjectIRollup.VoucherUnbilled = ISNULL(#tProjectIRollup.VoucherUnbilled, 0)
			,#tProjectIRollup.VoucherWriteOff = ISNULL(#tProjectIRollup.VoucherWriteOff, 0)		
			,#tProjectIRollup.VoucherBilled = ISNULL(#tProjectIRollup.VoucherBilled, 0)
			,#tProjectIRollup.VoucherInvoiced = ISNULL(#tProjectIRollup.VoucherInvoiced, 0)
							
			,#tProjectIRollup.OpenOrderNet = ISNULL(#tProjectIRollup.OpenOrderNet, 0)
			,#tProjectIRollup.OpenOrderNetApproved = ISNULL(#tProjectIRollup.OpenOrderNetApproved, 0)
			,#tProjectIRollup.OpenOrderGross = ISNULL(#tProjectIRollup.OpenOrderGross, 0)
			,#tProjectIRollup.OpenOrderGrossApproved = ISNULL(#tProjectIRollup.OpenOrderGrossApproved, 0)
			,#tProjectIRollup.OpenOrderUnbilled = ISNULL(#tProjectIRollup.OpenOrderUnbilled, 0)
			,#tProjectIRollup.OrderPrebilled = ISNULL(#tProjectIRollup.OrderPrebilled, 0)
			
			,#tProjectIRollup.BilledAmount = ISNULL(#tProjectIRollup.BilledAmount, 0)
			,#tProjectIRollup.BilledAmountApproved = ISNULL(#tProjectIRollup.BilledAmountApproved, 0)
			,#tProjectIRollup.BilledAmountNoTax = ISNULL(#tProjectIRollup.BilledAmountNoTax, 0)
			,#tProjectIRollup.AdvanceBilled = ISNULL(#tProjectIRollup.AdvanceBilled, 0)
			,#tProjectIRollup.AdvanceBilledOpen = ISNULL(#tProjectIRollup.AdvanceBilledOpen, 0)
			
			,#tProjectIRollup.EstQty = ISNULL(#tProjectIRollup.EstQty, 0)
			,#tProjectIRollup.EstNet = ISNULL(#tProjectIRollup.EstNet, 0)
			,#tProjectIRollup.EstGross = ISNULL(#tProjectIRollup.EstGross, 0)
			,#tProjectIRollup.EstCOQty = ISNULL(#tProjectIRollup.EstCOQty, 0)
			,#tProjectIRollup.EstCONet = ISNULL(#tProjectIRollup.EstCONet, 0)
			,#tProjectIRollup.EstCOGross = ISNULL(#tProjectIRollup.EstCOGross, 0)
	FROM    #tProjectIRollup		
	
	UPDATE #tProjectIRollup
	SET    Action = 2 -- Delete
	WHERE  Hours=0 AND HoursApproved=0 AND HoursBilled=0 AND HoursInvoiced=0 AND LaborNet=0 AND LaborNetApproved=0 AND LaborGross=0 AND LaborGrossApproved=0 AND LaborUnbilled=0 AND LaborBilled=0 AND LaborInvoiced=0 AND LaborWriteOff=0  
	AND MiscCostNet=0 AND MiscCostGross=0 AND MiscCostUnbilled=0 AND MiscCostBilled=0 AND MiscCostInvoiced=0 AND MiscCostWriteOff=0
	AND ExpReceiptNet=0 AND ExpReceiptNetApproved=0 AND ExpReceiptGross=0 AND ExpReceiptGrossApproved=0 AND ExpReceiptUnbilled=0 AND ExpReceiptBilled=0 AND ExpReceiptInvoiced=0 AND ExpReceiptWriteOff=0
	AND	VoucherNet=0 AND VoucherNetApproved=0 AND VoucherGross=0 AND VoucherGrossApproved=0 AND VoucherOutsideCostsGross=0 AND VoucherOutsideCostsGrossApproved=0 AND VoucherUnbilled=0 AND VoucherBilled=0 AND VoucherInvoiced=0 AND VoucherWriteOff=0
	AND OpenOrderNet=0 AND OpenOrderNetApproved=0 AND OpenOrderGross=0 AND OpenOrderUnbilled=0 AND OpenOrderGrossApproved=0 AND OrderPrebilled=0
	AND BilledAmount=0 AND BilledAmountApproved=0 AND BilledAmountNoTax=0 AND AdvanceBilled=0 AND AdvanceBilledOpen = 0
	AND EstQty=0 AND EstNet=0 AND EstGross=0 AND EstCOQty=0 AND EstCONet=0 AND EstCOGross=0


	IF @SingleMode = 1
	BEGIN
		DELETE  tProjectItemRollup
		FROM    #tProjectIRollup b
		WHERE   tProjectItemRollup.ProjectKey =@ProjectKey
		AND     tProjectItemRollup.Entity = b.Entity COLLATE DATABASE_DEFAULT
		AND     tProjectItemRollup.EntityKey = b.EntityKey
		AND     b.Action = 2
		
	END
	ELSE
	BEGIN
		DELETE  tProjectItemRollup
		FROM    #tProjectIRollup b
		WHERE   tProjectItemRollup.ProjectKey =b.ProjectKey
		AND     tProjectItemRollup.Entity = b.Entity COLLATE DATABASE_DEFAULT
		AND     tProjectItemRollup.EntityKey = b.EntityKey
		AND     b.Action = 2
	END

	DELETE #tProjectIRollup WHERE Action = 2
	
	-- safer to retest again if we need to update or insert
	UPDATE #tProjectIRollup SET Action = 0
	
	UPDATE #tProjectIRollup SET Action =  1
	FROM   tProjectItemRollup b (NOLOCK)
	WHERE  #tProjectIRollup.ProjectKey = b.ProjectKey 
	AND    #tProjectIRollup.Entity = b.Entity COLLATE DATABASE_DEFAULT
	AND    #tProjectIRollup.EntityKey = b.EntityKey 
		
	INSERT tProjectItemRollup (ProjectKey, Entity, EntityKey)
	SELECT ProjectKey, Entity, EntityKey
	FROM   #tProjectIRollup WHERE Action = 0

	UPDATE tProjectItemRollup
		SET tProjectItemRollup.Hours = #tProjectIRollup.Hours
		    ,tProjectItemRollup.HoursApproved = #tProjectIRollup.HoursApproved
			,tProjectItemRollup.HoursBilled = #tProjectIRollup.HoursBilled
			,tProjectItemRollup.HoursInvoiced = #tProjectIRollup.HoursInvoiced
			,tProjectItemRollup.LaborNet = #tProjectIRollup.LaborNet
			,tProjectItemRollup.LaborNetApproved = #tProjectIRollup.LaborNetApproved
			,tProjectItemRollup.LaborGross = #tProjectIRollup.LaborGross
			,tProjectItemRollup.LaborGrossApproved = #tProjectIRollup.LaborGrossApproved
			,tProjectItemRollup.LaborUnbilled = #tProjectIRollup.LaborUnbilled
			,tProjectItemRollup.LaborWriteOff = #tProjectIRollup.LaborWriteOff
			,tProjectItemRollup.LaborBilled = #tProjectIRollup.LaborBilled
			,tProjectItemRollup.LaborInvoiced = #tProjectIRollup.LaborInvoiced
			
			,tProjectItemRollup.MiscCostNet = #tProjectIRollup.MiscCostNet
			,tProjectItemRollup.MiscCostGross = #tProjectIRollup.MiscCostGross
			,tProjectItemRollup.MiscCostUnbilled = #tProjectIRollup.MiscCostUnbilled
			,tProjectItemRollup.MiscCostWriteOff = #tProjectIRollup.MiscCostWriteOff
			,tProjectItemRollup.MiscCostBilled = #tProjectIRollup.MiscCostBilled
			,tProjectItemRollup.MiscCostInvoiced = #tProjectIRollup.MiscCostInvoiced
			
			,tProjectItemRollup.ExpReceiptNet = #tProjectIRollup.ExpReceiptNet
			,tProjectItemRollup.ExpReceiptNetApproved = #tProjectIRollup.ExpReceiptNetApproved
			,tProjectItemRollup.ExpReceiptGross = #tProjectIRollup.ExpReceiptGross
			,tProjectItemRollup.ExpReceiptGrossApproved = #tProjectIRollup.ExpReceiptGrossApproved
			,tProjectItemRollup.ExpReceiptUnbilled = #tProjectIRollup.ExpReceiptUnbilled
			,tProjectItemRollup.ExpReceiptWriteOff = #tProjectIRollup.ExpReceiptWriteOff
			,tProjectItemRollup.ExpReceiptBilled = #tProjectIRollup.ExpReceiptBilled
			,tProjectItemRollup.ExpReceiptInvoiced = #tProjectIRollup.ExpReceiptInvoiced
					
			,tProjectItemRollup.VoucherNet = #tProjectIRollup.VoucherNet
			,tProjectItemRollup.VoucherNetApproved = #tProjectIRollup.VoucherNetApproved
			,tProjectItemRollup.VoucherGross = #tProjectIRollup.VoucherGross
			,tProjectItemRollup.VoucherGrossApproved = #tProjectIRollup.VoucherGrossApproved
			,tProjectItemRollup.VoucherOutsideCostsGross = #tProjectIRollup.VoucherOutsideCostsGross
			,tProjectItemRollup.VoucherOutsideCostsGrossApproved = #tProjectIRollup.VoucherOutsideCostsGrossApproved
			,tProjectItemRollup.VoucherUnbilled = #tProjectIRollup.VoucherUnbilled
			,tProjectItemRollup.VoucherWriteOff = #tProjectIRollup.VoucherWriteOff		
			,tProjectItemRollup.VoucherBilled = #tProjectIRollup.VoucherBilled
			,tProjectItemRollup.VoucherInvoiced = #tProjectIRollup.VoucherInvoiced
							
			,tProjectItemRollup.OpenOrderNet = #tProjectIRollup.OpenOrderNet
			,tProjectItemRollup.OpenOrderNetApproved = #tProjectIRollup.OpenOrderNetApproved
			,tProjectItemRollup.OpenOrderGross = #tProjectIRollup.OpenOrderGross
			,tProjectItemRollup.OpenOrderUnbilled = #tProjectIRollup.OpenOrderUnbilled
			,tProjectItemRollup.OpenOrderGrossApproved = #tProjectIRollup.OpenOrderGrossApproved
			,tProjectItemRollup.OrderPrebilled = #tProjectIRollup.OrderPrebilled
			
			,tProjectItemRollup.BilledAmount = #tProjectIRollup.BilledAmount
			,tProjectItemRollup.BilledAmountApproved = #tProjectIRollup.BilledAmountApproved
			,tProjectItemRollup.BilledAmountNoTax = #tProjectIRollup.BilledAmountNoTax
			,tProjectItemRollup.AdvanceBilled = #tProjectIRollup.AdvanceBilled
			,tProjectItemRollup.AdvanceBilledOpen = #tProjectIRollup.AdvanceBilledOpen
			
			,tProjectItemRollup.EstQty = #tProjectIRollup.EstQty
			,tProjectItemRollup.EstNet = #tProjectIRollup.EstNet
			,tProjectItemRollup.EstGross = #tProjectIRollup.EstGross
			,tProjectItemRollup.EstCOQty = #tProjectIRollup.EstCOQty
			,tProjectItemRollup.EstCONet = #tProjectIRollup.EstCONet
			,tProjectItemRollup.EstCOGross = #tProjectIRollup.EstCOGross
			
			,tProjectItemRollup.UpdateStarted = @UpdateStarted
			,tProjectItemRollup.UpdateEnded = GETDATE()
	FROM    #tProjectIRollup		
	WHERE   tProjectItemRollup.ProjectKey = #tProjectIRollup.ProjectKey
	AND     tProjectItemRollup.Entity = #tProjectIRollup.Entity COLLATE DATABASE_DEFAULT
	AND     tProjectItemRollup.EntityKey = #tProjectIRollup.EntityKey
		

	-- And finally do the rollup for the titles
	exec sptProjectTitleRollupUpdate @ProjectKey, @SingleMode, @TranType,@BaseRollup ,@Approved ,@Unbilled ,@WriteOff ,@CompanyKey 
	
    -- testing only
    /*
	select  ProjectKey
			,Hours,(select SUM(Hours) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as Hours2  
		    ,HoursApproved,(select SUM(HoursApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as HoursApproved2 
			,LaborNet,(select SUM(LaborNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborNet2 
			,LaborNetApproved ,(select SUM(LaborNetApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborNetApproved2
			,LaborGross,(select SUM(LaborGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborGross2 
			,LaborGrossApproved,(select SUM(LaborGrossApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborGrossApproved2 
			,LaborUnbilled,(select SUM(LaborUnbilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborUnbilled2 
			,LaborWriteOff,(select SUM(LaborWriteOff) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborWriteOff2 
			
			,MiscCostNet,(select SUM(MiscCostNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostNet2 
			,MiscCostGross,(select SUM(MiscCostGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostGross2 
			,MiscCostUnbilled,(select SUM(MiscCostUnbilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostUnbilled2 
			,MiscCostWriteOff,(select SUM(MiscCostWriteOff) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostWriteOff2 
			
			,ExpReceiptNet,(select SUM(ExpReceiptNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptNet2 
			,ExpReceiptNetApproved,(select SUM(ExpReceiptNetApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptNetApproved2 
			,ExpReceiptGross,(select SUM(ExpReceiptGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptGross2 
			,ExpReceiptGrossApproved,(select SUM(ExpReceiptGrossApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptGrossApproved2
			,ExpReceiptUnbilled,(select SUM(ExpReceiptUnbilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptUnbilled2 
			,ExpReceiptWriteOff,(select SUM(ExpReceiptWriteOff) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptWriteOff2 
					
			,VoucherNet,(select SUM(VoucherNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherNet2 
			,VoucherNetApproved,(select SUM(VoucherNetApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherNetApproved2 
			,VoucherGross,(select SUM(VoucherGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherGross2
			,VoucherGrossApproved,(select SUM(VoucherGrossApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherGrossApproved2 
			,VoucherOutsideCostsGross,(select SUM(VoucherOutsideCostsGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherOutsideCostsGross2 
			,VoucherOutsideCostsGrossApproved,(select SUM(VoucherOutsideCostsGrossApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherOutsideCostsGrossApproved2 
			
			,VoucherUnbilled,(select SUM(VoucherUnbilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherUnbilled2 
			,VoucherWriteOff,(select SUM(VoucherWriteOff) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherWriteOff2 		
							
			,OpenOrderNet,(select SUM(OpenOrderNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderNet2 
			,OpenOrderNetApproved,(select SUM(OpenOrderNetApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderNetApproved2 
			,OpenOrderGross,(select SUM(OpenOrderGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderGross2 
			,OpenOrderGrossApproved,(select SUM(OpenOrderGrossApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderGrossApproved2 
			,OrderPrebilled,(select SUM(OrderPrebilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OrderPrebilled2 
			
			,BilledAmount,(select SUM(BilledAmount) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmount2 
			,BilledAmountApproved,(select SUM(BilledAmountApproved) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmountApproved2 
			,BilledAmountNoTax,(select SUM(BilledAmountNoTax) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmountNoTax2 
			,AdvanceBilled,(select SUM(AdvanceBilled) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as AdvanceBilled2 
			,AdvanceBilledOpen,(select SUM(AdvanceBilledOpen) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as AdvanceBilledOpen2 

			,EstQty,(select SUM(EstQty) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstQty2 
			,EstNet,(select SUM(EstNet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstNet2 
			,EstGross,(select SUM(EstGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstGross2 
			,EstCOQty,(select SUM(EstCOQty) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCOQty2 
			,EstCONet,(select SUM(EstCONet) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCONet2 
			,EstCOGross,(select SUM(EstCOGross) From tProjectItemRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCOGross2 
		
		From tProjectRollup (nolock)
		Where (@ProjectKey is null Or ProjectKey = @ProjectKey)	
		Order by ProjectKey
		*/
		
 RETURN 1
GO
