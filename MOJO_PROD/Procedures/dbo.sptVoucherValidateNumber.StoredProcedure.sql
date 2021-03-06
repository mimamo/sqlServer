USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherValidateNumber]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherValidateNumber]

	(
		@CompanyKey int,
		@VendorKey int,
		@InvoiceNumber varchar(50)
	)

AS --Encrypt

Declare @VoucherKey int


Select @VoucherKey = VoucherKey
From vVoucher (nolock)
Where
	CompanyKey = @CompanyKey and
	VendorKey = @VendorKey and
	InvoiceNumber = @InvoiceNumber and
	Status = 4
	
return isnull(@VoucherKey , 0)
GO
