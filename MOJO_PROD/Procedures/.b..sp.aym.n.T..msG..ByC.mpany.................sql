USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spPaymentTermsGetByCompany]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spPaymentTermsGetByCompany]
 @CompanyKey int
 
AS --Encrypt
 SELECT *
 FROM tPaymentTerms (NOLOCK)
 WHERE CompanyKey = @CompanyKey
GO
