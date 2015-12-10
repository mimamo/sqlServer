USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixVoucherDetails]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixVoucherDetails]
	
	
AS
	SET NOCOUNT ON 

	-- Assume tVoucherDetail.Taxable is correct
	-- Assume tVoucherTax is correct

	declare @VoucherKey int
	declare @SalesTaxAmountH money
	declare @SalesTaxAmountD money
	declare @VoucherDetailKey int
	declare @SalesTaxAmount money
	declare @TotalNonTaxAmount money



	select @VoucherKey = -1
	while (1=1)
	begin
		select @VoucherKey = min(VoucherKey)
		from   tVoucher (nolock)
		where  VoucherKey > @VoucherKey
		--and    VoucherKey  = 1447 --!!!!!!!!!!!!!!!!!!!!Testing only

		if @VoucherKey is null
			break

		--select @VoucherKey

		select @SalesTaxAmountH = 0
		select @SalesTaxAmountD = 0

		select @SalesTaxAmountH = SalesTaxAmount
		from   tVoucher (nolock)
		where  VoucherKey = @VoucherKey

		select @SalesTaxAmountD = sum(SalesTaxAmount)
		from   tVoucherDetail (nolock)
		where  VoucherKey = @VoucherKey

		select @SalesTaxAmountH = isnull(@SalesTaxAmountH, 0)
		select @SalesTaxAmountD = isnull(@SalesTaxAmountD, 0)

		select @TotalNonTaxAmount = isnull(VoucherTotal, 0) - isnull(SalesTaxAmount, 0)
		from   tVoucher (nolock)
		where  VoucherKey = @VoucherKey

		if @SalesTaxAmountH <> @SalesTaxAmountD
		begin
			select @VoucherKey

			update tVoucherDetail
			set    SalesTax1Amount = 0
			where  VoucherKey = @VoucherKey
			and    Taxable = 0

			update tVoucherDetail
			set    SalesTax2Amount = 0
			where  VoucherKey = @VoucherKey
			and    Taxable2 = 0
		
			exec sptVoucherRecalcAmountsForFix @VoucherKey

		end -- diff tax on header and detail





	end




	RETURN 1
GO
