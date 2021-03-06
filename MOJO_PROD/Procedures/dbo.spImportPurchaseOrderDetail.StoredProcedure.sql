USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportPurchaseOrderDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportPurchaseOrderDetail]
	@PurchaseOrderKey int,
	@ProjectNumber varchar(50),
	@TaskID varchar(30),
	@ClassID varchar(50),
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@ItemID varchar(50),
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@BillableCost money
	
AS --Encrypt

	DECLARE	@ProjectKey int,
			@TaskKey int,
			@ClassKey int,
			@ItemKey int,
			@CompanyKey int,
			@LineNumber int
			
	SELECT	@CompanyKey = CompanyKey
	FROM	tPurchaseOrder (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
	
	IF @ProjectNumber IS NOT NULL
	BEGIN			
		SELECT	@ProjectKey = ProjectKey
		FROM	tProject (nolock)
		WHERE	ProjectNumber = @ProjectNumber
		AND		CompanyKey = @CompanyKey
		
		IF @ProjectKey IS NULL
			RETURN -1
	END
	
	IF @TaskID IS NOT NULL
	BEGIN
		SELECT	@TaskKey = TaskKey
		FROM	tTask (nolock)
		WHERE	TaskID = @TaskID
		AND		ProjectKey = @ProjectKey
		
		IF @TaskKey IS NULL
			RETURN -2
			
		IF @ProjectKey IS NULL
			Return -3
	END	
	
	if @ProjectKey is not null 
	begin
		if @TaskKey is null and (select isnull(RequireTasks, 1) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
			return -4
	end
	
	IF @ItemID is not null
	BEGIN
		SELECT	@ItemKey = ItemKey
		FROM	tItem (nolock)
		WHERE	ItemID = @ItemID
		AND		ItemType = 0
		AND		CompanyKey = @CompanyKey
		
		if @ItemKey is null
			return -5
	END
	
	if @ClassID is not null
	begin
		select @ClassKey = ClassKey
		from   tClass (nolock)
		where  ClassID = @ClassID
		and    CompanyKey = @CompanyKey
		
		if @ClassKey is null
			return -7
	end
	
	if @ClassKey is null and (select ISNULL(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -7
	
	if @ProjectKey is not null
	BEGIN
	if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
		return -6
		
	if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 0)
		return -6
	END

	Select @LineNumber = Count(*) + 1 from tPurchaseOrderDetail (nolock) Where PurchaseOrderKey = @PurchaseOrderKey
	
	INSERT tPurchaseOrderDetail
		(
		PurchaseOrderKey,
		LineNumber,
		ProjectKey,
		TaskKey,
		ClassKey,
		ShortDescription,
		LongDescription,
		ItemKey,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		Billable,
		Markup,
		BillableCost,
		AppliedCost
		)

	VALUES
		(
		@PurchaseOrderKey,
		@LineNumber,
		@ProjectKey,
		@TaskKey,
		@ClassKey,
		@ShortDescription,
		@LongDescription,
		@ItemKey,
		@Quantity,
		@UnitCost,
		@UnitDescription,
		@TotalCost,
		@Billable,
		@Markup,
		@BillableCost,
		0
		)
	
	RETURN 1
GO
