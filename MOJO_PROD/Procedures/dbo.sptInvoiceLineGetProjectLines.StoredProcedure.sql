USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetProjectLines]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetProjectLines]

	(
		@ProjectKey int
	)
AS


Select
	i.InvoiceKey
	,i.InvoiceNumber
	,i.InvoiceDate
	,il.EstimateKey
	,il.LineSubject
	,il.Quantity
	,il.UnitAmount
	,il.TotalAmount
	,il.BillFrom
From
	tInvoice i (nolock)
	inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
Where
	il.ProjectKey = @ProjectKey
Order By 
	i.InvoiceDate, i.InvoiceNumber, il.InvoiceOrder
GO
