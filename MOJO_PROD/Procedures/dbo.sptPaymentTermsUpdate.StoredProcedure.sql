USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsUpdate]
 @PaymentTermsKey int,
 @TermsDescription varchar(100),
 @CompanyKey int,
 @DueDays int
 
AS --Encrypt
/*
|| When      Who Rel      What
|| 09/01/09  MAS 10.5.0.8 Added insert logic
*/

IF @PaymentTermsKey <= 0
	BEGIN
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

		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tPaymentTerms
		SET
			TermsDescription = @TermsDescription,
			CompanyKey = @CompanyKey,
			DueDays = @DueDays
		WHERE
			PaymentTermsKey = @PaymentTermsKey 

		RETURN @PaymentTermsKey
	END
GO
