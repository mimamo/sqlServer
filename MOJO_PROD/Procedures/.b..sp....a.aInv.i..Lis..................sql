USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataInvoiceList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataInvoiceList]

	(
		@CompanyKey int,
		@LaterThanDate smalldatetime,
		@BottomLineInvoice tinyint = 0
	)

AS --Encrypt

/*
|| When     Who		Rel      What
|| 05/26/10 MAS		10.5.3.0 (81637) Added Join to tVoucherDetail to bring back related invoices
|| 08/13/10 MAS		10.5.3.3 (87568) Added the UNION to include the Invoice LinkIDs
*/

Select 
	v.VoucherKey,
	ISNULL(vd.LinkID, '0') as LinkID
From tVoucher v (nolock)
Join tVoucherDetail vd (nolock) on vd.VoucherKey =  v.VoucherKey
Where
	v.CompanyKey = @CompanyKey
	and v.InvoiceDate >= @LaterThanDate
	and v.Posted = 1
	and	v.LinkID is not null and vd.LinkID is not null
	and isnull(BottomLineInvoice, 0) = @BottomLineInvoice

Union 
Select 
	v.VoucherKey,
	ISNULL(v.LinkID, '0') as LinkID -- Invoice's LinkID
From tVoucher v (nolock)
Where
	v.CompanyKey = @CompanyKey
	and v.InvoiceDate >= @LaterThanDate
	and v.Posted = 1
	and	v.LinkID is not null
	and isnull(BottomLineInvoice, 0) = @BottomLineInvoice	
		
Order By v.VoucherKey
GO
