USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceInsertSplit]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceInsertSplit]

	(
		@ParentInvoiceKey int,
		@ClientKey int,
		@PercentageSplit decimal(24,4)
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 09/19/07 GHL 8.5   Added GLCompanyKey + OfficeKey
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 11/30/09 GHL 10.514 (63703) Get now sales taxes from the client
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 08/21/12 GHL 10.559 (150786) Added check of client key <> 0 
||                     patch because of project setup should not allow that
|| 10/01/13 GHL 10.573 Added multi currency logic
|| 01/03/14 WDF 10.576 (188500) Added @CreatedByKey
*/

Declare  @CompanyKey int
		,@AdvanceBill tinyint
		,@InvoiceDate smalldatetime
		,@DueDate smalldatetime
		,@PostingDate smalldatetime
		,@TermsKey int
		,@ARAccountKey int
		,@ClassKey int
		,@ProjectKey int
		,@HeaderComment varchar(500)
		,@SalesTaxKey int
		,@SalesTax2Key int
		,@InvoiceTemplateKey int
		,@ApprovedByKey int
		,@UserDefined1 varchar(250)
		,@UserDefined2 varchar(250)
		,@UserDefined3 varchar(250)
		,@UserDefined4 varchar(250)
		,@UserDefined5 varchar(250)
		,@UserDefined6 varchar(250)
		,@UserDefined7 varchar(250)
		,@UserDefined8 varchar(250)
		,@UserDefined9 varchar(250)
		,@UserDefined10 varchar(250)
		,@Downloaded tinyint
		,@Printed tinyint
		,@NewKey int
		,@RetVal int
		,@GLCompanyKey int
		,@OfficeKey int
		,@LayoutKey int
		,@MultiCurrency int
		,@CurrencyID varchar(10)
		,@ParentCurrencyID varchar(10)
		,@ExchangeRate decimal(24,7)
	    ,@CreatedByKey int

Select
	 @CompanyKey = CompanyKey
	,@AdvanceBill = AdvanceBill
	,@InvoiceDate = InvoiceDate
	,@DueDate = DueDate
	,@PostingDate = PostingDate
	,@TermsKey = TermsKey
	,@ARAccountKey = ARAccountKey
	,@ClassKey = ClassKey
	,@ProjectKey = ProjectKey
	,@HeaderComment = HeaderComment
	,@SalesTaxKey = SalesTaxKey
	,@SalesTax2Key = SalesTax2Key
	,@InvoiceTemplateKey = InvoiceTemplateKey
	,@ApprovedByKey = ApprovedByKey
	,@UserDefined1 = UserDefined1
	,@UserDefined2 = UserDefined2
	,@UserDefined3 = UserDefined3
	,@UserDefined4 = UserDefined4
	,@UserDefined5 = UserDefined5
	,@UserDefined6 = UserDefined6
	,@UserDefined7 = UserDefined7
	,@UserDefined8 = UserDefined8
	,@UserDefined9 = UserDefined9
	,@UserDefined10 = UserDefined10
	,@Downloaded = Downloaded
	,@Printed = Printed
	,@GLCompanyKey = GLCompanyKey
	,@OfficeKey = OfficeKey
	,@LayoutKey = LayoutKey
	,@ParentCurrencyID = CurrencyID
	,@ExchangeRate = ExchangeRate
	,@CreatedByKey = CreatedByKey
 
From tInvoice (nolock)
Where InvoiceKey = @ParentInvoiceKey

Select @SalesTaxKey = SalesTaxKey
	  ,@SalesTax2Key = SalesTax2Key
	  ,@CurrencyID = CurrencyID
From   tCompany (nolock)
Where  CompanyKey = @ClientKey

if @@ROWCOUNT = 0
	return 0

select @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
 
if @MultiCurrency = 1 and isnull(@ParentCurrencyID, '') <> isnull(@CurrencyID, '') 
	return -10 -- return an error not returned by sptInvoiceInsert

exec @RetVal = sptInvoiceInsert
	@CompanyKey,
	@ClientKey,
	NULL,
	NULL,
	NULL,
	@AdvanceBill,
	NULL,
	@InvoiceDate,
	@DueDate,
	@PostingDate,
	@TermsKey,
	@ARAccountKey,
	@ClassKey,
	NULL, --@ProjectKey, setting this to null so it does not create another parent invoice
	@HeaderComment,
	@SalesTaxKey,
	@SalesTax2Key,
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
	0,
	0, --Emailed
	@CreatedByKey,
	@GLCompanyKey,
	@OfficeKey,
	0, --OpeningTransaction
	@LayoutKey,
	@ParentCurrencyID,
	@ExchangeRate,
	0, -- @RequestExchangeRate
	@NewKey output
	

	
if @NewKey > 0
BEGIN
	Update tInvoice 
	Set ProjectKey = @ProjectKey,
		PercentageSplit = @PercentageSplit,
		ParentInvoiceKey = @ParentInvoiceKey
	Where
		InvoiceKey = @NewKey

	exec sptInvoiceRollupAmounts @NewKey
		
END	

return @RetVal
GO
