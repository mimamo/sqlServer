USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataPrintOrderHeader]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataPrintOrderHeader]
	(
		@OwnerCompanyKey int,
		@UserKey int,
		@PurchaseOrderNumber varchar(50),
		@RevisionNumber int,
		@LinkID varchar(50),
		@VendorID varchar(50),
		@PublicationID varchar(50),
		@EstimateLinkID varchar(50),
		@ItemLinkID varchar(50),
		@SpecialInstructions varchar(50),
		@PODate smalldatetime,
		@Address1 varchar(200),
		@Address2 varchar(200),
		@City varchar(200),
		@State varchar(50),
		@PostalCode varchar(20),
		@Contact varchar(200),
		@FlightStartDate smalldatetime,
		@FlightEndDate smalldatetime,
		@FlightInterval tinyint,
		@StrataVersion decimal(24,4)= 0
	)
            
AS --Encrypt

/*
|| When     Who Rel    What
|| 11/16/06 CRG 8.3571 Modified to get the ClassKey from the Media Estimate.
|| 04/16/07 BSH 8.4.5  DateUpdated needs to be updated.
|| 10/01/07 BSH 8.5    Insert GLCompanyKey to PO Header, get from Estimate or Project based on ClientLink. 
|| 10/22/08 GHL 10.5  (37963) Added CompanyAddressKey param
|| 03/19/09 RTC 10.0.2.1 (48709) Relaxed restriction for updating Project, GLCompany, Office by only counting lines that have
||                       been pre-billed or have a vendor invoice applied against them, otherwise allow update.
|| 05/24/11 MAS 10.0.4.4 (109450)Make sure the project allows changes before updating the PurchaseOrder
|| 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
|| 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
|| 07/09/12 MAS 10.5.5.7 Added support for Interactive packages (SBMS 19.5)
|| 10/08/12	MAS 10.5.6.0 (156278) Changed the SBMS version for packages to 19.6 since some clients have been mistakenly upgraded
|| 03/26/13	MAS 10.5.6.6 Removed the SBMS version check since we're now able to pull over both 18.8 and 19.5+ orders in the same
||                       query on the client with the query Strata provided
|| 12/16/13 GHL 10.5.7.5 Added currency info when calling sptPurchaseOrderInsert
*/

Declare @POKey int, @VendorKey int, @EstimateKey int, @ItemKey int, @ProjectKey int, @TaskKey int, @DisplayMode smallint, @ClassKey int, @GLCompanyKey int
Declare @RetVal int, @DefaultPOType int, @RequireItems tinyint, @RequireTasks tinyint, @Key int, @OrderedBy varchar(200)
declare @AutoApproveExternalOrders tinyint
declare @OrderStatus smallint 
declare @IOClientLink smallint
declare @CompanyMediaKey int
declare @PrintClientOnOrder tinyint
declare @BillAt smallint
declare @ClientKey int
declare @DFA tinyint
declare @RequireGLCompany tinyint
declare @LineCount int
declare @CompanyAddressKey int

declare @CurrentVendorKey int
declare @CurrentProjectKey int
declare @CurrentTaskKey int
declare @CurrentItemKey int
declare @CurrentClassKey int
declare @CurrentPODate smalldatetime
declare @CurrentAddress1 varchar(50)
declare @CurrentAddress2 varchar(50)
declare @CurrentCity varchar(50)
declare @CurrentState varchar(50)
declare @CurrentPostalCode varchar(50)
declare @CurrentSpecialInstructions varchar(50)
declare @CurrentFlightStartDate smalldatetime
declare @CurrentFlightEndDate smalldatetime
declare @CurrentFlightInterval int
 
Select @POKey = MIN(PurchaseOrderKey) 
From tPurchaseOrder (NOLOCK) 
Where
	LinkID = @LinkID and POKind = 1 and CompanyKey = @OwnerCompanyKey

Select @PrintClientOnOrder = isnull(IOPrintClientOnOrder,1), 
       @IOClientLink = isnull(IOClientLink,1), 
       @RequireItems = RequireItems, 
       @RequireTasks = RequireTasks, 
       @DefaultPOType = ISNULL(DefaultPrintPOType, 0),
       @AutoApproveExternalOrders = isnull(AutoApproveExternalOrders,0),
       @RequireGLCompany  = isnull(RequireGLCompany, 0),
       @DFA = CASE ISNULL(CHARINDEX('dfa',Customizations), 0) When 0 then 0 Else 1 End
    from tPreference (NOLOCK) 
Where CompanyKey = @OwnerCompanyKey
	
if @DFA = 0
  BEGIN
	Select @VendorKey = MIN(CompanyKey) 
	From tCompany (NOLOCK) 
	Where VendorID = @VendorID and OwnerCompanyKey = @OwnerCompanyKey
		
	select @CompanyMediaKey = CompanyMediaKey
	  from tCompanyMedia (nolock)
	 where CompanyKey = @OwnerCompanyKey
	   and StationID = @PublicationID
	   and MediaKind = 1
		   
	Select @ItemKey = MIN(ItemKey) from tItem (NOLOCK) Where CompanyKey = @OwnerCompanyKey and ItemType = 1 and LinkID = @ItemLinkID
	if @RequireItems = 1
		if @ItemKey is null
			return -5		   
  END
Else -- For DFA, we need to find the item
	select @CompanyMediaKey = CompanyMediaKey,
	       @ItemKey = ItemKey,
	       @VendorKey = VendorKey
	  from tCompanyMedia (nolock)
	 where CompanyKey = @OwnerCompanyKey
	   and StationID = @PublicationID
	   and MediaKind = 1   	


if @VendorKey is null
	return -1
	
Select @EstimateKey = MIN(MediaEstimateKey) from tMediaEstimate (NOLOCK) Where CompanyKey = @OwnerCompanyKey
	and LinkID = @EstimateLinkID

if not @EstimateKey is null
	Select @ProjectKey = ProjectKey, @TaskKey = TaskKey, @DisplayMode = IOOrderDisplayMode, @ClassKey = ClassKey
	From tMediaEstimate (nolock) Where MediaEstimateKey = @EstimateKey
else
	return -2

if @IOClientLink = 1 -- link client via project	
	if @ProjectKey is null
		return -3

if @IOClientLink = 1 -- link client via project
	if @RequireTasks = 1
		if @TaskKey is null 
			return -4

-- use project or estimate to retrieve client key and get billing preferences
if @IOClientLink = 1 -- link client via project
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
		
select @BillAt = isnull(IOBillAt,0)
  from tCompany (nolock)
 where CompanyKey = @ClientKey
	
if @AutoApproveExternalOrders = 1
    select @OrderStatus = 4
else
	select @OrderStatus = 2
	
Select @OrderedBy = FirstName + ' ' + LastName From tUser (nolock) Where UserKey = @UserKey

   
If @POKey is null
BEGIN
	exec @RetVal = sptPurchaseOrderInsert
		@OwnerCompanyKey,
		1,
		@DefaultPOType,
		@PurchaseOrderNumber,
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
		0,
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
		Status = @OrderStatus
	Where
		PurchaseOrderKey = @POKey
END
ELSE
BEGIN
	if @AutoApproveExternalOrders <> 1
		if exists(Select 1 from tPurchaseOrder (nolock) Where PurchaseOrderKey = @POKey and Status = 4)
			return -101
	
	Select @LineCount = Count(*)
	From tPurchaseOrderDetail (nolock)
	where PurchaseOrderKey = @POKey
	and (isnull(AppliedCost, 0) <> 0 or InvoiceLineKey is not null)
	
	Select @CurrentVendorKey = VendorKey,
			@CurrentProjectKey = ProjectKey,
			@CurrentTaskKey = TaskKey,
			@CurrentItemKey = ItemKey,
			@CurrentClassKey = ClassKey,
			@CurrentPODate = PODate,
			@CurrentAddress1 = Address1,
			@CurrentAddress2 = Address2,
			@CurrentCity = City,
			@CurrentState = State,
			@CurrentPostalCode = PostalCode,
			@CurrentSpecialInstructions = SpecialInstructions,
			@CurrentFlightStartDate = FlightStartDate,
			@CurrentFlightEndDate = FlightEndDate,
			@CurrentFlightInterval = FlightInterval
		From tPurchaseOrder (NOLOCK)
		Where PurchaseOrderKey = @POKey
		
		-- Check to see if something has changed
	if @CurrentVendorKey <> @VendorKey
			or @CurrentProjectKey <> @ProjectKey
			or @CurrentTaskKey <> @TaskKey
			or @CurrentItemKey <> @ItemKey
			or @CurrentClassKey <> @ClassKey
			or @CurrentPODate <> @PODate
			or @CurrentAddress1 <> @Address1
			or @CurrentAddress2 <> @Address2
			or @CurrentCity <> @City
			or @CurrentState <> @State
			or @CurrentPostalCode <> @PostalCode
			or @CurrentSpecialInstructions <> @SpecialInstructions
			or @CurrentFlightStartDate <> @FlightStartDate
			or @CurrentFlightEndDate <> @FlightEndDate
			or @CurrentFlightInterval <> @FlightInterval
	begin
		if @ProjectKey is not null
			begin
				-- if something has changed, can we update the order based on project status
				if not exists(Select 1 from tProject p (NOLOCK) 
						  inner join tProjectStatus ps (NOLOCK) on p.ProjectStatusKey = ps.ProjectStatusKey
						  Where p.ProjectKey = @ProjectKey and  ps.ExpenseActive = 1 )
					return -6
			end
	end			

	If @LineCount > 0
		Update tPurchaseOrder
		Set
			VendorKey = @VendorKey,
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
			FlightStartDate = @FlightStartDate,
			FlightEndDate = @FlightEndDate,
			FlightInterval = @FlightInterval,
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)		
		Where
			PurchaseOrderKey = @POKey
	Else
		Update tPurchaseOrder
		Set
			VendorKey = @VendorKey,
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
			FlightStartDate = @FlightStartDate,
			FlightEndDate = @FlightEndDate,
			FlightInterval = @FlightInterval,
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)		
		Where
			PurchaseOrderKey = @POKey

END

Return @POKey
GO
