USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportInsertionOrders]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportInsertionOrders]
	@CompanyKey int,
	@PurchaseOrderTypeName varchar(200),
	@PurchaseOrderNumber varchar(30),
	@VendorID varchar(50),
	@StationID varchar(50),
	@MediaEstimateID varchar(50),
	@ProjectNumber varchar(50),
	@TaskID varchar(50),
	@ClassID varchar(50),
	@ItemID varchar(50),
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
	@OrderedBy varchar(200),
	@SpecialInstructions varchar(1000),
	@DeliveryInstructions varchar(1000),
	@Revision int,
	@ApprovedDate smalldatetime,
	@ApprovedByUserID varchar(100),
	@UserKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel      What
  || 07/24/09 GHL 10.5     Corrected addresses
  */

	DECLARE	@PurchaseOrderTypeKey int,
			@VendorKey int,
			@ApprovedByKey int,
			@ItemKey int,
			@ClassKey int,
			@ProjectKey int,
			@TaskKey int,
			@CompanyMediaKey int,
			@MediaEstimateKey int
			
	SELECT	@oIdentity = 0
			
	IF EXISTS(SELECT 1 FROM tPurchaseOrder (nolock) 
		WHERE CompanyKey = @CompanyKey and PurchaseOrderNumber = @PurchaseOrderNumber and POKind = 1)
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
		
	Select @ProjectKey = ProjectKey 
	from tProject p (nolock) 
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	Where p.CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber and ps.ExpenseActive = 1
	if @ProjectKey is null
		return -4
		
	Select @TaskKey = TaskKey from tTask (nolock) Where ProjectKey = @ProjectKey and TaskID = @TaskID and MoneyTask = 1
	if @TaskKey is null
		return -5
		
	Select @ItemKey = ItemKey from tItem (nolock) 
		Where CompanyKey = @ItemKey and ItemType = 1 and ItemID = @ItemID
	if @ItemKey is null and not @ItemID is null
		return -6
		
	Select @ClassKey = @ClassKey from tClass (nolock) Where CompanyKey = @CompanyKey and ClassID = @ClassID
	if @ClassKey is null and not @ClassID is null
		return -7
		
	Select @MediaEstimateKey = MediaEstimateKey from tMediaEstimate (nolock) 
		Where CompanyKey = @CompanyKey and EstimateID = @MediaEstimateID
	if @MediaEstimateKey is null and not @MediaEstimateID is null
		return -8
		
	Select @CompanyMediaKey = CompanyMediaKey from tCompanyMedia (nolock)
	Where CompanyKey = @CompanyKey and VendorKey = @VendorKey and MediaKind = 1 and StationID = @StationID
	if @CompanyMediaKey is null and not @StationID is null
		return -9
		
	IF @ApprovedByKey IS NULL
		SELECT	@ApprovedByKey = @UserKey
	
	if @DateCreated is null
		Select @DateCreated = GETDATE()
		
	if @Address1 is null
	BEGIN
	IF @CompanyMediaKey is null
		SELECT 
			@Address1 = case when pa.AddressKey is null then da.Address1 else pa.Address1 end ,
			@Address2 = case when pa.AddressKey is null then da.Address2  else pa.Address2 end ,
			@Address3 = case when pa.AddressKey is null then da.Address3  else pa.Address3 end ,
			@City = case when pa.AddressKey is null then da.City  else pa.City end ,
			@State = case when pa.AddressKey is null then da.State  else pa.State end , 
			@PostalCode = case when pa.AddressKey is null then da.PostalCode  else pa.PostalCode end ,
			@Country = case when pa.AddressKey is null then da.Country  else pa.Country end 
		FROM
			tCompany c (nolock)
		LEFT OUTER JOIN tAddress da (NOLOCK) ON c.DefaultAddressKey = da.AddressKey
		LEFT OUTER JOIN tAddress pa (NOLOCK) ON c.PaymentAddressKey = pa.AddressKey
		WHERE
			c.CompanyKey = @VendorKey
	ELSE
		SELECT 
			@Address1 = Address1,
			@Address2 = Address2,
			@Address3 = Address3,
			@City = City,
			@State = State, 
			@PostalCode = PostalCode,
			@Country = Country
		FROM
			tCompanyMedia (nolock)
		WHERE
			CompanyMediaKey = @CompanyMediaKey
	END
	
	
	INSERT tPurchaseOrder
		(
		CompanyKey,
		POKind,
		PurchaseOrderTypeKey,
		PurchaseOrderNumber,
		VendorKey,
		CompanyMediaKey,
		MediaEstimateKey,
		ProjectKey,
		TaskKey,
		ItemKey,
		ClassKey,
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
		OrderedBy,
		SpecialInstructions,
		DeliveryInstructions,
		Revision,
		ApprovedDate,
		ApprovedByKey,
		Status,
		Closed,
		Downloaded,
		Printed
		)
	VALUES
		(
		@CompanyKey,
		1,
		@PurchaseOrderTypeKey,
		@PurchaseOrderNumber,
		@VendorKey,
		@CompanyMediaKey,
		@MediaEstimateKey,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
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
		@OrderedBy,
		@SpecialInstructions,
		@DeliveryInstructions,
		ISNULL(@Revision, 0),
		@ApprovedDate,
		@ApprovedByKey,
		4,
		0,
		0,
		0
		)
	
	SELECT @oIdentity = @@IDENTITY


	RETURN 1
GO
