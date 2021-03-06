USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesGroupByBillingItem]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesGroupByBillingItem]
	(
	@CompanyKey int
	,@LayoutKey int
	,@RootEntity varchar(50)
	,@RootEntityKey int
	,@WorkTypeCustomEntity varchar(50)
	,@WorkTypeCustomEntityKey int
	)
AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel    What
  || 05/25/10 GHL 10.530 Creation: purpose is to convert a list of items/services to a list of lines grouped by layout
  || 12/02/10 GHL 10.539 Added RootEntity and RootEntityKey parameters because the initial design was
  ||
  ||                     Billing Item 1
  ||                         Item 1
  ||                         Service 1
  ||                     Billing Item 2
  ||                         Item 2
  ||                         Item 3
  ||                     Item 4
  ||                     No Item
  ||
  ||                     What is now actually needed:
  ||
  ||                     Project 1                      
  ||                         Billing Item 1
  ||                             Item 1
  ||                             Service 1
  ||                         Billing Item 2
  ||                             Item 2
  ||                             Item 3
  ||                         Item 4
  ||                        No Item
  ||                      Project 2
  ||
  || 01/17/11  GHL 10.540 (100559) Eliminated LineDescription (line 238) from insert/select distinct sequence 
  ||                      because it is failing in SQL 2000. Surprising because the select distinct
  ||                      was not failing by itself, but was failing in conjunction with insert 
  ||                       
  */

/* debugging
	create table #item (
		Entity varchar(50) null
		,EntityKey int null
		,RootEntity varchar(50) null
		,RootEntityKey int null
		)


insert #item (Entity, EntityKey) values ('tItem', 55)
insert #item (Entity, EntityKey) values ('tService', 35)
insert #item (Entity, EntityKey) values ('tService', 30)
insert #item (Entity, EntityKey) values ('tItem', 5)
insert #item (Entity, EntityKey) values ('tService', 31)
insert #item (Entity, EntityKey) values ('tService', 36)
insert #item (Entity, EntityKey) values ('tService', 0)
insert #item (Entity, EntityKey) values ('tItem', 0)

delete #item where EntityKey = 55

 
select * from tItem where CompanyKey = 100



spBillingLinesGroupByBillingItem 100, 0, 'tCampaign', 3


delete tLayoutBilling where Entity = 'tItem' and EntityKey = 5

*/

	-- Input
	/*
	create table #item (
		Entity varchar(50) null
		,EntityKey int null
		,RootEntity varchar(50) null
		,RootEntityKey int null
		)

	-- Output
    create table #line(
		LineKey INT IDENTITY(1,1)
		,ParentLineKey int null
		,LineSubject varchar(500) null
		,LineDescription text null
		,Entity varchar(50) null
		,EntityKey int null
		,WorkTypeKey int null
		
		,DisplayOrder int null
		,NewDisplayOrder int null
		,InvoiceOrder int null
		,DisplayOption int null
		,LineType int null

		,RootEntity varchar(50) null
		,RootEntityKey int null

		)


	*/

	DECLARE @kNoItemDisplayOrder INT SELECT @kNoItemDisplayOrder = 9999 -- At bottom, -1 At top

	-- need also this one for the sorts
	CREATE TABLE #sorted(SortedKey INT IDENTITY(1,1), LineKey INT NULL)  

	-- get current items, assume under the root
    insert #line(ParentLineKey, Entity, EntityKey, RootEntity, RootEntityKey)
	select 0, Entity, EntityKey, RootEntity, RootEntityKey
	from   #item
	where  RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    RootEntityKey = @RootEntityKey 
	
	--select @RootEntityKey
	--select * from #item
	--select * from #line

	update #line 
	set    #line.LineSubject = i.ItemName
	      ,#line.LineDescription = i.StandardDescription
    from   tItem i (nolock) 
	where  #line.Entity = 'tItem'
	and    #line.EntityKey = i.ItemKey
	and    RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    RootEntityKey = @RootEntityKey 
	
	update #line 
	set    #line.LineSubject = '[No Item]'
	      ,#line.LineDescription = '[No Item]'
    where  #line.Entity = 'tItem'
	and    #line.EntityKey = 0
	and    RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    RootEntityKey = @RootEntityKey 
	
	update #line 
	set    #line.LineSubject = s.Description
	      ,#line.LineDescription = s.InvoiceDescription
    from   tService s (nolock) 
	where  #line.Entity = 'tService'
	and    #line.EntityKey = s.ServiceKey
	and    RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    RootEntityKey = @RootEntityKey 
	
	update #line 
	set    #line.LineSubject = '[No Service]'
	      ,#line.LineDescription = '[No Service]'
    where  #line.Entity = 'tService'
	and    #line.EntityKey = 0
	and    RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    RootEntityKey = @RootEntityKey 
	

	-- First set the WorkTypeKey based on LayoutKey or not

	if @LayoutKey > 0
	begin
		
		update #line
		set    #line.WorkTypeKey = 0
		       ,#line.DisplayOrder = 0
		where  RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    RootEntityKey = @RootEntityKey 
	       
		update #line
		set    #line.WorkTypeKey = lb.ParentEntityKey
		      ,#line.DisplayOrder = lb.DisplayOrder
		      ,#line.DisplayOption = lb.DisplayOption
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #line.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #line.EntityKey = lb.EntityKey
		and    lb.ParentEntity = 'tWorkType'
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
		update #line
		set    #line.WorkTypeKey = 0
		      ,#line.DisplayOrder = lb.DisplayOrder
		      ,#line.DisplayOption = lb.DisplayOption
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #line.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #line.EntityKey = lb.EntityKey
		and    lb.ParentEntity = 'tProject'
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
		update #line
		set    #line.DisplayOrder = @kNoItemDisplayOrder
		where  #line.DisplayOrder = 0
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
	end
	else
	begin
		-- no layout
		update #line
		set    #line.WorkTypeKey = 0
		where  RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    RootEntityKey = @RootEntityKey 
	
		update #line
		set    #line.WorkTypeKey = isnull(s.WorkTypeKey, 0)
		from   tService s (nolock)
		where  #line.Entity = 'tService'
		and    #line.EntityKey = s.ServiceKey
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
		update #line
		set    #line.WorkTypeKey = isnull(i.WorkTypeKey, 0)
		from   tItem i (nolock)
		where  #line.Entity = 'tItem'
		and    #line.EntityKey = i.ItemKey
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
		update #line
		set    #line.DisplayOrder = @kNoItemDisplayOrder
		where  #line.WorkTypeKey = 0
		and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
	
	end


	-- Next create the new lines for the billing items ...(100559) removed LineDescription here
	INSERT #line (Entity, EntityKey, LineSubject, DisplayOrder, RootEntity, RootEntityKey
		,  WorkTypeKey, ParentLineKey)
	SELECT distinct 'tWorkType', wt.WorkTypeKey, wt.WorkTypeName, 0,@RootEntity, @RootEntityKey
		, wt.WorkTypeKey, 0
	FROM   #line (nolock)
		INNER JOIN tWorkType wt (nolock) ON #line.WorkTypeKey = wt.WorkTypeKey 
	where  #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    #line.RootEntityKey = @RootEntityKey 
	ORDER BY wt.WorkTypeName		

	-- had to do that because Description is a text field...distinct does not work
	update #line
	set    #line.LineDescription = wt.Description
	from   tWorkType wt (nolock)
	where  #line.Entity = 'tWorkType'
    and    #line.EntityKey = wt.WorkTypeKey
	and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    #line.RootEntityKey = @RootEntityKey 
	
	if @WorkTypeCustomEntityKey > 0
	begin
		update #line
		set    #line.LineSubject = cust.Subject
				,#line.LineDescription = cust.Description
		from   tWorkTypeCustom cust (nolock)
		where  #line.EntityKey = cust.WorkTypeKey
		and    #line.Entity = 'tWorkType'
		and    cust.Entity = @WorkTypeCustomEntity COLLATE DATABASE_DEFAULT
		and    cust.EntityKey = @WorkTypeCustomEntityKey  
		and    #line.Entity = 'tWorkType'
	    and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	    and    #line.RootEntityKey = @RootEntityKey 
			 			
	end
	
	if @LayoutKey > 0
    update #line
    set    #line.DisplayOrder = lb.DisplayOrder
	      ,#line.DisplayOption = lb.DisplayOption
    from   tLayoutBilling lb (nolock)
    where  lb.LayoutKey = @LayoutKey
    and    lb.Entity = 'tWorkType'
    and    #line.Entity = 'tWorkType' 
    and    #line.EntityKey = lb.EntityKey	
	and    #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT
	and    #line.RootEntityKey = @RootEntityKey 
	
	-- On a layout, there could be a [No Billing Item] if we just added a billing item and it is not saved yet in the layout
	-- Without a layout, we could have an item without a BI
	-- in both cases we should handling the case when ther is no BI
	if @LayoutKey > 0
		if exists (select * from #line where Entity <> 'tWorkType' and WorkTypeKey = 0 and DisplayOrder = 0 
		        and RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and RootEntityKey = @RootEntityKey)
				INSERT #line (Entity, EntityKey, LineSubject, LineDescription, DisplayOrder, RootEntity, RootEntityKey
					,  WorkTypeKey, ParentLineKey)
				SELECT 'tWorkType', 0, '[No Billing Item]', '[No Billing Item]', @kNoItemDisplayOrder,@RootEntity, @RootEntityKey
					, 0, 0
	
	if @LayoutKey = 0
	begin
		if exists (select * from #line where Entity <> 'tWorkType' and WorkTypeKey = 0
		        and RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and RootEntityKey = @RootEntityKey)
				INSERT #line (Entity, EntityKey, LineSubject, LineDescription, DisplayOrder, RootEntity, RootEntityKey
					,  WorkTypeKey, ParentLineKey)
				SELECT 'tWorkType', 0, '[No Billing Item]', '[No Billing Item]', @kNoItemDisplayOrder,@RootEntity, @RootEntityKey
					, 0, 0		
		
		update #line set DisplayOrder = isnull(DisplayOrder, 0)  
		where RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and RootEntityKey = @RootEntityKey

	end

	/* 2 possibilities

	No BillingItem
		No Item
		No Service
		Item 1
		Service 3

	or

	No Billing Item
		Item 1
		Service 2
	No Item
	No Service
	*/

	
	-- now update the parent lines 	
	UPDATE #line
	SET    #line.ParentLineKey = ISNULL((
		SELECT MAX(l.LineKey) FROM #line l WHERE l.Entity = 'tWorkType' and l.WorkTypeKey = #line.WorkTypeKey
		and l.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and l.RootEntityKey = @RootEntityKey
	),0)
	WHERE #line.Entity <> 'tWorkType'
	and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey		
	
	--select * from #line

	DECLARE @DisplayOrder INT
	DECLARE @ParentLineKey INT
	DECLARE @LineKey INT
	DECLARE @SortedKey INT
	
	-- these need to be resorted!!
	IF @LayoutKey = 0
		INSERT #sorted (LineKey)
		SELECT LineKey
		FROM   #line
		WHERE  ParentLineKey = 0
		and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
		ORDER BY DisplayOrder, LineSubject -- this is why we need this sorted table...will be sorted by alphabetical order
	ELSE
		INSERT #sorted (LineKey)
		SELECT LineKey
		FROM   #line
		WHERE  ParentLineKey = 0
		and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
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
			
		UPDATE #line
		SET    NewDisplayOrder = @DisplayOrder
		WHERE  LineKey = @LineKey
		
		SELECT @DisplayOrder = @DisplayOrder + 1
			
	END

	--select * from #line
	
	-- now assign the display order for the lines under each parent
	SELECT @ParentLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ParentLineKey = MIN(ParentLineKey)
		FROM   #line
		WHERE  ParentLineKey <> 0
		AND    ParentLineKey > @ParentLineKey 
	    and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

		IF @ParentLineKey IS NULL
			BREAK
		
		-- these need to be resorted!!
		TRUNCATE TABLE #sorted
		 
		IF @LayoutKey = 0 
			INSERT #sorted (LineKey)
			SELECT LineKey
			FROM   #line
			WHERE  ParentLineKey = @ParentLineKey
			and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
			ORDER BY DisplayOrder, LineSubject 
		ELSE
			INSERT #sorted (LineKey)
			SELECT LineKey
			FROM   #line
			WHERE  ParentLineKey = @ParentLineKey
			and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
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
				
			UPDATE #line
			SET    NewDisplayOrder = @DisplayOrder
			WHERE  LineKey = @LineKey
			and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

			SELECT @DisplayOrder = @DisplayOrder + 1
				
		END
					
	END


	DECLARE @InvoiceOrder int
	DECLARE @ChildDisplayOrder int
	DECLARE @ChildLineKey int

	IF @RootEntity = 'tCampaign'
		select @InvoiceOrder = 1
    ELSE
	BEGIN
		select @InvoiceOrder = MAX(InvoiceOrder) from #line
		
		SELECT @InvoiceOrder = isnull(@InvoiceOrder, 0) + 1
	END

	select @DisplayOrder = -1
	while (1=1)
	begin
		select  @DisplayOrder = min(NewDisplayOrder)
		from    #line 
		where   ParentLineKey = 0
		and     NewDisplayOrder >  @DisplayOrder
		and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

		if @DisplayOrder is null
			break

		select @LineKey = LineKey
		from   #line
		where  ParentLineKey = 0
		and    NewDisplayOrder =  @DisplayOrder
		and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

		update #line
		set    #line.InvoiceOrder = @InvoiceOrder
		where  LineKey = @LineKey
		and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

		select @InvoiceOrder = @InvoiceOrder + 1

		if exists (select 1 from #line where ParentLineKey = @LineKey)
		begin
		
			select @ChildDisplayOrder = -1
			while (1=1)
			begin
				select  @ChildDisplayOrder = min(NewDisplayOrder)
				from    #line 
				where   ParentLineKey = @LineKey
				and     NewDisplayOrder > @ChildDisplayOrder
				and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

				if @ChildDisplayOrder is null
					break

				select @ChildLineKey = LineKey
				from   #line
				where  ParentLineKey = @LineKey
				and    NewDisplayOrder =  @ChildDisplayOrder
				and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

				update #line
				set    #line.InvoiceOrder = @InvoiceOrder
				where  LineKey = @ChildLineKey
				and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

				select @InvoiceOrder = @InvoiceOrder + 1

			end
		end
		
	end

update #line set LineType = 2 where #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
update #line set LineType = 1 where LineKey in (select ParentLineKey from #line where #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey) 
and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

	-- by default
	-- I apply the SubItemDetail disp option to summary tasks
	-- I apply the NoDetail disp option to detail tasks
	
	update #line
	set    DisplayOption = 2 --@kDisplayOptionSubItemDetail
	where  LineType = 1 -- @kLineTypeSummary
    and    isnull(DisplayOption, 0) = 0
    and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey
    	
	update #line
	set    DisplayOption = 1 -- @kDisplayOptionNoDetail
	where  LineType = 2 -- @kLineTypeDetail
    and    isnull(DisplayOption, 0) = 0
	and #line.RootEntity = @RootEntity COLLATE DATABASE_DEFAULT and #line.RootEntityKey = @RootEntityKey

--select * from #line order by ParentLineKey, NewDisplayOrder
--select * from #line order by InvoiceOrder

RETURN 1
GO
