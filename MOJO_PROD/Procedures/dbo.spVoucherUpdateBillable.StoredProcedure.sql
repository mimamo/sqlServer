USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spVoucherUpdateBillable]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spVoucherUpdateBillable]
 @VoucherDetailKey int,
 @AmountBilled money,
 @InvoiceLineKey int,
 @Remove tinyint
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/07/07 GHL 8.5   Added invoice Rollup  
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts   
  || 10/21/09 GHL 10.513 Recalc sales taxes for the line only                              
  */

 DECLARE @BillFrom smallint, @InvoiceKey int, @UpdateILKey int
    
 SELECT @UpdateILKey = @InvoiceLineKey
 
 IF @Remove = 1
 begin
  update tVoucherDetail
     set InvoiceLineKey = null
   where VoucherDetailKey = @VoucherDetailKey
  SELECT @UpdateILKey = NULL
 end
  
 UPDATE tVoucherDetail
 SET  AmountBilled = @AmountBilled,
   InvoiceLineKey = @UpdateILKey
 WHERE VoucherDetailKey = @VoucherDetailKey
 
 SELECT @BillFrom = BillFrom
		,@InvoiceKey = InvoiceKey
 FROM tInvoiceLine (NOLOCK)
 WHERE InvoiceLineKey = @InvoiceLineKey
 
 if @BillFrom = 2  --detail
 begin
	DECLARE @RecalcSalesTaxes int, @RecalcLineSalesTaxes int
	SELECT @RecalcSalesTaxes = 0, @RecalcLineSalesTaxes = 1
	EXEC sptInvoiceLineUpdateTotals @InvoiceLineKey, @RecalcSalesTaxes, @RecalcLineSalesTaxes
 end
 
 RETURN 1
GO
