USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCCUpdate]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCCUpdate]
	(
	@VoucherCCKey int,
	@VoucherKey int,
	@Amount money,
	@Exclude1099 money,
	@CreateTemp int = 0
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/22/11 GHL 10.547 Creation for credit card charges
  || 09/13/11 GHL 10.547 Added call to sptVoucherUpdateAmountPaid
  || 10/27/11 GHL 10.549 Added update of tVoucherCCDetail records
  || 11/02/11 GHL 10.549 Added truncate of #tApply
  || 03/22/14 RLB 10.578 (203504) Added field for enhancement 
  */

	SET NOCOUNT ON
	
	declare @IsAddMode int

	
	update tVoucherCC
	set    Amount = @Amount, Exclude1099 = @Exclude1099
	where  VoucherCCKey = @VoucherCCKey
	and    VoucherKey = @VoucherKey

	if @@ROWCOUNT = 0
	begin
		insert tVoucherCC (VoucherCCKey, VoucherKey, Amount, Exclude1099)
		select @VoucherCCKey, @VoucherKey, @Amount, @Exclude1099

		select @IsAddMode = 1
	end
	else
		select @IsAddMode = 0

	exec sptVoucherUpdateAmountPaid @VoucherKey

	declare @Posted int, @VoucherTotal money
	select @Posted = Posted, @VoucherTotal = VoucherTotal from tVoucher (nolock) where VoucherKey = @VoucherKey

	-- if not posted, the tCashTransactionLineKey have not been created yet, so abort
	if @Posted = 0
		return 1

	-- now handle the tVoucherCCDetail records

	-- #tApply should be created before the SQL tran
	if @CreateTemp = 1
	  CREATE TABLE #tApply (
            LineKey int null
            ,LineAmount money null
            ,AlreadyApplied money null
            ,ToApply money null
            ,DoNotApply int null
            )

	TRUNCATE TABLE #tApply 

	INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
	SELECT  CashTransactionLineKey, Debit, 0
	FROM    tCashTransactionLine (NOLOCK)
	WHERE   Entity = 'VOUCHER' 
	AND     EntityKey = @VoucherKey
	
	EXEC sptCashApplyToLines @VoucherTotal, @Amount, @Amount, 0	

	if @IsAddMode = 1
		insert tVoucherCCDetail (VoucherKey, VoucherCCKey, CashTransactionLineKey, Amount)
		SELECT  @VoucherKey, @VoucherCCKey, ctl.CashTransactionLineKey, b.ToApply
		FROM    tCashTransactionLine ctl (NOLOCK)
			inner join #tApply b on ctl.CashTransactionLineKey = b.LineKey 
		WHERE   ctl.Entity = 'VOUCHER' 
		AND     ctl.EntityKey = @VoucherKey 
	else
		update tVoucherCCDetail
		set    tVoucherCCDetail.Amount = b.ToApply
		from   #tApply b 
		where  tVoucherCCDetail.VoucherKey = @VoucherKey
		and    tVoucherCCDetail.VoucherCCKey = @VoucherCCKey
		and    tVoucherCCDetail.CashTransactionLineKey = b.LineKey
		
	UPDATE tCashTransactionLine
	SET    tCashTransactionLine.AdvBillAmount = ISNULL((
				SELECT SUM(vccd.Amount)
				FROM   tVoucherCCDetail vccd (nolock)
				WHERE  vccd.VoucherKey = @VoucherKey
				and vccd.CashTransactionLineKey = tCashTransactionLine.CashTransactionLineKey
			), 0)
	WHERE  tCashTransactionLine.Entity = 'VOUCHER' 
	AND    tCashTransactionLine.EntityKey = @VoucherKey
	

	UPDATE tCashTransactionLine
	SET    tCashTransactionLine.ReceiptAmount = 
			ISNULL(tCashTransactionLine.Debit, 0)
			- ISNULL(tCashTransactionLine.PrepaymentAmount, 0)
			- ISNULL(tCashTransactionLine.AdvBillAmount, 0)
	WHERE  tCashTransactionLine.Entity = 'VOUCHER' 
	AND    tCashTransactionLine.EntityKey = @VoucherKey
	 

	RETURN 1
GO
