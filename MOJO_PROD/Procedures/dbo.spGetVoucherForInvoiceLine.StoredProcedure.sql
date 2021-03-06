USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetVoucherForInvoiceLine]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGetVoucherForInvoiceLine]
 @InvoiceLineKey int
 
AS --Encrypt
 SELECT t.*,v.InvoiceDate
 FROM tVoucherDetail t (NOLOCK)
     ,tVoucher v (nolock)
 WHERE t.InvoiceLineKey = @InvoiceLineKey
   and t.VoucherKey = v.VoucherKey
 ORDER BY v.InvoiceDate,t.VoucherKey, t.LineNumber
GO
