USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixInvoiceSalesTax]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixInvoiceSalesTax]
	(
	@CompanyKey int
	)
AS
	SET NOCOUNT ON
	
	
	declare @AdvBillAccountKey int
	declare @InvoiceKey int
	declare @ProjectKey int
	declare @SalesTaxAmount money
	declare @DisplayOrder int
	declare @InvoiceOrder int
	declare @Posted int
	declare @GLClosedDate datetime
	
	select @AdvBillAccountKey = AdvBillAccountKey
	      ,@GLClosedDate = GLClosedDate
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey
	
	if @GLClosedDate is not null
		update tPreference
		set GLClosedDate = null
		where  CompanyKey = @CompanyKey
		
	
	select @InvoiceKey = -1
	while (1=1)
	begin
		select @InvoiceKey = min(InvoiceKey)
		from   tInvoice (nolock)
		where  CompanyKey = @CompanyKey
		and    InvoiceKey > @InvoiceKey
		and    AdvanceBill = 1
		and    SalesTax1Amount <> 0
		
		if @InvoiceKey is null
			break
				
		Select @InvoiceKey as InvoiceKey
			
		select @ProjectKey = ProjectKey
		      ,@SalesTaxAmount = SalesTax1Amount
		      ,@Posted = Posted
		from   tInvoice (nolock)
		where  InvoiceKey = @InvoiceKey
		
		select @DisplayOrder = (select count(*)+1
                            from tInvoiceLine (nolock)
                           where InvoiceKey = @InvoiceKey
                             and ParentLineKey = 0)
		select @InvoiceOrder = (select count(*)+1
                            from tInvoiceLine (nolock)
                           where InvoiceKey = @InvoiceKey
                             )
                             
		INSERT tInvoiceLine
			  (
			  InvoiceKey,
			  ProjectKey,
			  TaskKey,
			  LineSubject,
			  LineDescription,
			  BillFrom,
			  Quantity,
			  UnitAmount,
			  TotalAmount,
			  DisplayOrder,
			  InvoiceOrder,
			  LineType,
			  ParentLineKey,
			  SalesAccountKey,
			  ClassKey,
			  Taxable,
			  Taxable2,
			  WorkTypeKey,
			  PostSalesUsingDetail,
			  Entity,
			  EntityKey,
			  OfficeKey,
			  DepartmentKey,
			  RetainerKey
			  )
			 VALUES
			  (
			  @InvoiceKey,
			  @ProjectKey,
			  NULL, --@TaskKey,
			  'Sales Taxes', -- @LineSubject,
			  null, --@LineDescription,
			  1, -- @BillFrom , no transactions
			  1,-- @Quantity,
			  @SalesTaxAmount, --@UnitAmount,
			  @SalesTaxAmount, --@TotalAmount,
			  @DisplayOrder,
			  @InvoiceOrder, 
			  2, --@LineType,
			  0, --@ParentLineKey,
			  @AdvBillAccountKey, --@SalesAccountKey,
			  NULL, --@ClassKey,
			  0, --@Taxable,
			  0, --@Taxable2,
			  null, --@WorkTypeKey,
			  0, --@PostSalesUsingDetail,
			  null, --@Entity,
			  null, --@EntityKey,
			  null, --@OfficeKey,
			  null, --@DepartmentKey,
			  null --@RetainerKey
			  )
 	
 	
 			update tInvoice 
 			set    SalesTax1Amount = 0
 			      ,SalesTaxKey = null
 			where InvoiceKey = @InvoiceKey
 			
 			/*
 			delete tInvoiceLineTax
 			from tInvoiceLine il (nolock)
 			where tInvoiceLineTax.InvoiceLineKey = il.InvoiceLineKey
 			and il.InvoiceKey = @InvoiceKey
 			*/
 			
 			-- will do invoice summary
 			exec sptInvoiceRecalcAmounts @InvoiceKey 
			
			EXEC sptProjectRollupUpdateEntity 'tInvoice', @InvoiceKey
	
			if @Posted = 1
			begin
				exec spGLUnPostInvoice  @InvoiceKey
				
				exec spGLPostInvoice @CompanyKey, @InvoiceKey
			end
			
	end
		
	
	if @GLClosedDate is not null
		update tPreference
		set GLClosedDate = @GLClosedDate
		where  CompanyKey = @CompanyKey
		
	RETURN 1
GO
