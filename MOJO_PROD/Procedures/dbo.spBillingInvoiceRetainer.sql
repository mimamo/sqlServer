USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceRetainer]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceRetainer]
	(
	@NewInvoiceKey INT
	,@BillingKey INT
	,@BillingMethod INT
	,@DefaultSalesAccountKey INT
	,@DefaultClassKey INT
	,@WorkTypeKey INT
	,@InvoiceDate SMALLDATETIME
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 07/09/07 GHL 8.5	 Added logic for office/department  (revisited 8/9/07)
  || 11/09/12 GHL 10.562 (159129) Getting now retainer's title for line subject (instead of 'Retainer') 
  */

	SET NOCOUNT ON
	
Declare @NewInvoiceLineKey int
Declare @RetVal int
Declare @LineSubject VARCHAR(100)
Declare @LineDescription VARCHAR(1500)
Declare @RetainerAmount money
Declare @RetainerKey INT
Declare @OfficeKey int

	SELECT @RetainerKey = b.EntityKey
	      ,@RetainerAmount = b.RetainerAmount
		  ,@LineDescription = ISNULL(b.RetainerDescription, b.InvoiceComment)
		  ,@OfficeKey = b.OfficeKey
		  ,@LineSubject = r.Title
	FROM   tBilling b (NOLOCK)
		LEFT OUTER JOIN tRetainer r (NOLOCK) on b.EntityKey = r.RetainerKey 
	WHERE  b.BillingKey = @BillingKey
				
	SELECT @LineSubject = isnull(@LineSubject, 'Retainer')
				
	-- One line for the retainer amount
	exec @RetVal = sptInvoiceLineInsertMassBilling
			@NewInvoiceKey				-- Invoice Key
			,NULL						-- ProjectKey
			,NULL						-- TaskKey
			,@LineSubject				-- Line Subject
			,@LineDescription    		-- Line description
			,1               			-- Bill From: Important to distinguish Retainer Amount from extra 
			,0							-- Quantity
			,0							-- Unit Amount
			,@RetainerAmount			-- Line Amount
			,2							-- line type
			,0							-- parent line key
			,@DefaultSalesAccountKey	-- Default Sales AccountKey
			,@DefaultClassKey           -- Class Key
			,0							-- Taxable
			,0							-- Taxable2
			,@WorkTypeKey				-- Work TypeKey
   			,0							-- @PostSalesUsingDetail
			,NULL						-- Entity
			,NULL						-- EntityKey
			,@OfficeKey
			,NULL						-- DepartmentKey						  						  
			,@NewInvoiceLineKey output
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -17					   	
		end		
	if @RetVal <> 1 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -17					   	
		end
	           		   		
	 --exec sptInvoiceRecalcAmounts @NewInvoiceKey 

	Update tInvoiceLine Set RetainerKey = @RetainerKey Where InvoiceLineKey = @NewInvoiceLineKey
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -17					   	
		end				
	
	UPDATE tRetainer
	SET    LastBillingDate = @InvoiceDate
	WHERE  RetainerKey = @RetainerKey
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -17					   	
		end				

	RETURN 1
GO
