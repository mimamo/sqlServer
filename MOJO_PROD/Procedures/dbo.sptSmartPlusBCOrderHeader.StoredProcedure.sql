USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusBCOrderHeader]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusBCOrderHeader]
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
		@DeletedFlightFlag int, 
		@StationID varchar(50), 
		@ProjectID varchar(50), 
		@TaskID varchar(30),
		@FlightStartDate smalldatetime,
		@FlightEndDate smalldatetime,
		@FlightType varchar(1)	
	)


AS --Encrypt

/*
|| When     Who Rel      What
|| 04/16/07 BSH 8.45     DateUpdated needs to be updated. 
|| 10/05/07 BSH 8.5      Added GLCompanyKey, get from Estimate or Project based on ClientLink.
|| 01/28/08 GHL 8.503    (20203) Changed DefaultPOType to DefaultBCPOType instead of PrintTrafficOnBC
|| 07/17/08 RTC 10.0.0.5 Get the GL Class from the media estimate
|| 10/22/08 GHL 10.5  (37963) Added CompanyAddressKey param
|| 03/19/09 RTC 10.0.2.1 (48709) Relaxed restriction for updating Project, GLCompany, Office by only counting lines that have
||                       been pre-billed or have a vendor invoice applied against them, otherwise allow update.
|| 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
|| 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
|| 11/06/12 GHL 10.5.6.2 (158992) When updating project or media estimate after voucher detail lines exist
||                        Make sure that the GL company from the project or estimate matches the GL company on tPurchaseOrder
|| 03/03/13 MAS 10.5.6.5 (170597)Do not allow updating of the VendorID
|| 04/29/13 MAS 10.5.6.7 (170597)Now checking the existence of tVoucherDetail lines before not allowing/not allowing the updating of the VendorID
|| 06/25/13 MAS 10.5.6.9 (181522)Return 0 after calling sptPurchaseOrderDelete if there are no errors.  This prevents sptSmartPlusBCOrderDetail
||                        from trying to create revision lines to zero out the order detail 
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
declare @BCClientLink smallint
declare @CompanyMediaKey int 
declare @FlightInterval tinyint
declare @PrintClientOnOrder tinyint
declare @BillAt smallint
declare @ClientKey int
declare @PrintTraffic tinyint
declare @GLCompanyKey int
declare @OldGLCompanyKey int
declare @RequireGLCompany tinyint
declare @LineCount int
declare @ClassKey int
declare @CompanyAddressKey int

select @POKey = min(PurchaseOrderKey) 
  from tPurchaseOrder (nolock)
 where LinkID = @LinkID and POKind = 2 and CompanyKey = @OwnerCompanyKey
	
-- check to see if PO was deleted in SmartPlus and if it can be deleted in CMP
if @DeletedFlightFlag = 99
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
				else
				    Return 0	
		end
	else
		return 0
	
select @VendorKey = min(CompanyKey) 
  from tCompany (nolock)
 where VendorID = @VendorID and OwnerCompanyKey = @OwnerCompanyKey

if @VendorKey is null
	return -1
	
select @BCClientLink = isnull(BCClientLink,1),
       @RequireItems = RequireItems,
       @RequireTasks = RequireTasks,
       @DefaultPOType = ISNULL(DefaultBCPOType, 0),
       @AutoApproveExternalOrders = isnull(AutoApproveExternalOrders,0),
       @PrintClientOnOrder = isnull(BCPrintClientOnOrder,1),
       @PrintTraffic = isnull(PrintTrafficOnBC,0),
       @RequireGLCompany  = isnull(RequireGLCompany, 0)
  from tPreference (nolock)
 where CompanyKey = @OwnerCompanyKey

select @MediaEstimateKey = min(MediaEstimateKey) 
  from tMediaEstimate (nolock)
 where CompanyKey = @OwnerCompanyKey
   and EstimateID = @EstimateID

select @DisplayMode = BCOrderDisplayMode
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
	      
if @BCClientLink = 1 --	link to client through project (required)
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
   and ItemType = 2 
   and ItemID = @ItemID

if @RequireItems = 1
	if @ItemKey is null
		return -5

-- use project or estimate to retrieve client key and get billing preferences
if @BCClientLink = 1 -- link client via project
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
		
select @BillAt = isnull(BCBillAt,0)
  from tCompany (nolock)
 where CompanyKey = @ClientKey
	
	
select @CompanyMediaKey = CompanyMediaKey 
  from tCompanyMedia (nolock)
 where StationID = @StationID

if @AutoApproveExternalOrders = 1
    select @OrderStatus = 4
else
	select @OrderStatus = 2

if @OrderedBy is null
	select @OrderedBy = FirstName + ' ' + LastName 
	  from tUser (nolock) 
	 where UserKey = @UserKey

if upper(@FlightType) = 'S'
	select @FlightInterval = 1
else
	select @FlightInterval = 2

If @POKey is null
    begin
		exec @RetVal = sptPurchaseOrderInsert
			@OwnerCompanyKey,
			2,
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
			
		update tPurchaseOrder
		   set LinkID = @LinkID,
			   Status = @OrderStatus,
			   Revision = @Revision
		 where PurchaseOrderKey = @POKey

    end
else
    begin		
		-- You can not change the VendorID if there are any tVoucherDetail lines for the order
		if exists(Select 1
			From tVoucherDetail vd (nolock)
			Join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
			Join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
			Where pod.PurchaseOrderKey = @POKey)
		Begin
			Declare @OrigVendorKey int
			
			Select @OrigVendorKey = VendorKey
			From tPurchaseOrder (nolock)
			where PurchaseOrderKey = @POKey

			if @VendorKey <> @OrigVendorKey  
				return -12				
		End			
			
		Select @LineCount = Count(*)
		From tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @POKey
		and (isnull(AppliedCost, 0) <> 0 or InvoiceLineKey is not null)

		If @LineCount > 0
		begin
			select @OldGLCompanyKey = GLCompanyKey from tPurchaseOrder (nolock) where PurchaseOrderKey = @POKey
		
			-- if we do not update the GLCompany after changing the project or media estimate, error out if the GL Company is different
			if isnull(@OldGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
				return -11

			update tPurchaseOrder
			set 
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
				FlightStartDate = @FlightStartDate,
				FlightEndDate = @FlightEndDate,
				FlightInterval = @FlightInterval,
				DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)			   
			where PurchaseOrderKey = @POKey
	    End
		Else
	    update tPurchaseOrder
		   set
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
			   FlightStartDate = @FlightStartDate,
			   FlightEndDate = @FlightEndDate,
			   FlightInterval = @FlightInterval,
			   DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)			   
		 where PurchaseOrderKey = @POKey
    end


    return @POKey
GO
