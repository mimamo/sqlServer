USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineMoveUp]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineMoveUp]
	@InvoiceLineKey int
AS --Encrypt

declare @CurrentDisplayOrder int
declare @CurrentInvoiceKey int
declare @CurrentParentLineKey int


	select @CurrentDisplayOrder = DisplayOrder
	      ,@CurrentInvoiceKey = InvoiceKey
	      ,@CurrentParentLineKey = ParentLineKey
	  from tInvoiceLine (nolock)
	 where InvoiceLineKey = @InvoiceLineKey
	 
	if @CurrentDisplayOrder = 1
		return -1
		
	update tInvoiceLine
	   set DisplayOrder = DisplayOrder - 1
	 where InvoiceLineKey = @InvoiceLineKey
	   
	update tInvoiceLine
	   set DisplayOrder = DisplayOrder + 1
	 where InvoiceKey = @CurrentInvoiceKey
	   and ParentLineKey = @CurrentParentLineKey
	   and DisplayOrder = (@CurrentDisplayOrder-1)
	   and InvoiceLineKey <> @InvoiceLineKey
	   
	exec sptInvoiceDisplayOrder @CurrentInvoiceKey  
	exec sptInvoiceOrder @CurrentInvoiceKey, 0, 0, 0
	   
	RETURN 1
GO
