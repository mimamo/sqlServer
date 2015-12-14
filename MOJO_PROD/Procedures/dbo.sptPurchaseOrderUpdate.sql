USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderUpdate]
	@PurchaseOrderKey int,
	@POKind smallint,
	@PurchaseOrderTypeKey int = NULL,
	@CompanyKey int,
	@PurchaseOrderNumber varchar(30),
	@VendorKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@Contact varchar(200),
	@PODate smalldatetime,
	@DueDate smalldatetime,
	@OrderedBy varchar(200),
	@Printed smallint,
	@PrintOption smallint,
	@Downloaded smallint,
	@CustomFieldKey int,
	@HeaderTextKey int,
	@FooterTextKey int,
	@ApprovedByKey int,
	@CreatedByKey int = NULL,
	@CompanyMediaKey int,
	@MediaEstimateKey int,
	@OrderDisplayMode smallint,
	@BillAt smallint,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@FlightStartDate smalldatetime,
	@FlightEndDate smalldatetime,
	@FlightInterval tinyint,
	@PrintClientOnOrder tinyint,
	@PrintTraffic tinyint,
	@GLCompanyKey int,
	@CompanyAddressKey int,
	@SkipLineValidation tinyint = 0,
	@LastUpdateBy int = null,
	@Emailed tinyint = null,
	@MediaWorksheetKey int = null,
	@InternalID int = null,
	@MediaPrintSpaceKey int = null,
	@MediaPrintPositionKey int = null,
	@CompanyMediaPrintContractKey int = null,
	@MediaUnitTypeKey int = null,
	@CompanyMediaRateCardKey int = null,
	@MediaPrintSpaceID varchar(500) = null,
	@MediaMarketKey int = null,
	@MediaPrintPositionID varchar(500) = null,
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PlacementTag varchar(500) = null,
	@Description varchar(max) = null,
	@MediaAffiliateKey int = null,
	@MediaDayKey int = null,
	@MediaDayPartKey int = null,
	@MediaLen int = null,
	@BillingBase smallint = null,
	@BillingAdjPercent decimal(24, 4) = null,
	@BillingAdjBase smallint = null,
	@MediaCategoryKey int = null,
	@MediaWorksheetDemoKey int = null

AS --Encrypt

/*
|| When     Who Rel      What
|| 04/13/07 BSH 8.4.5    DateUpdated needed to be updated.
|| 07/12/07 BSH 8.5      (9659)Update GLCompanyKey
|| 01/17/08 BSH 8.5      (18369)Validate that Project on line and header belong to same GLC
||							   and also the MediaEstimate for IOs and BCs.
|| 08/13/08 GHL 10.007   (32001) Calling now project rollup because changing things like BillAt
||                       affect the Open Order Gross on projects
|| 10/22/08 GHL 10.5     (37963) Added CompanyAddressKey param
|| 11/25/09 MFT 10.514	 Added insert logic
|| 10/14/10 MFT 10.536   Added @SkipLineValidation parameter to support document level saves
|| 11/0/11  RLB 10.500   (121862) Added for enhancement
|| 07/19/12 GHL 10.558   Added validation of GLCompany on media estimates 
|| 12/13/12 WDF 10.563   (162210) Added LastUpdateBy
|| 02/28/13 GHL 10.565   (167188) Prevent from changing BillAt if lines are prebilled or applied
|| 08/08/13 CRG 10.5.7.0 Added optional Emailed parameter
|| 08/30/13 CRG 10.5.7.1 Modified insert logic to handle a negative PurchaseOrderKey value passed in
|| 08/30/13 CRG 10.5.7.1 Added @MediaWorksheetKey and @InternalID
|| 09/05/13 CRG 10.5.7.2 Added @MediaPrintSpaceKey, @MediaPrintPositionKey, @CompanyMediaPrintContractKey, @MediaUnitTypeKey, @CompanyMediaRateCardKey
|| 09/16/13 CRG 10.5.7.2 Added @MediaPrintSpaceID
|| 09/30/13 CRG 10.5.7.3 Added @MediaMarketKey
|| 10/01/13 CRG 10.5.7.3 Now we're not setting the PurchaseOrderNumber on the insert if it's coming from the new Media Worksheet screen.
||                       We'll set the PurchaseOrderNumber upon approval
|| 11/25/13 CRG 10.5.7.4 Added logic to make sure that the MediaPrintSpaceKey is set to NULL if free form text is passed in
|| 12/09/13 CRG 10.5.7.5 Added @MediaPrintPositionID
|| 12/16/13 GHL 10.5.7.5 Added currency info
|| 12/17/13 CRG 10.5.7.5 Added @PlacementTag
|| 01/17/14 GHL 10.5.7.6 (197214) Added @Description for enhancement + made @LastUpdateBy optional
|| 02/14/14 CRG 10.5.7.7 Added @MediaAffiliateKey, @MediaDayKey, @MediaDayPartKey, @MediaLen
|| 03/14/14 CRG 10.5.7.8 Added @BillingBase, @BillingAdjPercent, @BillingAdjBase
|| 03/28/14 CRG 10.5.7.8 Added @MediaCategoryKey
|| 04/09/14 CRG 10.5.7.9 Added @MediaWorksheetDemoKey
|| 04/16/14 GHL 10.5.7.9 Modified section that restore null values from old ones because we cannot blank on screen (Added If statement)
|| 05/02/14 GHL 10.5.7.9 Added setting of po.ShowAdjustmentsAsSingleLine
|| 05/07/14 GHL 10.5.7.9 Added check of InternalID when using media worksheets
|| 05/08/14 RLB 10.5.7.9 (215598) since fields are locked down in PO allow update to a closed PO
|| 05/14/14 MFT 10.5.7.9 Added tMediaOrder join to duplicate PurchaseOrderNumber check (RETURN -4)
|| 07/28/14 MFT 10.5.8.1 Added ISNULL to MediaOrderKey comparison
|| 08/26/14 GHL 10.5.8.3 Only delete tPurchaseOrderDetailTax records if some exist because this changes POD.SalesTax1Amount and POD.SalesTax2Amount
||                       and this is a problem when trying to create adjustments for the new media screens
*/

DECLARE @Address1 varchar(100)
DECLARE @Address2 varchar(100)
DECLARE @Address3 varchar(100)
DECLARE @City varchar(100)
DECLARE @State varchar(50)
DECLARE @PostalCode varchar(20)
DECLARE @Country varchar(50)
DECLARE @TranType varchar(2)
DECLARE @RetVal	int
DECLARE @NextTranNo varchar(100)
DECLARE @UseClientCosting tinyint
DECLARE @BCUseClientCosting tinyint
DECLARE @IOUseClientCosting tinyint
DECLARE @BCShowAdjustmentsAsSingleLine tinyint
DECLARE @IOShowAdjustmentsAsSingleLine tinyint
	
DECLARE @CurrentStatus smallint
DECLARE @Revision int
DECLARE @ApprovedDate smalldatetime
DECLARE @ExistingCompanyMediaKey int
Declare @MultiCurrency int 

IF @MediaPrintSpaceKey > 0
	SELECT	@MediaPrintSpaceID = NULL
	
IF @MediaPrintPositionKey > 0
	SELECT	@MediaPrintPositionID = NULL

SELECT @BCUseClientCosting = ISNULL(BCUseClientCosting, 0),
			@IOUseClientCosting = ISNULL(IOUseClientCosting, 0),
			@MultiCurrency = ISNULL(MultiCurrency, 0),
			@BCShowAdjustmentsAsSingleLine = isnull(BCShowAdjustmentsAsSingleLine, 1),
			@IOShowAdjustmentsAsSingleLine = isnull(IOShowAdjustmentsAsSingleLine, 1)
		FROM tPreference (NOLOCK) 
		WHERE CompanyKey = @CompanyKey
		
if @MultiCurrency = 0
begin
	select @CurrencyID = null 
		  ,@ExchangeRate = 1
		  ,@PCurrencyID = null 
		  ,@PExchangeRate = 1
end
else 
begin
	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1 -- no division by 0 allowed

	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1

	if isnull(@PExchangeRate, 0) <=0
		select @PExchangeRate = 1

	if isnull(@PCurrencyID, '') = ''
		select @PCurrencyID = null -- no empty string
			  ,@PExchangeRate = 1
end

IF ISNULL(@PurchaseOrderKey, 0) <= 0
	BEGIN --INSERT LOGIC
		
		--Make sure MediaEstimate and IO/BC belong to same company. 
		IF (@POKind = 1 OR @POKind = 2) AND @MediaEstimateKey IS NOT NULL
			IF EXISTS(SELECT 1
				FROM  tMediaEstimate (nolock) 
				WHERE MediaEstimateKey = @MediaEstimateKey
				AND   ISNULL(GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
			RETURN -7

		IF EXISTS(SELECT 1 FROM tPurchaseOrder (NOLOCK) WHERE CompanyKey = @CompanyKey AND POKind = @POKind AND PurchaseOrderNumber = @PurchaseOrderNumber)
			RETURN -8
		
		IF ISNULL(@ProjectKey, 0) > 0
			IF NOT EXISTS(SELECT 1 FROM tProject p (nolock) INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
					WHERE p.ProjectKey = @ProjectKey AND ps.ExpenseActive = 1)
				RETURN -9
		
		-- if we have a media worksheet, the internal ID should be unique
		-- in VB do not trap the error, at this time, I want it to fail silently
		-- this is a patch for the copy function of the new media screen (if you select 2 dates to copy, it will create duplicates with same ID)
		if @MediaWorksheetKey > 0 
		begin
			if exists (select 1 from tPurchaseOrder (nolock) where MediaWorksheetKey = @MediaWorksheetKey and InternalID = @InternalID)
				return -10
		end

		-- Get the next number
		IF @POKind = 0
			BEGIN
				SELECT @UseClientCosting = 0
				SELECT @TranType = 'PO'
			END
		IF @POKind = 1
			BEGIN
				SELECT @UseClientCosting = @IOUseClientCosting
				SELECT @TranType = 'IO'
			END
		IF @POKind = 2
			BEGIN
				SELECT @UseClientCosting = @BCUseClientCosting
				SELECT @TranType = 'BC'
			END
		IF ISNULL(@MediaWorksheetKey, 0) = 0
		BEGIN
			IF @PurchaseOrderNumber IS NULL OR @PurchaseOrderNumber = ''
				BEGIN
					EXEC spGetNextTranNo
						@CompanyKey,
						@TranType,		-- TranType
						@RetVal		      OUTPUT,
						@NextTranNo 		OUTPUT
					
					IF @RetVal <> 1
						RETURN -8
				END
			ELSE
				SELECT @NextTranNo = @PurchaseOrderNumber
		END
		
		IF @CompanyMediaKey is null
			SELECT 
				@Address1 = CASE WHEN ap.AddressKey IS NULL THEN ad.Address1 ELSE ap.Address1 END ,
				@Address2 = CASE WHEN ap.AddressKey IS NULL THEN ad.Address2 ELSE ap.Address2 END ,
				@Address3 = CASE WHEN ap.AddressKey IS NULL THEN ad.Address3 ELSE ap.Address3 END ,
				@City = CASE WHEN ap.AddressKey IS NULL THEN ad.City ELSE ap.City END ,
				@State = CASE WHEN ap.AddressKey IS NULL THEN ad.State ELSE ap.State END , 
				@PostalCode = CASE WHEN ap.AddressKey IS NULL THEN ad.PostalCode ELSE ap.PostalCode END ,
				@Country = CASE WHEN ap.AddressKey IS NULL THEN ad.Country ELSE ap.Country END 
			FROM
				tCompany c (NOLOCK)
				LEFT OUTER JOIN tAddress ad (nolock) ON c.DefaultAddressKey = ad.AddressKey 
				LEFT OUTER JOIN tAddress ap (nolock) ON c.PaymentAddressKey = ap.AddressKey 
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
				tCompanyMedia (NOLOCK) 
			WHERE
				CompanyMediaKey = @CompanyMediaKey
		
		INSERT tPurchaseOrder
		(
			CompanyKey,
			POKind,
			PurchaseOrderTypeKey,
			PurchaseOrderNumber,
			VendorKey,
			ProjectKey,
			TaskKey,
			ItemKey,
			ClassKey,
			Contact,
			PODate,
			DueDate,
			OrderedBy,
			Revision,
			ApprovedByKey,
			Closed,
			DateCreated,
			DateUpdated,
			ApprovedDate,
			Address1,
			Address2,
			Address3,
			City,
			State,
			PostalCode,
			Country,
			Status,
			CustomFieldKey,
			HeaderTextKey,
			FooterTextKey,
			CreatedByKey,
			CompanyMediaKey,
			MediaEstimateKey,
			OrderDisplayMode,
			BillAt,
			SalesTaxKey,
			SalesTax2Key,	
			FlightStartDate,
			FlightEndDate,
			FlightInterval,
			PrintTraffic,
			GLCompanyKey,
			CompanyAddressKey,
			UseClientCosting,
			PrintOption,
			Emailed,
			MediaWorksheetKey,
			InternalID,
			MediaPrintSpaceKey,
			MediaPrintPositionKey,
			CompanyMediaPrintContractKey,
			MediaUnitTypeKey,
			CompanyMediaRateCardKey,
			MediaPrintSpaceID,
			MediaMarketKey,
			MediaPrintPositionID,
			CurrencyID, 
		    ExchangeRate,
		    PCurrencyID,  
		    PExchangeRate,
		    PlacementTag,
			Description,
			MediaAffiliateKey,
			MediaDayKey,
			MediaDayPartKey,
			MediaLen,
			BillingBase,
			BillingAdjPercent,
			BillingAdjBase,
			MediaCategoryKey,
			MediaWorksheetDemoKey,
			ShowAdjustmentsAsSingleLine
		)
		VALUES
		(
			@CompanyKey,
			@POKind,
			@PurchaseOrderTypeKey,
			RTRIM(LTRIM(@NextTranNo)), -- @PurchaseOrderNumber,
			@VendorKey,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Contact,
			@PODate,
			@DueDate,
			@OrderedBy,
			0,
			@ApprovedByKey,
			0,
			CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
			CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
			NULL,
			@Address1,
			@Address2,
			@Address3,
			@City,
			@State,
			@PostalCode,
			@Country,
			1,
			@CustomFieldKey,
			@HeaderTextKey,
			@FooterTextKey,
			@CreatedByKey,
			@CompanyMediaKey,
			@MediaEstimateKey,
			@OrderDisplayMode,
			@BillAt,
			@SalesTaxKey,
			@SalesTax2Key,			
			@FlightStartDate,
			@FlightEndDate,
			@FlightInterval,
			@PrintTraffic,
			@GLCompanyKey,
			@CompanyAddressKey,
			@UseClientCosting,
			@PrintOption,
			@Emailed,
			@MediaWorksheetKey,
			@InternalID,
			@MediaPrintSpaceKey,
			@MediaPrintPositionKey,
			@CompanyMediaPrintContractKey,
			@MediaUnitTypeKey,
			@CompanyMediaRateCardKey,
			@MediaPrintSpaceID,
			@MediaMarketKey,
			@MediaPrintPositionID,
			@CurrencyID, 
		    @ExchangeRate,
		    @PCurrencyID,  
		    @PExchangeRate,
		    @PlacementTag,
			@Description,
			@MediaAffiliateKey,
			@MediaDayKey,
			@MediaDayPartKey,
			@MediaLen,
			@BillingBase,
			@BillingAdjPercent,
			@BillingAdjBase,
			@MediaCategoryKey,
			@MediaWorksheetDemoKey,
			case @POKind 
				when 1 then @IOShowAdjustmentsAsSingleLine
				when 2 then @BCShowAdjustmentsAsSingleLine
				else 1
			end
		)
		
		SELECT @PurchaseOrderKey = @@IDENTITY
		
		-- if it is an IO or BC and we have media, insert default order contacts from media default contacts if no contact specified
		IF (@POKind = 1 or @POKind = 2) AND @CompanyMediaKey IS NOT NULL AND @Contact IS NULL
		EXEC sptPurchaseOrderUserDefault @PurchaseOrderKey, @CompanyMediaKey
		
		RETURN @PurchaseOrderKey
	END --INSERT LOGIC

--UPDATE LOGIC
IF @SkipLineValidation = 0 AND EXISTS(SELECT 1
		FROM tVoucherDetail vd (nolock), tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
		WHERE po.PurchaseOrderKey = @PurchaseOrderKey AND po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
	RETURN -1
/*IF EXISTS (SELECT 1
		FROM tPurchaseOrder po (nolock)
		WHERE po.PurchaseOrderKey = @PurchaseOrderKey AND po.Closed = 1)
	RETURN -2 
IF ISNULL(@ProjectKey, 0) > 0
	IF NOT EXISTS(SELECT 1 from tProject p (nolock) INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
			WHERE p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
		RETURN -3*/
IF EXISTS(SELECT 1
		FROM
			tPurchaseOrder po (nolock)
			LEFT JOIN tMediaOrder mo (nolock) ON po.MediaOrderKey = mo.MediaOrderKey
		WHERE
			CompanyKey = @CompanyKey AND POKind = @POKind AND PurchaseOrderKey <> @PurchaseOrderKey AND PurchaseOrderNumber = @PurchaseOrderNumber AND ISNULL(po.MediaOrderKey, 0) <> ISNULL(mo.MediaOrderKey, -1))
	RETURN -4
IF @SkipLineValidation = 0 AND EXISTS(SELECT 1
		FROM tPurchaseOrderDetail pod (nolock) INNER JOIN tProject p ON pod.ProjectKey = p.ProjectKey
		WHERE pod.PurchaseOrderKey = @PurchaseOrderKey AND ISNULL(p.GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
	RETURN -6
IF @SkipLineValidation = 0 AND @POKind = 2 --check broadcast order details to make sure they are within flight dates
	IF EXISTS(SELECT 1
			FROM tPurchaseOrderDetail (nolock)
			WHERE PurchaseOrderKey = @PurchaseOrderKey AND (DetailOrderDate < @FlightStartDate	OR DetailOrderEndDate > @FlightEndDate))
		RETURN -5
--Make sure MediaEstimate and IO/BC belong to same company. 
IF (@POKind = 1 OR @POKind = 2) AND @MediaEstimateKey IS NOT NULL
	IF EXISTS(SELECT 1
			FROM tPurchaseOrder po (nolock) INNER JOIN tMediaEstimate me ON po.MediaEstimateKey = me.MediaEstimateKey
			WHERE po.PurchaseOrderKey = @PurchaseOrderKey AND ISNULL(me.GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
		RETURN -7

DECLARE @OldSalesTaxKey INT,
		@OldSalesTax2Key INT,
		@OldBillAt INT,
		@OldMediaWorksheetKey INT,
		@OldInternalID INT,
		@OldMediaPrintSpaceKey INT,
		@OldMediaPrintPositionKey INT,
		@OldCompanyMediaPrintContractKey INT,
		@OldMediaUnitTypeKey INT,
		@OldCompanyMediaRateCardKey INT,
		@OldMediaPrintSpaceID varchar(500),
		@OldMediaMarketKey INT,
		@OldMediaPrintPositionID varchar(500),
		@OldPlacementTag varchar(500),
		@OldMediaAffiliateKey int,
		@OldMediaDayKey int,
		@OldMediaDayPartKey int,
		@OldMediaLen int,
		@OldBillingBase smallint,
		@OldBillingAdjPercent decimal(24, 4),
		@OldBillingAdjBase smallint,
		@OldMediaCategoryKey int,
		@OldMediaWorksheetDemoKey int

SELECT @ExistingCompanyMediaKey = ISNULL(CompanyMediaKey,0)
      ,@OldSalesTaxKey = ISNULL(SalesTaxKey, 0)
      ,@OldSalesTax2Key = ISNULL(SalesTax2Key, 0)
	  ,@OldBillAt = ISNULL(BillAt, 0)
	  ,@OldMediaWorksheetKey = MediaWorksheetKey
	  ,@OldInternalID = InternalID
	  ,@OldMediaPrintSpaceKey = MediaPrintSpaceKey
	  ,@OldMediaPrintPositionKey = MediaPrintPositionKey
	  ,@OldCompanyMediaPrintContractKey = CompanyMediaPrintContractKey
	  ,@OldMediaUnitTypeKey = MediaUnitTypeKey
	  ,@OldCompanyMediaRateCardKey = CompanyMediaRateCardKey
	  ,@OldMediaPrintSpaceID = MediaPrintSpaceID
	  ,@OldMediaMarketKey = MediaMarketKey
	  ,@OldMediaPrintPositionID = MediaPrintPositionID
	  ,@OldPlacementTag = PlacementTag
	  ,@OldMediaAffiliateKey = MediaAffiliateKey
	  ,@OldMediaDayKey = MediaDayKey
	  ,@OldMediaDayPartKey = MediaDayPartKey
	  ,@OldMediaLen = MediaLen
	  ,@OldBillingBase = BillingBase
	  ,@OldBillingAdjPercent = BillingAdjPercent
	  ,@OldBillingAdjBase = BillingAdjBase
	  ,@OldMediaCategoryKey = MediaCategoryKey
	  ,@OldMediaWorksheetDemoKey = MediaWorksheetDemoKey
FROM tPurchaseOrder (nolock)
WHERE PurchaseOrderKey = @PurchaseOrderKey

-- If the Prebill At changes, check if some PODs have been prebilled or applied
IF @OldBillAt <> @BillAt
BEGIN
	IF EXISTS (SELECT 1 FROM tPurchaseOrderDetail (NOLOCK) WHERE PurchaseOrderKey = @PurchaseOrderKey
		AND InvoiceLineKey > 0)
		RETURN -10

	IF EXISTS (SELECT 1 FROM tPurchaseOrderDetail pod (NOLOCK) 
		INNER JOIN tVoucherDetail vd (NOLOCK) ON pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey 
		WHERE pod.PurchaseOrderKey = @PurchaseOrderKey)
		RETURN -10
END

IF @Emailed IS NULL
	SELECT	@Emailed = Emailed
	FROM	tPurchaseOrder (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey

/* Code segment added in case a order under a worksheet is updated from another source */

IF ISNULL(@MediaWorksheetKey, 0) = 0 AND ISNULL(@OldMediaWorksheetKey, 0) > 0
BEGIN
	SELECT @MediaWorksheetKey = @OldMediaWorksheetKey
	IF @InternalID IS NULL SELECT @InternalID = @OldInternalID
	IF @MediaPrintSpaceKey IS NULL AND @MediaPrintSpaceID IS NULL SELECT @MediaPrintSpaceKey = @OldMediaPrintSpaceKey
	IF @MediaPrintPositionKey IS NULL AND @MediaPrintPositionID IS NULL SELECT @MediaPrintPositionKey = @OldMediaPrintPositionKey
	IF @CompanyMediaPrintContractKey IS NULL SELECT @CompanyMediaPrintContractKey = @OldCompanyMediaPrintContractKey
	IF @MediaUnitTypeKey IS NULL SELECT @MediaUnitTypeKey = @OldMediaUnitTypeKey
	IF @CompanyMediaRateCardKey IS NULL SELECT @CompanyMediaRateCardKey = @OldCompanyMediaRateCardKey
	IF @MediaPrintSpaceID IS NULL SELECT @MediaPrintSpaceID = @OldMediaPrintSpaceID
	IF @MediaMarketKey IS NULL SELECT @MediaMarketKey = @OldMediaMarketKey
	IF @MediaPrintPositionID IS NULL SELECT @MediaPrintPositionID = @OldMediaPrintPositionID
	IF @PlacementTag IS NULL SELECT @PlacementTag = @OldPlacementTag
	IF @MediaAffiliateKey IS NULL SELECT @MediaAffiliateKey = @OldMediaAffiliateKey
	IF @MediaDayKey IS NULL SELECT @MediaDayKey = @OldMediaDayKey
	IF @MediaDayPartKey IS NULL SELECT @MediaDayPartKey = @OldMediaDayPartKey
	IF @MediaLen IS NULL SELECT @MediaLen = @OldMediaLen
	IF @BillingBase IS NULL SELECT @BillingBase = @OldBillingBase
	IF @BillingAdjPercent IS NULL SELECT @BillingAdjPercent = @OldBillingAdjPercent
	IF @BillingAdjBase IS NULL SELECT @BillingAdjBase = @OldBillingAdjBase
	IF @MediaCategoryKey IS NULL SELECT @MediaCategoryKey = @OldMediaCategoryKey
	IF @MediaWorksheetDemoKey IS NULL SELECT @MediaWorksheetDemoKey = @OldMediaWorksheetDemoKey
END


UPDATE
	tPurchaseOrder
SET
	CompanyKey = @CompanyKey,
	PurchaseOrderNumber = @PurchaseOrderNumber,
	VendorKey = @VendorKey,
	ProjectKey = @ProjectKey,
	TaskKey = @TaskKey,
	ItemKey = @ItemKey,
	ClassKey = @ClassKey,
	Contact = @Contact,
	PODate = @PODate,
	DueDate = @DueDate,
	OrderedBy = @OrderedBy,
	Printed = @Printed,
	PrintOption = @PrintOption,
	Downloaded = @Downloaded,
	CustomFieldKey = @CustomFieldKey,
	HeaderTextKey = @HeaderTextKey,
	FooterTextKey = @FooterTextKey,
	ApprovedByKey = @ApprovedByKey,
	CompanyMediaKey = @CompanyMediaKey,
	MediaEstimateKey = @MediaEstimateKey,
	OrderDisplayMode = @OrderDisplayMode,
	BillAt = @BillAt,
	SalesTaxKey = @SalesTaxKey,
	SalesTax2Key = @SalesTax2Key,
	FlightStartDate = @FlightStartDate,
	FlightEndDate = @FlightEndDate,
	FlightInterval = @FlightInterval,
	PrintClientOnOrder = @PrintClientOnOrder,
	PrintTraffic = @PrintTraffic,
	GLCompanyKey = @GLCompanyKey,
	CompanyAddressKey = @CompanyAddressKey,
	DateUpdated = CAST(CAST(MONTH(GETDATE()) AS varchar) + '/' + CAST(DAY(GETDATE()) AS varchar) + '/' + CAST(YEAR(GETDATE()) AS varchar) AS smalldatetime),
	LastUpdateBy = @LastUpdateBy,
	Emailed = @Emailed,
	MediaWorksheetKey = @MediaWorksheetKey,
	InternalID = @InternalID,
	MediaPrintSpaceKey = @MediaPrintSpaceKey,
	MediaPrintPositionKey = @MediaPrintPositionKey,
	CompanyMediaPrintContractKey = @CompanyMediaPrintContractKey,
	MediaUnitTypeKey = @MediaUnitTypeKey,
	CompanyMediaRateCardKey = @CompanyMediaRateCardKey,
	MediaPrintSpaceID = @MediaPrintSpaceID,
	MediaMarketKey = @MediaMarketKey,
	MediaPrintPositionID = @MediaPrintPositionID,
	CurrencyID = @CurrencyID,
	ExchangeRate = @ExchangeRate,
	PCurrencyID = @PCurrencyID,
	PExchangeRate = @PExchangeRate,
	PlacementTag = @PlacementTag,
	Description = @Description,
	MediaAffiliateKey = @MediaAffiliateKey,
	MediaDayKey = @MediaDayKey,
	MediaDayPartKey = @MediaDayPartKey,
	MediaLen = @MediaLen,
	BillingBase = @BillingBase,
	BillingAdjPercent = @BillingAdjPercent,
	BillingAdjBase = @BillingAdjBase,
	MediaCategoryKey = @MediaCategoryKey,
	MediaWorksheetDemoKey = @MediaWorksheetDemoKey
WHERE
	PurchaseOrderKey = @PurchaseOrderKey 

-- if it is an IO or BC and we have media, insert default order contacts from media default contacts
IF (@POKind = 1 OR @POKind = 2) AND @CompanyMediaKey IS NOT NULL AND @CompanyMediaKey <> @ExistingCompanyMediaKey
	EXEC sptPurchaseOrderUserDefault @PurchaseOrderKey, @CompanyMediaKey

/* Taxes should be handled in the PO line UI 
So only recalc if they change sales taxes
*/

IF ISNULL(@OldSalesTaxKey, 0) <> ISNULL(@SalesTaxKey, 0) OR ISNULL(@OldSalesTax2Key, 0) <> ISNULL(@SalesTax2Key, 0)
BEGIN
	-- Do this only if we have tPurchaseOrderDetailTax records, because this changes POD.SalesTax1Amount and POD.SalesTax2Amount
	-- and this is a problem when trying to create adjustments for the new media screens

	if exists (select 1 from tPurchaseOrderDetailTax podt (nolock)
				inner join tPurchaseOrderDetail pod (nolock) on podt.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				where pod.PurchaseOrderKey = @PurchaseOrderKey)
	begin 
		DELETE tPurchaseOrderDetailTax
		FROM tPurchaseOrderDetail vd (NOLOCK) 
		WHERE vd.PurchaseOrderKey = @PurchaseOrderKey
		AND   tPurchaseOrderDetailTax.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		AND   tPurchaseOrderDetailTax.SalesTaxKey IN (@SalesTaxKey, @SalesTax2Key)
	
		-- this will do the rollup also	
		EXEC sptPurchaseOrderRecalcAmounts @PurchaseOrderKey
	end 
	else
	begin
		EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey
	end
END
ELSE
BEGIN
	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey
END

EXEC sptProjectRollupUpdateEntity 'tPurchaseOrder', @PurchaseOrderKey, 0

RETURN @PurchaseOrderKey
GO
