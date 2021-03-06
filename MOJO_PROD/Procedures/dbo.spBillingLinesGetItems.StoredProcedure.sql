USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesGetItems]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesGetItems]
	(
	@CompanyKey int
	,@WorkTypeCustomEntity varchar(50)
	,@WorkTypeCustomEntityKey int
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 03/26/10 GHL 10.521 Creation for new layouts  
*/

	SET NOCOUNT ON
	
/*	
	create table #allitems (Entity varchar(20) null, EntityKey int, WorkTypeKey int
	    , EntityName varchar(200) null, Description text null
	    , StdEntityName varchar(200) null, StdDescription text null
	    , DisplayOrder int null 
	    , SalesAccountKey int null,ClassKey int null, Taxable int null, Taxable2 int null
		)
*/	
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



	RETURN 1
GO
