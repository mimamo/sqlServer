USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorInvoicebyStatus]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVendorInvoicebyStatus]
(
@CompanyKey int,
@Status int,
@VendorKey int 


)

AS --Encrypt

select 
v.*,
v.VoucherTotal - v.AmountPaid as AmountDue,
c.CompanyName
from tVoucher v (nolock) left outer join tCompany c (nolock) on c.CompanyKey = v.VendorKey
where 
	v.Status = @Status 
and 
v.VoucherTotal != v.AmountPaid 
and 
v.DueDate <= GetDate() and v.CompanyKey = @CompanyKey
and
v.VendorKey = @VendorKey 

return 1
GO
