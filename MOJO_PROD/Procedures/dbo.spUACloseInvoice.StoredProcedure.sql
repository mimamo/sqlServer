USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUACloseInvoice]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUACloseInvoice]
	(
	@InvoiceNumber varchar(35)
	)
	
AS 
	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 10/23/08 GHL 10.011  Creation for University of Alberta 
||                      Purpose is to close an invoice and 
||                      create receipt for the open amount
|| 01/30/09 GHL 10.017  Added posting of receipt at Steve Kress's request
*/

declare @CompanyKey int
select @CompanyKey = 1
	
-- error constants
declare @kErrNoInv int				select @kErrNoInv = -1
declare @kErrBadStatusInv int		select @kErrBadStatusInv = -2
declare @kErrNotPostedInv int		select @kErrNotPostedInv = -3
declare @kErrClosedInv int			select @kErrClosedInv = -4
declare @kErrCheckNo int			select @kErrCheckNo = -5
declare @kErrDepositCleared int		select @kErrDepositCleared = -6
declare @kErrCheckUnexpected int	select @kErrCheckUnexpected = -7
declare @kErrCheckAppl int			select @kErrCheckAppl = -8
declare @kErrUpdateInv int			select @kErrUpdateInv = -9
declare @kErrBadMethod int			select @kErrBadMethod = -10

-- invoice data
declare @InvoiceKey int
declare @OpenAmount money 
declare @Posted int
declare @InvoiceStatus int
declare @ClientKey int
declare @SalesAccountKey int
declare @OfficeKey int
declare @ClassKey int
declare @GLCompanyKey int

-- pref data and misc
declare @DefaultCashAccountKey int
declare @UnappliedCashAccountKey int
declare @RetVal int

-- check data
declare @CheckKey int
declare @CheckMethodKey int
declare @CheckDate smalldatetime
declare @PostingDate smalldatetime
declare @DepositID varchar(50)

select @InvoiceKey = InvoiceKey
       ,@ClientKey = ClientKey
       ,@OpenAmount = (isnull(InvoiceTotalAmount, 0) 
					- isnull(AmountReceived, 0) 
					- isnull(WriteoffAmount, 0) 
					- isnull(DiscountAmount, 0) 
					- isnull(RetainerAmount, 0))
       ,@Posted = Posted
       ,@InvoiceStatus = InvoiceStatus
       ,@SalesAccountKey = ARAccountKey
       ,@OfficeKey = OfficeKey
       ,@ClassKey = ClassKey
       ,@GLCompanyKey = GLCompanyKey
from   tInvoice (nolock)
where  CompanyKey = @CompanyKey
and    InvoiceNumber = @InvoiceNumber

if @@ROWCOUNT = 0
	return @kErrNoInv
	
if @InvoiceStatus <> 4
	return @kErrBadStatusInv
	
if @Posted <> 1
	return @kErrNotPostedInv
		
if @OpenAmount = 0
	return @kErrClosedInv		

select @DefaultCashAccountKey = DefaultCashAccountKey
       ,@UnappliedCashAccountKey = UnappliedCashAccountKey
from   tPreference  (nolock)
where  CompanyKey = @CompanyKey

/*
This could be passed as a parameter if they need it
Right now @CheckMethodKey will be null 
declare @CheckMethod varchar(100)

select @CheckMethodKey = CheckMethodKey
from   tCheckMethod (nolock)
where  CompanyKey = @CompanyKey
and    CheckMethod = @CheckMethod

if @@ROWCOUNT = 0
	return @kErrBadMethod
*/
select @DepositID = CAST(MONTH(GETDATE()) as varchar(2)) + '/' + CAST(DAY(GETDATE()) as varchar(2)) + '/' + CAST(YEAR(GETDATE()) as varchar(4))  
select @CheckDate = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)  
select @PostingDate = @CheckDate

if exists(Select 1 from tCheck (nolock) Where ReferenceNumber = @InvoiceNumber and ClientKey = @ClientKey)
begin
	select @InvoiceNumber = @InvoiceNumber + '.'
end

begin tran

exec @RetVal = sptCheckInsert 
    @ClientKey
    ,@OpenAmount
    ,@CheckDate
    ,@PostingDate
    ,@InvoiceNumber
	,null -- description
    ,@DefaultCashAccountKey
    ,@ClassKey -- class key or take it from the invoice
    ,@UnappliedCashAccountKey
    ,@DepositID
    ,@CheckMethodKey
    ,@GLCompanyKey -- GL company
    ,0 -- not an opening transaction
    ,@CheckKey output    
  
if @RetVal <> 1
begin
	if @RetVal = -1
	begin
		rollback tran
		return @kErrCheckNo
	end
		
	if @RetVal = -2	
	begin
		rollback tran
		return @kErrDepositCleared
	end
	
	rollback tran	
	return 	@kErrCheckUnexpected
end	       

INSERT tCheckAppl
		(
		CheckKey,
		InvoiceKey,
		SalesAccountKey,
		OfficeKey,
		DepartmentKey,
		ClassKey,
		Description,
		Amount,
		Prepay
		)
	VALUES
		(
		@CheckKey,
		@InvoiceKey,
		ISNULL(@SalesAccountKey, 0),
		@OfficeKey,
		null, --@DepartmentKey,
		@ClassKey,
		null, --@Description,
		@OpenAmount,
		0 -- @Prepay
		)

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return @kErrCheckAppl
	end       
       
    exec sptInvoiceUpdateAmountPaid @InvoiceKey
	
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return @kErrUpdateInv
	end
      
    commit tran
    
    exec @RetVal = spGLPostCheck @CompanyKey, @CheckKey
      
	RETURN 1
GO
