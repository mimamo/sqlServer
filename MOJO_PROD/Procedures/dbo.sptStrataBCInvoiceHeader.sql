USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCInvoiceHeader]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCInvoiceHeader]
(
	@CompanyKey int,
	@UserKey int,
	@LinkID varchar(50),
	@VendorID varchar(50),
	@InvoiceNumber varchar(50),
	@InvoiceDate smalldatetime,
	@MatchedDate smalldatetime = NULL,
	@DueDate smalldatetime,
	@EstimateID varchar(50)
)

as --Encrypt

/*
|| When     Who Rel      What
|| 11/16/06 CRG 8.3571   Modified to get the ClassKey from the Estimate. 
|| 12/05/06 RTC 8.4      Check to make sure an existing vendor invoice has not already been posted
|| 10/09/07 BSH 8.5      Insert GLCompany and Office to the Invoice.
|| 06/18/08 GHL 8.513    Insert OpeningTransaction to the Invoice.
|| 09/16/08 RTC 10.0.0.9 Insure vendor is active.
|| 03/25/10 MAS 10.5.1.3 (76058) Added the option to use the ClearDate from Strata as the PostingDate	
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert		
|| 01/17/12 GHL 10.5.5.2 VoucherType = 0 now since the Voucher UI can handle all po kinds 	
|| 08/13/12 MAS 10.5.5.9 Use the Vendor's DefaultAPAccountKey if it's set.  Otherwise default to the Company DefaultAPAccountKey
|| 10/05/12 MAS 10.5.6.0 (155997) In some cases the Vendor's DefaultAPAccountKey was 0.  We were looking for NULL 	
|| 01/20/15 RLB 10.5.8.7 Adding missing parm	 
*/

Declare @VoucherKey int, @VendorKey int, @TermsPercent decimal(24,4), @TermsDays int, @TermsNet int, @RetVal int, @APAccountKey int
declare @ClassKey int, @GLCompanyKey int, @OfficeKey int, @BCClientLink smallint, @ProjectKey int
declare @Active tinyint
declare @PostingDate smalldatetime
declare @UseClearedDate int

DECLARE	@AutoApproveExternalInvoices tinyint, @Status smallint

Select @VoucherKey = min(VoucherKey) from tVoucher (NOLOCK) Where CompanyKey = @CompanyKey and LinkID = @LinkID

--get defaults needed
select   @UseClearedDate = ISNULL(UseClearedDate, 0) 
from tPreference (nolock)
where CompanyKey = @CompanyKey

If @UseClearedDate > 0 
	Select @PostingDate = @MatchedDate
else
	Select @PostingDate = @InvoiceDate
	
select @VendorKey = CompanyKey
	  ,@Active = isnull(Active, 0)
	  ,@APAccountKey = DefaultAPAccountKey 	
from tCompany (nolock) 
where OwnerCompanyKey = @CompanyKey 
and Vendor = 1 
and VendorID = @VendorID
			
if @VendorKey is null
	return -1
	
if @Active <> 1
	return -4
						
if @VoucherKey is null
	BEGIN
		if @InvoiceDate is null
			return -2
		if @InvoiceNumber is null
			return -3
			
        -- Use the company defualt APAccountKey if the vendor didn't have one setup
		if ISNULL(@APAccountKey, 0) = 0
			Select	@APAccountKey = DefaultAPAccountKey,
					@AutoApproveExternalInvoices = AutoApproveExternalInvoices, 
					@BCClientLink = isnull(BCClientLink,1)
			from	tPreference (NOLOCK) 
			Where	CompanyKey = @CompanyKey
		else
			Select	@AutoApproveExternalInvoices = AutoApproveExternalInvoices,
					@BCClientLink = isnull(BCClientLink,1) 
			from	tPreference (NOLOCK) 
			Where	CompanyKey = @CompanyKey 
			
		Select @TermsPercent = ISNULL(TermsPercent, 0), @TermsDays = ISNULL(TermsDays, 0), @TermsNet = ISNULL(TermsNet, 0) 
			From tCompany (NOLOCK) Where CompanyKey = @VendorKey
			
		Select @DueDate = ISNULL(@DueDate, DATEADD(day, @TermsNet, @InvoiceDate))

		SELECT	@ClassKey = ClassKey,
				@ProjectKey = ProjectKey,
				@GLCompanyKey = GLCompanyKey,
				@OfficeKey = OfficeKey
		FROM	tMediaEstimate (nolock)
		WHERE	EstimateID = @EstimateID
		AND		CompanyKey = @CompanyKey

		exec @RetVal = sptVoucherInsert
			@CompanyKey,
			@VendorKey,
			@InvoiceDate,
			@PostingDate,
			@InvoiceNumber,
			@InvoiceDate,
			@UserKey,
			@TermsPercent,
			@TermsDays,
			@TermsNet,
			@DueDate,
			NULL,
			@ProjectKey,
			@UserKey,
			@APAccountKey,
			@ClassKey,
			NULL,
			NULL,
			@GLCompanyKey,
			@OfficeKey,
			0, -- OpeningTransaction
			0,
			null, -- CurrencyID
			1,    -- ExchangeRate
			null, -- PCurrencyID
			1,    -- PExchangeRate
			null, -- CompanyMediaKey		
			@VoucherKey output
			
		if @RetVal = -1
			Return -10  --Invoice number already exists
			
		if @RetVal = -2
			Return -11  --Project status is not accepting costs
			
		IF @AutoApproveExternalInvoices = 1
			SELECT @Status = 4
		ELSE
			SELECT @Status = 2	
		
		Update tVoucher Set LinkID = @LinkID, Status = @Status Where VoucherKey = @VoucherKey
		
	END
ELSE
	--existing voucher, make sure it's not already been posted
	begin
		if (select Posted
			from tVoucher (nolock)
			where VoucherKey = @VoucherKey) = 1
				return -12 --voucher has already been posted, do not update
	end	
	
Return @VoucherKey
GO
