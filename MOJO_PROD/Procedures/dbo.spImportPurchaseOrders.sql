USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportPurchaseOrders]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportPurchaseOrders]
	@CompanyKey int,
	@PurchaseOrderTypeName varchar(200),
	@PurchaseOrderNumber varchar(30),
	@VendorID varchar(50),
	@Contact varchar(200),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@DateCreated smalldatetime,
	@PODate smalldatetime,
	@DueDate smalldatetime,
	@OrderedBy varchar(200),
	@SpecialInstructions varchar(1000),
	@DeliveryInstructions varchar(1000),
	@DeliverTo1 varchar(100),
	@DeliverTo2 varchar(100),
	@DeliverTo3 varchar(100),
	@DeliverTo4 varchar(100),
	@Revision int,
	@ApprovedDate smalldatetime,
	@ApprovedByUserID varchar(100),
	@UserKey int,
	@ClassID varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

	DECLARE	@PurchaseOrderTypeKey int,
			@VendorKey int,
			@ApprovedByKey int,
			@ClassKey int
			
	SELECT	@oIdentity = 0
			
	IF EXISTS(SELECT 1 FROM tPurchaseOrder (nolock) 
		WHERE CompanyKey = @CompanyKey and PurchaseOrderNumber = @PurchaseOrderNumber and POKind = 0)
		Return -1

	if @PurchaseOrderTypeName is not null
	BEGIN
		SELECT	@PurchaseOrderTypeKey = PurchaseOrderTypeKey
		FROM	tPurchaseOrderType (nolock)
		WHERE	PurchaseOrderTypeName = @PurchaseOrderTypeName
		AND		CompanyKey = @CompanyKey
		if @PurchaseOrderTypeKey is null
			Return -3
	END
	ELSE
		Select @PurchaseOrderTypeKey = 0
		
	SELECT	@VendorKey = CompanyKey
	FROM	tCompany (nolock)
	WHERE	VendorID = @VendorID
	AND		OwnerCompanyKey = @CompanyKey
	
	IF @VendorKey IS NULL
		RETURN -2
		
	SELECT	@ApprovedByKey = UserKey
	FROM	tUser (nolock)
	WHERE	UserID = @ApprovedByUserID
	AND		CompanyKey = @CompanyKey
	
	IF @ApprovedByKey IS NULL
		SELECT	@ApprovedByKey = UserKey
		FROM	tUser (nolock)
		WHERE	SystemID = @ApprovedByUserID
		AND		CompanyKey = @CompanyKey
		
	IF @ApprovedByKey IS NULL
		SELECT	@ApprovedByKey = @UserKey
	
	if @DateCreated is null
		Select @DateCreated = GETDATE()
		
	if @ClassID is not null
	begin
		select @ClassKey = ClassKey from tClass (nolock) where CompanyKey = @CompanyKey and ClassID = @ClassID
		if @ClassKey is null
			return -4
	end
	
	if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return -4


	INSERT tPurchaseOrder
		(
		CompanyKey,
		POKind,
		PurchaseOrderTypeKey,
		PurchaseOrderNumber,
		VendorKey,
		Contact,
		Address1,
		Address2,
		Address3,
		City,
		State,
		PostalCode,
		Country,
		DateCreated,
		PODate,
		DueDate,
		OrderedBy,
		SpecialInstructions,
		DeliveryInstructions,
		DeliverTo1,
		DeliverTo2,
		DeliverTo3,
		DeliverTo4,
		Revision,
		ApprovedDate,
		ApprovedByKey,
		Status,
		Closed,
		Downloaded
		)
	VALUES
		(
		@CompanyKey,
		0,
		@PurchaseOrderTypeKey,
		@PurchaseOrderNumber,
		@VendorKey,
		@Contact,
		@Address1,
		@Address2,
		@Address3,
		@City,
		@State,
		@PostalCode,
		@Country,
		@DateCreated,
		@PODate,
		@DueDate,
		@OrderedBy,
		@SpecialInstructions,
		@DeliveryInstructions,
		@DeliverTo1,
		@DeliverTo2,
		@DeliverTo3,
		@DeliverTo4,
		ISNULL(@Revision, 0),
		@ApprovedDate,
		@ApprovedByKey,
		4,
		0,
		0
		)
	
	SELECT @oIdentity = @@IDENTITY


	RETURN 1
GO
