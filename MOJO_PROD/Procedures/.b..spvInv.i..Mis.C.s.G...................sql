USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvInvoiceMiscCostGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvInvoiceMiscCostGet]
	(
		@InvoiceLineKey int
	)
AS --Encrypt
	-- Do later: Use View
	
	SELECT *
	FROM   tMiscCost (NOLOCK)
	WHERE  InvoiceLineKey = @InvoiceLineKey
	ORDER BY ExpenseDate
	
	/* set nocount on */
	return 1
GO
