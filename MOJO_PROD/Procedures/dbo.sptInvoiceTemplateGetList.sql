USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tInvoiceTemplate (nolock)
		WHERE
		CompanyKey = @CompanyKey

	RETURN 1
GO
