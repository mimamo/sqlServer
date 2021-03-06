USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceValidateReference]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceValidateReference]

 @InvoiceKey int,
 @ReferenceNumber varchar(100)
 
AS --Encrypt

 DECLARE @CheckKey int
 
 SELECT @CheckKey = CheckKey 
 FROM tCheck c (nolock)
        ,tInvoice i (nolock)
 WHERE i.InvoiceKey = @InvoiceKey
   and i.ClientKey = c.ClientKey
   and c.ReferenceNumber = @ReferenceNumber
   and ISNULL(c.VoidCheckKey, 0) = 0
 
  RETURN ISNULL(@CheckKey, 0)
GO
