USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCCDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCCDelete]
	(
	@VoucherCCKey int,
	@VoucherKey int
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 10/26/11 GHL 10.549 Creation for credit card charges
  ||                     Must call sptVoucherUpdateAmountPaid
  ||                     Must also delete tVoucherCCDetail
  */

	SET NOCOUNT ON

	delete tVoucherCC 
	where  VoucherCCKey = @VoucherCCKey
	and    VoucherKey = @VoucherKey

	exec sptVoucherUpdateAmountPaid @VoucherKey

	delete tVoucherCCDetail
	where  VoucherCCKey = @VoucherCCKey
	and    VoucherKey = @VoucherKey

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
