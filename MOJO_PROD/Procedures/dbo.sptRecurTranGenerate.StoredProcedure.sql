USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGenerate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGenerate]
	(
	@RecurTranKey int
	)
AS --Encrypt
	
  /*
  || When     Who Rel    What
  || 02/12/10 GWG 10.519 Creation for new recurring logic                      
  || 02/22/10 GHL 10.519 Using now specific stored proc for each entity        
  || 04/20/10 GWG 10.5.21 Changed Never to none
  || 11/17/10 RLB 10.538 (94361)  Removed If No Reminder when generating Recurring Transactions    
  || 11/03/11 GHL 10.549  Added support of credit card charges          
  */
  
-- Constants
declare @kErrVouchers int		select @kErrVouchers = -1000
declare @kErrInvoices int		select @kErrInvoices = -2000
declare @kErrPayments int		select @kErrPayments = -3000
declare @kErrReceipts int		select @kErrReceipts = -4000
declare @kErrJournals int		select @kErrJournals = -5000
declare @kErrCreditCards int	select @kErrCreditCards = -6000

declare @kDoProjectRollup int	select @kDoProjectRollup = 1

-- Vars  
Declare @CompanyKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@Frequency varchar(50)
	,@NextDate smalldatetime
	,@NextNextDate smalldatetime
	,@ReminderOption varchar(50)
	,@NumberRemaining int
	,@DaysInAdvance int
	,@CreateAsApproved tinyint
	,@NextTranNo VARCHAR(100)
	,@RetVal INTEGER
	,@NewKey int

select @NewKey = 0

Select 
	@CompanyKey = CompanyKey,
	@Entity = Entity,
	@EntityKey = EntityKey,
	@ReminderOption = ReminderOption,
	@Frequency = Frequency, 
	@NextDate = NextDate, 
	@NumberRemaining = NumberRemaining, 
	@DaysInAdvance = DaysInAdvance, 
	@CreateAsApproved = CreateAsApproved
From tRecurTran (nolock) 
Where RecurTranKey = @RecurTranKey


if @NextDate is null OR @Frequency = 'None'
begin
	Select @NextNextDate = dbo.fFormatDateNoTime(GETDATE())
	Select @NextDate = @NextNextDate 
end
else if @Frequency = 'Daily'
	Select @NextNextDate = dateadd(d, 1,@NextDate) 
else if @Frequency = 'Weekly'
	Select @NextNextDate = dateadd(d, 7,@NextDate)
else if @Frequency = 'Every Two Weeks'
	Select @NextNextDate = dateadd(d, 14,@NextDate)
else if @Frequency = 'Every Four Weeks'
	Select @NextNextDate = dateadd(d, 28,@NextDate)
else if @Frequency = 'Monthly'
	Select @NextNextDate = dateadd(m, 1,@NextDate)
else if @Frequency = 'Quarterly'
	Select @NextNextDate = dateadd(q, 1,@NextDate)
else if @Frequency = 'Twice a Year'
	Select @NextNextDate = dateadd(q, 2,@NextDate)
else if @Frequency = 'Annually'
	Select @NextNextDate = dateadd(yy, 1,@NextDate)

if @NumberRemaining > 1
	select @NumberRemaining  = @NumberRemaining -1
	
-- ******************************************************************************************************************************************************
-- Vouchers
-- ******************************************************************************************************************************************************
if @Entity = 'VOUCHER' 
BEGIN
	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGenerateVoucher @EntityKey,@CompanyKey,@NextDate,@CreateAsApproved,@kDoProjectRollup
		,@RecurTranKey,@NextNextDate,@NumberRemaining
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrVouchers + @NewKey	

END

-- ******************************************************************************************************************************************************
-- Credit Cards
-- ******************************************************************************************************************************************************
if @Entity = 'CREDITCARD' 
BEGIN
	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGenerateVoucher @EntityKey,@CompanyKey,@NextDate,@CreateAsApproved,@kDoProjectRollup
		,@RecurTranKey,@NextNextDate,@NumberRemaining, 1
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrVouchers + @NewKey	

END

-- ******************************************************************************************************************************************************
-- Invoices
-- ******************************************************************************************************************************************************
if @Entity = 'INVOICE'
begin
	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGenerateInvoice @EntityKey,@CompanyKey,@NextDate,@CreateAsApproved,@kDoProjectRollup
		,@RecurTranKey,@NextNextDate,@NumberRemaining
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrInvoices + @NewKey	
end

-- ******************************************************************************************************************************************************
-- Payments
-- ******************************************************************************************************************************************************
if @Entity = 'PAYMENT'
BEGIN

	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGeneratePayment @EntityKey,@CompanyKey,@NextDate
		,@RecurTranKey,@NextNextDate,@NumberRemaining
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrPayments + @NewKey	


END

-- ******************************************************************************************************************************************************
-- Receipts
-- ******************************************************************************************************************************************************
if @Entity = 'RECEIPT'
BEGIN

	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGenerateReceipt @EntityKey,@CompanyKey,@NextDate
		,@RecurTranKey,@NextNextDate,@NumberRemaining
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrReceipts + @NewKey	


END


-- ******************************************************************************************************************************************************
-- Journal Entries
-- ******************************************************************************************************************************************************
if @Entity = 'GENJRNL'
BEGIN

	-- generate a single recurrence
	-- the update of the recur tran record will be part of the same SQL tran
	exec @NewKey = sptRecurTranGenerateJournalEntry @EntityKey,@CompanyKey,@NextDate
		,@RecurTranKey,@NextNextDate,@NumberRemaining
	
	-- add the base error so that the UI can perform a single error lookup  	
	if @NewKey < 0
		select @NewKey = @kErrJournals + @NewKey	

END


return @NewKey
GO
