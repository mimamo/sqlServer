USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBVoucherInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBVoucherInsert]
	@CompanyKey int,
	@UserKey int,
	@InvoiceNumber varchar(50),
	@TransactionDate smalldatetime,
	@DueDate smalldatetime,
	@VendorID varchar(100),
	@Description varchar(500),
	@LinkID varchar(100)
				
				
AS --Encrypt

/*
|| When     Who Rel     What
|| 09/25/07 BSH 8.5     (9659)Insert null values for GLCompanyKey and OfficeKey
|| 06/18/08 GHL 8.513   Added OpeningTransaction
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 11/06/13 GHL 10.5.7.4 Added multi currency fields
|| 01/03/14 WDF 10.5.7.6 (188500) Added @UserKey to sptVoucherInsert
|| 01/20/15 RLB 10.5.8.7 Adding missing parm
*/
		   

declare @RetVal integer
declare @VendorKey int
declare @VoucherKey int


	select @VendorKey = CompanyKey
	  from tCompany (nolock)
     where LinkID = @VendorID
	   and OwnerCompanyKey = @CompanyKey
     
    if @VendorKey is null
		return -10

	select @VoucherKey = VoucherKey
	  from tVoucher (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	      
if @VoucherKey is null
  begin
	exec @RetVal = sptVoucherInsert
		 @CompanyKey,
		 @VendorKey,
		 @TransactionDate,
		 @TransactionDate,
		 @InvoiceNumber,
		 @TransactionDate,
		 @UserKey,
		 null,
		 null,
		 null,
		 @DueDate,
		 @Description,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 0,	--OpeningTransaction
		 1, -- VoucherType
		 NULL, -- CurrencyID
		 1, -- ExchangeRate
		 NULL, -- PCurrencyID
		 1, -- PExchangeRate
		 NULL, -- CompanyMediaKey
		 				
		 @VoucherKey output
		
	if @RetVal < 0 
		return -1

	update tVoucher
	   set Status = 4,
	       LinkID = @LinkID,
	       ApprovedDate = @TransactionDate,
	       ApprovedByKey = @UserKey
	 where VoucherKey = @VoucherKey
  end
else
  begin
	update tVoucher
       set VendorKey = @VendorKey,
           InvoiceDate = @TransactionDate,
           PostingDate = @TransactionDate,
           DateReceived = @TransactionDate,
           InvoiceNumber = @InvoiceNumber,
		   DueDate = @DueDate,
		   Description = @Description   
     where VoucherKey = @VoucherKey        
  end
   	
	return @VoucherKey
GO
