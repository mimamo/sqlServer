USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdateSplit]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdateSplit]

	(
		@ParentInvoiceKey int,
		@InvoiceKey int,
		@PercentageSplit decimal(24,4)
	)

AS --Encrypt


Update tInvoice
Set PercentageSplit = @PercentageSplit
Where
	InvoiceKey = @InvoiceKey
	
exec sptInvoiceRollupAmounts @InvoiceKey
GO
