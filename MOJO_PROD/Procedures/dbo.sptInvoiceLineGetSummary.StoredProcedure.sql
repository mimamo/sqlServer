USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetSummary]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineGetSummary]

	(
		@InvoiceKey int
	   ,@InvoiceLineKey int	
	)

AS --Encrypt

	if @InvoiceLineKey is null
		SELECT 
			InvoiceLineKey,
			LineSubject
		FROM
			tInvoiceLine (nolock)
		WHERE
			InvoiceKey = @InvoiceKey AND
			LineType = 1
			
		ORDER BY
			LineSubject

	else
		SELECT 
			InvoiceLineKey,
			LineSubject
		FROM
			tInvoiceLine (nolock)
		WHERE
			InvoiceKey = @InvoiceKey AND
			LineType = 1 and
			InvoiceLineKey <> @InvoiceLineKey
			
		ORDER BY
			LineSubject
GO
