USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsGetCompanyList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsGetCompanyList]
 @CompanyKey int
AS --Encrypt
 SELECT *
 FROM tPaymentTerms (NOLOCK) 
 WHERE
  CompanyKey = @CompanyKey
 RETURN 1
GO
