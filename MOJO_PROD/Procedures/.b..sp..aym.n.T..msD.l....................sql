USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsDelete]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsDelete]
 @PaymentTermsKey int
AS --Encrypt
 DELETE
 FROM tPaymentTerms
 WHERE
  PaymentTermsKey = @PaymentTermsKey 
 RETURN 1
GO
