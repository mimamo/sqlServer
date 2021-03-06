USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_VoucherDetail]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vExport_VoucherDetail]
AS
SELECT 
	tVoucher.CompanyKey, 
	tVoucher.InvoiceDate, 
	tVoucher.Downloaded, 
	tVoucher.Status,
	tVoucherDetail.VoucherKey, 
	tVoucherDetail.LineNumber, 
	tVoucherDetail.ShortDescription, 
	tVoucherDetail.Quantity, 
	tVoucherDetail.UnitCost, 
	tVoucherDetail.UnitDescription, 
	tVoucherDetail.TotalCost, 
	tItem.ItemID,
	tGLAccount.AccountNumber AS ExpenseAccount, 
	tGLAccount.ParentAccountKey,
	tVoucherDetail.VoucherDetailKey,
	tClass.ClassID
FROM tVoucherDetail 
	LEFT OUTER JOIN tGLAccount (nolock) ON tVoucherDetail.ExpenseAccountKey = tGLAccount.GLAccountKey
    INNER JOIN tVoucher (nolock) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
	LEFT OUTER JOIN tItem (nolock) on tVoucherDetail.ItemKey = tItem.ItemKey
	LEFT OUTER JOIN tClass (nolock) on tVoucherDetail.ClassKey = tClass.ClassKey
GO
