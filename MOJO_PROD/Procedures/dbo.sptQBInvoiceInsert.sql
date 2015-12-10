USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBInvoiceInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBInvoiceInsert]
	@CompanyKey int,
	@UserKey int,
	@InvoiceNumber varchar(50),
	@TransactionDate smalldatetime,
	@DueDate smalldatetime,
	@ClientID varchar(100),
	@HeaderComment varchar(500),
	@ARAccountID varchar(100),
	@LinkID varchar(100)

					
AS --Encrypt
		   
/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 11/19/07 GHL 8.5   Added GLCompanyKey, OfficeKey
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 10/01/13 GHL 10.573 Added multicurrency
|| 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
*/

declare @RetVal int
declare @InvoiceKey int
declare @ClientKey int
declare @ARAccountKey int
declare @MultiCurrency int
declare @CurrencyID int

select @MultiCurrency = isnull(MultiCurrency, 0)
  from tPreference (nolock)
 where CompanyKey = @CompanyKey

	select @ClientKey = CompanyKey
	     ,@CurrencyID = CurrencyID
	  from tCompany (nolock)
     where LinkID = @ClientID
	   and OwnerCompanyKey = @CompanyKey
     
    if @ClientKey is null
		return -10

	if  @MultiCurrency = 0
		select @CurrencyID = null

	select @ARAccountKey = GLAccountKey
	  from tGLAccount (nolock)
     where LinkID = @ARAccountID
	   and CompanyKey = @CompanyKey
     
    if @ARAccountKey is null
		return -11
		
	select @InvoiceKey = InvoiceKey
	  from tInvoice (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	      
if @InvoiceKey is null
  begin		   
	exec @RetVal = sptInvoiceInsert
		 @CompanyKey,
		 @ClientKey,
		 null,
		 null,
		 null,
		 0,
		 @InvoiceNumber,
		 @TransactionDate,
		 @DueDate,
		 @TransactionDate,
		 null,
		 @ARAccountKey,
		 null,
		 null,
		 @HeaderComment,
		 null,
		 null,
		 null,
		 @UserKey,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 0,
		 0,         --Emailed
		 @UserKey,  --CreatedByKey
		 null, --GLCompanyKey
		 null, --OfficeKey
		 0,	   --OpeningTransaction
		 null,
		 @CurrencyID,
		 1, -- exchange rate
		 1, -- request exchange rate
		 @InvoiceKey output
		 
	if @RetVal <> 1 
		return -1

	update tInvoice
	   set InvoiceStatus = 4,
	       LinkID = @LinkID,
	       ApprovedDate = @TransactionDate,
	       ApprovedByKey = @UserKey
	 where InvoiceKey = @InvoiceKey
  end
else
  begin
	update tInvoice
       set ClientKey = @ClientKey,
           InvoiceDate = @TransactionDate,
           PostingDate = @TransactionDate,
           InvoiceNumber = @InvoiceNumber,
		   DueDate = @DueDate,
		   HeaderComment = @HeaderComment,    
		   ARAccountKey = @ARAccountKey
	 where InvoiceKey = @InvoiceKey 	   
  end

	
	return @InvoiceKey
GO
