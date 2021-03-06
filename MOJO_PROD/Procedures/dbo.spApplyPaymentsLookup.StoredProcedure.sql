USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spApplyPaymentsLookup]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spApplyPaymentsLookup]
 (
  @InvoiceKey INT
    ,@ReferenceNumber VARCHAR(100)
 )
AS --Encrypt
 DECLARE @ClientKey INT
 
 SELECT @ClientKey = ClientKey
 FROM   tInvoice (NOLOCK)
 WHERE  InvoiceKey = @InvoiceKey
 
 IF @ReferenceNumber IS NULL
  SELECT c.CheckKey
        ,c.ReferenceNumber
        ,c.CheckAmount
        ,(SELECT ISNULL(SUM(ca3.Amount), 0)
                      FROM   tCheckAppl ca3 (NOLOCK)
                      WHERE  ca3.CheckKey = c.CheckKey) AS AmountApplied  
        ,c.CheckAmount - (SELECT ISNULL(SUM(ca3.Amount), 0)
                      FROM   tCheckAppl ca3 (NOLOCK)
                      WHERE  ca3.CheckKey = c.CheckKey) AS AmountUnapplied 
  FROM   tCheck    c (NOLOCK)
  WHERE  c.ClientKey = @ClientKey
  AND    c.CheckAmount > (SELECT ISNULL(SUM(ca2.Amount), 0)
                      FROM   tCheckAppl ca2 (NOLOCK)
                      WHERE  ca2.CheckKey = c.CheckKey)      
  AND    c.CheckKey NOT IN (SELECT CheckKey
                            FROM   tCheckAppl (NOLOCK)
                            WHERE  InvoiceKey = @InvoiceKey) 
                            
 
 ELSE
 
  SELECT c.CheckKey
        ,c.ReferenceNumber
        ,c.CheckAmount
        ,(SELECT ISNULL(SUM(ca3.Amount), 0)
                      FROM   tCheckAppl ca3 (NOLOCK)
                      WHERE  ca3.CheckKey = c.CheckKey) AS AmountApplied  
        ,c.CheckAmount - (SELECT ISNULL(SUM(ca3.Amount), 0)
                      FROM   tCheckAppl ca3 (NOLOCK)
                      WHERE  ca3.CheckKey = c.CheckKey) AS AmountUnapplied                       
  FROM   tCheck    c (NOLOCK)
  WHERE  c.ClientKey = @ClientKey
  AND    UPPER(LTRIM(RTRIM(c.ReferenceNumber))) LIKE UPPER(LTRIM(RTRIM(@ReferenceNumber))) + '%' 
  AND    c.CheckAmount > (SELECT ISNULL(SUM(ca2.Amount), 0)
                      FROM   tCheckAppl ca2 (NOLOCK)
                      WHERE  ca2.CheckKey = c.CheckKey)      
  AND    c.CheckKey NOT IN (SELECT CheckKey
                            FROM   tCheckAppl (NOLOCK)
                            WHERE  InvoiceKey = @InvoiceKey) 
 RETURN 1
GO
