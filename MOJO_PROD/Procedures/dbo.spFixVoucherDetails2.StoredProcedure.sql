USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixVoucherDetails2]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixVoucherDetails2]
	
	
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

	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)


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
		

			TRUNCATE TABLE #tApply 

			select @SalesTaxAmount = 0

			-- allocate tVoucherTax Type 1
			select @SalesTaxAmount = SalesTaxAmount
			from tVoucherTax (nolock)
			where VoucherKey = @VoucherKey
			and   Type = 1

			select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)

			if @SalesTaxAmount <> 0
			begin
				insert #tApply (LineKey, LineAmount, AlreadyApplied)
				select VoucherDetailKey, TotalCost, 0
				from   tVoucherDetail (nolock)
				where  VoucherKey = @VoucherKey
				and    Taxable = 1

				exec sptCashApplyToLines @TotalNonTaxAmount, @SalesTaxAmount, @SalesTaxAmount

				--select * from #tApply

				update tVoucherDetail
				set    tVoucherDetail.SalesTax1Amount = b.ToApply
				from   #tApply b
				where  tVoucherDetail.VoucherDetailKey = b.LineKey 
				and    tVoucherDetail.VoucherKey = @VoucherKey
			end
			else
			begin
				
				update tVoucherDetail
				set    tVoucherDetail.SalesTax1Amount = 0
				where  tVoucherDetail.VoucherKey = @VoucherKey

			end
		
			TRUNCATE TABLE #tApply 

			select @SalesTaxAmount = 0

			-- allocate tVoucherTax Type 1
			select @SalesTaxAmount = SalesTaxAmount
			from tVoucherTax (nolock)
			where VoucherKey = @VoucherKey
			and   Type = 2

			select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)

			if @SalesTaxAmount <> 0
			begin
				insert #tApply (LineKey, LineAmount, AlreadyApplied)
				select VoucherDetailKey, TotalCost, 0
				from   tVoucherDetail (nolock)
				where  VoucherKey = @VoucherKey
				and    Taxable2 = 1 

				exec sptCashApplyToLines @TotalNonTaxAmount, @SalesTaxAmount, @SalesTaxAmount

				--select * from #tApply

				update tVoucherDetail
				set    tVoucherDetail.SalesTax2Amount = b.ToApply
				from   #tApply b
				where  tVoucherDetail.VoucherDetailKey = b.LineKey 
				and    tVoucherDetail.VoucherKey = @VoucherKey
			end
			else
			begin
				
				update tVoucherDetail
				set    tVoucherDetail.SalesTax2Amount = 0
				where  tVoucherDetail.VoucherKey = @VoucherKey

			end

			-- try tax 3
			select @SalesTaxAmount = 0

			-- allocate tVoucherTax Type 1
			select @SalesTaxAmount = SalesTaxAmount
			from tVoucherTax (nolock)
			where VoucherKey = @VoucherKey
			and   Type = 3

			select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)

			if @SalesTaxAmount <> 0
			begin
				update tVoucherDetail
				set    tVoucherDetail.SalesTaxAmount = ISNULL((
					select sum(SalesTaxAmount)
					from   tVoucherDetailTax b (nolock)
					where  b.VoucherDetailKey = tVoucherDetail.VoucherDetailKey 
				),0)
				where tVoucherDetail.VoucherKey = @VoucherKey 

				update tVoucherDetail
				set    SalesTaxAmount = isnull(SalesTaxAmount, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
				where VoucherKey = @VoucherKey 

			end
			else
			begin
				update tVoucherDetail
				set    SalesTaxAmount = isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
				where VoucherKey = @VoucherKey 

			end

		end -- diff tax on header and detail





	end




	RETURN 1
GO
