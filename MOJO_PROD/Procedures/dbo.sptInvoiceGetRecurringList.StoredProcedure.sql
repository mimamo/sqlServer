USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetRecurringList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetRecurringList]

	(
		@InvoiceKey int
	)

AS


Declare @RecurringInvoiceKey int

Select @RecurringInvoiceKey = RecurringParentKey from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

If ISNULL(@RecurringInvoiceKey, 0) = 0
	Select @RecurringInvoiceKey = @InvoiceKey
	
	
	
Select * from vInvoice Where RecurringParentKey = @RecurringInvoiceKey and InvoiceKey <> @RecurringInvoiceKey Order By InvoiceDate
GO
