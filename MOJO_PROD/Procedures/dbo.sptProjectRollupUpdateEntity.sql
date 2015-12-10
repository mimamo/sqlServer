USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupUpdateEntity]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupUpdateEntity]
	(
		@Entity VARCHAR(50)
		,@EntityKey INT
		,@RecalcAll INT = 0
		,@ApprovedOnly INT = 0
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 02/23/07 GHL 8.4   Creation to update project rollup for an invoice, po, envelope, voucher, timesheet
  || 08/07/07 GHL 8.5   Modified rollup for invoices since invoice lines can have transactions from diff projects
  ||                    Can use now tInvoiceSummary
  || 09/24/09 GHL 10.5  Added support for entity = 'tInvoiceLine' when modifying inv lines
  || 05/13/10 GHL 10.522 Added param @ApprovedOnly so that we can update approved data only 
  || 07/17/13 GHL 10.570 (183754) for real invoices recalc projects on advance bills also to recalc the AdvBillOpen
  */
  
	SET NOCOUNT ON
	
	IF ISNULL(@EntityKey, 0) < 0
		RETURN 1
		
	DECLARE @ProjectKey INT
	        ,@TranType INT
	        
	IF @Entity = 'tInvoice'
	BEGIN
		-- Loop through invoice summary records
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tInvoiceSummary (NOLOCK)
			WHERE  InvoiceKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK
			
			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 6
			
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
		
		END	
	END

	-- Also take care of the AB invoices applied to regular invoices
	-- we need to recalc AdvBillOpen
	IF @Entity = 'tInvoice'
	BEGIN
		-- Loop through invoice summary records
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(summ.ProjectKey)
			FROM   tInvoiceAdvanceBill iab (NOLOCK)
			INNER  JOIN tInvoiceSummary summ (NOLOCK) on iab.AdvBillInvoiceKey = summ.InvoiceKey
			WHERE  iab.InvoiceKey = @EntityKey
			AND    ISNULL(summ.ProjectKey, 0) > 0
			AND    summ.ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK
			
			-- recalc all for billing trantype (6)
			EXEC sptProjectRollupUpdate @ProjectKey, 6, 1, 1, 1, 1
		
		END	
	END


	IF @Entity = 'tInvoiceLine'
	BEGIN
		DECLARE @InvoiceKey INT
		
		SELECT @InvoiceKey = InvoiceKey
		FROM   tInvoiceLine (NOLOCK)
		WHERE  InvoiceLineKey = @EntityKey
		
		-- Loop through invoice summary records
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tInvoiceSummary (NOLOCK)
			WHERE  InvoiceKey = @InvoiceKey
			AND    InvoiceLineKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK
			
			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 6
			
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
		
		END	
	END
	
	IF @Entity = 'tPurchaseOrder'
	BEGIN
		-- Loop through po lines
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK

			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 5
				
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
					
		END	
	END

	IF @Entity = 'tExpenseEnvelope'
	BEGIN
		-- Loop through er lines
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tExpenseReceipt (NOLOCK)
			WHERE  ExpenseEnvelopeKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK

			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 3
				
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
					
		END	
	END

	IF @Entity = 'tVoucher'
	BEGIN
		-- Loop through voucher lines
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tVoucherDetail (NOLOCK)
			WHERE  VoucherKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK
				
			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 4
	
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
					
		END	
	END
	
	IF @Entity = 'tTimeSheet'
	BEGIN
		-- Loop through voucher lines
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   tTime (NOLOCK)
			WHERE  TimeSheetKey = @EntityKey
			AND    ISNULL(ProjectKey, 0) > 0
			AND    ProjectKey > @ProjectKey  
			
			IF @ProjectKey IS NULL
				BREAK

			IF @RecalcAll = 1
				SELECT @TranType = -1
			ELSE
				SELECT @TranType = 1
				
			IF @ApprovedOnly = 1	
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 0, 1, 0, 0
			ELSE
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, 1, 1, 1, 1
					
		END	
	END
	
	RETURN 1
GO
