USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGroupFFByBillingItem]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGroupFFByBillingItem]
	(
	@InvoiceKey int
	,@TopParentLineKey int = 0 -- this would be the ParentLineKey for the project in the case of master billing WS 
	                           -- or 0 (the root) when no master billing WS is involved
	                           -- or 0 (the root) when used from the fixed_fees.aspx  
	,@CalcInvoiceOrder int = 0 -- Do not calculate the InvoiceOrder when calling from billing WS
	)
AS --Encrypt

/*
|| When      Who   Rel    What
|| 06/25/09  GHL   10.027 (50759) Creation of sptInvoiceLineGroupFFByBillingItem to reorganize 
||                        FF invoice lines by billing Item in a way similar to the TM invoice lines.
||                        In FF, we already had a way to create lines first by service
||                        then by item, we can simply reorg the lines...
||
||                        Current FF process creates lines for services first then items 
||                        Services should not be linked to billing item
||                        Sort the lines by subject    
||                        
||                        Create invoice lines for billing items (tWorkType)
||                        Then determine ParentLineKey and DisplayOrder
||                        Then call sptInvoiceOrder to determine InvoiceOrder and LineLevel
|| 08/14/09  GHL   10.507 (60056) Now the services must be organized under billing items
|| 05/20/10  GHL   10.522 Added logic for Layout + campaign segments
||                        Added cascading of billing item down to underlying lines
*/
	SET NOCOUNT ON 
	
	DECLARE @kNoItemDisplayOrder INT SELECT @kNoItemDisplayOrder = 9999 -- At bottom, -1 At top

	CREATE TABLE #lines (
	     -- fields captured from tInvoiceLine
	     Entity varchar(50) null -- 'tService', 'tItem' and 'tWorkType' for new lines
	    ,EntityKey int null 
	    ,LineSubject varchar(100) null -- debug purpose only
	    ,Description text null -- for the new lines
	    ,DisplayOrder int null
		,InvoiceLineKey int null
		,WorkTypeKey int null
		,ParentLineKey int null -- will hold initial and final parent line
		,DisplayOption int null
		
		-- fields used for calcs
		,LineKey int identity(1,1)
		,NewDisplayOrder int null
		,NewParentLineKey int null -- will hold temporary parent line key for items under billing item
		)
		
	-- need also this one for the sorts
	CREATE TABLE #sorted(SortedKey INT IDENTITY(1,1), LineKey INT NULL)  
		
	SELECT @TopParentLineKey = ISNULL(@TopParentLineKey, 0) 
		
	-- capture all the lines, this will populate only InvoiceLineKey 	
	exec sptInvoiceLineGetDetailLines @InvoiceKey, @TopParentLineKey	
	
	update #lines
	set    #lines.Entity = il.Entity
	      ,#lines.EntityKey = il.EntityKey
		  ,#lines.LineSubject = il.LineSubject
		  ,#lines.Description = il.LineDescription
		  ,#lines.WorkTypeKey = il.WorkTypeKey
		  ,#lines.ParentLineKey = il.ParentLineKey
		  ,#lines.DisplayOrder = il.DisplayOrder -- by default, take current display order		  
	from   tInvoiceLine il (nolock)
    where  #lines.InvoiceLineKey = il.InvoiceLineKey
	  
	declare @LayoutKey int
	declare @CampaignKey int
	declare @CampaignSegmentKey int
	  
	select @LayoutKey  = isnull(LayoutKey, 0)
	      ,@CampaignKey = isnull(CampaignKey, 0)
	from   tInvoice (nolock) 
	where  InvoiceKey = @InvoiceKey
		  
	-- should be cascaded down to the underlying lines		  
	select @CampaignSegmentKey = CampaignSegmentKey -- keep null
	from   tInvoiceLine (nolock) 
	where  InvoiceLineKey = @TopParentLineKey
		  
	if @CampaignSegmentKey = 0
		select @CampaignSegmentKey = null -- because we will update the invoice lines
			  
	if @LayoutKey > 0
	begin
		
		update #lines
		set    #lines.WorkTypeKey = 0
		       ,#lines.DisplayOrder = 0
		       
		update #lines
		set    #lines.WorkTypeKey = lb.ParentEntityKey
		      ,#lines.DisplayOrder = lb.DisplayOrder
		      ,#lines.DisplayOption = lb.DisplayOption
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #lines.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #lines.EntityKey = lb.EntityKey
		and    lb.ParentEntity = 'tWorkType'
		
		update #lines
		set    #lines.WorkTypeKey = 0
		      ,#lines.DisplayOrder = lb.DisplayOrder
		      ,#lines.DisplayOption = lb.DisplayOption
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #lines.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #lines.EntityKey = lb.EntityKey
		and    lb.ParentEntity = 'tProject'

		update #lines
		set    #lines.DisplayOrder = @kNoItemDisplayOrder
		where  #lines.DisplayOrder = 0
		
	end
	else
	begin
		-- no layout
		update #lines
		set    #lines.WorkTypeKey = 0
		
		update #lines
		set    #lines.WorkTypeKey = isnull(s.WorkTypeKey, 0)
		from   tService s (nolock)
		where  #lines.Entity = 'tService'
		and    #lines.EntityKey = s.ServiceKey
		
		update #lines
		set    #lines.WorkTypeKey = isnull(i.WorkTypeKey, 0)
		from   tItem i (nolock)
		where  #lines.Entity = 'tItem'
		and    #lines.EntityKey = i.ItemKey

		update #lines
		set    #lines.DisplayOrder = @kNoItemDisplayOrder
		where  #lines.WorkTypeKey = 0
		
	end
				
	
	-- Next create the new lines for the billing items
	INSERT #lines (Entity, EntityKey, LineSubject, DisplayOrder
		, InvoiceLineKey, WorkTypeKey, ParentLineKey, NewParentLineKey)
	SELECT distinct 'tWorkType', wt.WorkTypeKey, wt.WorkTypeName, 0
		, 0,wt.WorkTypeKey, @TopParentLineKey, @TopParentLineKey
	FROM   #lines (nolock)
		INNER JOIN tWorkType wt (nolock) ON #lines.WorkTypeKey = wt.WorkTypeKey 
	ORDER BY wt.WorkTypeName		
	
	-- Now update entity specific WorkTypeNames
	if isnull(@CampaignKey, 0) >0
	UPDATE	#lines
	SET		#lines.LineSubject = cust.Subject
		   ,#lines.Description = cust.Description
	FROM	tWorkTypeCustom cust (nolock)
	WHERE	#lines.WorkTypeKey = cust.WorkTypeKey
	AND		cust.Entity = 'tCampaign'
	AND		cust.EntityKey = @CampaignKey
    AND     #lines.Entity = 'tWorkType'
    
    if isnull(@CampaignSegmentKey, 0) >0
	UPDATE	#lines
	SET		#lines.LineSubject = cust.Subject
		   ,#lines.Description = cust.Description
	FROM	tWorkTypeCustom cust (nolock)
	WHERE	#lines.WorkTypeKey = cust.WorkTypeKey
	AND		cust.Entity = 'tCampaignSegment'
	AND		cust.EntityKey = @CampaignSegmentKey
    AND     #lines.Entity = 'tWorkType'
    
    
    if @LayoutKey > 0
    update #lines
    set    #lines.DisplayOrder = lb.DisplayOrder
    from   tLayoutBilling lb (nolock)
    where  lb.LayoutKey = @LayoutKey
    and    lb.Entity = 'tWorkType'
    and    #lines.Entity = 'tWorkType' 
    and    #lines.EntityKey = lb.EntityKey
     
	-- now update the parent lines 	
	UPDATE #lines
	SET    #lines.NewParentLineKey = ISNULL((
		SELECT MAX(l.LineKey) FROM #lines l WHERE l.Entity = 'tWorkType' and l.WorkTypeKey = #lines.WorkTypeKey
	),0)
	WHERE #lines.Entity <> 'tWorkType'
			
	IF @TopParentLineKey > 0
	BEGIN
		UPDATE #lines
		SET    #lines.NewParentLineKey = @TopParentLineKey
		WHERE  ISNULL(#lines.NewParentLineKey, 0) = 0
	END		
		
	--select * from #lines

	DECLARE @DisplayOrder INT
	DECLARE @ParentLineKey INT
	DECLARE @LineKey INT
	DECLARE @SortedKey INT
	
	-- these need to be resorted!!
	IF @LayoutKey = 0
		INSERT #sorted (LineKey)
		SELECT LineKey
		FROM   #lines
		WHERE  NewParentLineKey = @TopParentLineKey
		ORDER BY LineSubject -- this is why we need this sorted table...will be sorted by alphabetical order
	ELSE
		INSERT #sorted (LineKey)
		SELECT LineKey
		FROM   #lines
		WHERE  NewParentLineKey = @TopParentLineKey
		ORDER BY DisplayOrder -- DisplayOrder from the layout but we may have some gaps/holes due to some missing items/BIs
		
		
	-- assign the display order for the lines under the root/Top Summary line
	SELECT @SortedKey = -1
	SELECT @DisplayOrder = 1
	WHILE (1=1)
	BEGIN
		SELECT @SortedKey = MIN(SortedKey)
		FROM   #sorted
		WHERE  SortedKey > @SortedKey
		 
		IF @SortedKey IS NULL
			BREAK
			
		SELECT @LineKey = LineKey
		FROM   #sorted
		WHERE  SortedKey = @SortedKey
			
		UPDATE #lines
		SET    NewDisplayOrder = @DisplayOrder
		WHERE  LineKey = @LineKey
		
		SELECT @DisplayOrder = @DisplayOrder + 1
			
	END

	--select * from #lines
	
	-- now assign the display order for the lines under each parent
	SELECT @ParentLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ParentLineKey = MIN(NewParentLineKey)
		FROM   #lines
		WHERE  NewParentLineKey <> @TopParentLineKey
		AND    NewParentLineKey > @ParentLineKey 
	
		IF @ParentLineKey IS NULL
			BREAK
		
		-- these need to be resorted!!
		TRUNCATE TABLE #sorted
		 
		IF @LayoutKey = 0 
			INSERT #sorted (LineKey)
			SELECT LineKey
			FROM   #lines
			WHERE  NewParentLineKey = @ParentLineKey
			ORDER BY LineSubject 
		ELSE
			INSERT #sorted (LineKey)
			SELECT LineKey
			FROM   #lines
			WHERE  NewParentLineKey = @ParentLineKey
			ORDER BY DisplayOrder 
				
		-- assign the display order for the lines under the root/Top Summary line
		SELECT @SortedKey = -1
		SELECT @DisplayOrder = 1
		WHILE (1=1)
		BEGIN
			SELECT @SortedKey = MIN(SortedKey)
			FROM   #sorted
			WHERE  SortedKey > @SortedKey
			 
			IF @SortedKey IS NULL
				BREAK
				
			SELECT @LineKey = LineKey
			FROM   #sorted
			WHERE  SortedKey = @SortedKey
				
			UPDATE #lines
			SET    NewDisplayOrder = @DisplayOrder
			WHERE  LineKey = @LineKey
			
			SELECT @DisplayOrder = @DisplayOrder + 1
				
		END
					
	END

	--select * from #lines order by NewParentLineKey, NewDisplayOrder
	--return

	-- now insert missing invoice lines	

	DECLARE @InvoiceLineKey INT
	DECLARE @LineSubject VARCHAR(200)
	DECLARE @WorkTypeKey INT
	DECLARE @LineLevel int
	
	IF @TopParentLineKey = 0
		SELECT @LineLevel = 0 -- not important will be recalced by sptInvoiceOrder
	ELSE
		SELECT @LineLevel = 1
		
	SELECT @LineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @LineKey = MIN(LineKey)
		FROM   #lines 
		WHERE  Entity = 'tWorkType'
		AND    LineKey > @LineKey
		
		IF @LineKey IS NULL
			BREAK

		-- get the data to insert an invoice line
		SELECT @LineSubject = LineSubject
		      ,@DisplayOrder = NewDisplayOrder
		      ,@WorkTypeKey = EntityKey
		FROM   #lines 
		WHERE  Entity = 'tWorkType'
		AND    LineKey = @LineKey
		
		INSERT tInvoiceLine (
			InvoiceKey
			,LineSubject
			,LineType
			,BillFrom
			,Quantity
			,UnitAmount
			,TotalAmount
		    ,PostSalesUsingDetail
		    ,SalesAccountKey
		    ,ParentLineKey
		    ,DisplayOrder
		    ,LineLevel
		    ,InvoiceOrder
		    ,SalesTaxAmount
		    ,SalesTax1Amount
		    ,SalesTax2Amount
		    ,Taxable
		    ,Taxable2
		    ,WorkTypeKey
		    ,CampaignSegmentKey
		    )
		 SELECT @InvoiceKey
			,@LineSubject
			,1 -- LineType = Summary
			,1 -- BillFrom = FF
 			,0 --Quantity
			,0 --UnitAmount
			,0 --TotalAmount
		    ,0--PostSalesUsingDetail
		    ,0-- SalesAccountKey
		    ,@TopParentLineKey
		    ,@DisplayOrder
		    ,@LineLevel
		    ,0--InvoiceOrder
		    ,0--SalesTaxAmount
		    ,0--SalesTax1Amount
		    ,0--SalesTax2Amount   
		    ,0--Taxable
		    ,0--Taxable2
		    ,@WorkTypeKey
		    ,@CampaignSegmentKey
		    

		SELECT @InvoiceLineKey = @@IDENTITY

		UPDATE #lines SET InvoiceLineKey = @InvoiceLineKey WHERE LineKey = @LineKey
					
		-- save the new invoice line key on the lines under this billing item
		UPDATE #lines SET ParentLineKey = @InvoiceLineKey WHERE NewParentLineKey = @LineKey
					
	END	
	
	
	/*
	select * from #lines 
	
	delete tInvoiceLine 
	from   #lines l
	where  tInvoiceLine.InvoiceLineKey = l.InvoiceLineKey 
	and    l.Entity = 'tWorkType'
	and    tInvoiceLine.InvoiceKey = @InvoiceKey
	
	update tInvoiceLine
	set    ParentLineKey = 0
	where  tInvoiceLine.InvoiceKey = @InvoiceKey
	
	*/
	
	
	UPDATE tInvoiceLine
	SET    tInvoiceLine.ParentLineKey = l.ParentLineKey
	      ,tInvoiceLine.DisplayOrder = l.NewDisplayOrder
	      ,tInvoiceLine.WorkTypeKey = l.WorkTypeKey -- cascade down the BI
	      ,tInvoiceLine.CampaignSegmentKey =  @CampaignSegmentKey
	      ,tInvoiceLine.LineDescription =  l.Description
	      ,tInvoiceLine.DisplayOption =  l.DisplayOption
	FROM   #lines l
	WHERE  tInvoiceLine.InvoiceKey = @InvoiceKey
	AND    tInvoiceLine.InvoiceLineKey = l.InvoiceLineKey

	-- by default
	-- I apply the SubItemDetail disp option to summary tasks
	-- I apply the NoDetail disp option to detail tasks
	
	update tInvoiceLine
	set    DisplayOption = 2 --@kDisplayOptionSubItemDetail
	where  InvoiceKey = @InvoiceKey
	and    LineType = 1 -- @kLineTypeSummary
    and    isnull(DisplayOption, 0) = 0
    	
	update tInvoiceLine
	set    DisplayOption = 1 -- @kDisplayOptionNoDetail
	where  InvoiceKey = @InvoiceKey
	and    LineType = 2 -- @kLineTypeDetail
    and    isnull(DisplayOption, 0) = 0
    
	-- only do this when there is no master billing WS 
	IF @CalcInvoiceOrder = 1
		EXEC sptInvoiceOrder @InvoiceKey, 0, 0, 0


	RETURN 1
GO
