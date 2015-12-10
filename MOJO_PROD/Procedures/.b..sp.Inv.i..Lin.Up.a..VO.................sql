USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateVO]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdateVO]
 @VoucherDetailKey int,
 @AmountBilled money,
 @InvoiceLineKey int
 
AS --Encrypt
  
	UPDATE tVoucherDetail
	SET		AmountBilled = @AmountBilled,
			InvoiceLineKey = @InvoiceLineKey
	WHERE	VoucherDetailKey = @VoucherDetailKey

 RETURN 1
GO
