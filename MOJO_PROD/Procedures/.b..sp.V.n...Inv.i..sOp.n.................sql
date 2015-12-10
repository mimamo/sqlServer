USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorInvoicesOpen]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVendorInvoicesOpen]
(
@CompanyKey int,
@VendorKey int 

)

AS --Encrypt

select 
v.*,
v.VoucherTotal - v.AmountPaid as AmountDue,
c.CompanyName
from tVoucher v (nolock) left outer join tCompany c (nolock) on c.CompanyKey = v.VendorKey
where 
	v.Status = 4 
and 
v.VoucherTotal != v.AmountPaid 
and 
v.CompanyKey = @CompanyKey
and
v.VendorKey = @VendorKey



return 1
GO
