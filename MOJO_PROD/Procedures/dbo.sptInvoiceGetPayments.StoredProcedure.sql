USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetPayments]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetPayments]

	(
		@InvoiceKey int
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 07/28/14 GHL 10.852 (224103) Added Description from the header 
||                     Do not take it from the detail because that one is used for GL accounts (not invoices)
*/

Select
	ca.CheckApplKey,
	ca.Amount,
	ch.CheckKey,
	ch.ReferenceNumber,
	ch.CheckDate,
	ch.CheckAmount,
	ch.Description
From 
	tCheckAppl ca (nolock)
	inner join tCheck ch (nolock) on ca.CheckKey = ch.CheckKey
Where
	ca.InvoiceKey = @InvoiceKey and Prepay = 0
GO
