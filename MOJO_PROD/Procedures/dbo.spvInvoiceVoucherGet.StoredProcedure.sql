USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvInvoiceVoucherGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spvInvoiceVoucherGet]
	(
		@InvoiceLineKey int
	)
AS --Encrypt
	-- Do later: Use View
	
	SELECT vd.*
	      ,v.InvoiceDate
	FROM   tVoucherDetail vd (NOLOCK)
	      ,tVoucher       v  (NOLOCK)
	WHERE  vd.InvoiceLineKey = @InvoiceLineKey
	AND    vd.VoucherKey = v.VoucherKey
	ORDER BY v.InvoiceDate
	 
	/* set nocount on */
	return 1
GO
