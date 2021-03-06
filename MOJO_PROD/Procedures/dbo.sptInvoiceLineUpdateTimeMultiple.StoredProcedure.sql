USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateTimeMultiple]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineUpdateTimeMultiple]
	(
	@InvoiceLineKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 03/09/07 GHL 8.4   Creation to prevent deadlocks
  || 05/18/07 GHL 8.422 Setting BilledService when billing time entry                
  || 08/06/07 GHL 8.5   Using now an Action 1/0 to distinguish Update/Delete
  || 08/07/07 GHL 8.5   Added call to Invoice Summary + removed tran  
  ||                    Removed ProjectKey param since we may have more than one per line
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
  || 11/20/07 GHL 8.5   Setting now DateBilled = null when removing from the line
  || 07/15/09 GHL 10.505 (57341) Added rollback when sptInvoiceLineUpdateTotals returns an error
  ||                    When transactions are linked to a real invoice, then applied to Advance Bills
  ||                    If we remove transactions, this causes the real invoice to be over applied 
  || 08/03/09 RLB 10.509 (58417) removed the where clause  b.Action = 1 since update and delete are done in one section
  || 10/20/09 GHL 10.513 Calling now sptInvoiceRecalcLineAmounts here so that only taxes for this line are recalc'ed  
  */
  
	SET NOCOUNT ON
		
	/* Assume done in VB
	  sSQL = "CREATE TABLE #tInvoiceLineTime ( "
            sSQL = sSQL & "		 Action INT NULL "	
            sSQL = sSQL & "		,TimeKey uniqueidentifier NULL "
            sSQL = sSQL & "		,BilledHours decimal(24,4) NULL "
            sSQL = sSQL & "		,BilledRate money NULL "
            sSQL = sSQL & "		,ProjectKey int NULL "
            sSQL = sSQL & " )"
	*/

	DECLARE @InvoiceKey INT, @ProjectKey INT, @RetVal INT
	SELECT @InvoiceKey = InvoiceKey FROM tInvoiceLine (NOLOCK) WHERE InvoiceLineKey = @InvoiceLineKey

	BEGIN TRAN 

	UPDATE tTime
	SET    tTime.InvoiceLineKey	= CASE WHEN b.Action = 1 THEN @InvoiceLineKey ELSE NULL END
          ,tTime.BilledService	= CASE WHEN b.Action = 1 THEN tTime.ServiceKey ELSE NULL END 
          ,tTime.BilledHours	= CASE WHEN b.Action = 1 THEN b.BilledHours ELSE NULL END
          ,tTime.BilledRate		= CASE WHEN b.Action = 1 THEN b.BilledRate ELSE NULL END
          ,tTime.DateBilled		= CASE WHEN b.Action = 1 THEN tTime.DateBilled ELSE NULL END     	      
	FROM   #tInvoiceLineTime b
	WHERE  tTime.TimeKey = b.TimeKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END
		
	-- do not recalc sales taxes 'cause we create a temp table in sptInvoiceRecalcLineAmounts and there is a SQL tran
	DECLARE @RecalcSalesTaxes int, @RecalcLineSalesTaxes int
	SELECT @RecalcSalesTaxes = 0, @RecalcLineSalesTaxes = 0
	EXEC @RetVal = sptInvoiceLineUpdateTotals @InvoiceLineKey, @RecalcSalesTaxes, @RecalcLineSalesTaxes

	IF @RetVal < 0
	BEGIN
		ROLLBACK TRAN
		-- and report errors to the UI
		RETURN @RetVal	
	END
	
	COMMIT TRAN

	exec sptInvoiceRecalcLineAmounts @InvoiceKey, @InvoiceLineKey
	
	-- Project rollup for billed trantype (6)
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tInvoiceLineTime
		WHERE  ProjectKey > @ProjectKey
		
		IF @ProjectKey IS NULL
			BREAK
			
		EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0
	END
	
	
	RETURN 1
GO
