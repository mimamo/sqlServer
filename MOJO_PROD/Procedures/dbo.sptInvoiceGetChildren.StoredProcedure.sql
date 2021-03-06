USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetChildren]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptInvoiceGetChildren]
	(
		@InvoiceKey int
	)
	
AS --Encrypt

Select
	i.InvoiceKey,
	i.ParentInvoiceKey,
	i.InvoiceNumber,
	i.InvoiceTotalAmount,
	c.CustomerID + ' - ' + c.CompanyName as ClientName,
	c.CustomerID + ' - ' + c.CompanyName as ClientFullName,
	i.PercentageSplit
From
	tInvoice i (nolock) 
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
Where
	i.ParentInvoiceKey = @InvoiceKey
GO
