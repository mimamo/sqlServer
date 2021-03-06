USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateTime]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdateTime]
 @InvoiceLineKey int,
 @TimeKey uniqueidentifier,
 @BilledHours decimal(24,4),
 @BilledRate money
 
AS --Encrypt
 DECLARE @TotalAmount money

 UPDATE tTime
 SET  InvoiceLineKey = @InvoiceLineKey,
   BilledService = ServiceKey,
   BilledHours = @BilledHours,
   BilledRate = @BilledRate
 WHERE TimeKey = @TimeKey

  
 RETURN 1
GO
