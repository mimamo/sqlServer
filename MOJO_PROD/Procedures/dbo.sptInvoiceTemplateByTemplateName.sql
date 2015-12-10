USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateByTemplateName]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptInvoiceTemplateByTemplateName]
	@CompanyKey Int,
	@TemplateName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 05/09/09 MAS 10.5		Created
*/
	SELECT *
	FROM dbo.tInvoiceTemplate(NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(TemplateName))) = ltrim(rtrim(upper(@TemplateName)))
GO
