USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportInsertionOrderDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportInsertionOrderDetail]
	@PurchaseOrderKey int,
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@ItemID varchar(50),
	@TotalCost money,
	@Markup decimal(24,4),
	@BillableCost money,
	@UserDefinedDate1 smalldatetime,
	@UserDefinedDate2 smalldatetime,
	@UserDefinedDate3 smalldatetime,
	@UserDefinedDate4 smalldatetime,
	@UserDefinedDate5 smalldatetime,
	@UserDefinedDate6 smalldatetime
	
AS --Encrypt

	DECLARE	@ProjectKey int,
			@TaskKey int,
			@ClassKey int,
			@ItemKey int,
			@CompanyKey int,
			@LineNumber int
			
	SELECT	@CompanyKey = CompanyKey, @ProjectKey = ProjectKey, @TaskKey = TaskKey, @ClassKey = ClassKey
	FROM	tPurchaseOrder (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
	

	IF @ItemID is not null
	BEGIN
		SELECT	@ItemKey = ItemKey
		FROM	tItem (nolock)
		WHERE	ItemID = @ItemID
		AND		CompanyKey = @CompanyKey
		
		if @ItemKey is null
			return -1
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
		AppliedCost,
		AmountBilled,
		UserDate1,
		UserDate2,
		UserDate3,
		UserDate4,
		UserDate5,
		UserDate6
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
		0,
		0,
		NULL,
		@TotalCost,
		1,
		1,
		@BillableCost,
		0,
		0,
		@UserDefinedDate1,
		@UserDefinedDate2,
		@UserDefinedDate3,
		@UserDefinedDate4,
		@UserDefinedDate5,
		@UserDefinedDate6
		)
	
	RETURN 1
GO
