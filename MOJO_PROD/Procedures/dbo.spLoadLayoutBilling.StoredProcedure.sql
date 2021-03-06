USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadLayoutBilling]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadLayoutBilling]
	@CompanyKey int,

    @LayoutName varchar(500),
	@WorkTypeID varchar(300),
    @ItemID varchar(300),
	@ServiceCode varchar(300),
	@ParentWorkTypeID varchar(300),
	
	@Entity varchar(50),
	@ParentEntity varchar(50),
	
	@DisplayOption smallint,
	@DisplayOrder int,
	@LayoutOrder int,
	@LayoutLevel smallint
AS

/*
|| When      Who Rel      What
|| 6/2/10    GHL 10.5.3.0 Added support of layouts to the load standard functionality
*/

declare @LayoutKey int
	
select @LayoutKey = LayoutKey
from   tLayout (nolock)
where  CompanyKey = @CompanyKey
and    LayoutName = @LayoutName

if @@ROWCOUNT = 0
	return -1

-- we need to convert the EntityKey

declare @NewEntityKey int

if @Entity = 'tProject'
	select @NewEntityKey = 0
else if @Entity = 'tItem'
	select @NewEntityKey = ItemKey
	from   tItem (nolock)
	where  CompanyKey = @CompanyKey
	and    ItemID = @ItemID
else if @Entity = 'tService'
	select @NewEntityKey = ServiceKey
	from   tService (nolock)
	where  CompanyKey = @CompanyKey
	and    ServiceCode = @ServiceCode
else if @Entity = 'tWorkType'
	select @NewEntityKey = WorkTypeKey
	from   tWorkType (nolock)
	where  CompanyKey = @CompanyKey
	and    WorkTypeID = @WorkTypeID

if @Entity <> 'tProject' and isnull(@NewEntityKey, 0) = 0
	return -2
	 
declare @NewParentEntityKey int

if @ParentEntity = 'tProject' Or isnull(@ParentEntity, '') = ''
	select @NewParentEntityKey = 0
else if @ParentEntity = 'tWorkType'
	select @NewParentEntityKey = WorkTypeKey
	from   tWorkType (nolock)
	where  CompanyKey = @CompanyKey
	and    WorkTypeID = @ParentWorkTypeID

if @ParentEntity = 'tWorkType' and isnull(@NewParentEntityKey, 0) = 0
	return -3

-- this sp has no return
-- call be called several times, no duplicate created
EXEC sptLayoutBillingUpdate @LayoutKey ,@Entity,@NewEntityKey,@ParentEntity,@NewParentEntityKey,@DisplayOption,@DisplayOrder,@LayoutOrder,@LayoutLevel

return 1
GO
