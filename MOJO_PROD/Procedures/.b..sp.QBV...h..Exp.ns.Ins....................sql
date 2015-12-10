USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBVoucherExpenseInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBVoucherExpenseInsert]
    @CompanyKey int,
	@VoucherKey int,
	@ClientID varchar(100),
	@ExpenseAccountID varchar(100),
	@TotalCost money,
	@ShortDescription varchar(500)


AS --Encrypt

/*
|| When     Who Rel   What
|| 09/28/06 CRG 8.35  Added parameter for sptVoucherDetailInsert
|| 09/25/07 BSH 8.5   (9659)Insert OfficeKey, DepartmentKey as null to sptVoucherDetailInsert.
|| 01/31/08 GHL 8.503 (20244) Added sptVoucherDetailInsert.CheckProject parameter so that the checking of the project 
||                    can be bypassed when creating vouchers from expense receipts  
|| 10/16/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/06/13 GHL 10.5.7.4 Added multi currency fields
*/

declare @ClientKey int
declare @GLAccountKey int
declare @VoucherDetailKey int
declare @RetVal int


	if @ClientID is not null
		begin
			select @ClientKey = CompanyKey 
			from tCompany (nolock)
			where LinkID = @ClientID
			and OwnerCompanyKey = @CompanyKey

			if @ClientKey is null
				return -10
		end
	
	select @GLAccountKey = GLAccountKey 
	  from tGLAccount (nolock)
	 where LinkID = @ExpenseAccountID
	   and CompanyKey = @CompanyKey
	 
	if @GLAccountKey is null
		return -11
		
	exec @RetVal = sptVoucherDetailInsert
		 @VoucherKey,
		 null,
		 @ClientKey,
		 null,
		 null,
		 null,
		 null,
		 @ShortDescription,
		 null,
		 null,
		 null,
		 @TotalCost,
		 null,
		 1,
		 null,
		 null,
		 @GLAccountKey,
		 null,
		 null,	
		 0,
		 null,
		 null,
		 1, -- @CheckProject
		 null, -- Commission
		 @TotalCost, -- GrossAmount
		 NULL, -- PCurrencyID
		 1, -- PExchangeRate
		 @TotalCost, -- PTotalCost
		 
		 @VoucherDetailKey
		
	RETURN 1
GO
