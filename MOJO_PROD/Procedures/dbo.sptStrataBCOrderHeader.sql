USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCOrderHeader]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCOrderHeader]
	(
		@OwnerCompanyKey int,
		@UserKey int,
		@LinkID varchar(50),
		@VendorID varchar(50),
		@StationID varchar(50),
		@EstimateLinkID varchar(50),
		@ItemLinkID varchar(50),
		@SpecialInstructions varchar(500),
		@DeliveryInstructions varchar(500),
		@PODate smalldatetime,
		@Address1 varchar(200),
		@Address2 varchar(200),
		@City varchar(200),
		@State varchar(50),
		@PostalCode varchar(20),
		@Contact varchar(200),
		@FlightStartDate smalldatetime,
		@FlightEndDate smalldatetime,
		@FlightInterval tinyint
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Modifed to get the ClassKey from the Media Estimate.
|| 04/16/07 BSH 8.4.5   DateUpdated needs to be updated.
|| 09/28/07 BSH 8.5     Insert GLCompanyKey to PO Header, get from Estimate or Project based on ClientLink.  
|| 01/28/08 GHL 8.503   (20203) Changed DefaultPOType to DefaultBCPOType instead of PrintTrafficOnBC
|| 10/22/08 GHL 10.5  (37963) Added CompanyAddressKey param
|| 03/19/09 RTC 10.0.2.1 (48709) Relaxed restriction for updating Project, GLCompany, Office by only counting lines that have
||                       been pre-billed or have a vendor invoice applied against them, otherwise allow update.
|| 01/19/10 MAS 10.5.6.1(72080) Added 'BCUseProductName' Customization option.  This will allow the StrataLink client to
||						send the PRODUCT_CODE instead of the LinkID.  This is because if they are syncing using Products, there
||						can be multiple PRODUCT_CODES with different IDs but they need to be treated as the same Broadcast Item in WMJ
|| 09/07/11 MAS 10.5.4.7 (120604) Expanded the field lengths from 50 to 500 for @SpecialInstructions and @DeliveryInstructions
|| 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
|| 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
|| 11/06/12 GHL 10.5.6.2 (158992) When updating project or media estimate after voucher detail lines exist
||                        Make sure that the GL company from the project or estimate matches the GL company on tPurchaseOrder
|| 03/01/13 MAS 10.5.6.5 (170151)Do not allow updating of the VendorID
|| 12/16/13 GHL 10.5.7.5 Added currency info when calling sptPurchaseOrderInsert
*/

Declare @POKey int, @VendorKey int, @EstimateKey int, @ItemKey int, @ProjectKey int, @TaskKey int, @DisplayMode smallint, @ClassKey int, @GLCompanyKey int
Declare @RetVal int, @DefaultPOType int, @RequireItems tinyint, @RequireTasks tinyint, @Key int, @OrderedBy varchar(200)
declare @AutoApproveExternalOrders tinyint
declare @OrderStatus smallint 
declare @BCClientLink smallint
declare @CompanyMediaKey int
declare @PrintClientOnOrder tinyint
declare @BillAt smallint
declare @ClientKey int
declare @PrintTraffic tinyint
declare @BCUseProductName tinyint
declare @RequireGLCompany tinyint
declare @LineCount int
declare @CompanyAddressKey int
declare @OldGLCompanyKey int

Select @POKey = MIN(PurchaseOrderKey) 
From tPurchaseOrder (NOLOCK) 
Where
	LinkID = @LinkID and POKind = 2 and CompanyKey = @OwnerCompanyKey
	
Select @VendorKey = MIN(CompanyKey) 
From tCompany (NOLOCK) 
Where
	VendorID = @VendorID and OwnerCompanyKey = @OwnerCompanyKey

if @VendorKey is null
	return -1
	
Select @EstimateKey = MIN(MediaEstimateKey) from tMediaEstimate (NOLOCK) Where CompanyKey = @OwnerCompanyKey
	and LinkID = @EstimateLinkID

if not @EstimateKey is null
	Select @ProjectKey = ProjectKey, @TaskKey = TaskKey, @DisplayMode = BCOrderDisplayMode, @ClassKey = ClassKey
	From tMediaEstimate (nolock) Where MediaEstimateKey = @EstimateKey
else
	return -2
	
Select @PrintClientOnOrder = isnull(BCPrintClientOnOrder,1)
      ,@BCClientLink = isnull(BCClientLink,1)
      ,@RequireItems = RequireItems
      ,@RequireTasks = RequireTasks
      ,@DefaultPOType = ISNULL(DefaultBCPOType, 0) 
      ,@AutoApproveExternalOrders = isnull(AutoApproveExternalOrders,0) 
      ,@PrintTraffic = isnull(PrintTrafficOnBC,0)
	  ,@RequireGLCompany  = isnull(RequireGLCompany, 0)
	  ,@BCUseProductName = ISNULL(BCUseProductName,0)
  from tPreference (NOLOCK)
 Where CompanyKey = @OwnerCompanyKey
	
if @BCClientLink = 1 -- link client via project	
    begin
		if @ProjectKey is null
			return -3

		if @RequireTasks = 1
			if @TaskKey is null 
				return -4
	end

-- If they are using the 'BCUseProductName' Customization option, the @ItemLinkID will contain the PRODUCT_CODE rather then the LinkID
If @BCUseProductName > 0 
	Begin
		Select @ItemKey = MIN(ItemKey) from tItem (NOLOCK) Where CompanyKey = @OwnerCompanyKey and ItemType = 2 and ItemID = @ItemLinkID
	End
Else
	Begin			
		Select @ItemKey = MIN(ItemKey) from tItem (NOLOCK) Where CompanyKey = @OwnerCompanyKey and ItemType = 2 and LinkID = @ItemLinkID
	End
	
if @RequireItems = 1
		if @ItemKey is null
			return -5
			
-- use project or estimate to retrieve client key and get billing preferences
-- For 8.5 also get GLCompany and Office from Project.
if @BCClientLink = 1 -- link client via project
	select @ClientKey = ClientKey,
		   @GLCompanyKey = GLCompanyKey
	  from tProject (nolock)
	 where ProjectKey = @ProjectKey
else -- link client via estimate
	select @ClientKey = ClientKey,
		   @GLCompanyKey = GLCompanyKey
	  from tMediaEstimate (nolock)
	 where MediaEstimateKey = @EstimateKey

if @ClientKey is null
	return -7
		
if isnull(@GLCompanyKey, 0) > 0
begin
	select @CompanyAddressKey = AddressKey
	from   tGLCompany (nolock)
	where  GLCompanyKey = @GLCompanyKey
	
	if @CompanyAddressKey = 0
		select @CompanyAddressKey = null
end
		
select @BillAt = isnull(BCBillAt,0)
	from tCompany (nolock)
	where CompanyKey = @ClientKey

if @AutoApproveExternalOrders = 1
    select @OrderStatus = 4
else
	select @OrderStatus = 2

Select @OrderedBy = FirstName + ' ' + LastName From tUser (nolock) Where UserKey = @UserKey

select @CompanyMediaKey = CompanyMediaKey
  from tCompanyMedia (nolock)
 where CompanyKey = @OwnerCompanyKey
   and StationID = @StationID
   and MediaKind = 2
   
If @POKey is null
BEGIN
	exec @RetVal = sptPurchaseOrderInsert
		@OwnerCompanyKey,
		2,
		@DefaultPOType,
		NULL,
		@VendorKey,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@Contact,
		@PODate,
		NULL,
		@OrderedBy,
		0,
		0,
		0,
		@UserKey,
		@UserKey,
		@CompanyMediaKey,
		@EstimateKey,
		@DisplayMode,
		@BillAt,
		null,
		null,
		@FlightStartDate,
		@FlightEndDate,
		@FlightInterval,
		@PrintClientOnOrder,
		@PrintTraffic,
		1,
		@GLCompanyKey,
		@CompanyAddressKey,
		null, -- currency id
		1,    -- exchange rate
		null, -- P currency id
		1,    -- P exchange rate
		@POKey output
		
	if @RetVal < 0 
		return -6
		
	Update tPurchaseOrder
	Set
		LinkID = @LinkID,
		Address1 = @Address1,
		Address2 = @Address2,
		City = @City,
		State = @State,
		PostalCode = @PostalCode,
		SpecialInstructions = @SpecialInstructions,
		DeliveryInstructions = @DeliveryInstructions,
		Status = @OrderStatus
	Where
		PurchaseOrderKey = @POKey

END
ELSE
BEGIN
	Declare @OrigVendorKey int
	
	-- You can not change the VendorID
	Select @OrigVendorKey = VendorKey
	From tPurchaseOrder (nolock)
	where PurchaseOrderKey = @POKey

	if @VendorKey <> @OrigVendorKey  
		return -9
	
    Select @LineCount = Count(*)
	From tPurchaseOrderDetail (nolock)
	where PurchaseOrderKey = @POKey
	and (isnull(AppliedCost, 0) <> 0 or InvoiceLineKey is not null)
	
	If @LineCount > 0	
	begin
		select @OldGLCompanyKey = GLCompanyKey from tPurchaseOrder (nolock) where PurchaseOrderKey = @POKey
		
			-- if we do not update the GLCompany after changing the project or media estimate, error out if the GL Company is different
			if isnull(@OldGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
				return -8

		Update tPurchaseOrder
		Set
			ProjectKey = @ProjectKey,
			TaskKey = @TaskKey,
			ItemKey = @ItemKey,
			ClassKey = @ClassKey,
			PODate = @PODate,
			Address1 = @Address1,
			Address2 = @Address2,
			City = @City,
			State = @State,
			PostalCode = @PostalCode,
			SpecialInstructions = @SpecialInstructions,
			DeliveryInstructions = @DeliveryInstructions,
			CompanyMediaKey = @CompanyMediaKey,
			FlightStartDate = @FlightStartDate,
			FlightEndDate = @FlightEndDate,
			FlightInterval = @FlightInterval,
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
		Where
			PurchaseOrderKey = @POKey
	end
	Else
		Update tPurchaseOrder
		Set
			ProjectKey = @ProjectKey,
			GLCompanyKey = @GLCompanyKey,
			TaskKey = @TaskKey,
			ItemKey = @ItemKey,
			ClassKey = @ClassKey,
			PODate = @PODate,
			Address1 = @Address1,
			Address2 = @Address2,
			City = @City,
			State = @State,
			PostalCode = @PostalCode,
			SpecialInstructions = @SpecialInstructions,
			DeliveryInstructions = @DeliveryInstructions,
			CompanyMediaKey = @CompanyMediaKey,
			FlightStartDate = @FlightStartDate,
			FlightEndDate = @FlightEndDate,
			FlightInterval = @FlightInterval,
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
	Where
		PurchaseOrderKey = @POKey

END

Return @POKey
GO
