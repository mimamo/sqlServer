USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceChangeStatusMultiple]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceChangeStatusMultiple]
	(
		@CompanyKey int,
		@UserKey int,
		@ApprovalComments varchar(500) = NULL
	)

AS --Encrypt

/* Assume done in VB
CREATE TABLE #tInvoice (InvoiceKey int null, ClientFullName varchar(250) null
			, InvoiceNumber varchar(35) null, InvoiceTotalAmount money null
			, InvoiceStatus int null, ApprovedByKey int null
			, ErrorNum int null)

*/

-- Some of this is for display on flash screen, we may not have an Invoice # at this point
-- Some users delay Invoice # assignment until approval
UPDATE  #tInvoice
SET     #tInvoice.InvoiceTotalAmount = b.InvoiceTotalAmount
		,#tInvoice.InvoiceStatus = b.InvoiceStatus
		,#tInvoice.ApprovedByKey = b.ApprovedByKey
		,#tInvoice.ClientFullName = cl.CustomerID + '-' + cl.CompanyName
FROM    tInvoice b (NOLOCK)
		,tCompany cl (NOLOCK)
WHERE	b.CompanyKey = @CompanyKey
AND		#tInvoice.InvoiceKey = b.InvoiceKey 
AND		b.ClientKey = cl.CompanyKey
		
DECLARE @InvoiceKey INT
DECLARE @ErrorNum INT
DECLARE @InvoiceStatus INT
DECLARE @ApprovedByKey INT

SELECT @InvoiceKey = -1
WHILE (1=1)
BEGIN
	SELECT @InvoiceKey = MIN(InvoiceKey)
	FROM	#tInvoice 
	WHERE	InvoiceKey > @InvoiceKey
	
	IF @InvoiceKey IS NULL
		BREAK
		
	SELECT @ApprovedByKey = ApprovedByKey	
		   ,@InvoiceStatus = InvoiceStatus
	FROM   #tInvoice 
	WHERE  InvoiceKey = @InvoiceKey
		
	IF @InvoiceStatus IN (1, 3)
	BEGIN
		IF @ApprovedByKey = @UserKey
		BEGIN
			-- Approve
			EXEC @ErrorNum = sptInvoiceChangeStatus @InvoiceKey, 4, @ApprovalComments
			UPDATE #tInvoice SET #tInvoice.ErrorNum = @ErrorNum WHERE InvoiceKey = @InvoiceKey			
		END
		ELSE
		BEGIN
			-- Submit
			EXEC @ErrorNum = sptInvoiceChangeStatus @InvoiceKey, 2, @ApprovalComments
			IF @ErrorNum = 1
				SELECT @ErrorNum = 2 -- Success when submitting, different from approval
			UPDATE #tInvoice SET #tInvoice.ErrorNum = @ErrorNum WHERE InvoiceKey = @InvoiceKey			
		END
	END
	
	IF @InvoiceStatus = 2
	BEGIN
		IF @ApprovedByKey = @UserKey
		BEGIN
			-- Approve
			EXEC @ErrorNum = sptInvoiceChangeStatus @InvoiceKey, 4, @ApprovalComments
			UPDATE #tInvoice SET #tInvoice.ErrorNum = @ErrorNum WHERE InvoiceKey = @InvoiceKey			
		END
		ELSE
		BEGIN
			SELECT @ErrorNum = -99 -- We are not the approver
			UPDATE #tInvoice SET #tInvoice.ErrorNum = @ErrorNum WHERE InvoiceKey = @InvoiceKey			
		END
	END
		
	IF @InvoiceStatus = 4
	BEGIN
		SELECT @ErrorNum = -999 -- Already approved
		UPDATE #tInvoice SET #tInvoice.ErrorNum = @ErrorNum WHERE InvoiceKey = @InvoiceKey			
	END
		
END


-- Now capture Invoice # and new status
UPDATE  #tInvoice
SET     #tInvoice.InvoiceNumber = b.InvoiceNumber
		,#tInvoice.InvoiceStatus = b.InvoiceStatus
FROM    tInvoice b (NOLOCK)
WHERE	b.CompanyKey = @CompanyKey
AND		#tInvoice.InvoiceKey = b.InvoiceKey 
		

RETURN 1
GO
