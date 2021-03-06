USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateProject]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingGenerateProject]
	@FromGrid int	-- 1=TM Grid, 2=FF Grid
	,@UserKey int
	,@ProjectKey int
	,@ThruDate datetime -- Date used to pull transactions 
	,@DueDate datetime	-- Due date on billing worksheet for approvers
	,@DefaultAsOfDate datetime	-- Date used for some posting operations like WO, marked as billed
	,@Time tinyint
	,@Expense tinyint
	,@PO tinyint
	,@IO tinyint
	,@IOBeginDate datetime
	,@IOEndDate datetime
	,@BC tinyint
	,@BCBeginDate datetime
	,@BCEndDate datetime
	,@WMJMode int = 0
	,@ThruDateOption int = 1 -- 1 Use InvoiceDate with ThruDate, 2 Use Posting Date
	,@OpenOrdersOnly int = 1
AS --Encrypt

/*
|| When     Who Rel    What
|| 11/27/06 CRG 8.35   Modified to get the default ClassKey from tPreference.
|| 07/09/07 GHL 8.4    Added 2 nulls for company/office to sptBillingInsert
||                     sptBillingInsert will get these fields from ProjectKey
|| 07/09/07 GHL 8.5    Added restriction on ERs 
|| 08/10/07 GHL 8.5    Getting now class from project 
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 03/31/10 GHL 10.521 Added support of layouts
|| 03/31/10 GHL 10.521 Added support of tCampaign.BillBy
|| 03/10/11 GHL 10.542 (65287) Transactions on Hold should be placed on Hold on the billing worksheet
||                     so that the user can make a decision on holding or billing
|| 04/12/11 GHL 10.542 (108635) Fixed On Hold logic (If tTime.OnHold = 1 then Action = 3, not the opposite) 
|| 04/28/11 GHL 10.543 (109716) Changed the way OneInvoicePer = ParentClient is handled for the parent
||                     we keep it by ParentClient, for regular companies, we change it to Client    
|| 02/08/12 GHL 10.552 (123900) Added @DefaultAsOfDate for WriteOffs, Mark  As Billed and Transfer actions
|| 05/30/12 GHL 10.556 (144891) Added pulling of BillingAddressKey from client
|| 07/17/12 GHL 10.558 Added support of tProject.BillingGroupCode (override of tCompany.OneInvoicePer)
|| 07/19/12 GHL 10.558 (144713) Use the Flight Start Date (instead of the Flight End Date) for the date ranges
||                     so that it is the same as Mass Billing
|| 09/26/12 GHL 10.560 Changed BillingGroupCode to BillingGroupKey
|| 01/15/13 MAS 10.564 Added @UserKey param to EXEC sptBillingInsert
|| 05/06/13 MFT 10.567 Added BillingManagerKey override for @Approver
|| 07/03/13 GHL 10.569 Added parameter ThruDate to compare to NextBillDate for Fixed Fee projects (sptBillingInsert)
|| 08/14/13 GHL 10.571 (186305) Using now an option to compare ThruDate to InvoiceDate or PostingDate
|| 08/26/13 RLB 10.571 removed BillingManagerKey override
|| 10/02/13 GHL 10.573 Added param currency = null to sptBillingInsert, sp will get correct currency for you
|| 04/07/14 WDF 10.569 (206430) Adding Date Range Option for IOs and BOs
|| 09/04/14 GHL 10.584 (228260) Added OpenOrdersOnly to support the new media screens
|| 09/26/14 GHL 10.584 (230994) Using pod.DetailOrderDate rather than pod.DetailOrder-End-Date to compare to @BCBeginDate @BCEndDate
||                     to be consistent with the media sps
|| 01/21/15 GHL 10.588 Changed the order in which billing groups and campaign groups are handled (Abelson/Taylor)
|| 04/01/15 GHL 10.590 (252013) Added patch against PTotalCost with 3 digits from Media 
*/
	
	-- Originally used for TM Action=Bill=1
	-- Can also be used for FF
	--		Labor Action=Mark as Billed=2
	--		If ExpensesNotIncluded = 1 then Action=Bill=1 	
	--		If ExpensesNotIncluded = 0 then Action=Mark as Billed=2 	
	
	-- Other requirement:
	-- The FF grid contains FF projects and TM projects (Advance Billings)
	-- For advance billings TM Projects, FromGrid = 2, do not insert transactions, but check billing schedule
	
	IF @ThruDate IS NULL
		SELECT @ThruDate = '01/01/2050'
	IF @IOBeginDate is null
		select @IOBeginDate = '1/1/1960'
	IF @BCBeginDate is null
		select @BCBeginDate = '1/1/1960'
	IF @IOEndDate is null
		select @IOEndDate = '01/01/2050'
	IF @BCEndDate is null
		select @BCEndDate = '01/01/2050'

	DECLARE @Ret INT
			,@CompanyKey INT
			,@ClientKey INT
			,@Approver INT
			,@BillingKey INT
			,@BillingScheduleDate DATETIME
			,@BillingMethod INT
			,@ExpensesNotIncluded INT
			,@LaborAction INT
			,@ExpAction INT
			,@OneInvoicePer INT
			,@Entity VARCHAR(50)
			,@EntityKey INT			
			,@GroupEntity VARCHAR(50)
			,@GroupEntityKey INT	
			,@ParentCompany INT		
			,@ClassKey INT
			,@WorkSheetComment VARCHAR(4000)
			,@ProjectNumber VARCHAR(50)
			,@AdvanceBill INT
			,@AdvBillAccountKey INT
            ,@BillingContact INT
			,@DefaultClassKey INT
			,@ClientLayoutKey INT
			,@LayoutKey INT
			,@CampaignKey INT
			,@CampaignBillBy INT -- 1 By Project, 2 By Campaign
			,@BillingAddressKey INT
			,@BillingGroupKey INT

	-- this could be a field in tPreference or on the UI
	declare @BillingGroupOverridesCampaign int
	select @BillingGroupOverridesCampaign = 1

	SELECT 	@CompanyKey = p.CompanyKey
		   ,@ProjectNumber = p.ProjectNumber
		   ,@ClientKey = p.ClientKey
		   ,@BillingMethod = ISNULL(p.BillingMethod, 1)
		   ,@ExpensesNotIncluded = ISNULL(p.ExpensesNotIncluded, 0)
		   ,@Approver = ISNULL(p.AccountManager, @UserKey)
		   ,@BillingContact = p.BillingContact
		   ,@ClassKey = p.ClassKey
		   ,@LayoutKey = p.LayoutKey
		   ,@CampaignKey = p.CampaignKey
		   ,@CampaignBillBy = isnull(c.BillBy, 1)
		   ,@BillingGroupKey = BillingGroupKey
	FROM    tProject p (NOLOCK)
	    LEFT OUTER JOIN tCampaign c (NOLOCK) ON p.CampaignKey = c.CampaignKey
	    LEFT JOIN tCompany cm (nolock) ON p.ClientKey = cm.CompanyKey
	WHERE	p.ProjectKey = @ProjectKey
	
	IF @ClientKey IS NULL
		RETURN -100		
	
	IF @Approver = 0
		SELECT @Approver = @UserKey
		
	IF @BillingMethod = 1		-- TM
		SELECT @LaborAction = 1 -- Bill
			  ,@ExpAction = 1   -- Bill
	ELSE IF @BillingMethod = 2	-- FF
	BEGIN
		SELECT @LaborAction = 2 -- Mark as Billed		
		IF @ExpensesNotIncluded = 1
			SELECT @ExpAction = 1 -- Bill
		ELSE
			SELECT @ExpAction = 2 -- Mark as Billed		
	END	
		
	-- OneInvoicePer = 0 By Project
	-- OneInvoicePer = 1 By Client
	-- OneInvoicePer = 2 By Parent Client
	-- OneInvoicePer = 3 By Division
	-- OneInvoicePer = 4 By Product
	-- OneInvoicePer = 5 By Campaign
		
	SELECT @OneInvoicePer = ISNULL(OneInvoicePer, 0)
	      ,@ClientLayoutKey = LayoutKey
		  ,@BillingAddressKey = BillingAddressKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @ClientKey
	
	IF @OneInvoicePer = 0
		SELECT @GroupEntity = 'Project'
			   ,@GroupEntityKey = @ProjectKey
			    	
	IF @OneInvoicePer = 1
		SELECT @GroupEntity = 'Client'
			   ,@GroupEntityKey = @ClientKey
			
	IF @OneInvoicePer = 2
	BEGIN
		SELECT @GroupEntityKey = ParentCompanyKey
		      ,@ParentCompany = isnull(ParentCompany, 0)
		FROM   tCompany (NOLOCK)
		WHERE  CompanyKey = @ClientKey
		
		SELECT @GroupEntityKey = ISNULL(@GroupEntityKey, 0)
			   ,@GroupEntity = 'ParentClient'
			   						
		-- If ParentKey is 0, i.e. means that there is no parent
		IF @GroupEntityKey = 0
		begin
			IF @ParentCompany = 1
				-- if this is a parent company, just point the key to this client 
				SELECT @GroupEntityKey = @ClientKey
			ELSE
				-- if this is not a parent company, change the group to by client
				SELECT @GroupEntity = 'Client'
				   ,@GroupEntityKey = @ClientKey
				
		end

		
	END		
			
	IF @OneInvoicePer = 3
	BEGIN
		SELECT @GroupEntityKey = ClientDivisionKey
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		
		SELECT @GroupEntityKey = ISNULL(@GroupEntityKey, 0)
			   ,@GroupEntity = 'Division'
			   						
		-- If Division is 0, group by Project
		IF @GroupEntityKey = 0
			SELECT @GroupEntity = 'Project'
				   ,@GroupEntityKey = @ProjectKey
	END		

	IF @OneInvoicePer = 4
	BEGIN
		SELECT @GroupEntityKey = ClientProductKey
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		
		SELECT @GroupEntityKey = ISNULL(@GroupEntityKey, 0)
			   ,@GroupEntity = 'Product'
			   						
		-- If Product is 0, group by Project
		IF @GroupEntityKey = 0
			SELECT @GroupEntity = 'Project'
				   ,@GroupEntityKey = @ProjectKey
	END		

	IF @OneInvoicePer = 5
	BEGIN
		SELECT @GroupEntityKey = CampaignKey
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		
		SELECT @GroupEntityKey = ISNULL(@GroupEntityKey, 0)
			   ,@GroupEntity = 'Campaign'
			   						
		-- If Campaign is 0, group by Project
		IF @GroupEntityKey = 0
			SELECT @GroupEntity = 'Project'
				   ,@GroupEntityKey = @ProjectKey
	END		
	
	
	-- this is an override of OneInvoicePer
	IF @BillingGroupOverridesCampaign = 0
		-- The campaign wins over the billing group
		IF @CampaignBillBy = 2
		BEGIN
			-- we must bill by campaign (and not project)
			-- the only way that it is set to 2 is that there is a valid campaign and BillBy is 2
			SELECT @GroupEntityKey = @CampaignKey
				   ,@GroupEntity = 'Campaign'
		END
		ELSE
		BEGIN
			-- And now take in consideration the other override for InvoicePer: @BillingGroupKey
			IF isnull(@BillingGroupKey, 0) > 0
			BEGIN
				SELECT @GroupEntity = 'BillingGroup'
						   ,@GroupEntityKey = @BillingGroupKey
			END
		END
	ELSE
		-- the billing group wins over the campaign
		IF isnull(@BillingGroupKey, 0) > 0
		BEGIN
			SELECT @GroupEntity = 'BillingGroup'
				   ,@GroupEntityKey = @BillingGroupKey
		END
		ELSE
		BEGIN
			IF @CampaignBillBy = 2
			BEGIN
				-- we must bill by campaign (and not project)
				-- the only way that it is set to 2 is that there is a valid campaign and BillBy is 2
				SELECT @GroupEntityKey = @CampaignKey
					   ,@GroupEntity = 'Campaign'
			END
		END

	SELECT @Entity = 'Project'
		  ,@EntityKey = @ProjectKey

	-- Get comment from Schedules
	SELECT @BillingScheduleDate = MIN(NextBillDate)
	FROM   tBillingSchedule (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	AND    BillingKey IS NULL
	AND    NextBillDate IS NOT NULL

	IF @BillingScheduleDate IS NOT NULL AND @FromGrid = 2 -- Only if on the FF grid !
		SELECT @WorkSheetComment = Comments
		FROM   tBillingSchedule (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    NextBillDate = @BillingScheduleDate
	
	--IF @WorkSheetComment IS NULL
		--SELECT @WorkSheetComment = 'Billing worksheet generated for project: '+@ProjectNumber		 		  	
			 		  			 		  		
	-- Must mark it as Advanced Billing if TM billing method in FF grid
	IF @FromGrid = 2 AND @BillingMethod = 1
	BEGIN
		Select @AdvBillAccountKey = AdvBillAccountKey
		From   tPreference (nolock)
		Where  CompanyKey = @CompanyKey
	
		Select @AdvanceBill = 1		
	END
	ELSE
		Select @AdvanceBill = 0		
	
	--Get the DefaultClassKey for the Company
	SELECT	@DefaultClassKey = DefaultClassKey
	FROM	tPreference (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	
	IF ISNULL(@ClassKey, 0) = 0
		SELECT @ClassKey = @DefaultClassKey

	IF ISNULL(@LayoutKey, 0) = 0
		SELECT @LayoutKey = @ClientLayoutKey
		
	-- if we generate from CMP, no layouts	
	IF @WMJMode = 0
		SELECT @LayoutKey = NULL
		
	IF @LayoutKey = 0
		SELECT @LayoutKey = NULL

		
	-- Might return -1 (no client) or -2 (dup)		
	-- Pass @FromGrid instead of real billing nethod for @BillingMethod parameter
	-- Pass Currency = null, sp will get it for you
	EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, @ProjectKey, @ClassKey, @FromGrid, @WorkSheetComment, NULL
	,0 , NULL, @Entity, @EntityKey, @GroupEntity, @GroupEntityKey, NULL, NULL, @Approver, @AdvanceBill, @ThruDate
	, @DueDate, @DefaultAsOfDate, @BillingContact, @BillingAddressKey, NULL, NULL, @LayoutKey, @UserKey, NULL, @BillingKey OUTPUT
	
	IF @Ret < 0 
		RETURN @Ret				
	IF @BillingKey IS NULL
		RETURN -101
	
	IF ISNULL(@AdvBillAccountKey, 0) > 0 
		UPDATE tBilling
		SET    DefaultSalesAccountKey = @AdvBillAccountKey
		WHERE  BillingKey = @BillingKey
	
	-- Update Billing Schedules
	-- Do not link TM projects to schedules, only if on the second FF grid (TM Advance Billings or FF) 
	IF @BillingScheduleDate IS NOT NULL AND @FromGrid = 2  
		UPDATE tBillingSchedule
		SET    BillingKey = @BillingKey
		WHERE  ProjectKey = @ProjectKey
		AND    NextBillDate = @BillingScheduleDate
			
	-- If Advance Billing, do not insert transactions
	IF @FromGrid = 2 AND @BillingMethod = 1
	BEGIN
		UPDATE tBilling SET GeneratedLabor = 0, GeneratedExpense = 0 WHERE BillingKey = @BillingKey
		RETURN @BillingKey
	END
			
	if @Time = 1
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Comments,
			Quantity,
			Rate,
			Total,
			ServiceKey,
			RateLevel
			)
		SELECT  @BillingKey, 'tTime', NULL, TimeKey
			--, @LaborAction
			, case when ISNULL(tTime.OnHold, 0) = 1 THEN 3 -- On Hold
		           else @LaborAction 
			  end	 
			, Comments
			,ISNULL(ActualHours, 0), ISNULL(ActualRate, 0), ROUND(ActualHours * ActualRate, 2)
			,tTime.ServiceKey, tTime.RateLevel
		FROM    tTime (NOLOCK), tTimeSheet (nolock)
		WHERE   tTimeSheet.CompanyKey = @CompanyKey
		AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		AND		ProjectKey = @ProjectKey
		AND		tTimeSheet.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		--AND		ISNULL(tTime.OnHold, 0) = 0
		AND     WorkDate <= @ThruDate
		AND		TimeKey NOT IN (SELECT bd.EntityGuid
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey  
							AND   bd.Entity = 'tTime'
							AND   b.ProjectKey = tTime.ProjectKey
							AND   b.Status < 5
							)

 
   if @Expense = 1
   BEGIN
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT  @BillingKey, 'tExpenseReceipt', ExpenseReceiptKey, NULL
		--, @ExpAction
		, case when ISNULL(tExpenseReceipt.OnHold, 0) = 1 THEN 3 -- On Hold
		       else @ExpAction 
		end	 
		, ISNULL(ActualQty, 0), ISNULL(ActualUnitCost, 0), ISNULL(BillableCost, 0)
		FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock)
		WHERE   ProjectKey = @ProjectKey
		AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
		AND		tExpenseEnvelope.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		--AND		ISNULL(tExpenseReceipt.OnHold, 0) = 0
		AND     ExpenseDate <= @ThruDate
		AND		ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tExpenseReceipt' 
							AND   b.ProjectKey = tExpenseReceipt.ProjectKey
							AND   b.Status < 5
							)
		AND		tExpenseReceipt.VoucherDetailKey IS NULL
			
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT  @BillingKey, 'tMiscCost', MiscCostKey, NULL
			--, @ExpAction
			, case when ISNULL(tMiscCost.OnHold, 0) = 1 THEN 3 -- On Hold
					else @ExpAction 
			  end 
			,ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
		FROM   tMiscCost (NOLOCK)
		WHERE   ProjectKey = @ProjectKey
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		--AND		ISNULL(tMiscCost.OnHold, 0) = 0
		AND     ExpenseDate <= @ThruDate
		AND		MiscCostKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tMiscCost' 
							AND   b.ProjectKey = tMiscCost.ProjectKey
							AND   b.Status < 5
							)

		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT  @BillingKey, 'tVoucherDetail', VoucherDetailKey, NULL
			--, @ExpAction
			, case when ISNULL(vd.OnHold, 0) = 1 THEN 3 -- On Hold
					else @ExpAction 
			 end	 
			,ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
		FROM    tVoucherDetail vd (NOLOCK)
				,tVoucher       v  (NOLOCK)
		WHERE   vd.ProjectKey = @ProjectKey
		AND     vd.InvoiceLineKey IS NULL
		AND     ISNULL(vd.WriteOff, 0) = 0
		AND      vd.VoucherKey = v.VoucherKey
		AND		v.Status = 4
		--AND		ISNULL(vd.OnHold, 0) = 0
		AND     (
				(@ThruDateOption = 1 AND v.InvoiceDate <= @ThruDate)
				OR
				(@ThruDateOption = 2 AND v.PostingDate <= @ThruDate)
				)		
		AND		VoucherDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tVoucherDetail' 
							AND   b.ProjectKey = vd.ProjectKey
							AND   b.Status < 5
							)
	END
	
	IF @PO = 1
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT  @BillingKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL
			--, @ExpAction
			, case when ISNULL(pod.OnHold, 0) = 1 THEN 3 -- On Hold
					else @ExpAction 
			 end	 
			,ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 0
		--AND		ISNULL(pod.OnHold, 0) = 0
		AND     po.PODate <= @ThruDate		-- Or DueDate ?
		AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tPurchaseOrderDetail' 
							AND   b.ProjectKey = pod.ProjectKey
							AND   b.Status < 5
							)
						
	IF @IO = 1
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT @BillingKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL
			--, @ExpAction 
			, case when ISNULL(pod.OnHold, 0) = 1 THEN 3 -- On Hold
					else @ExpAction 
			 end	 
			,ISNULL(Quantity, 0), ISNULL(UnitCost, 0), 
		CASE po.BillAt 
			WHEN 0 THEN ISNULL(BillableCost, 0)
			WHEN 1 THEN isnull(PTotalCost, isnull(TotalCost,0))
			WHEN 2 THEN ISNULL(BillableCost,0) - isnull(PTotalCost, isnull(TotalCost,0)) 
		END
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 1
		--AND		ISNULL(pod.OnHold, 0) = 0
--		AND     pod.DetailOrderDate <= @ThruDate	
		AND		pod.DetailOrderDate >= @IOBeginDate
		AND		pod.DetailOrderDate <= @IOEndDate		
		AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tPurchaseOrderDetail' 
							AND   b.ProjectKey = pod.ProjectKey
							AND   b.Status < 5
							)
	
	IF @BC = 1
		INSERT tBillingDetail
			(
			BillingKey,
			Entity,
			EntityKey,
			EntityGuid,
			Action,
			Quantity,
			Rate,
			Total
			)
		SELECT  @BillingKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL
		       --, @ExpAction, 
				,case when ISNULL(pod.OnHold, 0) = 1 THEN 3 -- On Hold
					else @ExpAction 
				end	 
				,ISNULL(Quantity, 0), ISNULL(UnitCost, 0), 
		CASE po.BillAt 
			WHEN 0 THEN ISNULL(BillableCost, 0)
			WHEN 1 THEN isnull(PTotalCost, isnull(TotalCost,0))
			WHEN 2 THEN ISNULL(BillableCost,0) - isnull(PTotalCost, isnull(TotalCost,0)) 
		END
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 2
		--AND		ISNULL(pod.OnHold, 0) = 0
		--AND     pod.DetailOrderDate <= @ThruDate	
		AND		pod.DetailOrderDate >= @BCBeginDate
		AND		pod.DetailOrderDate <= @BCEndDate	
		AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND	  bd.Entity = 'tPurchaseOrderDetail' 
							AND   b.ProjectKey = pod.ProjectKey
							AND   b.Status < 5
							)

	-- patch against SmartPlus/Strata sending me PTotalCost with 3 digits after decimal point
	UPDATE tBillingDetail
	SET	   Total = ROUND(Total, 2)	
	WHERE  BillingKey = @BillingKey

	UPDATE tBillingDetail
	SET	   Rate = ROUND(Total / Quantity, 3)	
	WHERE  BillingKey = @BillingKey
	AND    Quantity <> 0
	AND    Entity <> 'tTime'
				 		
	UPDATE tBillingDetail
	SET	   GeneratedTotal = Total	
	WHERE  BillingKey = @BillingKey
	AND    Action = 1
				 		
	UPDATE tBillingDetail
	SET	   AsOfDate = @DefaultAsOfDate	
	WHERE  BillingKey = @BillingKey
	AND    Action in (0, 2, 5) -- WO, MasB, Xfers

	Declare @GeneratedLabor money, @GeneratedExpense money		 		
	Select @GeneratedLabor = Sum(GeneratedTotal) from tBillingDetail (nolock) 
	Where BillingKey = @BillingKey and Action = 1 and EntityGuid is not null
	
	Select @GeneratedExpense = Sum(GeneratedTotal) from tBillingDetail (nolock) 
	Where BillingKey = @BillingKey and Action = 1 and EntityGuid is null
	
	Update tBilling 
	Set    GeneratedLabor = @GeneratedLabor
		  ,GeneratedExpense = @GeneratedExpense
	Where  BillingKey = @BillingKey
		  	  	 		
	EXEC sptBillingRecalcTotals @BillingKey
				 		
	RETURN @BillingKey
GO
