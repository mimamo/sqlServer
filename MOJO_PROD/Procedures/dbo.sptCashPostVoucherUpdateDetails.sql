USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostVoucherUpdateDetails]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostVoucherUpdateDetails]
	(
	@VoucherKey int
	,@VoucherCCKey int
	,@CreateTemp int = 0
	,@UpdatePermanent int = 0
	)
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 10/10/11 GHL 10.459 Creation for cash basis posting and tVoucherCC records
||                     When the user changes the Credit card charge screen (voucher tab)
||                     we need to update tCashTransactionLine and tVoucherCCDetail if they exist 
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
*/
	SET NOCOUNT ON

	if @CreateTemp = 1
	begin
		CREATE TABLE #tVoucherCCDetail (
			VoucherKey int null
			,VoucherCCKey int null
			,CashTransactionLineKey int null
			,Amount money null
			,TempTranLineKey int null
			,UpdateFlag int null
			)	

		CREATE TABLE #tCashTransactionLine (
			Entity varchar(50) null
			,EntityKey int null
			,CashTransactionLineKey int null
			,Debit money null
			,Credit money null
			,AdvBillAmount money null
			,PrepaymentAmount money null
			,ReceiptAmount money null
			,TempTranLineKey int null
			)		

		CREATE TABLE #tApply (
			LineKey int null
			,LineAmount money null
			,AlreadyApplied money null
			,ToApply money null
			,DoNotApply int null
			)	

		CREATE TABLE #tVouchersCC (
			VoucherKey int null
			)

	end

	declare @UpdateTemporary int   select @UpdateTemporary = 1

	-- if it is not posted yet, do not update temporary
	if not exists (select 1 from tCashTransactionLine (nolock) where Entity = 'VOUCHER' and EntityKey = @VoucherKey)
		select @UpdateTemporary = 0

	-- if already processed, abort
	if exists (select 1 from #tVouchersCC where VoucherKey = @VoucherKey)
		select @UpdateTemporary = 0

	IF isnull(@VoucherKey, 0) = 0
		select @UpdateTemporary = 0

	if @UpdateTemporary = 1
	begin
		insert #tCashTransactionLine (Entity,EntityKey,CashTransactionLineKey,Debit,Credit,AdvBillAmount,PrepaymentAmount,ReceiptAmount,TempTranLineKey)
		select Entity,EntityKey,CashTransactionLineKey,Debit,Credit,AdvBillAmount,PrepaymentAmount,ReceiptAmount,CashTransactionLineKey
		from   tCashTransactionLine (nolock) where Entity = 'VOUCHER' and EntityKey = @VoucherKey

		-- this will prepare the tVoucherCCDetail and tCashTransactionLine.AdvBillAmount
		exec sptCashPostVoucherFillCCDetail @VoucherKey, null, null, 0

		-- this will calculate tCashTransactionLine.PrepaymentAmount and tCashTransactionLine.ReceiptAmount
		-- tVoucherCC records should be already saved
		exec sptCashPostVoucherCalcLineAmounts @VoucherKey, null, null, 0

		-- we do not need to update the other records
		delete #tVoucherCCDetail where VoucherCCKey <> @VoucherCCKey

		--sptCashPostVoucherFillCCDetail sets TempTranLineKey only
		--we need to update CashTransactionLineKey
		update #tVoucherCCDetail
		set    #tVoucherCCDetail.CashTransactionLineKey = #tVoucherCCDetail.TempTranLineKey

		insert #tVouchersCC (VoucherKey) select @VoucherKey

	end

	--select * from #tCashTransactionLine
	--select * from #tVoucherCCDetail

	if @UpdatePermanent = 1
	begin
		-- this is independent of @VoucherCCKey
		update tCashTransactionLine
		set    tCashTransactionLine.AdvBillAmount = b.AdvBillAmount
		      ,tCashTransactionLine.PrepaymentAmount = b.PrepaymentAmount
			  ,tCashTransactionLine.ReceiptAmount = b.ReceiptAmount
		from  #tCashTransactionLine b
		where  tCashTransactionLine.Entity = 'VOUCHER'
		and    tCashTransactionLine.EntityKey = b.EntityKey
		and    tCashTransactionLine.CashTransactionLineKey = b.CashTransactionLineKey

		if @@Error <> 0
			return -1

		delete tVoucherCCDetail where VoucherCCKey = @VoucherCCKey and VoucherKey not in (
			select VoucherKey from #tVoucherCCDetail)

		if @@Error <> 0
			return -1

		update #tVoucherCCDetail
		set    #tVoucherCCDetail.UpdateFlag = 0
		

		update #tVoucherCCDetail
		set    #tVoucherCCDetail.UpdateFlag = 1
		from   tVoucherCCDetail b (nolock)
		where  #tVoucherCCDetail.VoucherKey = b.VoucherKey
		and    #tVoucherCCDetail.VoucherCCKey = b.VoucherCCKey
		and    #tVoucherCCDetail.CashTransactionLineKey = b.CashTransactionLineKey

		if @@Error <> 0
			return -1

		update tVoucherCCDetail
		set    tVoucherCCDetail.Amount = b.Amount
		from   #tVoucherCCDetail b
		where  tVoucherCCDetail.VoucherKey = b.VoucherKey
		and    tVoucherCCDetail.VoucherCCKey = b.VoucherCCKey
		and    tVoucherCCDetail.CashTransactionLineKey = b.CashTransactionLineKey
      	and    b.UpdateFlag = 1

		if @@Error <> 0
			return -1
		
		insert tVoucherCCDetail (VoucherKey, VoucherCCKey, CashTransactionLineKey, Amount)
		select VoucherKey, VoucherCCKey, CashTransactionLineKey, Amount
		from   #tVoucherCCDetail
		where  UpdateFlag = 0 	      

		if @@Error <> 0
			return -1

	end

		
		 

	RETURN 1
GO
