USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTitleRollupUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTitleRollupUpdate]
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
  || When     Who Rel    What
  || 10/01/14 GHL 10.584 Creation to rollup title data 
  ||                     Cloned sptProjectTitleRollupUpdate and modified accordingly
  ||                     The temp tables must have a different name than in sptProjectItemRollupUpdate 
  */
  
 
	SET NOCOUNT ON
	
	DECLARE @UpdateStarted DATETIME
	SELECT @UpdateStarted = GETDATE()
	
	IF @SingleMode = 1 AND ISNULL(@ProjectKey, 0) <= 0
		RETURN 1
	
	IF @SingleMode = 1 AND @CompanyKey = 0
		SELECT @CompanyKey = CompanyKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey

	IF @SingleMode = 1
	BEGIN
		if not exists (select 1 from tPreference (nolock) where CompanyKey = @CompanyKey and isnull(UseBillingTitles, 0) = 1)
			RETURN 1
	END
	ELSE
	BEGIN
		if not exists (select 1 from #tProjectRollup -- the main project rollup table
						where UseBillingTitles = 1)
					RETURN 1
	END

	
			
	-- this temp table contains a list of entities to calculate data for
	-- will depend on @TranType and other params
	CREATE TABLE #tTitle(
		Action int NULL,			-- 0 Insert, 1 Update, 2 Delete 
	    CompanyKey int null,		-- for Adv Billed Open loop
		ProjectKey int NULL, 
	    TitleKey int NULL, 
	    AdvanceBill int NULL )
		
	-- Project Item Rollup table	
	CREATE TABLE #tProjectTRollup (
	    Action int NULL,			-- 0 Insert, 1 Update, 2 Delete 
	    CompanyKey int null,		-- for Adv Billed Open loop
		ProjectKey int NULL ,
		TitleKey int NULL,
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
	
	CREATE CLUSTERED INDEX [IX_tProjectTRollup_Temp] ON #tProjectTRollup(ProjectKey, TitleKey)
	
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
	INSERT #tProjectTRollup (Action, ProjectKey, CompanyKey, TitleKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, BilledAmount ,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross)
	SELECT 1, ProjectKey, @CompanyKey, TitleKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, BilledAmount, BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross
	FROM  tProjectTitleRollup (NOLOCK)
	WHERE ProjectKey = @ProjectKey
	
	ELSE
	
	INSERT #tProjectTRollup (Action, ProjectKey, CompanyKey, TitleKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, BilledAmount,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross)
	SELECT 1, b.ProjectKey, b.CompanyKey, TitleKey
		, Hours, HoursApproved, LaborNet, LaborNetApproved, LaborGross, LaborGrossApproved, LaborUnbilled, LaborWriteOff
		, BilledAmount,BilledAmountApproved, BilledAmountNoTax, AdvanceBilled, AdvanceBilledOpen
		, EstQty, EstNet, EstGross, EstCOQty, EstCONet, EstCOGross
	FROM  tProjectTitleRollup (NOLOCK)
	INNER JOIN (SELECT #tProjectRollup.ProjectKey, #tProjectRollup.CompanyKey 
				FROM  #tProjectRollup where UseBillingTitles = 1
				) As b ON b.ProjectKey = tProjectTitleRollup.ProjectKey

	
	IF @Labor = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tTitle(Action, CompanyKey, ProjectKey,TitleKey)
		SELECT 0, @CompanyKey, ProjectKey, isnull(TitleKey, 0)
		FROM   tTime (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(TitleKey, 0)
		ELSE
		INSERT #tTitle(Action, ProjectKey,TitleKey)
		SELECT 0, ProjectKey, isnull(TitleKey, 0)
		FROM   tTime (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup where UseBillingTitles = 1)
		GROUP BY ProjectKey, isnull(TitleKey, 0)
	END
	
	IF @Billing = 1
	BEGIN
		-- problem with fixed fee (Entity = null, TitleKey = null)
		-- take null Entity as tService
		IF @SingleMode = 1
		INSERT #tTitle(Action, CompanyKey, ProjectKey,TitleKey)
		SELECT 0, @CompanyKey, ProjectKey, ISNULL(TitleKey, 0)
		FROM   tInvoiceSummaryTitle (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, isnull(TitleKey, 0)
		ELSE
		INSERT #tTitle(Action, ProjectKey,TitleKey)
		SELECT 0, ProjectKey, ISNULL(TitleKey, 0)
		FROM   tInvoiceSummaryTitle (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup  where UseBillingTitles = 1)
		GROUP BY ProjectKey, isnull(TitleKey, 0)
		                
		UPDATE #tTitle
		SET    #tTitle.AdvanceBill = 1
		FROM   tInvoiceSummaryTitle isum (NOLOCK)
		      ,tInvoice i (NOLOCK)
		WHERE  isum.InvoiceKey = i.InvoiceKey
		AND    #tTitle.ProjectKey = isum.ProjectKey
		AND    #tTitle.TitleKey = isnull(isum.TitleKey, 0)
		                
	END
	
	IF @Estimate = 1
	BEGIN
		IF @SingleMode = 1
		INSERT #tTitle(Action, CompanyKey, ProjectKey,TitleKey)
		SELECT 0, @CompanyKey, ProjectKey, TitleKey
		FROM   tProjectEstByTitle (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		GROUP BY ProjectKey, TitleKey
		ELSE
		INSERT #tTitle(Action, ProjectKey,TitleKey)
		SELECT 0, ProjectKey, TitleKey
		FROM   tProjectEstByTitle (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup  where UseBillingTitles = 1)
		GROUP BY ProjectKey, TitleKey
	END
	
	IF @SingleMode = 0
		UPDATE #tTitle
		SET    #tTitle.CompanyKey = b.CompanyKey
		FROM   #tProjectRollup b
		WHERE  #tTitle.ProjectKey = b.ProjectKey 
	
--select * from #tTitle
	
	UPDATE #tTitle
	SET    #tTitle.Action = 1 -- indicates an update operation
	FROM   #tProjectTRollup  
	WHERE  #tProjectTRollup.ProjectKey = #tTitle.ProjectKey 
	AND    #tProjectTRollup.TitleKey = #tTitle.TitleKey
	
	INSERT #tProjectTRollup (Action, CompanyKey, ProjectKey, TitleKey) 
	SELECT 0, CompanyKey, ProjectKey, TitleKey
	FROM   #tTitle 
	WHERE Action = 0 -- indicates an insert operation
	GROUP BY CompanyKey, ProjectKey, TitleKey
	
	/*			
	UPDATE #tProjectTRollup
	SET    #tProjectTRollup.AdvanceBill = isnull(#tTitle.AdvanceBill, 0)
	FROM   #tTitle 
	WHERE  #tProjectTRollup.ProjectKey = #tTitle.ProjectKey 
	AND    #tProjectTRollup.Entity = #tTitle.Entity COLLATE DATABASE_DEFAULT  
	AND    #tProjectTRollup.TitleKey = #tTitle.TitleKey
	*/
	
	-- Mark the projects as having advance bill, regardless of entity and entitykey
	-- Set to 1 and not to isnull(#tTitle.AdvanceBill, 0)
	IF @Billing = 1
	UPDATE #tProjectTRollup
	SET    #tProjectTRollup.AdvanceBill = 1
	FROM   #tTitle 
	WHERE  #tProjectTRollup.ProjectKey = #tTitle.ProjectKey 
	AND    isnull(#tTitle.AdvanceBill, 0) = 1
	
--select * from #tProjectTRollup
--select count(*) from #tProjectTRollup
	
	DECLARE @UseTempLabor INT	SELECT @UseTempLabor = 0
	
	IF isnull(@ProjectKey, 0) > 0 And @Labor = 1 And @MiscCost = 0 And @ExpReceipt = 0 And @Voucher = 0 And @OpenOrder = 0 And @Billing = 0 And @Estimate = 0
		SELECT @UseTempLabor = 1
		
	IF @UseTempLabor = 1
	BEGIN
		CREATE TABLE #tTimeTitle (TimeKey uniqueidentifier null, ProjectKey int null, TitleKey int null
		, ActualHours decimal(24,4) null, ActualRate money null, CostRate money null
		, BilledHours decimal(24,4) null, BilledRate money null
		, DateBilled datetime null, WriteOff int null, InvoiceLineKey int null, Status int null)
		
		-- use IX_tTime_15
		INSERT #tTimeTitle (TimeKey, ProjectKey, TitleKey, ActualHours, ActualRate, CostRate
		 , BilledHours, BilledRate, DateBilled, WriteOff, InvoiceLineKey, Status)
		SELECT t.TimeKey, t.ProjectKey, t.TitleKey, t.ActualHours, t.ActualRate, t.CostRate
		 , t.BilledHours, t.BilledRate, t.DateBilled, t.WriteOff, t.InvoiceLineKey, 1
		FROM tTime t with (index=IX_tTime_15,nolock)
		WHERE t.ProjectKey = @ProjectKey
		
		-- use PK_tTime + let SQL decide for timesheet status
		UPDATE #tTimeTitle
		SET    #tTimeTitle.Status = ts.Status
		FROM   tTime with (index=PK_tTime, nolock)
			  ,tTimeSheet ts (NOLOCK)  
		WHERE  #tTimeTitle.TimeKey = tTime.TimeKey
		AND    tTime.TimeSheetKey = ts.TimeSheetKey
		 
	END	
						 		   
	IF @Labor = 1
	BEGIN
	
		IF @BaseRollup = 1
		BEGIN
			-- need to cleanup all rows, part of the delete action
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.Hours = 0
				   ,#tProjectTRollup.HoursBilled = 0
				   ,#tProjectTRollup.HoursInvoiced = 0
				   ,#tProjectTRollup.LaborNet = 0
			       ,#tProjectTRollup.LaborGross= 0
			       ,#tProjectTRollup.LaborUnbilled = 0
		           ,#tProjectTRollup.LaborBilled = 0
				   ,#tProjectTRollup.LaborInvoiced = 0
			
			IF @UseTempLabor = 0	   
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.Hours =  
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 

					,#tProjectTRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectTRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)
					
			       ,#tProjectTRollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 
						
					,#tProjectTRollup.LaborGross =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 
				
					,#tProjectTRollup.LaborUnbilled =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NULL
					), 0)
					
					,#tProjectTRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectTRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)
			
				ELSE
				
				UPDATE #tProjectTRollup
				SET		#tProjectTRollup.Hours =  
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 

					,#tProjectTRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectTRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)
					
			       ,#tProjectTRollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 
						
					,#tProjectTRollup.LaborGross =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					), 0) 
				
					,#tProjectTRollup.LaborUnbilled =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NULL
					), 0)
					
					,#tProjectTRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectTRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)
			
					
		 END
		
		 IF @Approved = 1
		 BEGIN   
			-- need to cleanup all rows, part of the delete action
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.HoursApproved = 0
			       ,#tProjectTRollup.LaborNetApproved = 0
			       ,#tProjectTRollup.LaborGrossApproved= 0
			
			IF @UseTempLabor = 0	   
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.HoursApproved = 
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   tTimeSheet.Status = 4
					), 0) 
				
					,#tProjectTRollup.LaborNetApproved = 
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   tTimeSheet.Status = 4
					), 0) 
						
					,#tProjectTRollup.LaborGrossApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   tTimeSheet.Status = 4
					), 0) 
			
			ELSE
			
					UPDATE #tProjectTRollup
					SET		#tProjectTRollup.HoursApproved = 
					ISNULL((
					SELECT SUM(ActualHours) 
					FROM #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   #tTimeTitle.Status = 4
					), 0) 
				
					,#tProjectTRollup.LaborNetApproved = 
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   #tTimeTitle.Status = 4
					), 0) 
						
					,#tProjectTRollup.LaborGrossApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM #tTimeTitle (NOLOCK) 
					WHERE #tTimeTitle.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(#tTimeTitle.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   #tTimeTitle.Status = 4
					), 0) 
						
		END
		
		IF @BaseRollup = 0 AND @Unbilled = 1
		BEGIN
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.LaborUnbilled = 0
					,#tProjectTRollup.LaborBilled = 0
					,#tProjectTRollup.LaborInvoiced = 0
					,#tProjectTRollup.HoursBilled = 0
					,#tProjectTRollup.HoursInvoiced = 0
			
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND DateBilled IS NULL
					), 0)

					,#tProjectTRollup.HoursBilled =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NULL
					AND   WriteOff = 0
					), 0)
					
					,#tProjectTRollup.HoursInvoiced =  
					ISNULL((
					SELECT SUM(BilledHours) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)

					,#tProjectTRollup.LaborBilled =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   DateBilled IS NOT NULL
					AND   WriteOff = 0
					), 0)

					,#tProjectTRollup.LaborInvoiced =
					ISNULL((
					SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND   InvoiceLineKey > 0
					), 0)
				 
		END	 
		
		IF @WriteOff = 1
		BEGIN
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.LaborWriteOff = 0
			
			UPDATE #tProjectTRollup
			SET		#tProjectTRollup.LaborWriteOff =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #tProjectTRollup.ProjectKey
					AND   isnull(tTime.TitleKey, 0) = #tProjectTRollup.TitleKey
					AND WriteOff = 1), 0)
							 
		END	
		
	END
	
		
	IF @Billing = 1
	BEGIN
		UPDATE #tProjectTRollup
		SET	   #tProjectTRollup.BilledAmount = 0
		      ,#tProjectTRollup.BilledAmountApproved = 0
		      ,#tProjectTRollup.BilledAmountNoTax = 0
		      ,#tProjectTRollup.AdvanceBilled = 0
		      ,#tProjectTRollup.AdvanceBilledOpen = 0
		      
		      
		UPDATE #tProjectTRollup
		SET			#tProjectTRollup.BilledAmount = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummaryTitle isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectTRollup.ProjectKey
					AND   ISNULL(isum.TitleKey, 0) = #tProjectTRollup.TitleKey
					),0)
					
					,#tProjectTRollup.BilledAmountApproved = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummaryTitle isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and   i.InvoiceStatus = 4
					and isum.ProjectKey = #tProjectTRollup.ProjectKey
					AND   ISNULL(isum.TitleKey, 0) = #tProjectTRollup.TitleKey
					),0)
					
					,#tProjectTRollup.BilledAmountNoTax = 
					ISNULL((SELECT SUM(isum.Amount)
					FROM tInvoiceSummaryTitle isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectTRollup.ProjectKey
					AND   ISNULL(isum.TitleKey, 0) = #tProjectTRollup.TitleKey
					),0)
					
					,#tProjectTRollup.AdvanceBilled = 
					ISNULL((SELECT SUM(isum.Amount  + isum.SalesTaxAmount)
					FROM tInvoiceSummaryTitle isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 1 
					and isum.ProjectKey = #tProjectTRollup.ProjectKey
					AND   ISNULL(isum.TitleKey, 0) = #tProjectTRollup.TitleKey
					),0)
			
	END					
				
	DECLARE @AdvanceBilledOpen MONEY
	DECLARE @TitleKey INT
	DECLARE @CurrProjectKey INT
		
IF @Billing = 1
BEGIN	
	SELECT @CurrProjectKey = -1		
	
	WHILE (1=1)
	BEGIN
		SELECT @CurrProjectKey = MIN(ProjectKey)
		FROM   #tProjectTRollup 
		WHERE  ProjectKey > @CurrProjectKey
		AND    ISNULL(AdvanceBill, 0) = 1

		IF @CurrProjectKey IS NULL
			BREAK

		SELECT @CompanyKey = CompanyKey
		FROM   #tProjectTRollup 
		WHERE  ProjectKey = @CurrProjectKey
			
					
		SELECT @TitleKey = -1
		WHILE (1=1)
		BEGIN
			
			SELECT @TitleKey = MIN(TitleKey)
			FROM   #tProjectTRollup 
			WHERE  TitleKey > @TitleKey
			AND    ISNULL(AdvanceBill, 0) = 1
			AND    ProjectKey = @CurrProjectKey
			
			IF @TitleKey IS NULL
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
						FROM  tInvoiceSummaryTitle isum (NOLOCK)
							INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
						WHERE isum.ProjectKey = @CurrProjectKey
						AND   isnull(isum.TitleKey, 0) = @TitleKey
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

			--select @ProjectKey, @Entity, @TitleKey, @AdvanceBilledOpen
			
			UPDATE #tProjectTRollup SET AdvanceBilledOpen = @AdvanceBilledOpen
			WHERE ProjectKey = @CurrProjectKey AND TitleKey = @TitleKey
				
		END -- TitleKey loop
			
	END -- ProjectKey loop
			
END	-- Billing=1	

				
	IF @Estimate = 1
	BEGIN
		UPDATE #tProjectTRollup
		SET	   #tProjectTRollup.EstQty= 0, #tProjectTRollup.EstNet= 0, #tProjectTRollup.EstGross= 0
              ,#tProjectTRollup.EstCOQty= 0, #tProjectTRollup.EstCONet= 0, #tProjectTRollup.EstCOGross= 0
              
              
		UPDATE #tProjectTRollup
		SET	   #tProjectTRollup.EstQty= est.Qty, #tProjectTRollup.EstNet= est.Net, #tProjectTRollup.EstGross= est.Gross
              ,#tProjectTRollup.EstCOQty= est.COQty, #tProjectTRollup.EstCONet= est.CONet, #tProjectTRollup.EstCOGross= est.COGross
        FROM   tProjectEstByTitle est (NOLOCK)
        WHERE  #tProjectTRollup.ProjectKey = est.ProjectKey
        AND    #tProjectTRollup.TitleKey = est.TitleKey
        
	END
	
	
	UPDATE #tProjectTRollup
		SET #tProjectTRollup.Hours = ISNULL(#tProjectTRollup.Hours, 0)
		    ,#tProjectTRollup.HoursApproved = ISNULL(#tProjectTRollup.HoursApproved, 0)
			,#tProjectTRollup.HoursBilled = ISNULL(#tProjectTRollup.HoursBilled, 0)
			,#tProjectTRollup.HoursInvoiced = ISNULL(#tProjectTRollup.HoursInvoiced, 0)
			,#tProjectTRollup.LaborNet = ISNULL(#tProjectTRollup.LaborNet, 0)
			,#tProjectTRollup.LaborNetApproved = ISNULL(#tProjectTRollup.LaborNetApproved, 0)
			,#tProjectTRollup.LaborGross = ISNULL(#tProjectTRollup.LaborGross, 0)
			,#tProjectTRollup.LaborGrossApproved = ISNULL(#tProjectTRollup.LaborGrossApproved, 0)
			,#tProjectTRollup.LaborUnbilled = ISNULL(#tProjectTRollup.LaborUnbilled, 0)
			,#tProjectTRollup.LaborWriteOff = ISNULL(#tProjectTRollup.LaborWriteOff, 0)
			,#tProjectTRollup.LaborBilled = ISNULL(#tProjectTRollup.LaborBilled, 0)
			,#tProjectTRollup.LaborInvoiced = ISNULL(#tProjectTRollup.LaborInvoiced, 0)
				
			,#tProjectTRollup.BilledAmount = ISNULL(#tProjectTRollup.BilledAmount, 0)
			,#tProjectTRollup.BilledAmountApproved = ISNULL(#tProjectTRollup.BilledAmountApproved, 0)
			,#tProjectTRollup.BilledAmountNoTax = ISNULL(#tProjectTRollup.BilledAmountNoTax, 0)
			,#tProjectTRollup.AdvanceBilled = ISNULL(#tProjectTRollup.AdvanceBilled, 0)
			,#tProjectTRollup.AdvanceBilledOpen = ISNULL(#tProjectTRollup.AdvanceBilledOpen, 0)
			
			,#tProjectTRollup.EstQty = ISNULL(#tProjectTRollup.EstQty, 0)
			,#tProjectTRollup.EstNet = ISNULL(#tProjectTRollup.EstNet, 0)
			,#tProjectTRollup.EstGross = ISNULL(#tProjectTRollup.EstGross, 0)
			,#tProjectTRollup.EstCOQty = ISNULL(#tProjectTRollup.EstCOQty, 0)
			,#tProjectTRollup.EstCONet = ISNULL(#tProjectTRollup.EstCONet, 0)
			,#tProjectTRollup.EstCOGross = ISNULL(#tProjectTRollup.EstCOGross, 0)
	FROM    #tProjectTRollup		
	
	UPDATE #tProjectTRollup
	SET    Action = 2 -- Delete
	WHERE  Hours=0 AND HoursApproved=0 AND HoursBilled=0 AND HoursInvoiced=0 AND LaborNet=0 AND LaborNetApproved=0 AND LaborGross=0 AND LaborGrossApproved=0 AND LaborUnbilled=0 AND LaborBilled=0 AND LaborInvoiced=0 AND LaborWriteOff=0  
	AND BilledAmount=0 AND BilledAmountApproved=0 AND BilledAmountNoTax=0 AND AdvanceBilled=0 AND AdvanceBilledOpen = 0
	AND EstQty=0 AND EstNet=0 AND EstGross=0 AND EstCOQty=0 AND EstCONet=0 AND EstCOGross=0


	IF @SingleMode = 1
	BEGIN
		DELETE  tProjectTitleRollup
		FROM    #tProjectTRollup b
		WHERE   tProjectTitleRollup.ProjectKey =@ProjectKey
		AND     tProjectTitleRollup.TitleKey = b.TitleKey
		AND     b.Action = 2
		
	END
	ELSE
	BEGIN
		DELETE  tProjectTitleRollup
		FROM    #tProjectTRollup b
		WHERE   tProjectTitleRollup.ProjectKey =b.ProjectKey
		AND     tProjectTitleRollup.TitleKey = b.TitleKey
		AND     b.Action = 2
	END

	DELETE #tProjectTRollup WHERE Action = 2
	
	-- safer to retest again if we need to update or insert
	UPDATE #tProjectTRollup SET Action = 0
	
	UPDATE #tProjectTRollup SET Action =  1
	FROM   tProjectTitleRollup b (NOLOCK)
	WHERE  #tProjectTRollup.ProjectKey = b.ProjectKey 
	AND    #tProjectTRollup.TitleKey = b.TitleKey 
		
	INSERT tProjectTitleRollup (ProjectKey, TitleKey)
	SELECT ProjectKey, TitleKey
	FROM   #tProjectTRollup WHERE Action = 0

	UPDATE tProjectTitleRollup
		SET tProjectTitleRollup.Hours = #tProjectTRollup.Hours
		    ,tProjectTitleRollup.HoursApproved = #tProjectTRollup.HoursApproved
			,tProjectTitleRollup.HoursBilled = #tProjectTRollup.HoursBilled
			,tProjectTitleRollup.HoursInvoiced = #tProjectTRollup.HoursInvoiced
			,tProjectTitleRollup.LaborNet = #tProjectTRollup.LaborNet
			,tProjectTitleRollup.LaborNetApproved = #tProjectTRollup.LaborNetApproved
			,tProjectTitleRollup.LaborGross = #tProjectTRollup.LaborGross
			,tProjectTitleRollup.LaborGrossApproved = #tProjectTRollup.LaborGrossApproved
			,tProjectTitleRollup.LaborUnbilled = #tProjectTRollup.LaborUnbilled
			,tProjectTitleRollup.LaborWriteOff = #tProjectTRollup.LaborWriteOff
			,tProjectTitleRollup.LaborBilled = #tProjectTRollup.LaborBilled
			,tProjectTitleRollup.LaborInvoiced = #tProjectTRollup.LaborInvoiced
			
			,tProjectTitleRollup.BilledAmount = #tProjectTRollup.BilledAmount
			,tProjectTitleRollup.BilledAmountApproved = #tProjectTRollup.BilledAmountApproved
			,tProjectTitleRollup.BilledAmountNoTax = #tProjectTRollup.BilledAmountNoTax
			,tProjectTitleRollup.AdvanceBilled = #tProjectTRollup.AdvanceBilled
			,tProjectTitleRollup.AdvanceBilledOpen = #tProjectTRollup.AdvanceBilledOpen
			
			,tProjectTitleRollup.EstQty = #tProjectTRollup.EstQty
			,tProjectTitleRollup.EstNet = #tProjectTRollup.EstNet
			,tProjectTitleRollup.EstGross = #tProjectTRollup.EstGross
			,tProjectTitleRollup.EstCOQty = #tProjectTRollup.EstCOQty
			,tProjectTitleRollup.EstCONet = #tProjectTRollup.EstCONet
			,tProjectTitleRollup.EstCOGross = #tProjectTRollup.EstCOGross
			
			,tProjectTitleRollup.UpdateStarted = @UpdateStarted
			,tProjectTitleRollup.UpdateEnded = GETDATE()
	FROM    #tProjectTRollup		
	WHERE   tProjectTitleRollup.ProjectKey = #tProjectTRollup.ProjectKey
	AND     tProjectTitleRollup.TitleKey = #tProjectTRollup.TitleKey
		
    -- testing only
    /*
	select  ProjectKey
			,Hours,(select SUM(Hours) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as Hours2  
		    ,HoursApproved,(select SUM(HoursApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as HoursApproved2 
			,LaborNet,(select SUM(LaborNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborNet2 
			,LaborNetApproved ,(select SUM(LaborNetApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborNetApproved2
			,LaborGross,(select SUM(LaborGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborGross2 
			,LaborGrossApproved,(select SUM(LaborGrossApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborGrossApproved2 
			,LaborUnbilled,(select SUM(LaborUnbilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborUnbilled2 
			,LaborWriteOff,(select SUM(LaborWriteOff) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as LaborWriteOff2 
			
			,MiscCostNet,(select SUM(MiscCostNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostNet2 
			,MiscCostGross,(select SUM(MiscCostGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostGross2 
			,MiscCostUnbilled,(select SUM(MiscCostUnbilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostUnbilled2 
			,MiscCostWriteOff,(select SUM(MiscCostWriteOff) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as MiscCostWriteOff2 
			
			,ExpReceiptNet,(select SUM(ExpReceiptNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptNet2 
			,ExpReceiptNetApproved,(select SUM(ExpReceiptNetApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptNetApproved2 
			,ExpReceiptGross,(select SUM(ExpReceiptGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptGross2 
			,ExpReceiptGrossApproved,(select SUM(ExpReceiptGrossApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptGrossApproved2
			,ExpReceiptUnbilled,(select SUM(ExpReceiptUnbilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptUnbilled2 
			,ExpReceiptWriteOff,(select SUM(ExpReceiptWriteOff) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as ExpReceiptWriteOff2 
					
			,VoucherNet,(select SUM(VoucherNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherNet2 
			,VoucherNetApproved,(select SUM(VoucherNetApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherNetApproved2 
			,VoucherGross,(select SUM(VoucherGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherGross2
			,VoucherGrossApproved,(select SUM(VoucherGrossApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherGrossApproved2 
			,VoucherOutsideCostsGross,(select SUM(VoucherOutsideCostsGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherOutsideCostsGross2 
			,VoucherOutsideCostsGrossApproved,(select SUM(VoucherOutsideCostsGrossApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherOutsideCostsGrossApproved2 
			
			,VoucherUnbilled,(select SUM(VoucherUnbilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherUnbilled2 
			,VoucherWriteOff,(select SUM(VoucherWriteOff) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as VoucherWriteOff2 		
							
			,OpenOrderNet,(select SUM(OpenOrderNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderNet2 
			,OpenOrderNetApproved,(select SUM(OpenOrderNetApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderNetApproved2 
			,OpenOrderGross,(select SUM(OpenOrderGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderGross2 
			,OpenOrderGrossApproved,(select SUM(OpenOrderGrossApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OpenOrderGrossApproved2 
			,OrderPrebilled,(select SUM(OrderPrebilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as OrderPrebilled2 
			
			,BilledAmount,(select SUM(BilledAmount) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmount2 
			,BilledAmountApproved,(select SUM(BilledAmountApproved) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmountApproved2 
			,BilledAmountNoTax,(select SUM(BilledAmountNoTax) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as BilledAmountNoTax2 
			,AdvanceBilled,(select SUM(AdvanceBilled) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as AdvanceBilled2 
			,AdvanceBilledOpen,(select SUM(AdvanceBilledOpen) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as AdvanceBilledOpen2 

			,EstQty,(select SUM(EstQty) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstQty2 
			,EstNet,(select SUM(EstNet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstNet2 
			,EstGross,(select SUM(EstGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstGross2 
			,EstCOQty,(select SUM(EstCOQty) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCOQty2 
			,EstCONet,(select SUM(EstCONet) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCONet2 
			,EstCOGross,(select SUM(EstCOGross) From tProjectTitleRollup (nolock) where ProjectKey = tProjectRollup.ProjectKey) as EstCOGross2 
		
		From tProjectRollup (nolock)
		Where (@ProjectKey is null Or ProjectKey = @ProjectKey)	
		Order by ProjectKey
		*/
		
 RETURN 1
GO
