USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateTimes]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateTimes]
	(
	@VoucherKey int
	,@TotalCost money			
	,@ExpenseAccountKey int	-- account key on labor detail line
	,@ClassKey int			-- class key on labor detail line
	,@OfficeKey int			-- office key on labor detail line
	,@DepartmentKey int		-- department key on labor detail line
	,@ClientKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 11/28/11 GHL 10.5.5.0 Creation to handle new voucher type labor
||                       This sp combines all inserts/updates for that particular type 
||                       Labor has no taxes
||                       But on the UI, user can select GL Account, class, office and department
||                       UI rolls up labor cost to header, could also be recalculated here from time entries
||                       Billable field??
|| 01/05/12 GHL 10.5.5.2 Made changes so that we can have time entries as well as orders and expenses on same voucher  
|| 04/05/12 GHL 10.5.5.5 (138826) Added client
|| 11/19/13 GHL 10.5.7.4 Added update of tTime.HCostRate 
*/
	SET NOCOUNT ON

	if isnull(@VoucherKey, 0) <= 0
		return 1

	declare @kLineDesc varchar(500)		select @kLineDesc = '**Labor Line**'
	declare @Error int
	declare @OldCount int
	declare @NewCount int
	declare @RowCount int
	declare @ExchangeRate decimal(24,7)
	declare @PTotalCost money

	/*
	Assume done in VB
	create table #labor(TimeKey uniqueidentifier null, Action varchar(50) null, UpdateFlag int null) 
	*/

	select @NewCount = count(*) from #labor
	select @OldCount = count(*) from tTime (nolock) where VoucherKey = @VoucherKey

	if @NewCount = 0
	begin
		-- we need to cleanup the time entries
		if @OldCount >0
		update tTime set VoucherKey = null where VoucherKey = @VoucherKey

		-- and remove labor line
		delete tVoucherDetail where VoucherKey = @VoucherKey and ShortDescription = @kLineDesc

		return 1
	end

	-- at this point, we know that we have labor
	select @ExchangeRate = ExchangeRate from tVoucher (nolock) where VoucherKey = @VoucherKey

	if isnull(@ExchangeRate, 0) <= 0
		select @ExchangeRate = 1

	-- since we have no project on the line, PTotalCost is in home currency
	select @PTotalCost = ROUND(@TotalCost * @ExchangeRate, 2)

	-- inserts or updates
	update tVoucherDetail
	set   TotalCost = @TotalCost
	      ,UnitCost = @TotalCost
		  ,PTotalCost = @PTotalCost
		  ,ExpenseAccountKey = @ExpenseAccountKey 
	      ,ClassKey = @ClassKey
		  ,OfficeKey = @OfficeKey
		  ,DepartmentKey = @DepartmentKey
		  ,ClientKey = @ClientKey
	where VoucherKey = @VoucherKey
	and ShortDescription = @kLineDesc

	select @Error = @@ERROR, @RowCount = @@ROWCOUNT

	-- VB will rollback
	if @Error <> 0
		return -1

	if @RowCount = 0
	begin
		insert tVoucherDetail (VoucherKey, LineNumber,ShortDescription,Quantity,UnitCost,TotalCost,ExpenseAccountKey,ClassKey,OfficeKey,DepartmentKey,ClientKey) 
		values (@VoucherKey, 1,@kLineDesc,1,@TotalCost,@TotalCost,@ExpenseAccountKey,@ClassKey,@OfficeKey,@DepartmentKey,@ClientKey)
	
		select @Error = @@ERROR
	end

	-- VB will rollback
	if @Error <> 0
		return -1

	update tTime
	set    tTime.VoucherKey = @VoucherKey
	      ,tTime.CostRate = b.CostRate
		  -- Convert to Home Currency
		  ,tTime.HCostRate = tTime.CostRate * tTime.ExchangeRate 
	from   #labor b
	where  tTime.TimeKey = b.TimeKey

	if @@ERROR <> 0
		return -1

	update tTime
	set    tTime.VoucherKey = NULL
	where  tTime.VoucherKey = @VoucherKey
	and    tTime.TimeKey not in (select TimeKey from #labor)

	if @@ERROR <> 0
		return -1


	RETURN 1
GO
