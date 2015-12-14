USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdateEmailedFlag]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdateEmailedFlag]
	@InvoiceKey int
AS --Encrypt

	UPDATE	tInvoice
	SET		Emailed = 1
	WHERE	InvoiceKey = @InvoiceKey
GO
