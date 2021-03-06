USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCreditCleanup]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptVoucherCreditCleanup]
	(
	@VoucherKey int
	)
AS
	
  /*
  || When     Who Rel    What
  || 02/24/12 GHL 10.552 Creation to cleanup records to prevent situations where credits are applied to credits
  ||                     or regular invoices applied to regular invoices
  */

	SET NOCOUNT ON
	 
	declare @VoucherTotal money
	declare @VoucherCreditKey int

	select @VoucherTotal = VoucherTotal from tVoucher (nolock) where VoucherKey = @VoucherKey

	if @VoucherTotal >= 0
	begin
		-- Voucher key cannot be on CreditVoucherKey
		if exists (select 1 from tVoucherCredit (nolock) where CreditVoucherKey = @VoucherKey)
		begin
			select @VoucherCreditKey = -1
			while (1=1)
			begin
				select @VoucherCreditKey = min(VoucherCreditKey)
				from   tVoucherCredit (nolock)
				where  CreditVoucherKey = @VoucherKey
				and    VoucherCreditKey > @VoucherCreditKey

				if @VoucherCreditKey is null
					break

				exec sptVoucherCreditDelete @VoucherCreditKey
			end
		end
	end

	if @VoucherTotal < 0
	begin
		-- Voucher key cannot be on VoucherKey
		if exists (select 1 from tVoucherCredit (nolock) where VoucherKey = @VoucherKey)
		begin
			select @VoucherCreditKey = -1
			while (1=1)
			begin
				select @VoucherCreditKey = min(VoucherCreditKey)
				from   tVoucherCredit (nolock)
				where  VoucherKey = @VoucherKey
				and    VoucherCreditKey > @VoucherCreditKey

				if @VoucherCreditKey is null
					break

				exec sptVoucherCreditDelete @VoucherCreditKey
			end
		end
	end

	RETURN 1
GO
