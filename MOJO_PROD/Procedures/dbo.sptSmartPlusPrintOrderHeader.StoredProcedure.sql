USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusPrintOrderHeader]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusPrintOrderHeader]
	(
		@OwnerCompanyKey int,
		@UserKey int,
		@LinkID varchar(50),
		@VendorID varchar(50),
		@EstimateID varchar(50),
		@ItemID varchar(50),
		@PODate smalldatetime,
		@Contact varchar(200),
		@OrderedBy varchar(200),
		@Revision int, 
		@DeletedOrderFlag int, 
		@BrandName varchar(50), 
		@ProjectID varchar(50), 
		@TaskID varchar(30) 	
	)


AS --Encrypt

/*
|| When     Who Rel      What
|| 04/16/07 BSH 8.4.5    DateUpdated needs to be updated.
|| 10/01/07 BSH 8.5      Added GLCompanyKey, get from Estimate or Project based on ClientLink.
|| 07/17/08 RTC 10.0.0.5 Get the GL Class from the media estimate
|| 10/22/08 GHL 10.5  (37963) Added CompanyAddressKey param
|| 03/19/09 RTC 10.0.2.1 (48709) Relaxed restriction for updating Project, GLCompany, Office by only counting lines that have
||                       been pre-billed or have a vendor invoice applied against them, otherwise allow update.
|| 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
|| 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
|| 11/26/13 GHL 10.5.7.4 Added currency fields when calling sptVoucherInsert
|| 12/16/13 GHL 10.5.7.5 Added currency info when calling sptPurchaseOrderInsert
*/

declare @POKey int
declare @VendorKey int
declare @MediaEstimateKey int
declare @ItemKey int
declare @ProjectKey int
declare @TaskKey int
declare @DisplayMode smallint
declare @RetVal int
declare @DefaultPOType int
declare @RequireItems tinyint
declare @RequireTasks tinyint
declare @AutoApproveExternalOrders tinyint
declare @OrderStatus smallint 
declare @IOClientLink smallint
declare @CompanyMediaKey int 
declare @PrintClientOnOrder tinyint
declare @BillAt smallint
declare @ClientKey int
declare @GLCompanyKey int
declare @RequireGLCompany tinyint
declare @LineCount int
declare @ClassKey int
declare @CompanyAddressKey int

select @POKey = min(PurchaseOrderKey) 
  from tPurchaseOrder (nolock)
 where LinkID = @LinkID and POKind = 1 and CompanyKey = @OwnerCompanyKey
	
-- check to see if PO was deleted in SmartPlus and if it can be deleted in CMP
if @DeletedOrderFlag = 99
	if @POKey is not null
	    begin
			if exists(select 1 
			            from tPurchaseOrderDetail (nolock) 
			           where PurchaseOrderKey = @POKey 
			             and InvoiceLineKey is not null)
				return -7
			if exists(select 1 
			     from tVoucherDetail vd (nolock) inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			    where PurchaseOrderKey = @POKey)
				return -8
				
			-- no vendor or client invoices, delete PO
			exec @RetVal = sptPurchaseOrderDelete @POKey
				if @RetVal < 0 
					return -9
		end
	else
		return 0
	
select @VendorKey = min(CompanyKey) 
  from tCompany (nolock)
 where VendorID = @VendorID and OwnerCompanyKey = @OwnerCompanyKey

if @VendorKey is null
	return -1
	
select @IOClientLink = isnull(IOClientLink,1),
       @RequireItems = RequireItems,
       @RequireTasks = RequireTasks,
       @DefaultPOType = ISNULL(DefaultPrintPOType, 0),
       @AutoApproveExternalOrders = isnull(AutoApproveExternalOrders,0),
       @PrintClientOnOrder = isnull(IOPrintClientOnOrder,1),       
	   @RequireGLCompany  = isnull(RequireGLCompany, 0)
  from tPreference (nolock)
 where CompanyKey = @OwnerCompanyKey

select @MediaEstimateKey = min(MediaEstimateKey) 
  from tMediaEstimate (nolock)
 where CompanyKey = @OwnerCompanyKey
   and EstimateID = @EstimateID

select @DisplayMode = IOOrderDisplayMode
      ,@ClassKey = ClassKey
  from tMediaEstimate (nolock)
 where MediaEstimateKey = @MediaEstimateKey
 
select @ProjectKey = min(ProjectKey)
  from tProject (nolock)
 where ProjectNumber = @ProjectID
   and CompanyKey = @OwnerCompanyKey

/*
select @TaskKey = TaskKey
  from tTask (nolock)
 where ProjectKey = ProjectKey
   and TaskID = @TaskID	
*/
   	
exec @TaskKey = spTaskIDValidate @TaskID, @ProjectKey, 2 -- Budget Tracking Task
if @TaskKey < 0
	select @TaskKey = null
		      
if @IOClientLink = 1 --	link to client through project (required)
	begin
		if @ProjectKey is null
			return -3
			
		if @TaskKey is null 
			if @RequireTasks = 1
				return -4
	end
else
	if @MediaEstimateKey is null -- link to client through estimate
		return -2
	
Select @ItemKey = min(ItemKey) 
  from tItem (nolock)
 where CompanyKey = @OwnerCompanyKey 
   and ItemType = 1 
   and ItemID = @ItemID
   
if @RequireItems = 1
	if @ItemKey is null
		return -5

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
	where MediaEstimateKey = @MediaEstimateKey

if @ClientKey is null
	return -10
		
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
 
 
select @CompanyMediaKey = CompanyMediaKey 
  from tCompanyMedia (nolock)
 where StationID = @BrandName

if @AutoApproveExternalOrders = 1
    select @OrderStatus = 4
else
	select @OrderStatus = 2

if @OrderedBy is null
	select @OrderedBy = FirstName + ' ' + LastName 
	  from tUser (nolock) 
	 where UserKey = @UserKey

If @POKey is null
    begin
		exec @RetVal = sptPurchaseOrderInsert
			@OwnerCompanyKey,
			1,
			@DefaultPOType,
			null,
			@VendorKey,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Contact,
			@PODate,
			null,
			@OrderedBy,
			0,
			0,
			0,
			@UserKey, 
			@UserKey,
			@CompanyMediaKey,
			@MediaEstimateKey,
			@DisplayMode,
			@BillAt,
			null,
			null,
			null,
			null,
			null,
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
			
		update tPurchaseOrder
		   set LinkID = @LinkID,
			   Status = @OrderStatus,
			   Revision = @Revision
		 where PurchaseOrderKey = @POKey

    end
else
    begin
		Select @LineCount = Count(*)
		From tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @POKey
		and (isnull(AppliedCost, 0) <> 0 or InvoiceLineKey is not null)
		
		If @LineCount > 0	
			update tPurchaseOrder
			set VendorKey = @VendorKey,
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				ItemKey = @ItemKey,
				ClassKey = @ClassKey,
				MediaEstimateKey = @MediaEstimateKey,
				PODate = @PODate,
				Contact = @Contact,
				OrderedBy = @OrderedBy,
				Revision = @Revision,
				CompanyMediaKey = @CompanyMediaKey,
				DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)			   
			where PurchaseOrderKey = @POKey
		Else
			update tPurchaseOrder
			set VendorKey = @VendorKey,
				ProjectKey = @ProjectKey,
				GLCompanyKey = @GLCompanyKey,
				TaskKey = @TaskKey,
				ItemKey = @ItemKey,
				ClassKey = @ClassKey,
				MediaEstimateKey = @MediaEstimateKey,
				PODate = @PODate,
				Contact = @Contact,
				OrderedBy = @OrderedBy,
				Revision = @Revision,
				CompanyMediaKey = @CompanyMediaKey,
				DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)			   
			where PurchaseOrderKey = @POKey
    end


    return @POKey
GO
