USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingDelete]
	@BillingKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/21/08 GHL 10.011 (31425) Added checking of status for mass delete action
  */

	DECLARE @InvoiceKey INT
	DECLARE @Status INT
	
	SELECT @InvoiceKey = ISNULL(InvoiceKey, 0)
	      ,@Status = Status
	FROM  tBilling (NOLOCK)
	WHERE BillingKey = @BillingKey
	      
	-- Could not be found      
	IF @@ROWCOUNT = 0
		RETURN -3
			
	-- Prevent form deleting if already billed and an invoice was created
	IF @Status > 4 AND @InvoiceKey > 0 
		RETURN -2

	-- Prevent form deleting if there are some child worksheets
	IF EXISTS (SELECT 1
				FROM  tBilling (NOLOCK)
				WHERE ParentWorksheetKey = @BillingKey)
		RETURN -1
	
	UPDATE tBillingSchedule
	SET	   BillingKey = NULL
	WHERE  
		BillingKey = @BillingKey
	
	DELETE
	FROM tBillingDetail
	WHERE
		BillingKey = @BillingKey

	DELETE
	FROM tBillingFixedFee
	WHERE
		BillingKey = @BillingKey

	DELETE
	FROM tBillingPayment
	WHERE
		BillingKey = @BillingKey

	DELETE
	FROM tBilling
	WHERE
		BillingKey = @BillingKey 

	RETURN 1
GO
