USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineRemoveTime]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineRemoveTime]
 @TimeKey uniqueidentifier
 
AS --Encrypt
 DECLARE @TotalAmount money

 UPDATE tTime
 SET  InvoiceLineKey = NULL,
   BilledService = ServiceKey,
   BilledHours = 0,
   BilledRate = 0
 WHERE TimeKey = @TimeKey

  
 RETURN 1
GO
