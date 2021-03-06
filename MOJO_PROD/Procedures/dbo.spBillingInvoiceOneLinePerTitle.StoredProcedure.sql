USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerTitle]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerTitle]
	(
	@InvoiceKey int
	,@BillingKey int
	,@Rollup int --  11 = 'TitleOnly' or 12 = 'TitleService' or 13 = 'ServiceTitle'
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	,@TopInvoiceLineKey INT = 0
	)
	
AS
	SET NOCOUNT ON

  /*
  || When     Who         Rel    What
  || 11/11/14 GHL         10.586 Creation for Abelson Taylor to support invoicing by titles
  ||                             Wrapper for core proc spBillingPerTitle
  || 12/15/14 GHL         10.587 Added update of RateLevel and BilledComments in case they are edited on the BWS
  */


   CREATE TABLE #labor (TimeKey uniqueidentifier null
		  , ActualRate decimal(24,4) null
		  , ActualHours decimal(24,4) null
		  , BillAmount money null
		  , ServiceKey int null
		  , TitleKey int null 
          , RateLevel int null
          , Comments varchar(2000) null

		  , GroupEntity varchar(50) null
		  , GroupEntityKey int null
		  , SubGroupEntity varchar(50) null
		  , SubGroupEntityKey int null

		  , InvoiceLineKey int null
		  )
  
		  CREATE TABLE #expense (Entity varchar(25) null
			, EntityKey int null
			, BillAmount money  null
	
			, GroupEntity varchar(50) null
			, GroupEntityKey int null
			, SubGroupEntity varchar(50) null
			, SubGroupEntityKey int null

			, InvoiceLineKey int null
		  )              
		  
		-- load labor
		insert #labor (TimeKey, ActualRate, ActualHours, BillAmount, ServiceKey, TitleKey, RateLevel,Comments)
		select EntityGuid, Rate, Quantity, Total, ServiceKey, 0, RateLevel,Comments 
		from   tBillingDetail (nolock)
		where  BillingKey = @BillingKey
		and    Entity = 'tTime'
		and    Action = 1
			 
		update #labor
		set    #labor.TitleKey = t.TitleKey
		from   tTime t (nolock)
		where  #labor.TimeKey = t.TimeKey 

		-- load expenses
		insert #expense (Entity, EntityKey, BillAmount)
		select case Entity
			when 'tMiscCost' then 'MiscExpense'
			when 'tExpenseReceipt' then 'Expense'
			when 'tVoucherDetail' then 'Voucher'
			when 'tPurchaseOrderDetail' then 'Order'
			end
			, EntityKey, Total
		from   tBillingDetail  (nolock)
		where  BillingKey = @BillingKey
		and    Entity <> 'tTime'
		and    Action = 1
		
		declare @LaborCount int
		declare @ExpenseCount int

		select @LaborCount = count(*) from #labor
		select @ExpenseCount = count(*) from #expense

		-- What to do about FF?
		if @LaborCount + @ExpenseCount = 0
		begin
			truncate table #labor
			truncate table #expense
			return 1
		end

		declare @TitleRollup varchar(25)
		if @Rollup = 11
			select @TitleRollup = 'TitleOnly'
		else if @Rollup = 12
			select @TitleRollup = 'TitleService'
		else if @Rollup = 13
			select @TitleRollup = 'ServiceTitle'

		declare @RetVal int
		declare @isBWS int

		select @isBWS = 1

		exec @RetVal = spBillingPerTitle @InvoiceKey ,@TitleRollup, @ProjectKey 
				,@DefaultSalesAccountKey , @DefaultClassKey, @InvoiceByClassKey, @PostSalesUsingDetail, @TopInvoiceLineKey, @isBWS 
	  	
		truncate table #labor
		truncate table #expense

		return @RetVal
GO
