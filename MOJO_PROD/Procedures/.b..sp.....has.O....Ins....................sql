USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderInsert]
	@CompanyKey int,
	@POKind smallint,
	@PurchaseOrderTypeKey int,
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
	@CustomFieldKey int,
	@HeaderTextKey int,
	@FooterTextKey int,
	@ApprovedByKey int,
	@CreatedByKey int,
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
	@PrintOption tinyint,
	@GLCompanyKey int,
	@CompanyAddressKey int,
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/12/07 BSH 8.5     (9659)Update GLCompanyKey
|| 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey param
|| 10/07/09 MAS 10.5.1.9 Use the Client Costing preference from tPref when creating new records
|| 06/06/11 GHL 10.5.4.5 (113213) In order to fight duplicate PO#s, placed GetNextTranNo closer to insert
|| 11/0/11  RLB 10.500  (121862) Added for enhancement
|| 07/12/12 GHL 10.558  Added validation of GLCompany on media estimates (fixed typo)
|| 01/31/13 WDF 10.5.6.4 (145601) Add GLCompany check on Vendor for Order Copies
|| 12/16/13 GHL 10.5.7.5 Added currency info
|| 05/02/14 GHL 10.5.7.9 Added setting of po.ShowAdjustmentsAsSingleLine
*/

	DECLARE @Address1 varchar(100)
	DECLARE @Address2 varchar(100)
	DECLARE @Address3 varchar(100)
	DECLARE @City varchar(100)
	DECLARE @State varchar(50)
	DECLARE @PostalCode varchar(20)
	DECLARE @Country varchar(50)
	Declare @TranType varchar(2)
	DECLARE @RetVal	INTEGER,	@NextTranNo VARCHAR(100)
	Declare @UseClientCosting tinyint
	Declare @BCUseClientCosting tinyint
	DECLARE @BCShowAdjustmentsAsSingleLine tinyint
	DECLARE @IOShowAdjustmentsAsSingleLine tinyint
	Declare @IOUseClientCosting tinyint
	Declare @VendorID varchar(50)
	Declare @MultiCurrency int

	IF EXISTS(SELECT 1 FROM tPurchaseOrder (NOLOCK) WHERE CompanyKey = @CompanyKey and POKind = @POKind and PurchaseOrderNumber = @PurchaseOrderNumber)
		Return -1
				
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2

	--Make sure MediaEstimate and IO/BC belong to same company. 
	IF (@POKind = 1 OR @POKind = 2) AND @MediaEstimateKey IS NOT NULL
		IF EXISTS(SELECT 1
				FROM  tMediaEstimate (nolock) 
				WHERE MediaEstimateKey = @MediaEstimateKey
				AND   ISNULL(GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
			RETURN -3
			
	-- Check that Vendor ID is valid for the GLCompany
    IF EXISTS(SELECT 1 FROM tPreference (NOLOCK) WHERE CompanyKey = @CompanyKey and RestrictToGLCompany = 1)
    BEGIN
        SELECT @VendorID = VendorID FROM tCompany WHERE CompanyKey = @VendorKey
        
		EXEC @RetVal = sptCompanyRestrictValidVendor @CompanyKey, @VendorID, N'transactions',
				@GLCompanyKey, Null, 1
				
		IF @RetVal = 0 
		   RETURN -8
     END


	Select @BCUseClientCosting = isnull(BCUseClientCosting, 0),
		   @IOUseClientCosting = isnull(IOUseClientCosting, 0),
		   @MultiCurrency = ISNULL(MultiCurrency, 0),
		   @BCShowAdjustmentsAsSingleLine = isnull(BCShowAdjustmentsAsSingleLine, 1),
		   @IOShowAdjustmentsAsSingleLine = isnull(IOShowAdjustmentsAsSingleLine, 1)
	From tPreference (NOLOCK) 
	Where CompanyKey = @CompanyKey
			
 -- Get the next number
 if @POKind = 0 
	Begin
		Select @UseClientCosting = 0
		Select @TranType = 'PO'
	End
 if @POKind = 1
	Begin
		Select @UseClientCosting = @IOUseClientCosting
		Select @TranType = 'IO'
	End
 if @POKind = 2 
	Begin
		Select @UseClientCosting = @BCUseClientCosting
		Select @TranType = 'BC'
	End

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
			LEFT OUTER JOIN tAddress ad (NOLOCK) ON c.DefaultAddressKey = ad.AddressKey 
			LEFT OUTER JOIN tAddress ap (NOLOCK) ON c.PaymentAddressKey = ap.AddressKey 
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
	
 IF @PurchaseOrderNumber IS NULL OR @PurchaseOrderNumber = ''
 BEGIN
	EXEC spGetNextTranNo
		@CompanyKey,
		@TranType,		-- TranType
		@RetVal		      OUTPUT,
		@NextTranNo 		OUTPUT

	IF @RetVal <> 1
		RETURN -1
END
ELSE
	SELECT @NextTranNo = @PurchaseOrderNumber


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
		PrintOption,
		GLCompanyKey,
		CompanyAddressKey,
		UseClientCosting,
		CurrencyID,  
		ExchangeRate,
		PCurrencyID,  
		PExchangeRate,
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
		@PrintOption,
		@GLCompanyKey,
		@CompanyAddressKey,
		@UseClientCosting,
		@CurrencyID,  
		@ExchangeRate,
		@PCurrencyID,  
		@PExchangeRate,
		case @POKind 
				when 1 then @IOShowAdjustmentsAsSingleLine
				when 2 then @BCShowAdjustmentsAsSingleLine
				else 1
			end
		)
	
	SELECT @oIdentity = @@IDENTITY

	-- if it is an IO or BC and we have media, insert default order contacts from media default contacts if no contact specified
	if (@POKind = 1 or @POKind = 2) and @CompanyMediaKey is not null and @Contact is null
		exec sptPurchaseOrderUserDefault @oIdentity, @CompanyMediaKey

	RETURN 1
GO
