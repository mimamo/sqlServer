USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateDelete]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateDelete]
	@InvoiceTemplateKey int

AS --Encrypt

If exists(select 1 from tInvoice (nolock) Where InvoiceTemplateKey = @InvoiceTemplateKey)
	return -1

	DELETE
	FROM tInvoiceTemplate
	WHERE
		InvoiceTemplateKey = @InvoiceTemplateKey 

	RETURN 1
GO
