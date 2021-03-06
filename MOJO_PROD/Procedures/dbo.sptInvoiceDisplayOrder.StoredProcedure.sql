USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceDisplayOrder]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptInvoiceDisplayOrder]
	(
		@InvoiceKey int
	)
AS

SET NOCOUNT ON

/*
|| When         Who    Rel    What
|| 12/11/07     GHL    8.5    (17177) Creation to recover from bad display orders in invoice lines 
*/	
	
IF NOT EXISTS (
	SELECT 1 FROM (	
		SELECT ParentLineKey, DisplayOrder, count(InvoiceLineKey) as LineCount
		FROM tInvoiceLine (nolock) 
		WHERE InvoiceKey = @InvoiceKey
		GROUP BY ParentLineKey, DisplayOrder
		) as dups
	WHERE dups.LineCount > 1
	)
	RETURN -1
	
	CREATE TABLE #line (ParentLineKey int null, InvoiceKey int null, InvoiceLineKey int null, DisplayOrder int null, NewDisplayOrder int null)
	INSERT #line (ParentLineKey, InvoiceKey, InvoiceLineKey, DisplayOrder, NewDisplayOrder)
	SELECT ParentLineKey, InvoiceKey, InvoiceLineKey, DisplayOrder, 0
	FROM   tInvoiceLine (nolock)
	WHERE  InvoiceKey = @InvoiceKey   
	 
	DECLARE @ParentLineKey INT
	DECLARE @InvoiceLineKey INT
	DECLARE @DisplayOrder INT
	DECLARE @NewDisplayOrder INT

	SELECT @ParentLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ParentLineKey = MIN(ParentLineKey)
		FROM   #line (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    ParentLineKey > @ParentLineKey
	
		IF @ParentLineKey IS NULL
			BREAK
			
		SELECT @NewDisplayOrder = 0
		
		SELECT @DisplayOrder = -1
		WHILE (1=1)
		BEGIN
			SELECT @DisplayOrder = MIN(DisplayOrder)
			FROM   #line (NOLOCK)
			WHERE  InvoiceKey = @InvoiceKey
			AND    ParentLineKey = @ParentLineKey
			AND    DisplayOrder > @DisplayOrder
			
			IF @DisplayOrder IS NULL
				BREAK
				
			SELECT @InvoiceLineKey = -1
			WHILE (1=1)				
			BEGIN
				SELECT @InvoiceLineKey = MIN(InvoiceLineKey)
				FROM   #line (NOLOCK)
				WHERE  InvoiceKey = @InvoiceKey
				AND    ParentLineKey = @ParentLineKey
				AND    DisplayOrder = @DisplayOrder
				AND    InvoiceLineKey > @InvoiceLineKey
				
				IF @InvoiceLineKey IS NULL
					BREAK
				
				SELECT @NewDisplayOrder = @NewDisplayOrder + 1
				UPDATE #line SET NewDisplayOrder = @NewDisplayOrder WHERE InvoiceLineKey = @InvoiceLineKey
				
			END -- ILK
		
		END -- display order
				
	END -- parent line key
	
		
	UPDATE tInvoiceLine
	SET    tInvoiceLine.DisplayOrder = #line.NewDisplayOrder
	FROM   #line
	WHERE  tInvoiceLine.InvoiceKey = @InvoiceKey
	AND    tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey
	AND    #line.NewDisplayOrder <> 0
		
	RETURN 1
GO
