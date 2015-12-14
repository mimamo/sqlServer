USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPFixTransfers]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPFixTransfers]
	(
		@CompanyKey int
	)
AS
	/* SET NOCOUNT ON */
	
--	declare @CompanyKey int
declare @ProjectKey int
declare @VoucherKey int
declare @Posted int

select @ProjectKey = -1
while (1=1)
begin
	select @ProjectKey = MIN(ProjectKey)
	from tProject (nolock) where CompanyKey = @CompanyKey
	and ProjectKey > @ProjectKey
	--and Closed = 0

	IF @ProjectKey is null
		break

	if exists (select 1 from vProjectCosts (nolock) where ProjectKey = @ProjectKey and 
	Type = 'VOUCHER' and TransferComment is not null and TransactionDate < '8/23/09' )
	begin
		--select 'found ' + cast(@ProjectKey as varchar(50))
		/*
		select v.InvoiceNumber
		from vProjectCosts vc (nolock) 
		inner join tVoucherDetail vd (nolock) on vc.TranKey = vd.VoucherDetailKey
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
  		where vc.ProjectKey = @ProjectKey and Type = 'VOUCHER' 
		and vc.TransferComment is not null and TransactionDate < '8/23/07'
		*/
		
		select @VoucherKey = -1
		while (1=1)
		begin
			select @VoucherKey = MIN(v.VoucherKey)
			from vProjectCosts vc (nolock) 
			inner join tVoucherDetail vd (nolock) on vc.TranKey = vd.VoucherDetailKey
			inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
  			where vc.ProjectKey = @ProjectKey and Type = 'VOUCHER' 
			and vc.TransferComment is not null and TransactionDate < '8/23/09'
		 	and v.VoucherKey > @VoucherKey

			IF @VoucherKey is null
				break
			
			select @Posted = Posted from tVoucher (NOLOCK) where VoucherKey = @VoucherKey

			if @Posted = 1
			begin
				select @VoucherKey
				exec spGLUnPostVoucher @VoucherKey, 0
				exec spGLPostVoucher @CompanyKey, @VoucherKey, 0, 1, 0
			end

		end

	end
	

end


	
	
	RETURN
GO
