USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsGet]
 @PaymentTermsKey int = null,
 @TermsDescription varchar(100) = null,
 @CompanyKey int = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/26/11   RLB 10544   Needed to change  SP to work with updates to Payment Terms when importing them.
*/

 IF ISNULL(@PaymentTermsKey, 0) = 0
  SELECT *
  FROM  tPaymentTerms (NOLOCK)
  WHERE CompanyKey =  @CompanyKey and TermsDescription = @TermsDescription
 ELSE
  SELECT *
  FROM tPaymentTerms (NOLOCK) 
  WHERE
   PaymentTermsKey = @PaymentTermsKey

 RETURN 1
GO
