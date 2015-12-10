USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadLayout]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadLayout]
	@CompanyKey int,
	@LayoutName varchar(500),
	@Entity varchar(50),
	@Active tinyint,
	@TaskDetailOption smallint,
	@TaskShowTransactions tinyint = 0,
	@EstLineFormat smallint = 1
AS

/*
|| When      Who Rel      What
|| 6/2/10    GHL 10.5.3.0 Added support of layouts to the load standard functionality
|| 10/3/10   GHL 10.5.3.7 Added TaskShowTransactions parameter
|| 12/14/10  GHL 10.5.3.9 Added seeding of tLayoutBilling since we do not load them in LoadStandard
|| 12/21/10  RLB 10.5.3.9 (97402) Only load the layout if it does not exist already
|| 06/16/11  GHL 10.5.4.5 (111334) Added EstLineFormat (replaces tEstimate.LineFormat)
*/

	DECLARE @LayoutKey INT
	DECLARE @Ret INT

	SELECT @LayoutKey = LayoutKey FROM tLayout (nolock) Where CompanyKey = @CompanyKey and LayoutName = @LayoutName
	SELECT @LayoutKey = ISNULL(@LayoutKey, 0)

	if @LayoutKey > 0
		return

	-- This can be called several times
	EXEC @Ret = sptLayoutUpdate @LayoutKey, @CompanyKey ,@LayoutName ,@Entity ,@Active,@TaskDetailOption, @TaskShowTransactions, @EstLineFormat

	SELECT @LayoutKey = LayoutKey FROM tLayout (nolock) Where CompanyKey = @CompanyKey and LayoutName = @LayoutName
	SELECT @LayoutKey = ISNULL(@LayoutKey, 0)

	if @LayoutKey = 0
		return

			
	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder, LayoutOrder)
	Select 
		@LayoutKey
		,0 as ParentEntityKey
		,NULL as ParentEntity
		,0 as EntityKey
		,'tProject' as Entity
		,2 as DisplayOption  -- show item detail by default
		,0 as LayoutLevel
		,1 as DisplayOrder
	    ,1 as LayoutOrder

	declare @DisplayOrder int   select @DisplayOrder = 1
	
	-- Billing items may not have display orders, redo them
	declare @WorkTypeID varchar(50)
	declare @WorkTypeKey int
	declare @WTCount int
	declare @DOCount int

	select @WTCount = count(*) from tWorkType (nolock) where CompanyKey = @CompanyKey and Active = 1
	select @DOCount = count(distinct DisplayOrder) from tWorkType (nolock) where CompanyKey = @CompanyKey and Active = 1

	if @WTCount <> @DOCount
	begin

		select @WorkTypeID = ''
		while (1=1)
		begin
			select @WorkTypeID = MIN(WorkTypeID)
			from   tWorkType (nolock)
			where  CompanyKey = @CompanyKey
			and    Active = 1
			and    WorkTypeID > @WorkTypeID

			if @WorkTypeID is null
				break
		
			select @WorkTypeKey = WorkTypeKey	
			from   tWorkType (nolock)
			where  CompanyKey = @CompanyKey
			and    Active = 1
			and    WorkTypeID = @WorkTypeID

			update tWorkType
			set    DisplayOrder = @DisplayOrder
			where  WorkTypeKey = @WorkTypeKey
	
			select @DisplayOrder = @DisplayOrder + 1

		end

	end

	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder)
	Select 
		@LayoutKey
		,0 as ParentEntityKey
		,'tProject' as ParentEntity
		,WorkTypeKey as EntityKey
		,'tWorkType' as Entity
		,2 as DisplayOption  -- show item detail by default
		,1 as LayoutLevel
		,DisplayOrder as DisplayOrder
	from tWorkType (nolock) Where CompanyKey = @CompanyKey
	And  Active = 1

	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder)
	Select 
		@LayoutKey
		,WorkTypeKey as ParentEntityKey
		,'tWorkType' as ParentEntity
		,ServiceKey as EntityKey
		,'tService' as Entity
		,1 as DisplayOption  -- show item detail by default
		,2 as LayoutLevel
		,0 as DisplayOrder
	from tService (nolock) Where CompanyKey = @CompanyKey
	and  isnull(WorkTypeKey, 0) > 0
	and  Active = 1
	order by ServiceCode

	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder)
	Select 
		@LayoutKey
		,WorkTypeKey as ParentEntityKey
		,'tWorkType' as ParentEntity
		,ItemKey as EntityKey
		,'tItem' as Entity
		,1 as DisplayOption  -- show item detail by default
		,2 as LayoutLevel
		,0 as DisplayOrder
	from tItem (nolock) Where CompanyKey = @CompanyKey
	and  isnull(WorkTypeKey, 0) > 0
	and Active = 1
	order by ItemID


	select @DisplayOrder = 1

	update tLayoutBilling
	set    DisplayOrder = @DisplayOrder
	      ,@DisplayOrder = @DisplayOrder + 1
    where LayoutKey = @LayoutKey
	and   ParentEntity = 'tWorkType'


	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder)
	Select 
		@LayoutKey
		,0 as ParentEntityKey
		,'tProject' as ParentEntity
		,ServiceKey as EntityKey
		,'tService' as Entity
		,1 as DisplayOption  -- show item detail by default
		,1 as LayoutLevel
		,0 as DisplayOrder
	from tService (nolock) Where CompanyKey = @CompanyKey
	and  isnull(WorkTypeKey, 0) = 0
	and  Active = 1
	order by ServiceCode

	insert tLayoutBilling (LayoutKey, ParentEntityKey, ParentEntity, EntityKey, Entity, DisplayOption, LayoutLevel, DisplayOrder)
	Select 
		@LayoutKey
		,0 as ParentEntityKey
		,'tProject' as ParentEntity
		,ItemKey as EntityKey
		,'tItem' as Entity
		,1 as DisplayOption  -- show item detail by default
		,1 as LayoutLevel
		,0 as DisplayOrder
	from tItem (nolock) Where CompanyKey = @CompanyKey
	and  isnull(WorkTypeKey, 0) = 0
	and  Active =1
   	order by ItemID

	select @DisplayOrder = MAX(DisplayOrder)
	from   tLayoutBilling (nolock)
	where  LayoutKey = @LayoutKey
	and    LayoutLevel = 1

	update tLayoutBilling
	set    DisplayOrder = @DisplayOrder
	      ,@DisplayOrder = @DisplayOrder + 1
    where LayoutKey = @LayoutKey
	and   LayoutLevel = 1
	and   Entity in ( 'tItem', 'tService')

	declare @LayoutOrder int
	select @LayoutOrder = 2
	
	declare @DisplayOrder2 int
	select @DisplayOrder = 0

	declare @ParentEntity varchar (50)
	declare @ParentEntityKey int

	while (1=1)
	begin
		select @DisplayOrder = min(DisplayOrder)
		from   tLayoutBilling (nolock)
		where  LayoutKey = @LayoutKey
		and    LayoutLevel = 1
		and    DisplayOrder > @DisplayOrder

			if @DisplayOrder is null
				break
		
			select @ParentEntity = Entity
			      ,@ParentEntityKey = EntityKey
			from  tLayoutBilling
			where  LayoutKey = @LayoutKey
			and    LayoutLevel = 1
			and    DisplayOrder = @DisplayOrder
	
			update tLayoutBilling
			set    LayoutOrder = @LayoutOrder
			where  LayoutKey = @LayoutKey
			and    LayoutLevel = 1
			and    DisplayOrder = @DisplayOrder

			select @LayoutOrder = @LayoutOrder + 1

			select @DisplayOrder2 = 0
	
			while (1=1)
			begin
				select @DisplayOrder2 = min(DisplayOrder)
				from   tLayoutBilling (nolock)
				where  LayoutKey = @LayoutKey
				and    LayoutLevel = 2
				and    ParentEntity = @ParentEntity
				and    ParentEntityKey = @ParentEntityKey
				and    DisplayOrder > @DisplayOrder2

				if @DisplayOrder2 is null
					break

				update tLayoutBilling
				set    LayoutOrder = @LayoutOrder
				where  LayoutKey = @LayoutKey
				and    LayoutLevel = 2
				and    ParentEntity = @ParentEntity
				and    ParentEntityKey = @ParentEntityKey
				and    DisplayOrder = @DisplayOrder2

				select @LayoutOrder = @LayoutOrder + 1

			end
	 
	 end


	
	RETURN @Ret
GO
