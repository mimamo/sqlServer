USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateRetainer]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingGenerateRetainer]
	(
	@UserKey int
	,@RetainerKey INT
	,@ThruDate DATETIME -- Date used to pull transactions 
	,@DueDate DATETIME	-- Due date on billing worksheet for approvers
	,@DefaultAsOfDate datetime -- Date used for some posting operations like WO, marked as billed
	,@ThruDateOption int = 1 -- 1 Use InvoiceDate with ThruDate, 2 Use Posting Date
	)
AS -- Encrypt

/*
|| When     Who Rel    What
|| 11/27/06 CRG 8.35   Modified to get the default ClassKey from tPreference. 
|| 05/23/07 GHL 8.422  Added update of tBillingDetail.ServiceKey+tBillingDetail.RateLevel 
|| 07/09/07 GHL 8.5    Added 2 nulls for company/office to sptBillingInsert
||                     sptBillingInsert will get these fields from RetainerKey 
|| 07/09/07 GHL 8.5    Added restriction on ERs
|| 07/30/07 GHL 8.5    Removed refs to expense type
|| 08/09/07 GHL 8.5    Copying GLCompanyKey, OfficeKey from retainer WS to master WS
|| 09/20/07 GHL 8.437  Added retainer description
|| 12/18/07 GHL 8.5    (17879) Added reading of tRetainer.ClassKey 
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 08/28/09 GHL 10.508 (60241) Change if RetainerAmount > 0 to if RetainerAmount >= 0,  because it can be 0 now
|| 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0  
|| 03/31/10 GHL 10.521  Added support of layouts, simply passing @LayoutKey = NULL for retainers
|| 02/08/12 GHL 10.552 (123900) Added @DefaultAsOfDate for WriteOffs, Mark  As Billed and Transfer actions
|| 02/08/12 GHL 10.552 (123900)(135565) Added missing @DefaultAsOfDate on 3rd billing insert
|| 05/31/12 GHL 10.556 (144891) Added pulling of BillingAddressKey from client
|| 09/07/12 RLB 10.560 (87856) Adding Primary Contact from Retainer to the billing worksheet
|| 01/15/13 MAS 10.564 Added @UserKey param to EXEC sptBillingInsert
|| 05/06/13 MFT 10.567 Added BillingManagerKey override for @InvoiceApprovedBy
|| 07/03/13 GHL 10.569 Added ThruDate  = null for sptBillingInsert
|| 08/14/13 GHL 10.571 (186305) Using now an option to compare ThruDate to InvoiceDate or PostingDate
|| 08/26/13 RLB 10.571 removed BillingManagerKey override
|| 10/02/13 GHL 10.573 added logic for multi currency
|| 10/07/13 GHL 10.573 getting now CurrencyID from retainer rather than the projects
*/

	SET NOCOUNT ON
	
	IF @ThruDate IS NULL
		SELECT @ThruDate = '01/01/2050'
		
	DECLARE @Ret INT
			,@ErrorOccurred INT
			,@CompanyKey INT
			,@ProjectKey INT
			,@RetainerAmount MONEY
			,@CanBillRetainer INT
			,@Title VARCHAR(200)
			,@Description VARCHAR(1500)
			,@InvoiceApprovedBy INT
			,@ProjectApprovedBy INT
			,@InvoiceExtrasSeparate INT
			,@IncludeLabor INT
			,@IncludeExpense INT			
			,@MasterBillingKey INT
			,@RetainerBillingKey INT
			,@BillingKey INT
			,@ClientKey INT
			,@ClassKey INT
			,@WorkSheetComment VARCHAR(4000)
			,@SalesAccountKey INT
			,@GeneratedLabor money
			,@GeneratedExpense money
			,@GLCompanyKey int
			,@OfficeKey int
			,@BillingAddressKey INT
			,@ContactKey INT
			,@CurrencyID varchar(10)

	SELECT	@CompanyKey = r.CompanyKey
			,@ClientKey = r.ClientKey
			,@Title = r.Title
			,@Description = r.Description
			,@InvoiceApprovedBy = ISNULL(r.InvoiceApprovedBy, @UserKey)
			,@InvoiceExtrasSeparate = ISNULL(r.InvoiceExpensesSeperate, 0)
			,@IncludeLabor = ISNULL(r.IncludeLabor, 0)
			,@IncludeExpense = ISNULL(r.IncludeExpense, 0)
			,@SalesAccountKey = r.SalesAccountKey
			,@GLCompanyKey = r.GLCompanyKey
			,@OfficeKey = r.OfficeKey						
			,@ClassKey = r.ClassKey
			,@ContactKey = r.ContactKey
			,@CurrencyID = r.CurrencyID
	FROM	tRetainer r (NOLOCK)
		LEFT JOIN tCompany c (nolock) ON r.ClientKey = c.CompanyKey
	WHERE   RetainerKey = @RetainerKey 
				
	IF @InvoiceApprovedBy = 0
		SELECT @InvoiceApprovedBy = @UserKey
	
	if @CurrencyID = ''
		select @CurrencyID = null

	SELECT @BillingKey = BillingKey
	FROM   tBilling (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND	   Entity = 'Retainer'
	AND    EntityKey = @RetainerKey
	AND    Status < 5  		
		
	IF @BillingKey IS NOT NULL
		RETURN -101
	
	-- Needed temp table because I did not want to create tBilling records if no details attached to them 
	-- Before inserting in tBilling, check for existing details 
	CREATE TABLE #tBillingDetail (
	ProjectKey int NULL,
	Entity varchar(50) NULL ,
	EntityKey int NULL ,
	EntityGuid uniqueidentifier NULL ,
	Action smallint NOT NULL ,
	Quantity decimal(24, 4) NULL ,
	Rate money NULL ,
	Total money NULL ,
	Comments varchar (2000)  NULL ,
	ServiceKey int NULL ,
	RateLevel int NULL) 
	
	EXEC @CanBillRetainer = sptRetainerGetAmount @RetainerKey, @ThruDate, @RetainerAmount OUTPUT

	--Get the DefaultClassKey for the Company
	IF ISNULL(@ClassKey, 0) = 0
	SELECT	@ClassKey = DefaultClassKey
	FROM	tPreference (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
			
	-- Create a child ws for the retainer with the retainer amount attached to it		
	IF @CanBillRetainer = 1
	BEGIN
		SELECT @BillingAddressKey = BillingAddressKey
		FROM   tCompany (NOLOCK)
		WHERE  CompanyKey = @ClientKey

		-- There should be no transactions attached to it
		SELECT @WorkSheetComment = 'Billing worksheet generated for retainer: '+@Title
		EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 3, @WorkSheetComment, NULL
		, 0, NULL, 'Retainer', @RetainerKey, 'RetainerMaster', @RetainerKey, @RetainerAmount, @Description, @InvoiceApprovedBy, 0, null
		, @DueDate, @DefaultAsOfDate, @ContactKey, @BillingAddressKey, @GLCompanyKey, @OfficeKey, NULL, @UserKey, @CurrencyID, @RetainerBillingKey OUTPUT

		IF @Ret < 0
			RETURN @Ret
		IF @RetainerBillingKey IS NULL
			RETURN -103		

		EXEC sptBillingRecalcTotals @RetainerBillingKey

		-- Should be approved and set SalesAccountKey			
		UPDATE tBilling 
		SET    Status = 4
		      ,DefaultSalesAccountKey = @SalesAccountKey 
		WHERE BillingKey = @RetainerBillingKey
		
	END
		
	-- Add labor 
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   tProject (NOLOCK) 
		WHERE  CompanyKey = @CompanyKey 
		AND    RetainerKey = @RetainerKey
		AND	   ProjectKey > @ProjectKey
		AND    ISNULL(Closed, 0) = 0
		AND    NonBillable = 0
	
		IF @ProjectKey IS NULL
			BREAK
			
		IF @IncludeLabor = 0 
			-- If retainer does not include labor, Action = Bill = 1 
			INSERT #tBillingDetail
				(
				ProjectKey,
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
			SELECT  @ProjectKey, 'tTime', NULL, TimeKey, 1, Comments
					, ISNULL(ActualHours, 0), ISNULL(ActualRate, 0), ROUND(ActualHours * ActualRate, 2)
					,tTime.ServiceKey, tTime.RateLevel
			FROM    tTime (NOLOCK), tTimeSheet (nolock)
			WHERE   tTimeSheet.CompanyKey = @CompanyKey
			AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
			AND		tTime.ProjectKey = @ProjectKey
			AND		tTimeSheet.Status = 4
			AND     InvoiceLineKey IS NULL
			AND     (WriteOff IS NULL OR WriteOff = 0)
			AND		ISNULL(tTime.OnHold, 0) = 0
			AND     WorkDate <= @ThruDate
			AND		TimeKey NOT IN (SELECT bd.EntityGuid
								FROM tBillingDetail bd (NOLOCK)
									INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
								WHERE b.CompanyKey = @CompanyKey
								AND   bd.Entity = 'tTime'  
								AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5
								)
								
		ELSE
		BEGIN
			-- If retainer includes labor, Action = Mark as Billed for services in tRetainerItems 
			INSERT #tBillingDetail
				(
				ProjectKey,
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
			SELECT  @ProjectKey, 'tTime', NULL, TimeKey, 2, Comments
				, ISNULL(ActualHours, 0), ISNULL(ActualRate, 0), ROUND(ActualHours * ActualRate, 2)
				,tTime.ServiceKey, tTime.RateLevel
			FROM    tTime (NOLOCK), tTimeSheet (nolock)
			WHERE   tTimeSheet.CompanyKey = @CompanyKey
			AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
			AND		tTime.ProjectKey = @ProjectKey
			AND		tTimeSheet.Status = 4
			AND     InvoiceLineKey IS NULL
			AND     (WriteOff IS NULL OR WriteOff = 0)
			AND		ISNULL(tTime.OnHold, 0) = 0
			AND     WorkDate <= @ThruDate
			AND		TimeKey NOT IN (SELECT bd.EntityGuid
								FROM tBillingDetail bd (NOLOCK)
									INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
								WHERE b.CompanyKey = @CompanyKey
								AND   bd.Entity = 'tTime'
								AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5
								)
			AND		tTime.ServiceKey IN (SELECT EntityKey FROM tRetainerItems (NOLOCK)
										WHERE Entity = 'tService'
										AND   RetainerKey = @RetainerKey)
			
			-- And Action = Bill for others not in tRetainerItems 
			INSERT #tBillingDetail
				(
				ProjectKey,
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
			SELECT  @ProjectKey, 'tTime', NULL, TimeKey, 1, Comments
				,ISNULL(ActualHours, 0), ISNULL(ActualRate, 0), ROUND(ActualHours * ActualRate, 2)
				,tTime.ServiceKey, tTime.RateLevel
			FROM    tTime (NOLOCK), tTimeSheet (nolock)
			WHERE   tTimeSheet.CompanyKey = @CompanyKey
			AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
			AND		tTime.ProjectKey = @ProjectKey
			AND		tTimeSheet.Status = 4
			AND     InvoiceLineKey IS NULL
			AND     (WriteOff IS NULL OR WriteOff = 0)
			AND		ISNULL(tTime.OnHold, 0) = 0
			AND     WorkDate <= @ThruDate
			AND		TimeKey NOT IN (SELECT bd.EntityGuid
								FROM tBillingDetail bd (NOLOCK)
									INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
								WHERE b.CompanyKey = @CompanyKey 
								AND   bd.Entity = 'tTime'
								AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5
								)
			AND		(tTime.ServiceKey IS NULL OR tTime.ServiceKey NOT IN (SELECT EntityKey FROM tRetainerItems (NOLOCK)
										WHERE Entity = 'tService'
										AND   RetainerKey = @RetainerKey)
					)
		END				

			
	END
	
	
	-- Add expenses
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tProject (NOLOCK) 
			WHERE  CompanyKey = @CompanyKey 
			AND    RetainerKey = @RetainerKey
			AND	   ProjectKey > @ProjectKey
			AND    ISNULL(Closed, 0) = 0
			AND    NonBillable = 0
			
			IF @ProjectKey IS NULL
				BREAK


			-- Expense receipts
			
			IF @IncludeExpense = 1
			BEGIN
				-- The retainer includes expenses
				-- Bill (i.e. Action = 1) items or expense types not in tRetainerItems
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tExpenseReceipt', ExpenseReceiptKey, NULL, 1, 
				ISNULL(ActualQty, 0), ISNULL(ActualUnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock)
				WHERE   ProjectKey = @ProjectKey
				AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
				AND		tExpenseEnvelope.Status = 4
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tExpenseReceipt.OnHold, 0) = 0
				AND     ExpenseDate <= @ThruDate
				AND		ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tExpenseReceipt'
								AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
				AND		(ItemKey IS NULL
						OR ItemKey NOT IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
				AND		tExpenseReceipt.VoucherDetailKey IS NULL
						
				-- The ones in tRetainerItems must be marked as Billed (i.e. Action = 2)		
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tExpenseReceipt', ExpenseReceiptKey, NULL, 2, 
				ISNULL(ActualQty, 0), ISNULL(ActualUnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock)
				WHERE   ProjectKey = @ProjectKey
				AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
				AND		tExpenseEnvelope.Status = 4
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tExpenseReceipt.OnHold, 0) = 0
				AND     ExpenseDate <= @ThruDate
				AND		ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tExpenseReceipt'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
				AND		(ItemKey IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
				AND		tExpenseReceipt.VoucherDetailKey IS NULL
				
			
			END
			ELSE
			BEGIN
				-- The retainer does not include expenses
				-- Bill all items or expense types
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tExpenseReceipt', ExpenseReceiptKey, NULL, 1, 
				ISNULL(ActualQty, 0), ISNULL(ActualUnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock)
				WHERE   ProjectKey = @ProjectKey
				AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
				AND		tExpenseEnvelope.Status = 4
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tExpenseReceipt.OnHold, 0) = 0
				AND     ExpenseDate <= @ThruDate
				AND		ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tExpenseReceipt'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
				AND		tExpenseReceipt.VoucherDetailKey IS NULL
								
			END



			-- Misc Cost
			
			IF @IncludeExpense = 1
			BEGIN
				-- The retainer includes expenses
				-- Bill items or expense types not in tRetainerItems
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tMiscCost', MiscCostKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tMiscCost (NOLOCK)
				WHERE   ProjectKey = @ProjectKey
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tMiscCost.OnHold, 0) = 0
				AND ExpenseDate <= @ThruDate
				AND		MiscCostKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tMiscCost'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
				AND		(ItemKey IS NULL
						OR ItemKey NOT IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
			
				-- The ones in tRetainerItems must be marked as Billed i.e. Action = 2		
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tMiscCost', MiscCostKey, NULL, 2, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tMiscCost (NOLOCK)
				WHERE   ProjectKey = @ProjectKey
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tMiscCost.OnHold, 0) = 0
				AND     ExpenseDate <= @ThruDate
				AND		MiscCostKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tMiscCost'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
				AND		(ItemKey  IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
   				
			END
			ELSE
			BEGIN
				-- The retainer does not include expenses
				-- Includes all items or expense types  Bill
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tMiscCost', MiscCostKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tMiscCost (NOLOCK)
				WHERE   ProjectKey = @ProjectKey
				AND     InvoiceLineKey IS NULL
				AND     (WriteOff IS NULL OR WriteOff = 0)
				AND		ISNULL(tMiscCost.OnHold, 0) = 0
				AND     ExpenseDate <= @ThruDate
				AND		MiscCostKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tMiscCost'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)
			
			END



			-- Vouchers
			
			IF @IncludeExpense = 1
			BEGIN
				-- The retainer includes expenses
				-- Just includes items or expense types not in tRetainerItems
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tVoucherDetail', vd.VoucherDetailKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tVoucherDetail vd (NOLOCK)
						,tVoucher       v  (NOLOCK)
				WHERE   vd.ProjectKey = @ProjectKey
				AND     vd.InvoiceLineKey IS NULL
				AND     ISNULL(vd.WriteOff, 0) = 0
				AND      vd.VoucherKey = v.VoucherKey
				AND		v.Status = 4
				AND		ISNULL(vd.OnHold, 0) = 0
				AND     (@ThruDateOption = 1 AND v.InvoiceDate <= @ThruDate
					OR
					@ThruDateOption = 2 AND v.PostingDate <= @ThruDate)		
				AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tVoucherDetail'
							AND b.ProjectKey = @ProjectKey
								AND   b.Status < 5)	
				AND		(vd.ItemKey IS NULL
						OR vd.ItemKey NOT IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
			
				-- The ones in tRetainerItems must be marked as Billed i.e. Action = 2		
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tVoucherDetail', vd.VoucherDetailKey, NULL, 2, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tVoucherDetail vd (NOLOCK)
						,tVoucher       v (NOLOCK)
				WHERE   vd.ProjectKey = @ProjectKey
				AND  vd.InvoiceLineKey IS NULL
				AND		ISNULL(vd.WriteOff, 0) = 0
				AND      vd.VoucherKey = v.VoucherKey
				AND		v.Status = 4
				AND		ISNULL(vd.OnHold, 0) = 0
				AND     (@ThruDateOption = 1 AND v.InvoiceDate <= @ThruDate
					OR
					@ThruDateOption = 2 AND v.PostingDate <= @ThruDate)			
				AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tVoucherDetail'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)	
				AND		(vd.ItemKey IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
   				
			END
			ELSE
			BEGIN
				-- The retainer does not include expenses
				-- Includes all items or expense types 
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tVoucherDetail', vd.VoucherDetailKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), ISNULL(BillableCost, 0)
				FROM    tVoucherDetail vd (NOLOCK)
						,tVoucher       v  (NOLOCK)
				WHERE   vd.ProjectKey = @ProjectKey
				AND     vd.InvoiceLineKey IS NULL
				AND     ISNULL(vd.WriteOff, 0) = 0
				AND      vd.VoucherKey = v.VoucherKey
				AND		v.Status = 4
				AND		ISNULL(vd.OnHold, 0) = 0
				AND     (@ThruDateOption = 1 AND v.InvoiceDate <= @ThruDate
					OR
					@ThruDateOption = 2 AND v.PostingDate <= @ThruDate)			
				AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tVoucherDetail'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)	

			END

					-- POs
		
		/* According to McClain do not include orders
		
			IF @IncludeExpense = 1
			BEGIN
				-- The retainer includes expenses
				-- Just includes items or expense types not in tRetainerItems
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), 
				CASE po.BillAt 
					WHEN 0 THEN ISNULL(BillableCost, 0)
					WHEN 1 THEN ISNULL(TotalCost,0)
					WHEN 2 THEN ISNULL(BillableCost,0) - ISNULL(TotalCost,0) 
				END
				FROM    tPurchaseOrderDetail pod (NOLOCK)
						,tPurchaseOrder po  (NOLOCK)
				WHERE   pod.ProjectKey = @ProjectKey
				AND     pod.InvoiceLineKey IS NULL
				AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
				AND		ISNULL(pod.AppliedCost, 0) = 0
				AND		pod.Closed = 0
				AND		ISNULL(pod.AmountBilled, 0) = 0
				AND		po.Status = 4
				AND		ISNULL(pod.OnHold, 0) = 0
				AND     ((po.POKind = 0 AND po.PODate <= @ThruDate) -- Reg POs
							OR
						 (po.POKind = 1 AND pod.DetailOrderDate <= @ThruDate) -- IOs
						  	OR
						 (po.POKind = 2 AND pod.DetailOrderEndDate <= @ThruDate) -- BCs
						)
				AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tPurchaseOrderDetail'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)					
				AND		(pod.ItemKey IS NULL
						OR pod.ItemKey NOT IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND   Entity = 'tItem')
						)
			
				-- The ones in tRetainerItems must be marked as Billed i.e. Action = 2		
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL, 2, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0), 
				CASE po.BillAt 
					WHEN 0 THEN ISNULL(BillableCost, 0)
					WHEN 1 THEN ISNULL(TotalCost,0)
					WHEN 2 THEN ISNULL(BillableCost,0) - ISNULL(TotalCost,0) 
				END
				FROM    tPurchaseOrderDetail pod (NOLOCK)
						,tPurchaseOrder po  (NOLOCK)
				WHERE   pod.ProjectKey = @ProjectKey
				AND     pod.InvoiceLineKey IS NULL
				AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
				AND		ISNULL(pod.AppliedCost, 0) = 0
				AND		pod.Closed = 0
				AND		ISNULL(pod.AmountBilled, 0) = 0
				AND		po.Status = 4
				AND		ISNULL(pod.OnHold, 0) = 0
				AND     ((po.POKind = 0 AND po.PODate <= @ThruDate) -- Reg POs
							OR
						 (po.POKind = 1 AND pod.DetailOrderDate <= @ThruDate) -- IOs
						  	OR
						 (po.POKind = 2 AND pod.DetailOrderEndDate <= @ThruDate) -- BCs
						)
				AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tPurchaseOrderDetail'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)					
				AND		(pod.ItemKey  IN 
							(SELECT EntityKey FROM tRetainerItems (NOLOCK) 
							 WHERE  RetainerKey = @RetainerKey
							 AND    Entity = 'tItem')
						)
						
			END
			ELSE
			BEGIN
				-- The retainer does not include expenses
				-- Includes all items or expense types 
				INSERT #tBillingDetail
					(
					ProjectKey,
					Entity,
					EntityKey,
					EntityGuid,
					Action,
					Quantity,
					Rate,
					Total
					)
				SELECT  @ProjectKey, 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, NULL, 1, 
				ISNULL(Quantity, 0), ISNULL(UnitCost, 0),
				CASE po.BillAt 
					WHEN 0 THEN ISNULL(BillableCost, 0)
					WHEN 1 THEN ISNULL(TotalCost,0)
					WHEN 2 THEN ISNULL(BillableCost,0) - ISNULL(TotalCost,0) 
				END
				FROM    tPurchaseOrderDetail pod (NOLOCK)
						,tPurchaseOrder po  (NOLOCK)
				WHERE   pod.ProjectKey = @ProjectKey
				AND     pod.InvoiceLineKey IS NULL
				AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
				AND		ISNULL(pod.AppliedCost, 0) = 0
				AND		pod.Closed = 0
				AND		ISNULL(pod.AmountBilled, 0) = 0
				AND		po.Status = 4
				AND		ISNULL(pod.OnHold, 0) = 0
				AND     ((po.POKind = 0 AND po.PODate <= @ThruDate) -- Reg POs
							OR
						 (po.POKind = 1 AND pod.DetailOrderDate <= @ThruDate) -- IOs
						  	OR
						 (po.POKind = 2 AND pod.DetailOrderEndDate <= @ThruDate) -- BCs
						)
				AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey 
							AND   bd.Entity = 'tPurchaseOrderDetail'
							AND   b.ProjectKey = @ProjectKey
								AND   b.Status < 5)					
			
			END --IF @IncludeExpense = 1

			*/
			
		END	-- WHILE(1=1)
			
	UPDATE #tBillingDetail
	SET	 Rate = ROUND(Total / Quantity, 3)	
	WHERE  Quantity <> 0
	AND    Entity <> 'tTime'
		
	DECLARE @ProjectNumber VARCHAR(50)
			,@BillingCount INT
			,@MasterBillingNeeded INT
			
	SELECT @BillingCount = COUNT(DISTINCT ProjectKey) 
	FROM   #tBillingDetail 
	
	IF @RetainerBillingKey IS NOT NULL
		SELECT @BillingCount = @BillingCount + 1

	-- We create a Master if more than 1 billing worksheet AND we do not Invoice separately
	IF @BillingCount > 1 AND @InvoiceExtrasSeparate = 0
		SELECT @MasterBillingNeeded = 1
	ELSE
		SELECT @MasterBillingNeeded = 0
	 		
	IF @MasterBillingNeeded = 1
	BEGIN
		-- Create a master ws for the retainer 
		EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
		, 1, NULL, 'RetainerMaster', @RetainerKey, NULL, NULL, NULL, NULL, @InvoiceApprovedBy, 0, null
		, @DueDate, @DefaultAsOfDate, @ContactKey, @BillingAddressKey, @GLCompanyKey, @OfficeKey, NULL, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT

		IF @Ret < 0
		BEGIN
			EXEC sptBillingDelete @RetainerBillingKey
			RETURN @Ret
		END
		IF @MasterBillingKey IS NULL
		BEGIN
			EXEC sptBillingDelete @RetainerBillingKey
			RETURN -102			
		END
			
		EXEC sptBillingAddChild @MasterBillingKey, @RetainerBillingKey	

		EXEC sptBillingRecalcTotals @RetainerBillingKey

	END
	
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tBillingDetail (NOLOCK) 
		WHERE  ProjectKey > @ProjectKey
	
		IF @ProjectKey IS NULL
			BREAK
		
		SELECT @BillingKey = NULL
		
		SELECT @ProjectNumber = ProjectNumber 
			   ,@ProjectApprovedBy = ISNULL(AccountManager, @InvoiceApprovedBy)	
		FROM tProject (NOLOCK) 
		WHERE ProjectKey = @ProjectKey
		
		-- Pass GLCompanyKey = null, OfficeKey = null, sptBillingInsert should retrieve from tProject
		-- Hopefully GLCompanyKey will match the retainer (validation already there in sptProjectUpdate)
		SELECT @WorkSheetComment = 'Billing worksheet generated for retainer: '+@Title+' and project: '+@ProjectNumber 
		EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, @ProjectKey, @ClassKey, 1, @WorkSheetComment, NULL
		, 0, NULL, 'Project', @ProjectKey, 'RetainerMaster', @RetainerKey, NULL, NULL, @ProjectApprovedBy, 0, null
		, @DueDate, @DefaultAsOfDate, @ContactKey, @BillingAddressKey, NULL, NULL, NULL, @UserKey, NULL, @BillingKey OUTPUT

		IF @BillingKey IS NULL
			SELECT @ErrorOccurred = 1		
		ELSE
		BEGIN		
			IF @MasterBillingNeeded = 1
				EXEC sptBillingAddChild @MasterBillingKey, @BillingKey	
			
			INSERT tBillingDetail (BillingKey,
						Entity,
						EntityKey,
						EntityGuid,
						Comments,
						Action,
						Quantity,
						Rate,
						Total,
						GeneratedTotal,
						RateLevel,
						ServiceKey)
			SELECT 		@BillingKey,
						Entity,
						EntityKey,
						EntityGuid,
						Comments,
						Action,
						Quantity,
						Rate,
						Total,
						CASE WHEN Action = 1 THEN Total
						ELSE 0 END,
						RateLevel,
						ServiceKey
			FROM   #tBillingDetail WHERE ProjectKey = @ProjectKey
			
			UPDATE tBillingDetail
			SET	   AsOfDate = @DefaultAsOfDate	
			WHERE  BillingKey = @BillingKey
			AND    Action in (0, 2, 5) -- WO, MasB, Xfers


			Select @GeneratedLabor = Sum(GeneratedTotal) from tBillingDetail (nolock) 
			Where BillingKey = @BillingKey and Action = 1 and EntityGuid is not null
			
			Select @GeneratedExpense = Sum(GeneratedTotal) from tBillingDetail (nolock) 
			Where BillingKey = @BillingKey and Action = 1 and EntityGuid is null
			
			Update tBilling 
			Set    GeneratedLabor = @GeneratedLabor
				,GeneratedExpense = @GeneratedExpense
			Where  BillingKey = @BillingKey

			EXEC sptBillingRecalcTotals @BillingKey
										
		END
	END


	-- Rollup generated totals to master
	IF @MasterBillingNeeded = 1
	BEGIN
		Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
		Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
		
		Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
		Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

		Select @GeneratedLabor = ISNULL(@GeneratedLabor, 0)
				,@GeneratedExpense = ISNULL(@GeneratedExpense, 0)

		UPDATE tBilling
		SET    GeneratedLabor = @GeneratedLabor
				,GeneratedExpense = @GeneratedExpense
		WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
	END
							
	IF @ErrorOccurred = 1
		RETURN -104
	ELSE 				
		RETURN 1
GO
