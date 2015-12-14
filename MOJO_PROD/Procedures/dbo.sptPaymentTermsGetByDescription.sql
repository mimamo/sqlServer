USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentTermsGetByDescription]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentTermsGetByDescription]
	@CompanyKey Int,
	@TermsDescription varchar(100)

AS --Encrypt

/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tPaymentTerms (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(TermsDescription))) = ltrim(rtrim(upper(@TermsDescription)))

 RETURN 1
GO
