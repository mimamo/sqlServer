USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateMC]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdateMC]
 @MiscCostKey int,
 @AmountBilled money,
 @InvoiceLineKey int
 
AS --Encrypt
  
 UPDATE tMiscCost
 SET	AmountBilled = @AmountBilled,
		InvoiceLineKey = @InvoiceLineKey
 WHERE	MiscCostKey = @MiscCostKey
 
 
 RETURN 1
GO
