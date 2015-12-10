USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingDeleteMultiple]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingDeleteMultiple]
	(
	@CompanyKey INT
	)
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/21/08 GHL 10.011 (31425) Creation for mass delete action
  */

	SET NOCOUNT ON
	
	-- Masters and Children worksheets are deleted on the same screen
	-- Masters can only be deleted if children are
	-- So delete children first   
	
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
	        
	-- Do children first because masters can only be deleted if children are       
	SELECT @BillingKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @BillingKey = MIN(BillingKey)
		FROM   #tBilling
		WHERE  BillingKey > @BillingKey
		AND    ParentWorksheet = 0 
				 
		IF @BillingKey IS NULL
			BREAK		 

		EXEC @ErrorNum = sptBillingDelete @BillingKey
						
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

		EXEC @ErrorNum = sptBillingDelete @BillingKey
						
		UPDATE #tBilling
		SET    ErrorNum = @ErrorNum 
		WHERE  BillingKey = @BillingKey
	END        
	
	RETURN 1
GO
