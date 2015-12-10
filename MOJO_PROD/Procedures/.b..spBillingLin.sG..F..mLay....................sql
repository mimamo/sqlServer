USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesGetFromLayout]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesGetFromLayout]
	(
	@CompanyKey int
	,@LayoutKey int
	,@WorkTypeCustomEntity varchar(50)
	,@WorkTypeCustomEntityKey int
	,@DefaultSalesAccountKey int = -1
	,@BillingClassKey int = -1
	,@DefaultClassKey int = -2
	,@GetItemInfo int = 1
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel    What
|| 03/26/10 GHL 10.521 Creation for new layouts  
|| 04/02/10 GHL 10.522 Added DisplayOption
|| 04/22/10 GHL 10.522 Added Distinct when inserting lines
||
||                     Inputs:
||                     1) Parameters
||                     2) list of transactions to organize in #tran
||                     3) tLayoutBilling (for structure and display orders)
||                     4) tWorkTypeCustom (for names)
||
||                     Outputs:
||                     list of lines in #line ready to be inserted in tInvoiceLine
||                     list of transactions in #tran (will need this to update actual transaction with InvoiceLineKey) 
||
||                     Default Class from : 
||                     1) Class from project, estimate, client, etc...
||                     2) If none on the project, estimate, client, get class from Item
||                     3) If none on the project/item, get class from billing item
||                     4) If none on the project/item/billing Item use Default Class  
||
||                     GL account from:
||                     1) from item
||                     2) if none on item, get from billing item
||                     3) if none on item/billing item, get from default
||
||                     Get the Taxable/taxable2 fields from Item or Service
||
||                     Example:
||                                  
||                            ==> with a layout      
||                            Item 0            <-- this could happen on the layout
||                            Billing Item 1    <-- Summary Line
||                               Item 1
||                               Item 2
||                               Service 1 
||                            Service 2
||                            Billing Item 2    <--- Summary Line
||                               Item 3
||                               Item 4
||                            Item 5            <-- Item 5 has no Billing Item
||                            No Item/Service   <-- No Item or Service 
||
||
||                            ==> without a layout      
||                            Billing Item 1    <-- Summary Line
||                               Item 1
||                               Item 2
||                               Service 1 
||                            Service 2
||                            Billing Item 2    <--- Summary Line
||                               Item 3
||                               Item 4
||                            Item 5            <-- Item 5 has no Billing Item
||                            No Item/Service   <-- No Item or Service 
*/

/*-- To debug, just comment out this line

--For Debugging cut and paste this in Query Analyzer
--exec spBillingLinesGetFromLayout 100, 2, 'tCampaign', 15
--exec spBillingLinesGetFromLayout 100, 0, 'tCampaign', 15
	
  CREATE TABLE #tran(
	Entity varchar(20) null,		-- like in tBillingDetail, tMiscCost, tTime, etc.... 
	EntityKey varchar(50) null,     -- transaction key
	EntityGuid uniqueidentifier null,
	
	BilledAmount money null,
	Quantity decimal(24,4) null,
	RateLevel int null,
	Rate money null,
	BilledComment varchar(2000),
	
	LayoutEntityKey int null,       -- ItemKey or ServiceKey depending on LayoutEntity

	-- All fields above should be set before this SP 
		
	LayoutEntity varchar(50) null,   -- like in tLayoutBilling, tItem, tService
	LayoutOrder int null,	
	WorkTypeLayoutOrder int null,
		
	WorkTypeKey int null,
	WorkTypeName varchar(200) null, 
	ItemName varchar(200) null,     -- will come from item or service
	
	InvoiceLineKey int null,
	LineID int null,
	
	UpdateFlag int null
	)
	
	CREATE TABLE #line(
	LineID int identity(1,1),
	ParentLineID int null,
	InvoiceLineKey int null,
	ParentLineKey int null,
	
	BilledAmount money null,
	Quantity decimal(24,4) null,
	UnitCost money null,
	
	Subject VARCHAR(200) null,
	Description text null,
	Taxable int null,
	Taxable2 int null,
	ClassKey int null,
	SalesAccountKey int null,
	
	WorkTypeKey int null,
	ItemKey int null, 
	ServiceKey int null,
	
	LayoutOrder int null, -- just for initial pull
	
	DisplayOption int null,
	
	UpdateFlag int null
	)


	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tMiscCost', 123, null, 1000, 10, 1, 100, null,  5) -- Color Copies
	
	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tMiscCost', 456, null, 2000, 20, 1, 100, null,  4) -- Account Planning

	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tMiscCost', 457, null, 2000, 20, 1, 100, null,  4) -- Account Planning

	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tMiscCost', 458, null, 2000, 20, 1, 100, null,  4) -- Account Planning
	
	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tMiscCost', 789, null, 2500, 20, 1, 100, null,  0) -- No item
	
	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tTime', 123123, null, 3000, 20, 1, 100, null,  30) -- Art Design

	insert #tran(Entity,EntityKey,EntityGuid, BilledAmount,Quantity,RateLevel,Rate,BilledComment,LayoutEntityKey)
	values ('tTime', 456456, null, 5000, 20, 1, 100, null,  114) -- No WorkType

*/

	select @LayoutKey = isnull(@LayoutKey, 0)
	
	if not exists (select 1 from tLayout (nolock) where LayoutKey = @LayoutKey)
		select @LayoutKey = 0

if @GetItemInfo = 1
begin
	-- we need some valid display orders for billing items and items and services in the case when LayoutKey = 0
	-- also we will need the names and descriptions
	-- so my strategy was to get them upfront
	create table #allitems (Entity varchar(20) null, EntityKey int, WorkTypeKey int
	    , EntityName varchar(200) null, Description text null
	    , StdEntityName varchar(200) null, StdDescription text null
	    , DisplayOrder int null 
	    , SalesAccountKey int null,ClassKey int null, Taxable int null, Taxable2 int null
		)
	
	insert #allitems (Entity, EntityKey, WorkTypeKey, EntityName, Description, StdEntityName, StdDescription, DisplayOrder
	     ,SalesAccountKey,ClassKey, Taxable, Taxable2)
	select 'tWorkType', WorkTypeKey, WorkTypeKey, WorkTypeName, Description, WorkTypeName, Description, 1 -- desc is text
	     ,isnull(GLAccountKey, 0),isnull(ClassKey, 0), isnull(Taxable, 0), isnull(Taxable2, 0)
	from    tWorkType (nolock)
	where   CompanyKey = @CompanyKey

	-- overwrite with the custom billing item descs
	if @WorkTypeCustomEntity is not null	
	update #allitems
	set    #allitems.EntityName = cust.Subject
	      ,#allitems.Description = cust.Description
	from   tWorkTypeCustom cust (nolock)
	where  #allitems.EntityKey = cust.WorkTypeKey
	and    #allitems.Entity = 'tWorkType'
	and    cust.Entity = @WorkTypeCustomEntity COLLATE DATABASE_DEFAULT
	and    cust.EntityKey = @WorkTypeCustomEntityKey    				
	 		
	insert #allitems (Entity, EntityKey, WorkTypeKey, EntityName, Description, DisplayOrder
	     ,SalesAccountKey,ClassKey, Taxable, Taxable2)
	select 'tItem', ItemKey, isnull(WorkTypeKey, 0), ItemName, StandardDescription, 1 -- desc is varchar(1000)
	     ,isnull(SalesAccountKey, 0),isnull(ClassKey, 0), isnull(Taxable, 0), isnull(Taxable2, 0)
	from    tItem (nolock)
	where   CompanyKey = @CompanyKey
	
	insert #allitems (Entity, EntityKey, WorkTypeKey, EntityName, Description, DisplayOrder
	     ,SalesAccountKey,ClassKey, Taxable, Taxable2)
	select 'tService', ServiceKey, isnull(WorkTypeKey, 0), Description, null, 1
	     ,isnull(GLAccountKey, 0),isnull(ClassKey, 0), isnull(Taxable, 0), isnull(Taxable2, 0)
	from    tService (nolock)
	where   CompanyKey = @CompanyKey

	declare @DisplayOrder int
	declare @EntityName varchar(200) 
	
	-- we must establish display orders for items if we do not have layouts 
	select @DisplayOrder = 1
	      ,@EntityName = ''
	while (1=1)
	begin
		select @EntityName = min(EntityName)
		from   #allitems
		where  EntityName > @EntityName
		and    Entity = 'tWorkType'
	
		if @EntityName is null
			break
			
		update #allitems 
		set    #allitems.DisplayOrder = @DisplayOrder
		where  EntityName = @EntityName
		and    Entity = 'tWorkType' 	
		
		select @DisplayOrder = @DisplayOrder + 1	
	end      
	      
	select @DisplayOrder = 1
	      ,@EntityName = ''
	while (1=1)
	begin
		select @EntityName = min(EntityName)
		from   #allitems
		where  EntityName > @EntityName
		and    Entity <> 'tWorkType'
	
		if @EntityName is null
			break
			
		update #allitems 
		set    #allitems.DisplayOrder = @DisplayOrder
		where  EntityName = @EntityName
		and    Entity <> 'tWorkType' 	

		select @DisplayOrder = @DisplayOrder + 1	
			
	end  -- loop    
	
end -- GetItemInfo
	
	
	update #tran
	set    #tran.LayoutEntity = 'tService'
	      ,#tran.LayoutEntityKey = isnull(#tran.LayoutEntityKey, 0)
	where  #tran.Entity = 'tTime'
	
	update #tran
	set    #tran.LayoutEntity = 'tItem'
	      ,#tran.LayoutEntityKey = isnull(#tran.LayoutEntityKey, 0)
	where  #tran.Entity <> 'tTime'

	update #tran set WorkTypeKey = 0, WorkTypeLayoutOrder = 0
	
	update #tran
    set    #tran.ItemName = i.EntityName
          ,#tran.WorkTypeKey = isnull(i.WorkTypeKey, 0)
    from   #allitems i (nolock)
    where  #tran.LayoutEntity = 'tItem'
    and    i.Entity = 'tItem'
    and    #tran.LayoutEntityKey = i.EntityKey
     
	update #tran
    set    #tran.ItemName = s.EntityName
          ,#tran.WorkTypeKey = isnull(s.WorkTypeKey, 0)
    from   #allitems s (nolock)
    where  #tran.LayoutEntity = 'tService'
    and    s.Entity = 'tService'
    and    #tran.LayoutEntityKey = s.EntityKey
    
	
	if @LayoutKey > 0
	begin
		-- the items have been reorganized on the layout, so reset WorkTypeKey = 0 
		-- LayoutOrder =9999 -- by default at the bottom if not found 
		update #tran
		set    #tran.WorkTypeKey = 0
	           ,#tran.LayoutOrder =9999 -- by default at the bottom
	           
		-- set the LayoutOrder on items that must be under the root (parent entity = tProject)
		update #tran
		set    #tran.LayoutOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #tran.LayoutEntity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #tran.LayoutEntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tProject'
	
		
		-- get WT key and LayoutOrder when parent entity is tWorkType
		-- these are items/services which are under a billing item	
		update #tran
		set    #tran.WorkTypeKey = lb.ParentEntityKey
		      ,#tran.LayoutOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #tran.LayoutEntity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #tran.LayoutEntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tWorkType'				
	
		-- get the layout order of the billing item
		update #tran
		set    #tran.WorkTypeLayoutOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #tran.WorkTypeKey = lb.EntityKey
		and    lb.Entity = 'tWorkType'

		-- we could not do it before, because the layouts change the structure
		update #tran
		set    #tran.WorkTypeName = wt.EntityName
		from   #allitems wt (nolock)
		where  #tran.WorkTypeKey = wt.EntityKey
		and    wt.Entity = 'tWorkType'
			
		-- WE CANNOT UPDATE THE DESCRIPTION NOW BECAUSE THIS IS A TEXT FIELD AND WE HAVE LOTS OF TRANS
	end
	else
	begin
		 -- no layout key
		 -- do it by name
		
		-- WorkTypeKey already set
		-- LayoutOrder =9999 -- by default at the bottom if not found 
		update #tran
		set    #tran.LayoutOrder =9999 -- by default at the bottom
		 
		 -- set the billing item name and display order	 
		update #tran
		set    #tran.WorkTypeName = wt.EntityName
		      ,#tran.WorkTypeLayoutOrder = wt.DisplayOrder
		from   #allitems wt (nolock)
		where  #tran.WorkTypeKey = wt.EntityKey 	 
        and    wt.Entity = 'tWorkType'
        
        -- set the display order on the items now
 		update #tran
		set    #tran.LayoutOrder = i.DisplayOrder
		from   #allitems i (nolock)
		where  #tran.LayoutEntityKey = i.EntityKey 	 
        and    i.Entity = 'tItem'
        and    #tran.LayoutEntity = 'tItem'
        
        update #tran
		set    #tran.LayoutOrder = s.DisplayOrder
		from   #allitems s (nolock)
		where  #tran.LayoutEntityKey = s.EntityKey 	 
        and    s.Entity = 'tService'
        and    #tran.LayoutEntity = 'tService'
        
					     
	end	
	
	 
	-- At this time, we have set all LayoutOrders, Billing Items for each item/service (when it can be found), ItemName
	-- some items with WorkTypeKey = 0 and LayoutOrder <> 9999 are under the root as specified by the layout 
	-- some items with WorkTypeKey = 0 and LayoutOrder = 9999, we could not find the billing item 
	
	truncate table #line
	
	-- STEP 1: CAPTURE THE LINES UNDER ROOT
		
	if @LayoutKey > 0
	begin
		-- must be done in one shot, because must be done by a certain order
		-- Take item or services without billing item having a valid LayoutOrder
		-- Take billing items 

		insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID, LayoutOrder)
		select distinct ItemName, 0, LayoutEntityKey, 0, 0, LayoutOrder
		from   #tran
		where  WorkTypeKey = 0       -- no billing Item
		and    LayoutEntity = 'tItem'
		and    LayoutOrder <> 9999
		
		Union  all

		select distinct ItemName, 0, 0, LayoutEntityKey, 0, LayoutOrder
		from   #tran
		where  WorkTypeKey = 0       -- no billing Item
		and    LayoutEntity = 'tService'
		and    LayoutOrder <> 9999
		
		Union  all
		
		select wt.WorkTypeName, wt.WorkTypeKey, 0, 0, 0, LayoutOrder
			from (
			select WorkTypeName, WorkTypeKey, min(WorkTypeLayoutOrder) as LayoutOrder
			from   #tran
			where  WorkTypeKey > 0 
			group by WorkTypeName, WorkTypeKey
			) as wt
			
		order by LayoutOrder

	end       

	if @LayoutKey = 0
	begin
		-- Do it in 2 shots to show at the top the billing items and then the items/services
		
		-- First billing items at top		
		insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID, LayoutOrder)
		select distinct WorkTypeName, WorkTypeKey, 0, 0, 0, WorkTypeLayoutOrder
		from   #tran
		where  WorkTypeKey > 0 
		order by WorkTypeLayoutOrder
		
		-- Then items or services
		insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID, LayoutOrder)
		select distinct ItemName, 0, LayoutEntityKey, 0, 0, LayoutOrder
		from   #tran
		where  WorkTypeKey = 0       -- no billing Item
		and    LayoutEntity = 'tItem'
		and    LayoutOrder <> 9999
		
		Union  all

		select distinct ItemName, 0, 0, LayoutEntityKey, 0, LayoutOrder
		from   #tran
		where  WorkTypeKey = 0       -- no billing Item
		and    LayoutEntity = 'tService'
		and    LayoutOrder <> 9999

		order by LayoutOrder
		
	end

   -- Update LineID on #tran
   update #tran	
   set    #tran.LineID = #line.LineID 
          ,#tran.UpdateFlag = 1       -- to identify my updates 
   from   #line
   where  #tran.WorkTypeKey = 0       -- no billing Item
   and    #tran.LayoutEntity = 'tItem'
   and    #line.ItemKey = #tran.LayoutEntityKey
   and    #line.ItemKey > 0
   
   update #tran	
   set    #tran.LineID = #line.LineID 
          ,#tran.UpdateFlag = 2
   from   #line
   where  #tran.WorkTypeKey = 0       -- no billing Item
   and    #tran.LayoutEntity = 'tService'
   and    #line.ServiceKey = #tran.LayoutEntityKey
   and    #line.ServiceKey > 0
   and    #tran.LineID is null

	-- this is for the ones without billing items and orders		
	if exists (select 1 from #tran where WorkTypeKey = 0 and LayoutEntityKey = 0 and LayoutOrder = 9999)
	begin
		insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID, LayoutOrder)
		select 'No Item/Service', 0, 0, 0, 0, 9999


	   update #tran	
	   set    #tran.LineID = #line.LineID 
             ,#tran.UpdateFlag = 3
 	   from   #line
	   where  #tran.WorkTypeKey = 0       -- no billing Item
	   and    #tran.LayoutEntityKey = 0
	   and    #tran.LineID is null
       and    #line.WorkTypeKey = 0       -- no billing Item
	   and    #line.ItemKey = 0
	   and    #line.ServiceKey = 0
   
	end

  

	-- STEP 2: CAPTURE THE LINES UNDER THE BILLING ITEMS NOW (INSERT WITH WorkTypeKey)

	insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID, LayoutOrder)
	select distinct ItemName, WorkTypeKey, LayoutEntityKey, 0, 0, LayoutOrder
	from   #tran
	where  WorkTypeKey > 0       -- there is a billing Item
	and    LayoutEntity = 'tItem'
	and    LayoutOrder <> 9999
	
	Union  all

	select distinct ItemName, WorkTypeKey, 0, LayoutEntityKey, 0, LayoutOrder
	from   #tran
	where  WorkTypeKey > 0       -- there is a billing Item
	and    LayoutEntity = 'tService'
	and    LayoutOrder <> 9999

	order by LayoutOrder

	-- Update LineID on #tran
   update #tran	
   set    #tran.LineID = #line.LineID 
         ,#tran.UpdateFlag = 4
   from   #line
   where  #tran.WorkTypeKey > 0       -- there is a billing Item
   and    #tran.LayoutEntity = 'tItem'
   and    #line.ItemKey = #tran.LayoutEntityKey
   and    #line.WorkTypeKey = #tran.WorkTypeKey 
   and    #tran.LineID is null
   and    #line.ItemKey > 0
   
   update #tran	
   set    #tran.LineID = #line.LineID 
         ,#tran.UpdateFlag = 5
   from   #line
   where  #tran.WorkTypeKey > 0       -- there is a billing Item
   and    #tran.LayoutEntity = 'tService'
   and    #line.ServiceKey = #tran.LayoutEntityKey
   and    #line.WorkTypeKey = #tran.WorkTypeKey 
   and    #tran.LineID is null
   and    #line.ServiceKey > 0
  
	-- Now Update ParentLineID on #line
	-- Join thru WorkTypeKey
   update #line
   set    #line.ParentLineID = b.LineID 
   from   #line b
         ,#line
   where  #line.WorkTypeKey = b.WorkTypeKey
   and    b.ItemKey + b.ServiceKey = 0
   and    (#line.ItemKey + #line.ServiceKey) > 0
   and    #line.WorkTypeKey > 0
   
	-- STEP 3: SET ACCOUNTING INFO ON THE LINES

    UPDATE #line
    SET    Taxable = 0,Taxable2 = 0,ClassKey = 0,SalesAccountKey = 0
          ,Quantity = 0, BilledAmount=0, UnitCost=0
          
	-- get the Taxable/taxable2 fields from Item or Service
	UPDATE #line
	SET    #line.Taxable = #allitems.Taxable
		  ,#line.Taxable2 = #allitems.Taxable2
	FROM   #allitems  
	WHERE  #line.ItemKey = #allitems.EntityKey
	AND    #line.ItemKey > 0
	AND    #allitems.Entity = 'tItem' 
	
	UPDATE #line
	SET    #line.Taxable = #allitems.Taxable
		  ,#line.Taxable2 = #allitems.Taxable2
	FROM   #allitems  
	WHERE  #line.ServiceKey = #allitems.EntityKey
	AND    #line.ServiceKey > 0
	AND    #allitems.Entity = 'tService' 


   -- GL account from:
   -- 1) from item
   -- 2) if none on item, get from billing item
   -- 3) if none on item/billing item, get from default
    UPDATE #line
	SET    #line.SalesAccountKey = #allitems.SalesAccountKey
	FROM   #allitems 
	WHERE  #line.ItemKey = #allitems.EntityKey
	AND    #line.ItemKey > 0
	AND    #allitems.Entity = 'tItem' 
	
    UPDATE #line
	SET    #line.SalesAccountKey = #allitems.SalesAccountKey
	FROM   #allitems 
	WHERE  #line.ServiceKey = #allitems.EntityKey
	AND    #line.ServiceKey > 0
	AND    #allitems.Entity = 'tService' 
	
	UPDATE #line
	SET    #line.SalesAccountKey = #allitems.SalesAccountKey
	FROM   #allitems 
	WHERE  #line.WorkTypeKey = #allitems.EntityKey
	AND    #line.WorkTypeKey > 0
	AND    (#line.ItemKey + #line.ServiceKey) > 0
	AND    ISNULL(#line.SalesAccountKey, 0) = 0
	AND    #allitems.Entity = 'tWorkType' 
	
	UPDATE #line
	SET    #line.SalesAccountKey = @DefaultSalesAccountKey
	WHERE   ISNULL(#line.SalesAccountKey, 0) = 0

	-- Default Class from : 
    -- 1) Class from project, estimate, client, etc...
    -- 2) If none on the project, estimate, client, get class from Item
    -- 3) If none on the project/item, get class from billing item
    -- 4) If none on the project/item/billing Item use Default Class
	IF ISNULL(@BillingClassKey, 0) > 0
		UPDATE #line
		SET    #line.ClassKey = @BillingClassKey
	ELSE
	BEGIN
		UPDATE #line
		SET    #line.ClassKey = #allitems.ClassKey
		FROM   #allitems 
		WHERE  #line.ItemKey = #allitems.EntityKey
		AND    #line.ItemKey > 0
		AND    #allitems.Entity = 'tItem' 
			
		UPDATE #line
		SET    #line.ClassKey = #allitems.ClassKey
		FROM   #allitems 
		WHERE  #line.ServiceKey = #allitems.EntityKey
		AND    #line.ServiceKey > 0
		AND    #allitems.Entity = 'tService' 
		
		UPDATE #line
		SET    #line.ClassKey = #allitems.ClassKey
		FROM   #allitems 
		WHERE  #line.WorkTypeKey = #allitems.EntityKey
		AND    #line.WorkTypeKey > 0
		AND    (#line.ItemKey + #line.ServiceKey) > 0
		AND    ISNULL(#line.ClassKey, 0) = 0
		AND    #allitems.Entity = 'tWorkType' 
		
		UPDATE #line
		SET    #line.ClassKey = @DefaultClassKey
		WHERE  ISNULL(#line.ClassKey, 0) = 0
	
	END

	-- Line description
	UPDATE #line
    SET    #line.Description = #allitems.Description
    FROM   #allitems (nolock)
    WHERE  #line.WorkTypeKey = #allitems.EntityKey
    AND    #line.WorkTypeKey > 0
    AND    #line.ItemKey = 0
    AND    #line.ServiceKey = 0
	AND    #allitems.Entity = 'tWorkType' 
  
	UPDATE #line
    SET    #line.Description = #allitems.Description
    FROM   #allitems (nolock)
    WHERE  #line.ServiceKey = #allitems.EntityKey
    AND    #line.WorkTypeKey = 0
    AND    #line.ItemKey = 0
    AND    #line.ServiceKey > 0
	AND    #allitems.Entity = 'tService' 
  
	UPDATE #line
    SET    #line.Description =  #allitems.Description
    FROM   #allitems (nolock)
    WHERE  #line.ItemKey = #allitems.EntityKey
    AND    #line.ItemKey > 0
    AND    #line.ServiceKey = 0
	AND    #allitems.Entity = 'tItem' 
  
    UPDATE  #line
   SET     #line.BilledAmount = ISNULL((
			SELECT SUM(#tran.BilledAmount)
			FROM   #tran
			WHERE  #tran.LineID = #line.LineID
			),0)
  
  -- on items or services only
   UPDATE  #line
   SET     #line.Quantity = ISNULL((
			SELECT SUM(#tran.Quantity)
			FROM   #tran
			WHERE  #tran.LineID = #line.LineID
			),0)
	WHERE   (ItemKey + ServiceKey) > 0						       
	
	UPDATE  #line
	SET     #line.UnitCost = CASE WHEN #line.Quantity = 0 THEN #line.BilledAmount
							      ELSE #line.BilledAmount / #line.Quantity END
	WHERE   (ItemKey + ServiceKey) > 0						       
  
if @LayoutKey > 0
begin
	/*
	DisplayOption = 1 No Details
	DisplayOption = 2 Sub Item Details
	DisplayOption = 3 Transactions
	*/

	update #line
	set    #line.DisplayOption = 1 -- no details by default

	update #line
	set    #line.DisplayOption = lb.DisplayOption
	from   tLayoutBilling lb (nolock)
	where  lb.LayoutKey = @LayoutKey
	and    #line.WorkTypeKey = lb.EntityKey
	and    #line.ItemKey = 0
	and    #line.ServiceKey = 0
    and    lb.Entity = 'tWorkType'	

	update #line
	set    #line.DisplayOption = lb.DisplayOption
	from   tLayoutBilling lb (nolock)
	where  lb.LayoutKey = @LayoutKey
	and    #line.ItemKey = lb.EntityKey
	and    #line.ServiceKey = 0
    and    lb.Entity = 'tItem'	

	update #line
	set    #line.DisplayOption = lb.DisplayOption
	from   tLayoutBilling lb (nolock)
	where  lb.LayoutKey = @LayoutKey
	and    #line.ItemKey = 0
	and    #line.ServiceKey = lb.EntityKey
    and    lb.Entity = 'tService'	

end
  
--/*
--select * from #tran order by LineID
--select * from #line order by ParentLineID, LineID
--select * from #allitems
--*/	 		
	RETURN 1
GO
