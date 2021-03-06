USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsInsert]
 @TermsDescription varchar(100),
 @CompanyKey int,
 @DueDays int,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tPaymentTerms
  (
  TermsDescription,
  CompanyKey,
  DueDays
  )
 VALUES
  (
  @TermsDescription,
  @CompanyKey,
  @DueDays
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
