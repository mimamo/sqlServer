USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingChangeStatusMultiple]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingChangeStatusMultiple]
	(
    @UserKey int
	,@CompanyKey INT
	,@Status INT 
	,@Comments VARCHAR(100)
	)
	
AS -- Encrypt

	SET NOCOUNT ON
	
	-- This sp is called from worksheets_approve.aspx
	-- Masters and Children worksheets are approved on the same screen
	-- Masters can only be approved if children are
	-- So approve children first   
  /*
  || When     Who Rel   What
  || 09/26/13 WDF 10.573 (188654) Added UserKey
 */
	
	-- Assume done
	--CREATE TABLE #tBilling (BillingKey int null, BillingID int null, ParentWorksheet int null, ErrorNum int null)
	
	-- Get Billing ID to report errors on the UI
	UPDATE #tBilling
	SET    #tBilling.BillingID = b.BillingID
		  ,#tBilling.ParentWorksheet = b.ParentWorksheet	
	FROM   tBilling b (NOLOCK)
	WHERE  #tBilling.BillingKey = b.BillingKey
	AND    b.CompanyKey = @CompanyKey
	
	DECLARE @BillingKey INT
	        ,@ErrorNum INT
	        
	-- Do children first because masters can only be approved if children are       
	SELECT @BillingKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @BillingKey = MIN(BillingKey)
		FROM   #tBilling
		WHERE  BillingKey > @BillingKey
		AND    ParentWorksheet = 0 
				 
		IF @BillingKey IS NULL
			BREAK		 

		EXEC @ErrorNum = sptBillingChangeStatus @BillingKey, @UserKey, @Status
						
		UPDATE #tBilling
		SET    ErrorNum = @ErrorNum 
		WHERE  BillingKey = @BillingKey
	END        
	
	-- Now process masters
	SELECT @BillingKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @BillingKey = MIN(BillingKey)
		FROM   #tBilling
		WHERE  BillingKey > @BillingKey
		AND    ParentWorksheet = 1 
				 
		IF @BillingKey IS NULL
			BREAK		 

		EXEC @ErrorNum = sptBillingChangeStatus @BillingKey, @UserKey, @Status
						
		UPDATE #tBilling
		SET    ErrorNum = @ErrorNum 
		WHERE  BillingKey = @BillingKey
	END        

	IF @Status = 4 AND @Comments IS NOT NULL
		UPDATE tBilling
		SET    tBilling.ApprovalComments = @Comments
		FROM   #tBilling b 
		WHERE  tBilling.BillingKey = b.BillingKey
		AND    b.ErrorNum = 1 			
	
	RETURN 1
GO
