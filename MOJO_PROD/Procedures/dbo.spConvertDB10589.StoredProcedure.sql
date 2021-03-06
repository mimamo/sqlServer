USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10589]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[spConvertDB10589]

AS
	SET NOCOUNT ON
	
	-- seed VoucherID for credit cards (243079)
	declare @CompanyKey int
	declare @VoucherID int
		
	select @CompanyKey = -1
		while (1=1)
		begin
			select @CompanyKey = min(CompanyKey) from tPreference (nolock) where CompanyKey > @CompanyKey

			if @CompanyKey is null
				break

			select @VoucherID = 0

			update tVoucher
			set    VoucherID = @VoucherID
				  ,@VoucherID = @VoucherID + 1
			where CompanyKey = @CompanyKey
			and   CreditCard = 1

		end
GO
