USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyGetByGLCompanyName]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyGetByGLCompanyName]
	@CompanyKey Int,
	@GLCompanyName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tGLCompany (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(GLCompanyName))) = ltrim(rtrim(upper(@GLCompanyName)))
GO
