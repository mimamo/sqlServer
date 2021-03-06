USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGenerateRecurringLines]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGenerateRecurringLines]

	(
		@SourceInvoiceKey int,
		@TargetInvoiceKey int,
		@SourceParentLineKey int,
		@TargetParentLineKey int
	)

AS --Encrypt
  /*
  || When     Who Rel    What
  || 10/6/07  GWG 8.5    Added hooks for company,office and department 
  || 05/01/09 RLB 10.024 (52239) Added TaskKey to recurring invoices          
  || 02/12/10 GHL 10.518 (74670) Added tax info
  || 02/22/10 GHL 10.519 Added returns to use with new recurring logic                 
  || 03/22/12 GWG 10.554 Added TargetGLCompanyKey to the copy
  */

Declare @CurKey int
		,@CurTargetKey int
		,@Error int
		,@RetVal int
		
Select @CurKey = -1
While 1=1
BEGIN

	Select @CurKey = Min(InvoiceLineKey) from tInvoiceLine (NOLOCK)
	Where InvoiceKey = @SourceInvoiceKey 
	and ParentLineKey = @SourceParentLineKey 
	and InvoiceLineKey > @CurKey
	
	if @CurKey is null
		Break
				
	INSERT tInvoiceLine
	(
		InvoiceKey,
		ProjectKey,
		TaskKey,
		LineType,
		ParentLineKey,
		LineSubject,
		LineDescription,
		BillFrom,
		BilledTimeAmount,
		BilledExpenseAmount,
		Quantity,
		UnitAmount,
		TotalAmount,
		PostSalesUsingDetail,
		SalesAccountKey,
		OfficeKey,
		DepartmentKey,
		ClassKey,
		DisplayOrder,
		Taxable,
		Taxable2,
		WorkTypeKey,
		InvoiceOrder,
		LineLevel,
		Entity,
		EntityKey,
		RetainerKey,
		EstimateKey,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		DisplayOption,
		TargetGLCompanyKey	
	)
	Select
		@TargetInvoiceKey,
		ProjectKey,
		TaskKey,
		LineType,
		@TargetParentLineKey,
		LineSubject,
		LineDescription,
		BillFrom,
		BilledTimeAmount,
		BilledExpenseAmount,
		Quantity,
		UnitAmount,
		TotalAmount,
		PostSalesUsingDetail,
		SalesAccountKey,
		OfficeKey,
		DepartmentKey,
		ClassKey,
		DisplayOrder,
		Taxable,
		Taxable2,
		WorkTypeKey,
		InvoiceOrder,
		LineLevel,
		Entity,
		EntityKey,
		RetainerKey,
		EstimateKey,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		DisplayOption,
		TargetGLCompanyKey	
	From tInvoiceLine (NOLOCK) 
	Where InvoiceLineKey = @CurKey

	Select @Error = @@ERROR, @CurTargetKey = @@Identity
	if @Error <> 0
		return -1	

	Insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, SalesTaxAmount, Type)
	select @TargetInvoiceKey, @CurTargetKey, SalesTaxKey, SalesTaxAmount, Type
	From   tInvoiceTax (nolock)
	Where  InvoiceLineKey = @CurKey
	
	If @@ERROR <> 0
		return -1 
	
	Insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
	select @CurTargetKey, SalesTaxKey, SalesTaxAmount
	From   tInvoiceLineTax (nolock)
	Where  InvoiceLineKey = @CurKey
	If @@ERROR <> 0
		return -1 
	
	exec @RetVal = sptInvoiceGenerateRecurringLines @SourceInvoiceKey, @TargetInvoiceKey, @CurKey, @CurTargetKey
	if @RetVal <> 1
		return -1
	
END 

return 1
GO
