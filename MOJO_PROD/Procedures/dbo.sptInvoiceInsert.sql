USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceInsert]
	@CompanyKey int,
	@ClientKey int,
	@ContactName Varchar(100),
	@PrimaryContactKey int,
	@AddressKey int,
	@AdvanceBill tinyint,
	@InvoiceNumber varchar(35),
	@InvoiceDate smalldatetime,
	@DueDate smalldatetime,
	@PostingDate smalldatetime,
	@TermsKey int,
	@ARAccountKey int,
	@ClassKey int,
	@ProjectKey int,
	@HeaderComment text,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@InvoiceTemplateKey int,
	@ApprovedByKey int,
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250),
	@Downloaded tinyint,
	@Printed tinyint,
	@ParentInvoice tinyint,
	@Emailed tinyint,
	@CreatedByKey INT,
	@GLCompanyKey INT = NULL,
    @OfficeKey INT = NULL,    
    @OpeningTransaction tinyint = 0,
    @LayoutKey int = NULL,
	@CurrencyID varchar(10) = null,
    @ExchangeRate decimal(14,7) = 1, -- pass exchange rate
	@RequestExchangeRate int = 0, -- or request to get it for you 
    @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 06/21/07 GHL 8.5   Added GLCompanyKey + OfficeKey
|| 10/22/07 CRG 8.5   (13583) Added logic for projects with Split Billing
|| 01/18/08 GHL 8.502 Removed all project locking in UI, but added validation here 
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 03/24/10 GHL 10.521 Added LayoutKey
|| 09/12/12 GHL 10.560 Added pulling of AlternatePayerKey from the client
|| 10/01/13 GHL 10.673 Added currency and rate to support multi currency
|| 01/03/14 WDF 10.576 (188500) Added CreatedByKey and DateCreated
|| 02/22/15 GHL 10.589 (245992) When billing by client, get the approver from the AE on the client
||                      if Default Approver = AE From Project
*/

DECLARE @Error INT

 IF EXISTS(
  SELECT 
   *
  FROM 
   tInvoice (nolock)
  WHERE
   CompanyKey = @CompanyKey AND
   InvoiceNumber = @InvoiceNumber)
 BEGIN
  SELECT @oIdentity = 0
  RETURN 0
 END
 
	DECLARE @RetVal	INTEGER
			,@NextTranNo VARCHAR(100)
			,@InvoiceNumberRequired INT
			,@UseGLCompany INT
			,@ProjectGLCompanyKey INT
			
-- DefaultARApprover/ApproverDef 
-- 0 Person Entering the Invoice
-- 1 AE From project
-- 2 Automatically approved ==> set invoice # when SetInvoiceNumberOnApproval = 1
-- 3 Default Approver in tPrefs

Declare @Status smallint, @ApproverPref smallint, @SetInvoiceNumberOnApproval tinyint, @DefaultApprover int
       ,@AlternatePayerKey int

Select @ApproverPref = ISNULL(DefaultARApprover, 0) 
      ,@SetInvoiceNumberOnApproval = ISNULL(SetInvoiceNumberOnApproval, 0)
      ,@DefaultApprover = ISNULL(DefaultARApproverKey, 0)
	  ,@UseGLCompany = ISNULL(UseGLCompany, 0)	
from tPreference (NOLOCK) 
Where CompanyKey = @CompanyKey

Declare @AE int
select @Status = 1
if @ApproverPref = 1
BEGIN 
	IF ISNULL(@ProjectKey, 0) > 0
	BEGIN
		Select @AE = ISNULL(AccountManager, 0) from tProject (nolock) Where ProjectKey = @ProjectKey
		if @AE > 0
			Select @ApprovedByKey = @AE
	END
	ELSE
	BEGIN
		Select @AE = ISNULL(AccountManagerKey, 0) from tCompany (nolock) Where CompanyKey = @ClientKey
		if @AE > 0
			Select @ApprovedByKey = @AE
	END
	
END

if @ApproverPref = 2
	Select @Status = 4

if @ApproverPref = 3 AND @DefaultApprover > 0
	Select @ApprovedByKey = @DefaultApprover

-- Only case when Invoice Number is not required
If @SetInvoiceNumberOnApproval = 1 And @ApproverPref <> 2
	Select @InvoiceNumberRequired = 0
Else
	Select @InvoiceNumberRequired = 1

 IF @InvoiceNumberRequired = 1
 BEGIN			
	-- Get the next number
	IF @InvoiceNumber IS NULL OR @InvoiceNumber = ''
	BEGIN
			EXEC spGetNextTranNo
				@CompanyKey,
				'AR',		-- TranType
				@RetVal		      OUTPUT,
				@NextTranNo 		OUTPUT
		
			IF @RetVal <> 1
				RETURN -1
	END
	ELSE
			SELECT @NextTranNo = @InvoiceNumber
			
		-- At this time, do not worry about InvoiceDate, PostingDate, DueDate
		-- Should be handled by UI, can be null now
		-- sptInvoiceChangeStatus will take care of nulls during approval	
END

ELSE
	-- Invoice Number not required
	-- Take null or what user gives us
	SELECT @NextTranNo = @InvoiceNumber
	
IF @GLCompanyKey = 0
	SELECT @GLCompanyKey = NULL
IF @OfficeKey = 0
	SELECT @OfficeKey = NULL
IF @ClassKey = 0
	SELECT @ClassKey = NULL	
IF @ProjectKey = 0
	SELECT @ProjectKey = NULL	

IF @UseGLCompany = 1 AND @ProjectKey IS NOT NULL
BEGIN
	SELECT @ProjectGLCompanyKey = GLCompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	IF ISNULL(@ProjectGLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0)
		RETURN -2

END
		
SELECT @AlternatePayerKey = AlternatePayerKey FROM tCompany (nolock) WHERE CompanyKey = @ClientKey

 -- Now multi currency
DECLARE @MultiCurrency int
DECLARE @RateHistory int

select @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
 
if @MultiCurrency = 0
begin
	select @CurrencyID = null 
		  ,@ExchangeRate = 1
end
else 
begin
	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1

	-- get the exchange rate for day/gl comp/curr if requested
	if @RequestExchangeRate = 1 and isnull(@CurrencyID, '') <> ''
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @InvoiceDate, @ExchangeRate output, @RateHistory output

	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1

end

 INSERT tInvoice
  (
	CompanyKey,
	ClientKey,
	ContactName,
	PrimaryContactKey,
	AddressKey,
	AdvanceBill,
	InvoiceNumber,
	InvoiceDate,
	DueDate,
	PostingDate,
	TermsKey,
	ARAccountKey,
	ClassKey,
	ProjectKey,
	InvoiceStatus,
	HeaderComment,
	SalesTaxKey,
	SalesTax2Key,
	SalesTaxAmount,
	TotalNonTaxAmount,
	InvoiceTotalAmount,
	InvoiceTemplateKey,
	ApprovedByKey,
	UserDefined1,
	UserDefined2,
	UserDefined3,
	UserDefined4,
	UserDefined5,
	UserDefined6,
	UserDefined7,
	UserDefined8,
	UserDefined9,
	UserDefined10,
	Downloaded,
	Printed,
	ParentInvoice,
	Emailed,
	GLCompanyKey,
	OfficeKey,
	OpeningTransaction,
	LayoutKey,
	AlternatePayerKey,
	CurrencyID,
	ExchangeRate,
	CreatedByKey,
	DateCreated
  )
 VALUES
  (
	@CompanyKey,
	@ClientKey,
	@ContactName,
	@PrimaryContactKey,
	@AddressKey,
	@AdvanceBill,
	RTRIM(LTRIM(@NextTranNo)),
	@InvoiceDate,
	@DueDate,
	@PostingDate,
	@TermsKey,
	@ARAccountKey,
	@ClassKey,
	@ProjectKey,
	@Status,  -- Not sent for approval
	@HeaderComment,
	@SalesTaxKey,
	@SalesTax2Key,
	0,	-- SalesTaxAmount,
	0,	-- TotalNonTaxAmount,
	0,		-- InvoiceTotalAmount
	@InvoiceTemplateKey,
	@ApprovedByKey,
	@UserDefined1,
	@UserDefined2,
	@UserDefined3,
	@UserDefined4,
	@UserDefined5,
	@UserDefined6,
	@UserDefined7,
	@UserDefined8,
	@UserDefined9,
	@UserDefined10,
	@Downloaded,
	@Printed,
	@ParentInvoice,
	@Emailed,
	@GLCompanyKey,
	@OfficeKey,
	@OpeningTransaction,
	@LayoutKey,
	@AlternatePayerKey,
	@CurrencyID,
	@ExchangeRate,
	@CreatedByKey,
	GETDATE()
  )
 
 SELECT @oIdentity = @@IDENTITY
       ,@Error = @@ERROR

 IF @Error <> 0
	RETURN -2

 if ISNULL(@ProjectKey, 0) > 0
 BEGIN
	DECLARE	@SplitBilling tinyint,
			@ProjectSplitBillingKey int,
			@PercentageSplit decimal(24,4)
	
	SELECT	@SplitBilling = SplitBilling
	FROM	tPreference (nolock)
	WHERE	CompanyKey = @CompanyKey
	
	IF @SplitBilling = 1
	BEGIN
		IF EXISTS
				(SELECT	NULL
				FROM	tProjectSplitBilling (nolock)
				WHERE	ProjectKey = @ProjectKey)
		BEGIN
			SELECT	@ProjectSplitBillingKey = 0
			Update tInvoice Set ParentInvoice = 1 Where InvoiceKey = @oIdentity
			
			WHILE (1=1)
			BEGIN
				SELECT	@ProjectSplitBillingKey = MIN(ProjectSplitBillingKey)
				FROM	tProjectSplitBilling (nolock)
				WHERE	ProjectKey = @ProjectKey
				AND		ProjectSplitBillingKey > @ProjectSplitBillingKey

				IF @ProjectSplitBillingKey IS NULL
					BREAK
					
				SELECT	@ClientKey = ClientKey,
						@PercentageSplit = PercentageSplit
				FROM	tProjectSplitBilling (nolock)
				WHERE	ProjectSplitBillingKey = @ProjectSplitBillingKey
				
				EXEC @Error = sptInvoiceInsertSplit @oIdentity, @ClientKey, @PercentageSplit
				
				IF @Error < 0
					RETURN @Error
			END
		END
	END			
END
      
RETURN 1
GO
