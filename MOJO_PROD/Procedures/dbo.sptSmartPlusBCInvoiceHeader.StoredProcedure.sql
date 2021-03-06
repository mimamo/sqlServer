USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusBCInvoiceHeader]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusBCInvoiceHeader]
(
	@CompanyKey int,
	@UserKey int,
	@LinkID varchar(50),
	@InvoiceNumber varchar(50),
	@InvoiceDate smalldatetime,
	@PostingDate smalldatetime
)

as --Encrypt

/*
|| When     Who Rel    What
|| 12/05/06 RTC 8.4    Check to make sure an existing vendor invoice has not already been posted.
|| 10/10/07 BSH 8.5    Insert GLCompany and Office to the Invoice.
|| 06/18/08 GHL 8.513  Added OpeningTransaction
|| 09/16/08 RTC 10.0.0.9 Insure vendor is active.
|| 07/13/10 MAS 10.5.3.2 Changed CompanyKey = CompanyKey to CompanyKey = @CompanyKey to make sure we do not have 
||                       possible conflicts based solely on @LinkID and POKind since @LinkID may not be Unique across 
||                       multiple customers on hosted sites
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 01/17/12 GHL 10.5.5.2 VoucherType = 0 now since the Voucher UI can handle all po kinds 
|| 11/26/13 GHL 10.5.7.4 Added currency fields when calling sptVoucherInsert
|| 01/20/15 RLB 10.5.8.7 Adding missing parm
*/

declare @VoucherKey int
declare @TermsPercent decimal(24,4)
declare @TermsDays int
declare @TermsNet int
declare @RetVal int
declare @APAccountKey int
declare @POKey int
declare @VendorKey int
declare @DueDate smalldatetime
declare @GLCompanyKey int, @OfficeKey int, @BCClientLink smallint, @ProjectKey int
DECLARE	@AutoApproveExternalInvoices tinyint, @Status smallint
declare @Active tinyint

-- find associated purchase order/vendor
select @POKey = PurchaseOrderKey,
       @VendorKey = VendorKey,
       @GLCompanyKey = GLCompanyKey
  from tPurchaseOrder (nolock)
 where LinkID = @LinkID
   and CompanyKey = @CompanyKey
   and POKind = 2

if @POKey is null
	return -1

select @TermsPercent = isnull(TermsPercent, 0)
	  ,@TermsDays = isnull(TermsDays, 0)
	  ,@TermsNet = isnull(TermsNet, 0) 
	  ,@Active = isnull(Active, 0)
from tCompany (nolock)
where CompanyKey = @VendorKey
		 	
if @Active <> 1
	return -4
		
-- add or insert vendor invoice		
select @VoucherKey = min(VoucherKey) 
  from tVoucher (nolock)
 where CompanyKey = @CompanyKey 
   and LinkID = @LinkID
   and InvoiceNumber = @InvoiceNumber
   
if @VoucherKey is null
	begin
		
		if @InvoiceDate is null
			return -2
		if @InvoiceNumber is null
			return -3
			
		select	@APAccountKey = DefaultAPAccountKey,
				@AutoApproveExternalInvoices = AutoApproveExternalInvoices	 
		  from	tPreference (nolock)
		 where	CompanyKey = @CompanyKey
						
		select @DueDate = dateadd(day, @TermsNet, @InvoiceDate)
			
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
			null,
			null,
			@UserKey,
			@APAccountKey,
			null,
			null,
			null,
			@GLCompanyKey,
			@OfficeKey,
			0,	--OpeningTransaction
			0,	
			null, -- CurrencyID
			1,    -- ExchangeRate
			null, -- PCurrencyID
			1,    -- PExchangeRate	
			null, -- CompanyMediaKey		
			@VoucherKey output
			
		if @RetVal = -1
			return -10  --Invoice number already exists
			
		if @RetVal = -2
			return -11  --Project status is not accepting costs
		
		IF @AutoApproveExternalInvoices = 1
			SELECT @Status = 4
		ELSE
			SELECT @Status = 2	
		
		update tVoucher set LinkID = @LinkID, Status = @Status where VoucherKey = @VoucherKey
		
	end
ELSE
	--existing voucher, make sure it's not already been posted
	begin
		if (select Posted
			from tVoucher (nolock)
			where VoucherKey = @VoucherKey) = 1
				return -12 --voucher has already been posted, do not update
	end	
		
return @VoucherKey
GO
