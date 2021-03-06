USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailTaxInsertMultiple]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailTaxInsertMultiple]
	(
	@VoucherKey int
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/23/11 GHL 10.550  Creation for new voucher flex screen
|| 02/24/12 GHL 10.552  Added call to sptVoucherCreditCleanup
||                      This is the last step when saving a vendor invoice in Flex
||                      and we need to make sure that the applications in tVoucherCredit are valid
||                      i.e. no credits applied to credits
*/

	SET NOCOUNT ON
	
	/*
	assume done in vb
	create table #KeyMap ( Entity VARCHAR(50) null, OldKey int null, NewKey int null)
	create table #tax (Entity VARCHAR(50) null, OldKey int null , NewKey int null , SalesTaxKey int null 
		, SalesTaxAmount money null, Action varchar(50) null , UpdateFlag int null )
	*/

	-- get new keys in tax from #KeyMap

	update #tax 
	set    #tax.NewKey = b.NewKey
	from   #KeyMap b
	where  #tax.Entity = b.Entity
	and    #tax.OldKey = b.OldKey


	delete tVoucherDetailTax 
	from   tVoucherDetail vd (nolock)
	where  vd.VoucherKey = @VoucherKey
	and    vd.VoucherDetailKey = tVoucherDetailTax.VoucherDetailKey
	
	insert tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
	select NewKey, SalesTaxKey, SalesTaxAmount
	from   #tax
	where  NewKey > 0

	-- no need at this point to rollup sales tax amounts to the voucher detail line
	-- it should have been done in the UI

	-- but we need to create tVoucherTax records
	exec sptVoucherRollupAmounts @VoucherKey

	exec sptVoucherCreditCleanup @VoucherKey

	RETURN 1
GO
