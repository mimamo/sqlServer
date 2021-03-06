USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvInvoiceGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvInvoiceGet]
 (
  @InvoiceKey int
 )
AS --Encrypt

Declare @Paid int

If Exists(Select 1 from tCheckAppl (NOLOCK) Where InvoiceKey = @InvoiceKey and Prepay = 0)
	Select @Paid = 1


SELECT 
 vInvoice.* 
 ,ISNULL(@Paid, 0) as Paid
FROM
 vInvoice (NOLOCK)
WHERE
 InvoiceKey = @InvoiceKey
GO
