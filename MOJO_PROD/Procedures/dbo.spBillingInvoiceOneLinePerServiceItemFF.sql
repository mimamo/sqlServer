USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerServiceItemFF]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerServiceItemFF]
	(
		@CompanyKey INT
		,@NewInvoiceKey INT
		,@BillingKey INT
		,@BillingMethod INT
		,@ProjectKey INT
		,@DefaultSalesAccountKey int
		,@DefaultClassKey int
		,@BillingClassKey int
		,@DefaultWorkTypeKey int		
		,@ParentInvoiceLineKey int
		,@EstimateKey int
		
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/27/06 GHL 8.4   Added support of fixed fee billing by billing item  
  || 07/09/07 GHL 8.5	Added logic for office/department 
  || 07/10/07 QMD 8.5   (+GHL) Expense Type reference changed to tItem 
  || 04/08/08 GHL 8.508 (23712) New logic for classes, remove reading of FixedFeeBillingClassDetail
  || 06/18/09 GHL 10.027 (50759) Added logic for grouping by billing item (only if Entity <> tWorkType)
  || 12/17/10 GHL 10.539 (97621) Using now sptInvoiceLineInsertMassBilling vs sptInvoiceLineInsert to improve performance 
  */

	SET NOCOUNT ON

	-- Similar to sptInvoiceLineProjectInsert used in original FF screen
	
	DECLARE @BillingFixedFeeKey INT
	       ,@Entity VARCHAR(50)
		   ,@EntityKey INT
		   ,@Percentage DECIMAL(24, 4)
	       ,@Amount MONEY
	       ,@Taxable1 INT
	       ,@Taxable2 INT
	       ,@SalesAccountKey INT
	       ,@LineSubject VARCHAR(100)
	       ,@WorkTypeKey INT
		   ,@RequireClasses INT	
		   ,@ClassKey INT
		   ,@RetVal INT
		   ,@NewInvoiceLineKey INT
		   ,@OfficeKey INT
		   ,@DepartmentKey INT
		   ,@ItemClassKey INT
		   ,@GroupByBillingItem INT
		   	   			   
	Select @RequireClasses = isnull(RequireClasses, 1)
	From tPreference (nolock)
	Where CompanyKey = @CompanyKey
		
	SELECT @OfficeKey = OfficeKey
	       ,@GroupByBillingItem = isnull(FixedFeeGroupByBI, 0)
	FROM   tBilling (NOLOCK)
	WHERE  BillingKey = @BillingKey  	
		    
	SELECT @BillingFixedFeeKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @BillingFixedFeeKey = MIN(BillingFixedFeeKey)
		FROM   tBillingFixedFee (NOLOCK)
		WHERE  BillingKey = @BillingKey
		AND    BillingFixedFeeKey > @BillingFixedFeeKey
		
		IF @BillingFixedFeeKey IS NULL
			BREAK 
		
		SELECT   @Entity = Entity 
				,@EntityKey = EntityKey
				,@Percentage = Percentage
				,@Amount = Amount
				,@Taxable1 = Taxable1
				,@Taxable2 = Taxable2
				,@DepartmentKey = DepartmentKey
		FROM   tBillingFixedFee (NOLOCK)
		WHERE  BillingKey = @BillingKey
		AND    BillingFixedFeeKey = @BillingFixedFeeKey

		-- Reset variables since we are in a loop
		SELECT @SalesAccountKey = NULL
				  ,@LineSubject = NULL
				  ,@WorkTypeKey = NULL
				  ,@ClassKey = NULL
		
		-- Beware here from [No Item]...i.e. may not be found 
		if @Entity = 'tItem'
		BEGIN
			select @SalesAccountKey = SalesAccountKey
				  ,@LineSubject = ItemName
				  ,@WorkTypeKey = WorkTypeKey
				  ,@ItemClassKey = ClassKey
			from   tItem (nolock)
			where  ItemKey = @EntityKey
							
			IF @LineSubject IS NULL
				SELECT @LineSubject = 'No Item'
		END
		else if @Entity = 'tService'
		BEGIN
			select @SalesAccountKey = GLAccountKey
				  ,@LineSubject = Description
				  ,@WorkTypeKey = WorkTypeKey
				  ,@ItemClassKey = ClassKey
			from   tService (nolock)
			where  ServiceKey = @EntityKey
		
			IF @LineSubject IS NULL
				SELECT @LineSubject = 'No Service'	
		END
		else if @Entity = 'tWorkType'
		BEGIN
			select @GroupByBillingItem = 0
				
			select @SalesAccountKey = GLAccountKey
				  ,@LineSubject = WorkTypeName
				  ,@WorkTypeKey = WorkTypeKey
				  ,@ItemClassKey = ClassKey
			from   tWorkType (nolock)
			where  WorkTypeKey = @EntityKey
		
			IF @LineSubject IS NULL
				SELECT @LineSubject = 'No Billing Item'
				
			-- Entity/EntityKey are for service or item or expense receipt
			-- reset these
			SELECT @Entity = NULL, @EntityKey = NULL
					
		END
		
		IF @SalesAccountKey IS NULL
			SELECT @SalesAccountKey = @DefaultSalesAccountKey
				       
		IF @WorkTypeKey IS NULL
			SELECT @WorkTypeKey = @DefaultWorkTypeKey
		
		IF ISNULL(@BillingClassKey, 0) > 0
			SELECT @ClassKey = @BillingClassKey
		ELSE
			IF ISNULL(@ItemClassKey, 0) > 0
				SELECT @ClassKey = @ItemClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey
		
		IF @RequireClasses = 1 AND @ClassKey IS NULL
			RETURN -2
								
		--create single invoice line
		exec @RetVal = sptInvoiceLineInsertMassBilling
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,null							-- TaskKey
					  ,@LineSubject					-- Line Subject
					  ,null                 		-- Line description
					  ,1                    		-- Bill From 
					  ,1							-- Quantity
					  ,@Amount						-- Unit Amount
					  ,@Amount						-- Line Amount
					  ,2							-- line type
					  ,@ParentInvoiceLineKey		-- parent line key
					  ,@SalesAccountKey				-- Default Sales AccountKey
					  ,@ClassKey                    -- Class Key
					  ,@Taxable1					-- Taxable
					  ,@Taxable2					-- Taxable
					  ,@WorkTypeKey					-- Work TypeKey
					  ,0							-- @PostSalesUsingDetail==> No do it like sptInvoiceLineProjectInsert for FF
					  ,@Entity
					  ,@EntityKey
					  ,@OfficeKey
					  ,@DepartmentKey
					  ,@NewInvoiceLineKey output		
	
			IF @RetVal <> 1
			BEGIN
				EXEC sptInvoiceDelete @NewInvoiceKey
				RETURN -1			
			END	
	
			IF ISNULL(@EstimateKey, 0) > 0
 				UPDATE tInvoiceLine
 				SET    EstimateKey = @EstimateKey
 				WHERE  InvoiceLineKey = @NewInvoiceLineKey

	
	END
	
	IF @GroupByBillingItem = 1
		EXEC sptInvoiceLineGroupFFByBillingItem @NewInvoiceKey, @ParentInvoiceLineKey, 0 
	
	RETURN 1
GO
