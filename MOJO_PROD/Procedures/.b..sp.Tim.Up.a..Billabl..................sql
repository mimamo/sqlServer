USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeUpdateBillable]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeUpdateBillable]
 @TimeKey uniqueidentifier,
 @BilledHours decimal(24,4),
 @BilledRate money,
 @InvoiceLineKey int,
 @Remove tinyint
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/07/07 GHL 8.5   Added invoice Rollup       
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts    
  || 10/21/09 GHL 10.513 Recalc sales taxes for the line only             
  */
  
	DECLARE @TotalAmount money, @UpdateILKey int
	SELECT @UpdateILKey = @InvoiceLineKey
 
	IF @Remove = 1
	SELECT @UpdateILKey = NULL
  
	UPDATE tTime
	SET		BilledHours = @BilledHours,
			BilledRate = @BilledRate,
			InvoiceLineKey = @UpdateILKey
	WHERE TimeKey = @TimeKey

	-- Rollup totals to invoice line 	
	DECLARE @RecalcSalesTaxes int, @RecalcLineSalesTaxes int
	SELECT @RecalcSalesTaxes = 0, @RecalcLineSalesTaxes = 1
	EXEC sptInvoiceLineUpdateTotals @InvoiceLineKey, @RecalcSalesTaxes, @RecalcLineSalesTaxes

	
 RETURN 1
GO
