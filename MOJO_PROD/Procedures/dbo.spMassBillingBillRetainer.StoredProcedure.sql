USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBillRetainer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMassBillingBillRetainer]
	(
		 @CompanyKey int
		,@ClientKey int
		,@RetainerKeys varchar(8000) -- one retainer if InvoiceBy = 0, otherwise comma separated
		,@InvoiceBy int -- 0 By Retainer, 1 By Client, 2 By Client Parent
		,@ThruDate datetime
		,@InvoiceDate datetime
		,@PostingDate datetime
		,@DefaultClassKey INT = NULL
		,@CreateAsApproved INT = 0
	)
	
AS --Encrypt

  /*
  || When     Who Rel     What
  || 02/23/07 GHL 8.4     Added Project Rollup sections
  || 05/03/07 GHL 8.4.2.1 Added ClassKey for Partners Napier
  || 07/05/07 GHL 8.5     Added logic for GLCompanyKey and OfficeKey
  || 07/09/07 GHL 8.5     Restricting ER to VoucherDetailKey null  
  || 07/31/07 GHL 8.5     removed refs to expense types       
  || 09/21/07 GHL 8.437   Complete rewrite for Enh 13169
  ||                      must be able to invoice retainers by client (see pseudocode below)
  || 12/12/07 GHL 8.5     (17879) Added reading of tRetainer.ClassKey
  || 04/08/08 GHL 8.508 (23712) Added new logic for classes  
  || 08/28/09 GHL 10.508 (60241) Change if RetainerAmount > 0 to if RetainerAmount >= 0,  because it can be 0 now
  || 09/02/09 RLB 10.509 (61624) Updating ProjectRollup for all Projects on that Retainer
  || 09/02/09 GHL 10.509 (61425) Use ThruDate not Invoice Date to determine retainer status  
  || 11/13/09 GHL 10.513 (67962) Went back to Invoice Date to determine retainer status
  ||                     but the Invoice Date is shown on the UI now so users can change it
  || 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0 
  || 04/26/12 GHL 10.555 (141647) Added CreateAsApproved param  
  || 09/10/12 RLB 10.560 (87856) Changes made for enhancement  
  || 10/07/13 GHL 10.573 Made changes for multi currency
  */

/*
get a list of retainers into a temp table #tRetainer(RetainerKey, GLCompanyKey, IncludeExpense, IncludeLabor, InvoiceExpensesSeperate, LineFormat, InvoiceApprovedBy)

create #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, ItemKey, InvoiceExpensesSeperate)
create #tProcWIPKeys (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, InvoiceLineKey, LineFormat)

for each retainer, determine retainer amount 
and insert #tProcWIPKeysKeep and Action = -1 (so that not picked up by other stored procs) even if retainer amount = 0 
EntityType = 'Retainer'

insert transaction records in #tProcWIPKeysKeep, determine Action =1 or 2 based on retainer's characteristics

for each GLCompanyKey
begin
	truncate #tProcWIPKeys
	copy #tProcWIPKeysKeep into #tProcWIPKeys where GLCompanyKey and InvoiceExpensesSeperate = 0

	call spProcessWIPWorksheet with parameters on the client

end

for each ProjectKey and InvoiceExpensesSeperate = 1
begin
	truncate #tProcWIPKeys
	copy #tProcWIPKeysKeep into #tProcWIPKeys where ProjectKey and InvoiceExpensesSeperate = 1

	call spProcessWIPWorksheet with parameters on the Project

end
*/
	SET NOCOUNT ON

	create table #tRetainer (RetainerKey int null
							,GLCompanyKey int null
							,OfficeKey int null
							,ClassKey int null
							,IncludeExpense int null
							,IncludeLabor int null
							,InvoiceExpensesSeperate int null
							,LineFormat int null
							,InvoiceApprovedBy int null
							,CurrencyID varchar(10) null
							,CurrencyKey int null -- we will need to loop by currency
							)
	
	create table #tProcWIPKeysKeep (RetainerKey int null
							,ProjectKey int null					
							,EntityType varchar(20) null
							,EntityKey varchar(50) null
							,AmountBilled money null
							,Action int null
							,ItemKey int null
							,InvoiceExpensesSeperate int null)			

	create table #tProcWIPKeys (RetainerKey int null
							,ProjectKey int null					
							,EntityType varchar(20) null
							,EntityKey varchar(50) null
							,AmountBilled money null
							,Action int null
							,InvoiceLineKey int null
							,LineFormat int null)			
																	
	DECLARE @MyStatement As VARCHAR(8000)
	DECLARE @UseGLCompany int
	DECLARE @RequireGLCompany int
	DECLARE @RetainerAmount money
	DECLARE	@CanBillRetainer INT
	DECLARE @GLCompanyKey int
	DECLARE @RetainerKey int
	DECLARE @ProjectKey int
	DECLARE @OfficeKey int
	DECLARE @ClassKey int
	DECLARE @InvoiceApprovedBy int
	DECLARE @Ret int
	DECLARE @LineFormat int
		
	IF @ClientKey IS NULL
	BEGIN
		SELECT @RetainerKey = CAST (@RetainerKeys AS INT)
		SELECT @ClientKey = ClientKey FROM tRetainer (NOLOCK) WHERE RetainerKey = @RetainerKey 
	END
			
	-- for a particular retainer/client
	IF @InvoiceBy IN (0, 1)	
	BEGIN	
		SELECT @MyStatement = '	INSERT #tRetainer (RetainerKey, GLCompanyKey, OfficeKey, ClassKey, IncludeExpense, IncludeLabor, InvoiceExpensesSeperate, LineFormat, InvoiceApprovedBy) ' 
		SELECT @MyStatement = @MyStatement + ' SELECT RetainerKey, ISNULL(GLCompanyKey, 0), ISNULL(OfficeKey, 0) , ISNULL(ClassKey, 0), IncludeExpense, IncludeLabor, InvoiceExpensesSeperate, LineFormat,InvoiceApprovedBy FROM tRetainer (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE CompanyKey = ' + CAST(@CompanyKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND ClientKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND RetainerKey IN (' + @RetainerKeys + ')'
	END
	ELSE
	-- for a particular client parent
	BEGIN	
		SELECT @MyStatement = '	INSERT #tRetainer (RetainerKey, GLCompanyKey, OfficeKey, ClassKey, IncludeExpense, IncludeLabor, InvoiceExpensesSeperate, LineFormat, InvoiceApprovedBy) ' 
		SELECT @MyStatement = @MyStatement + ' SELECT RetainerKey, ISNULL(GLCompanyKey, 0) ,ISNULL(OfficeKey, 0), ISNULL(ClassKey, 0), IncludeExpense, IncludeLabor, InvoiceExpensesSeperate, LineFormat, InvoiceApprovedBy FROM tRetainer (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE CompanyKey = ' + CAST(@CompanyKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND ( ClientKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' OR ClientKey IN (SELECT CompanyKey FROM tCompany (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE ParentCompanyKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' )) '
		SELECT @MyStatement = @MyStatement + ' AND RetainerKey IN (' + @RetainerKeys + ')'
	END
	
	EXEC ( @MyStatement )	
	

	SELECT @UseGLCompany = ISNULL(UseGLCompany, 0), @RequireGLCompany = ISNULL(RequireGLCompany, 0)
	FROM tPreference (NOLOCK)
	WHERE CompanyKey = @CompanyKey			

	IF @UseGLCompany = 1 And @RequireGLCompany = 1 AND EXISTS (SELECT 1 FROM #tRetainer WHERE GLCompanyKey = 0)
		RETURN -1000

	IF @ThruDate IS NULL
		SELECT @ThruDate = '01/01/2050'

	-- Currency 
	DECLARE @CurrencyID varchar(10), @CurrencyKey int

	-- at this time, get the currency from the project
	update 	#tRetainer
	set     #tRetainer.CurrencyID = r.CurrencyID
	from    tRetainer r (nolock)
	where   #tRetainer.RetainerKey = r.RetainerKey

	update 	#tRetainer
	set     #tRetainer.CurrencyKey = 0
	
	-- We must manufacture CurrencyKey to use in the loops
	-- CurrencyKey initialized at 0 -- Home Currency
	select @CurrencyID = ''
	Select @CurrencyKey = 1
	while (1=1)
	begin
		select @CurrencyID = min(CurrencyID)
		from   #tRetainer
		where  CurrencyID is not null
		and    CurrencyID > @CurrencyID

		if @CurrencyID is null
			break

		update #tRetainer
		set    CurrencyKey = @CurrencyKey 
		where  CurrencyID = @CurrencyID

		select @CurrencyKey = @CurrencyKey + 1
	end

	-- Get the retainer amounts
	SELECT @RetainerKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @RetainerKey = MIN(RetainerKey)
		FROM   #tRetainer
		WHERE  RetainerKey > @RetainerKey
		
		IF @RetainerKey IS NULL
			BREAK
		 	
		EXEC @CanBillRetainer = sptRetainerGetAmount @RetainerKey, @InvoiceDate, @RetainerAmount OUTPUT
		If @CanBillRetainer <> 1
			Select @RetainerAmount = 0
		
		-- Insert with Action = -1 so that it is not picked up by other sps	
		INSERT #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, InvoiceExpensesSeperate )
		SELECT @RetainerKey, 0, 'Retainer', @RetainerKey, @RetainerAmount, -1, 0
					
	END
	
	-- Now capture the transactions, Action = 1 i.e. Bill for now
	INSERT  #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, ItemKey, InvoiceExpensesSeperate)
	SELECT  r.RetainerKey, t.ProjectKey, 'Time', cast(TimeKey as VARCHAR(50)),
			round(isnull(t.ActualHours,0)*isnull(t.ActualRate,0), 2), 1, t.ServiceKey, r.InvoiceExpensesSeperate
	FROM    #tRetainer r 
			INNER JOIN tProject p (NOLOCK) ON r.RetainerKey = p.RetainerKey
			INNER JOIN tTime t (NOLOCK) ON p.ProjectKey = t.ProjectKey
		    INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
	WHERE   p.CompanyKey = @CompanyKey 
	AND     p.NonBillable = 0
	AND     p.Closed = 0
	AND		ts.Status = 4
	AND     t.InvoiceLineKey IS NULL
	AND     ISNULL(t.WriteOff, 0) = 0
	AND		ISNULL(t.OnHold, 0) = 0
	AND     t.WorkDate <= @ThruDate
	AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5
			AND   bd.EntityGuid = t.TimeKey  
			AND   bd.Entity = 'tTime'
			)
	
	INSERT  #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, ItemKey, InvoiceExpensesSeperate)
	SELECT  r.RetainerKey, mc.ProjectKey, 'MiscExpense', cast(mc.MiscCostKey as VARCHAR(50)), 
			isnull(mc.BillableCost, 0), 1, mc.ItemKey, r.InvoiceExpensesSeperate
	FROM    #tRetainer r 
			INNER JOIN tProject p (NOLOCK) ON r.RetainerKey = p.RetainerKey
			INNER JOIN tMiscCost mc (NOLOCK) ON p.ProjectKey = mc.ProjectKey
	WHERE   p.CompanyKey = @CompanyKey 
	AND     p.NonBillable = 0
	AND     p.Closed = 0
	AND     mc.InvoiceLineKey IS NULL
	AND     ISNULL(mc.WriteOff, 0) = 0
	AND		ISNULL(mc.OnHold, 0) = 0
	AND     mc.ExpenseDate <= @ThruDate
   	AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
			WHERE bill.CompanyKey = @CompanyKey
			AND   bill.Status < 5 -- Not Invoiced				
			AND   bd.EntityKey = mc.MiscCostKey  
			AND bd.Entity = 'tMiscCost'
			)

	INSERT  #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, ItemKey, InvoiceExpensesSeperate)
	SELECT  r.RetainerKey, er.ProjectKey, 'Expense', cast(er.ExpenseReceiptKey as VARCHAR(50)),
			isnull(er.BillableCost, 0), 1, er.ItemKey, r.InvoiceExpensesSeperate
	FROM    #tRetainer r 
			INNER JOIN tProject p (NOLOCK) ON r.RetainerKey = p.RetainerKey
			INNER JOIN tExpenseReceipt er (NOLOCK) ON p.ProjectKey = er.ProjectKey
			INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	WHERE   p.CompanyKey = @CompanyKey 
	AND     p.NonBillable = 0
	AND     p.Closed = 0
	AND		ee.Status = 4
	AND     er.InvoiceLineKey IS NULL
	AND     ISNULL(er.WriteOff, 0) = 0
	AND		ISNULL(er.OnHold, 0) = 0
	AND     er.ExpenseDate <= @ThruDate
	AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5
			AND   bd.EntityKey = er.ExpenseReceiptKey  
			AND   bd.Entity = 'tExpenseReceipt'
			)
	AND		er.VoucherDetailKey IS NULL

	INSERT  #tProcWIPKeysKeep (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, ItemKey, InvoiceExpensesSeperate)
	SELECT  r.RetainerKey, vd.ProjectKey, 'Voucher', cast(vd.VoucherDetailKey as VARCHAR(50)),
			isnull(vd.BillableCost, 0), 1, vd.ItemKey, r.InvoiceExpensesSeperate
	FROM    #tRetainer r 
			INNER JOIN tProject p (NOLOCK) ON r.RetainerKey = p.RetainerKey
		    INNER JOIN tVoucherDetail vd (NOLOCK) ON p.ProjectKey = vd.ProjectKey
			INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	WHERE   p.CompanyKey = @CompanyKey 
	AND     p.NonBillable = 0
	AND     p.Closed = 0
	AND		v.Status = 4
	AND     vd.InvoiceLineKey IS NULL
	AND     ISNULL(vd.WriteOff, 0) = 0
	AND		ISNULL(vd.OnHold, 0) = 0
	AND     v.InvoiceDate <= @ThruDate		
	AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5
			AND   bd.EntityKey = vd.VoucherDetailKey  
			AND   bd.Entity = 'tVoucherDetail'
			)

	-- According to McClain, do not include orders on retainers 
	
	-- All transactions have Action=1 Bill, now look at the retainer's characteristics to Mark As Billed

	UPDATE #tProcWIPKeysKeep
	SET    #tProcWIPKeysKeep.Action = 2 -- MARK AS BILLED
	FROM   #tRetainer r
		   ,tRetainerItems ri (NOLOCK)
	WHERE  #tProcWIPKeysKeep.RetainerKey = r.RetainerKey
	AND    r.RetainerKey = ri.RetainerKey
	AND	   r.IncludeLabor = 1							-- if it includes labor
	AND    #tProcWIPKeysKeep.ItemKey = ri.EntityKey		-- AND covered by tRetainerItems ri
	AND    #tProcWIPKeysKeep.EntityType = 'Time'
	AND    ri.Entity = 'tService'
	AND    #tProcWIPKeysKeep.Action = 1	

	UPDATE #tProcWIPKeysKeep
	SET    #tProcWIPKeysKeep.Action = 2 -- MARK AS BILLED
	FROM   #tRetainer r
		   ,tRetainerItems ri (NOLOCK)
	WHERE  #tProcWIPKeysKeep.RetainerKey = r.RetainerKey
	AND    r.RetainerKey = ri.RetainerKey
	AND	   r.IncludeExpense = 1							-- if it include expenses
	AND    #tProcWIPKeysKeep.ItemKey = ri.EntityKey		-- AND covered by tRetainerItems ri
	AND    #tProcWIPKeysKeep.EntityType <> 'Time'
	AND    ri.Entity = 'tItem'
	AND    #tProcWIPKeysKeep.Action = 1	


	-- Let us include the transaction Mark As Billed with the main invoices
	-- It really does not matter, so process them now
	UPDATE #tProcWIPKeysKeep
	SET    InvoiceExpensesSeperate = 0
	WHERE  Action = 2

	-- Now create one invoice per GLCompanyKey and this client
	SELECT @GLCompanyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GLCompanyKey = MIN(GLCompanyKey)
		FROM   #tRetainer 
		WHERE  GLCompanyKey > @GLCompanyKey
		
		IF @GLCompanyKey IS NULL
			BREAK

		SELECT @CurrencyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrencyKey = MIN(CurrencyKey)
			FROM   #tRetainer 
			WHERE  GLCompanyKey   =  @GLCompanyKey	
			AND    CurrencyKey    >  @CurrencyKey
					
			IF @CurrencyKey IS NULL
				BREAK

			select @CurrencyID = CurrencyID from #tRetainer
			where  CurrencyKey =  @CurrencyKey -- All separate currency IDs should have same key

			-- if same office, we will set it on the invoice header, otherwise NULL
			IF (SELECT COUNT(DISTINCT OfficeKey) FROM #tRetainer WHERE GLCompanyKey = @GLCompanyKey AND CurrencyKey = @CurrencyKey) = 1
				SELECT @OfficeKey = OfficeKey FROM #tRetainer WHERE GLCompanyKey = @GLCompanyKey AND CurrencyKey = @CurrencyKey
			ELSE
				SELECT @OfficeKey = NULL
			IF @OfficeKey = 0
				SELECT OfficeKey = NULL	
	
			-- For ClassKey, we can take the default
			IF (SELECT COUNT(DISTINCT ClassKey) FROM #tRetainer WHERE GLCompanyKey = @GLCompanyKey AND CurrencyKey = @CurrencyKey) = 1
				SELECT @ClassKey = ClassKey FROM #tRetainer WHERE GLCompanyKey = @GLCompanyKey AND CurrencyKey = @CurrencyKey
			ELSE
				SELECT @ClassKey = NULL
	
			-- we have no way to decide who approves, pick one at random
			-- we could pick the default approver
			SELECT @InvoiceApprovedBy = InvoiceApprovedBy FROM #tRetainer WHERE GLCompanyKey = @GLCompanyKey  AND CurrencyKey = @CurrencyKey
					
			TRUNCATE TABLE #tProcWIPKeys
			INSERT  #tProcWIPKeys (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action, InvoiceLineKey, LineFormat)
			SELECT 	k.RetainerKey, k.ProjectKey, k.EntityType, k.EntityKey, k.AmountBilled, k.Action, 0, r.LineFormat
			FROM    #tProcWIPKeysKeep k
				   INNER JOIN #tRetainer r ON k.RetainerKey = r.RetainerKey
			WHERE   r.GLCompanyKey = @GLCompanyKey
			AND     r.CurrencyKey = @CurrencyKey
			AND     k.InvoiceExpensesSeperate = 0  -- Include extras with main invoice		
	
			-- change to retainer type

			if @InvoiceBy = 0
			BEGIN
				-- set the RetainerKey because it is null because the retainer amount loop there should only be one retainer when billed this way
				SELECT @RetainerKey = MIN(RetainerKey) From #tRetainer
				SELECT @InvoiceBy = 5
		
				-- Rollup = NULL will be determined by SP, comes from retainer
				EXEC @Ret = spProcessWIPWorksheet @RetainerKey, @InvoiceBy, NULL, @InvoiceApprovedBy, NULL, 1, 
					@InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved, NULL, @CurrencyID

				-- If positive, this is an invoice key, not an error	
				IF @Ret > 0
					 EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret

				-- How can we report errors?


			END
			ELSE
			BEGIN
				SELECT @InvoiceBy = 4
		
				-- Rollup = NULL will be determined by SP, comes from retainer
				EXEC @Ret = spProcessWIPWorksheet @ClientKey, @InvoiceBy, NULL, @InvoiceApprovedBy, NULL, 1, 
					@InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved, NULL, @CurrencyID

				-- If positive, this is an invoice key, not an error	
				IF @Ret > 0
					 EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret

				-- How can we report errors?


			END

		END -- Currency loop		

	END -- end GL company loop
	
	
	-- now the case InvoiceExpensesSeperate = 1, we invoice expenses separately by project	
	SELECT @LineFormat = ISNULL(DefaultARLineFormat, 0) FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey 
	SELECT @LineFormat = 0 -- for now
	
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tProcWIPKeysKeep  
		WHERE  ProjectKey > @ProjectKey
		AND    InvoiceExpensesSeperate = 1
		AND    Action = 1
		
		IF @ProjectKey IS NULL
			BREAK

		SELECT @RetainerKey = RetainerKey FROM #tProcWIPKeysKeep WHERE ProjectKey = @ProjectKey

		-- we could default office from retainer or project
		SELECT @OfficeKey = OfficeKey, @ClassKey = ClassKey  FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey
		IF ISNULL(@OfficeKey, 0) = 0
			SELECT @OfficeKey = OfficeKey FROM #tRetainer WHERE RetainerKey = @RetainerKey 
		IF @OfficeKey = 0
			SELECT OfficeKey = NULL	
		
		-- Get approver and GLCompany from retainer
		SELECT @InvoiceApprovedBy = InvoiceApprovedBy, @GLCompanyKey = GLCompanyKey FROM #tRetainer WHERE RetainerKey = @RetainerKey
					
		TRUNCATE TABLE #tProcWIPKeys
		-- Other fields are not important here  
		INSERT  #tProcWIPKeys (RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action)
		SELECT 	RetainerKey, ProjectKey, EntityType, EntityKey, AmountBilled, Action
		FROM    #tProcWIPKeysKeep
		WHERE   ProjectKey = @ProjectKey
		AND     InvoiceExpensesSeperate = 1  		
		AND     Action = 1
	
		SELECT @InvoiceBy = 0 -- Invoice by Project

		-- Rollup for spProcessWIPWoksheet is LineFormat from client and will get the currency from the project	 
		EXEC @Ret = spProcessWIPWorksheet @ProjectKey ,@InvoiceBy, @LineFormat, @InvoiceApprovedBy, NULL, 1, 
			@InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved

        -- commented this out since we are rolling up at end
		-- If positive, this is an invoice key, not an error	
		--IF @Ret > 0
		--	EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret
		
		-- How can we report errors?

	END

        SELECT @ProjectKey = -1
	    WHILE (1=1)
	    BEGIN
		    SELECT @ProjectKey = MIN(ProjectKey)
		    FROM   #tProcWIPKeysKeep  
		    WHERE  ProjectKey > @ProjectKey
		
		
		    IF @ProjectKey IS NULL
			    BREAK

	    EXEC sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1

    END
	RETURN 1
GO
