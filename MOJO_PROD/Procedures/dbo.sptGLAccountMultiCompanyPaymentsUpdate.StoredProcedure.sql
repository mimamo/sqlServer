USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountMultiCompanyPaymentsUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[sptGLAccountMultiCompanyPaymentsUpdate]

	(
		@CompanyKey				INT,		
		@GLAccountKey			INT,
		@NextCheckNumber		BIGINT,
		@DefaultCheckFormatKey	INT,
		@GLCompanyKey			INT
	)

AS --Encrypt

  /*
  || When     Who Rel        What
  || 06/12/12 QMD 10.5.5.7   Created to insert the multi company payment data
  || 08/13/12 GHL 10.5.5.8   Do not insert if the account is rollup or not a bank account or not a multi payment
  */

  if exists (select 1 from tGLAccount (nolock)
			where GLAccountKey = @GLAccountKey
			and   (
					AccountType <> 10
				Or
					isnull(MultiCompanyPayments, 0) = 0
				Or 
					[Rollup] = 1
				)
			)
		RETURN 1

  IF EXISTS (SELECT * FROM tGLAccountMultiCompanyPayments (NOLOCK) WHERE GLAccountKey = @GLAccountKey 
			AND CompanyKey = @CompanyKey AND GLCompanyKey = @GLCompanyKey)
	BEGIN
		UPDATE	tGLAccountMultiCompanyPayments
		SET		NextCheckNumber = @NextCheckNumber, DefaultCheckFormatKey = @DefaultCheckFormatKey
		WHERE	CompanyKey = @CompanyKey
				AND GLAccountKey = @GLAccountKey
				AND GLCompanyKey = @GLCompanyKey

		RETURN 1
	END 
  ELSE
	BEGIN
		INSERT INTO tGLAccountMultiCompanyPayments (CompanyKey, GLAccountKey, NextCheckNumber, DefaultCheckFormatKey, GLCompanyKey)
		VALUES ( @CompanyKey, @GLAccountKey, @NextCheckNumber, @DefaultCheckFormatKey, @GLCompanyKey )
		
		RETURN 1
	END
GO
