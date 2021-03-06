USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetTemplate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptInvoiceGetTemplate]

	(
		@InvoiceKey int
	)

AS --Encrypt

Select
	it.*
from
	tInvoice i (nolock)
	LEFT OUTER JOIN tInvoiceTemplate it (nolock) on i.InvoiceTemplateKey = it.InvoiceTemplateKey
Where
	i.InvoiceKey = @InvoiceKey
GO
