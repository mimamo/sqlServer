USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spOpenInvcsGetForClient]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spOpenInvcsGetForClient]
 @ClientKey int
 
AS --Encrypt
 SELECT *
 FROM vInvoiceOpenAmount (nolock)
 WHERE ClientKey = @ClientKey
 ORDER BY InvoiceNumber
GO
