USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spInvoiceNumberValidate]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spInvoiceNumberValidate]
 @CheckKey int,
 @InvoiceNumber varchar(100)
 
AS --Encrypt
 DECLARE @InvoiceKey int
        ,@RowCount   int
        
 SELECT InvoiceKey 
 FROM tCheck c (nolock)
        ,tInvoice i (nolock)
 WHERE c.CheckKey  = @CheckKey
   AND c.ClientKey  = i.ClientKey
   AND i.InvoiceNumber = @InvoiceNumber
 
 SELECT @RowCount = @@ROWCOUNT
 
 IF @RowCount <= 0
  RETURN -1  -- No match
  
 IF @RowCount > 1
  RETURN -2  -- Too many matches, cannot return InvoiceKey
 -- Just 1 match, return InvoiceKey
 SELECT @InvoiceKey = InvoiceKey 
 FROM tCheck c (nolock)
        ,tInvoice i (nolock)
 WHERE c.CheckKey  = @CheckKey
   AND c.ClientKey  = i.ClientKey
   AND i.InvoiceNumber = @InvoiceNumber
  
  
 RETURN @InvoiceKey
GO
