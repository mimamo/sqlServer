USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdateRecurring]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdateRecurring]

	(
		@SourceInvoiceKey int,
		@TargetInvoiceKey int
	)

AS

  /*
  || When     Who Rel    What
  || 02/19/10 GHL 10.518 Added missing tax info 
  */
  
if exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @SourceInvoiceKey and BillFrom = 2)
	return -1
	
if exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @TargetInvoiceKey and BillFrom = 2)
	return -1

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @TargetInvoiceKey and (Posted = 1 or AmountReceived > 0 or RetainerAmount > 0))
	return -1
	

Declare @CompanyKey int,
	@ClientKey int,
	@ContactName varchar(100),
	@BillingContactKey int,
	@AdvanceBill tinyint,
	@TermsKey int,
	@ARAccountKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@ClassKey int,
	@ProjectKey int,
	@RetainerAmount money,
	@DiscountAmount money,
	@SalesTaxAmount money,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@TotalNonTaxAmount money,
	@InvoiceTotalAmount money,
	@HeaderComment varchar(500),
	@SalesTaxKey int,
	@SalesTax2Key int,
	@ApprovedByKey int,
	@InvoiceTemplateKey int,
	@InvoiceStatus smallint,
	@ApprovedDate smalldatetime,
	@ApprovalComments varchar(500),
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250)


Select
	@CompanyKey = CompanyKey,
	@ClientKey = ClientKey,
	@ContactName = ContactName,
	@BillingContactKey = BillingContactKey,
	@AdvanceBill = AdvanceBill,
	@TermsKey = TermsKey,
	@ARAccountKey = ARAccountKey,
	@GLCompanyKey = GLCompanyKey,
	@OfficeKey = OfficeKey,
	@ClassKey = ClassKey,
	@ProjectKey = ProjectKey,
	@RetainerAmount = RetainerAmount,
	@DiscountAmount = DiscountAmount,
	@SalesTaxAmount = SalesTaxAmount,
	@SalesTax1Amount = SalesTax1Amount,
	@SalesTax2Amount = SalesTax2Amount,
	@TotalNonTaxAmount = TotalNonTaxAmount,
	@InvoiceTotalAmount = InvoiceTotalAmount,
	@HeaderComment = HeaderComment,
	@SalesTaxKey = SalesTaxKey,
	@SalesTax2Key = SalesTax2Key,
	@ApprovedByKey = ApprovedByKey,
	@InvoiceTemplateKey = InvoiceTemplateKey,
	@InvoiceStatus = InvoiceStatus,
	@ApprovedDate = ApprovedDate,
	@ApprovedByKey = ApprovedByKey,
	@ApprovalComments = ApprovalComments,
	@UserDefined1 = UserDefined1,
	@UserDefined2 = UserDefined2,
	@UserDefined3 = UserDefined3,
	@UserDefined4 = UserDefined4,
	@UserDefined5 = UserDefined5,
	@UserDefined6 = UserDefined6,
	@UserDefined7 = UserDefined7,
	@UserDefined8 = UserDefined8,
	@UserDefined9 = UserDefined9,
	@UserDefined10 = UserDefined10
From tInvoice (nolock)
WHERE
	InvoiceKey = @SourceInvoiceKey 
		
UPDATE
		tInvoice
	SET
		CompanyKey = @CompanyKey,
		ClientKey = @ClientKey,
		ContactName = @ContactName,
		BillingContactKey = @BillingContactKey,
		AdvanceBill = @AdvanceBill,
		TermsKey = @TermsKey,
		ARAccountKey = @ARAccountKey,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		ClassKey = @ClassKey,
		ProjectKey = @ProjectKey,
		RetainerAmount = @RetainerAmount,
		DiscountAmount = @DiscountAmount,
		SalesTaxAmount = @SalesTaxAmount,
		SalesTax1Amount = @SalesTax1Amount,
		SalesTax2Amount = @SalesTax2Amount,
		TotalNonTaxAmount = @TotalNonTaxAmount,
		InvoiceTotalAmount = @InvoiceTotalAmount,
		HeaderComment = @HeaderComment,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		InvoiceStatus = @InvoiceStatus,
		ApprovedDate = @ApprovedDate,
		ApprovedByKey = @ApprovedByKey,
		ApprovalComments = @ApprovalComments,
		InvoiceTemplateKey = @InvoiceTemplateKey,
		UserDefined1 = @UserDefined1,
		UserDefined2 = @UserDefined2,
		UserDefined3 = @UserDefined3,
		UserDefined4 = @UserDefined4,
		UserDefined5 = @UserDefined5,
		UserDefined6 = @UserDefined6,
		UserDefined7 = @UserDefined7,
		UserDefined8 = @UserDefined8,
		UserDefined9 = @UserDefined9,
		UserDefined10 = @UserDefined10
	WHERE
		InvoiceKey = @TargetInvoiceKey 


Delete tInvoiceLine Where InvoiceKey = @TargetInvoiceKey

exec sptInvoiceGenerateRecurringLines @SourceInvoiceKey, @TargetInvoiceKey, 0, 0

EXEC sptInvoiceRecalcAmounts @TargetInvoiceKey
GO
