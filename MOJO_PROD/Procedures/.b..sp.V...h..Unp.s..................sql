USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUnpost]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherUnpost]

	(
		@VoucherKey int
	)

AS --Encrypt

	if exists(select 1 from tVoucherDetail (NOLOCK) Where InvoiceLineKey is not null and VoucherKey = @VoucherKey)
		Return -1
	if exists(Select 1 from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey and Downloaded = 1)
		return -2
		
	Update tVoucher
	Set
		Posted = 0,
		Downloaded = 0,
		Status = 1
	Where
		VoucherKey = @VoucherKey
GO
