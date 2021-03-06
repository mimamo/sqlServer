USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetRecurringInfo]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetRecurringInfo]
	@VoucherKey int

AS --Encrypt

Declare @Billed int, @PO int


IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and (WriteOff = 1 or not VoucherDetailKey is null) )
	Select @Billed = 1
if exists(select 1 from tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and ISNULL(PurchaseOrderDetailKey, 0) > 0)
	Select @PO = 1

	SELECT 
		v.*, 
		c.VendorID, 
		c.CompanyName AS VendorName,
		ISNULL(@Billed, 0) as Billed,
		ISNULL(@PO, 0) as HasPO
	FROM 
		tCompany c (nolock)
		INNER JOIN tVoucher v (nolock) ON c.CompanyKey = v.VendorKey 
	WHERE
		VoucherKey = @VoucherKey

	RETURN 1
GO
